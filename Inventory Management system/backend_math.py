import math

def calculate_eoq(demand, ordering_cost, holding_cost):
    """
    Calculate Economic Order Quantity (EOQ).
    
    Parameters:
        demand (int): Annual demand in units.
        ordering_cost (float): Fixed cost per order.
        holding_cost (float): Cost of holding one unit for a year.
    
    Returns:
        float: EOQ value.
    """
    eoq = math.sqrt((2 * demand * ordering_cost) / holding_cost)
    return round(eoq, 2)

def calculate_rop(daily_demand, lead_time, safety_stock=0):
    """
    Calculate Reorder Point (ROP).
    
    Parameters:
        daily_demand (float): Average daily demand.
        lead_time (int): Lead time in days.
        safety_stock (int): Additional safety stock.
    
    Returns:
        float: ROP value.
    """
    rop = (daily_demand * lead_time) + safety_stock
    return round(rop, 2)
# assumptions
annual_demand = 1200  # Annual demand in units
ordering_cost = 100   # Fixed cost per order
holding_cost = 5      # Holding cost per unit per year
daily_demand = annual_demand / 365
lead_time = 7         # Lead time in days
safety_stock = 20     # Safety stock in units

eoq = calculate_eoq(annual_demand, ordering_cost, holding_cost)
rop = calculate_rop(daily_demand, lead_time, safety_stock)

print(f"EOQ: {eoq} units")
print(f"ROP: {rop} units")
