import csv
import random

csv_file = "input.csv"

fieldnames = ["quantity", "price_per_item", "discount"]

with open(csv_file, mode='w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=fieldnames)

    writer.writeheader()

    for _ in range(50):
        writer.writerow({
            "quantity": random.randint(1, 100),
            "price_per_item": round(random.uniform(1, 100), 2),
            "discount": round(random.uniform(0, 1), 2)
        })

