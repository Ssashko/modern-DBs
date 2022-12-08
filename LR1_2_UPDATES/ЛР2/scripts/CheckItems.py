import random
import var
import lib


count = var.Variables.count_checkItem
countOfSupply = var.Variables.count_supply
countOfCheck = var.Variables.count_check


file = lib.CSV_exporter("CheckItems.csv", [
    "id_check",
    "id_supply",
    "count"
])

minCountItem = 1
maxCountItem = 6

for i in range(count):
    file.writeRecord([
        lib.getRandIndex(countOfCheck),
        lib.getRandIndex(countOfSupply),
        random.randint(minCountItem, maxCountItem)
    ])