import random
import lib
import var

min_weight = 1
max_weight = 1200
count_product_id = var.count_product
count_ingridient = var.Variables.count_ingridient

file = lib.CSV_exporter(
    "CompositionItem.csv",
    [
        "product_id",
        "ingridient_id",
        "weight"
    ]
)

file.writeRecord(
    [
        lib.getRandElement(count_product_id),
        lib.getRandElement(count_ingridient),
        random.randint(min_weight,max_weight)
    ]
)