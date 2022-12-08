import lib
import random

producer = ["Яготинське", "Рошен", "ООО Мегалюль", "Нестле", "Чернівецьке", "Нова лінія"]

file = lib.CSV_exporter(
    "Producer.csv",
    [
        "name"
    ]
)

for i in producer:
    file.writeRecord(
        [
           i
        ]
    )