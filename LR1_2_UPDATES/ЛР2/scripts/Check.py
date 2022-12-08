import random
import var
import lib


countOfEmployee = var.Variables.count_cashier
countTypeOfPurchase = var.Variables.count_typeOfPurchase
count = var.Variables.count_check



file = lib.CSV_exporter("Check.csv",[
    "id_of_cashier",
    "date_of_purchase",
    "time_of_purchase",
    "id_of_typeOfPurchase",
    "card_number"
])


for i in range(count):
    file.writeRecord([
        lib.getRandIndex(countOfEmployee),
        lib.getRandDate(),
        lib.getRandTime(),
        lib.getRandIndex(countTypeOfPurchase),
        random.randint(4000000000000000,4999999999999999)
    ])