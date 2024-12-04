from flask import Flask, render_template, request
import mysql.connector
import math

app = Flask(__name__)


db_config = {
    'user': 'root',      
    'password': 'password',  
    'host': 'localhost',
    'database': 'transit_system'
}

def get_all_stops():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT stop_id, stop_name FROM stops")
    stops = cursor.fetchall()
    cursor.close()
    conn.close()
    return stops

def build_graphs():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)

    
    cursor.execute("SELECT stop_id FROM stops")
    stops = cursor.fetchall()
    stop_ids = [stop['stop_id'] for stop in stops]
    stop_index = {stop_id: idx for idx, stop_id in enumerate(stop_ids)}
    n = len(stop_ids)

    
    INF = float('inf')
    distance_matrix = [[INF] * n for _ in range(n)]
    fare_matrix = [[INF] * n for _ in range(n)]

    
    cursor.execute("SELECT from_stop_id, to_stop_id, distance FROM stop_distances")
    distances = cursor.fetchall()
    for row in distances:
        i = stop_index[row['from_stop_id']]
        j = stop_index[row['to_stop_id']]
        distance_matrix[i][j] = row['distance']

    
    query = """
    SELECT
        st1.stop_id AS from_stop_id,
        st2.stop_id AS to_stop_id,
        MIN(fa.price) AS price
    FROM
        stop_times st1
    JOIN stop_times st2 ON st1.trip_id = st2.trip_id AND st2.stop_sequence = st1.stop_sequence + 1
    JOIN trips t ON st1.trip_id = t.trip_id
    JOIN fare_rules fr ON t.route_id = fr.route_id
    JOIN fare_attributes fa ON fr.fare_id = fa.fare_id
    GROUP BY st1.stop_id, st2.stop_id
    """
    cursor.execute(query)
    fares = cursor.fetchall()
    for row in fares:
        i = stop_index[row['from_stop_id']]
        j = stop_index[row['to_stop_id']]
        fare_matrix[i][j] = row['price']

    cursor.close()
    conn.close()

    return distance_matrix, fare_matrix, stop_ids, stop_index

def floyd_warshall(weight_matrix):
    n = len(weight_matrix)
    dist = [row[:] for row in weight_matrix]
    next_node = [[-1] * n for _ in range(n)]

    for i in range(n):
        for j in range(n):
            if weight_matrix[i][j] != float('inf'):
                next_node[i][j] = j

    for k in range(n):
        for i in range(n):
            for j in range(n):
                if dist[i][k] + dist[k][j] < dist[i][j]:
                    dist[i][j] = dist[i][k] + dist[k][j]
                    next_node[i][j] = next_node[i][k]

    return dist, next_node

def reconstruct_path(u, v, next_node):
    if next_node[u][v] == -1:
        return []
    path = [u]
    while u != v:
        u = next_node[u][v]
        path.append(u)
    return path

def get_stop_name(stop_id):
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()
    query = "SELECT stop_name FROM stops WHERE stop_id = %s"
    cursor.execute(query, (stop_id,))
    result = cursor.fetchone()
    cursor.close()
    conn.close()
    return result[0] if result else None

@app.route('/')
def index():
    
    stops = get_all_stops()
    return render_template('index.html', stops=stops)


@app.route('/search_route', methods=['POST'])
def search_route():
    start_point = request.form['start_point']
    end_point = request.form['end_point']
    option = request.form['option'] 

    
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)
    query = "SELECT stop_id FROM stops WHERE stop_name = %s"
    cursor.execute(query, (start_point,))
    start_result = cursor.fetchone()
    cursor.execute(query, (end_point,))
    end_result = cursor.fetchone()
    cursor.close()
    conn.close()

    if not start_result or not end_result:
        return render_template('route_results.html', routes=[], option=option)

    start_stop_id = start_result['stop_id']
    end_stop_id = end_result['stop_id']

    
    distance_matrix, fare_matrix, stop_ids, stop_index = build_graphs()
    n = len(stop_ids)

    
    if option == 'shortest':
        dist, next_node = floyd_warshall(distance_matrix)
        weight_matrix = dist
    else:
        dist, next_node = floyd_warshall(fare_matrix)
        weight_matrix = dist

    
    u = stop_index[start_stop_id]
    v = stop_index[end_stop_id]

    if weight_matrix[u][v] == float('inf'):
        return render_template('route_results.html', routes=[], option=option)

    
    path_indices = reconstruct_path(u, v, next_node)
    path_stop_ids = [stop_ids[idx] for idx in path_indices]
    stop_names = [get_stop_name(stop_id) for stop_id in path_stop_ids]

    result = [{
        'route_id': 'N/A',  
        'short_route_name': 'Computed Path',
        'stops': ','.join(stop_names),
    }]

    if option == 'cheapest':
        total_price = int(weight_matrix[u][v])
        result[0]['price'] = total_price
        result[0]['currency_type'] = 'USD'  
    else:
        total_distance = int(weight_matrix[u][v])
        result[0]['distance'] = total_distance

    return render_template('route_results.html', routes=result, option=option)

@app.route('/inventory')
def inventory():
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor(dictionary=True)

    query = """
    SELECT
        tyre_id,
        bus_id,
        tyre_condition,
        stock_quantity,
        last_updated
    FROM
        tyre_inventory
    """

    cursor.execute(query)
    tyres = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('inventory.html', tyres=tyres)

if __name__ == '__main__':
    app.run(debug=True)
