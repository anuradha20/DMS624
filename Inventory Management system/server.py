from flask import Flask, render_template, request, redirect
import mysql.connector

app = Flask(__name__)

# Database connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="password",
    database="inventory_db"
)

# Route to display inventory
@app.route("/")
def inventory():
    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Inventory")
    inventory_items = cursor.fetchall()
    cursor.close()
    return render_template("inventory.html", inventory_items=inventory_items)

# Route to add a tire
@app.route("/add_tire", methods=["POST"])
def add_tire():
    tire_type = request.form["tire_type"]
    quantity = request.form["quantity"]
    reorder_point = request.form["reorder_point"]
    supplier_id = request.form["supplier_id"]
    
    cursor = db.cursor()
    cursor.execute(
        "INSERT INTO Inventory (TireType, QuantityInStock, ReorderPoint, SupplierID) VALUES (%s, %s, %s, %s)",
        (tire_type, quantity, reorder_point, supplier_id)
    )
    db.commit()
    cursor.close()
    return redirect("/")

# Route to place an order
@app.route("/place_order", methods=["POST"])
def place_order():
    tire_id = request.form["tire_id"]
    quantity = request.form["quantity"]
    order_date = request.form["order_date"]
    delivery_date = request.form["delivery_date"]
    
    cursor = db.cursor()
    cursor.execute(
        "INSERT INTO Orders (TireID, QuantityOrdered, OrderDate, ExpectedDeliveryDate) VALUES (%s, %s, %s, %s)",
        (tire_id, quantity, order_date, delivery_date)
    )
    db.commit()
    cursor.close()
    return redirect("/")

if __name__ == "__main__":
    app.run(debug=True)
