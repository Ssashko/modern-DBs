import random
import lib
import var

countOfSupply = 1000
min_wholesale_price = 1000
max_wholesale_price = 100000
max_count_of_pieces = 150
min_count_of_pieces = 20
count_vendor = var.Variables.count_vendor
countOfProducts = var.Variables.count_product
file = lib.CSV_exporter(
    "BundleOfProducts.csv",
    [
        "wholesale_price",
        "count_of_pieces",
        "date_of_producing",
        "id_vendor",
        "id_product"
    ]
)

for i in range(countOfSupply):
    file.writeRecord(
        [
            random.randint(min_wholesale_price, max_wholesale_price),
            random.randint(min_count_of_pieces, max_count_of_pieces),
            lib.getRandDate(),
            lib.getRandIndex(count_vendor),
            lib.getRandIndex(countOfProducts)
        ]
    )
