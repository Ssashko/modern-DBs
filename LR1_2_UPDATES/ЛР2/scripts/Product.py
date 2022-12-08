import random
import lib
import var
file = open("Product.csv","w", encoding='utf-8')
countOfTypes = var.Variables.count_typeOfProduct
countOfProducts = var.Variables.count_product
countOfLicence = var.Variables.count_licence
countOfAddresses = var.Variables.count_address
countOfProducers = var.Variables.count_producer

name = ["Молоко","Хліб","Яйця курячі","Кола","Булочка","Консерва рибна","Фарш","Мука","Гречка","Макарони","Сметана","Яблука","Цукерки","Вода питна","Сир","Паштет","Вареники морожені","Сік","Апельсини","Банан"]
expiration_date = [3,1,60,90,45,5,7,10]
min_temperature = [-5,5,2,1,8,-20,0,15]
max_amplitude = 5
min_price = 10
max_price = 100
file = lib.CSV_exporter("Product.csv", [
    "name",
    "id_producer",
    "expiration_date",
    "min_temperature",
    "amplitude_temperature",
    "id_of_licence",
    "id_typeOfProduct",
    "address_producing"
])

for i in range(countOfProducts):
    file.writeRecord([
        lib.getRandElement(name),
        lib.getRandIndex(countOfProducers),
        lib.getRandElement(expiration_date),
        lib.getRandElement(min_temperature),
        random.randint(1,max_amplitude),
        random.randint(min_price,max_price),
        lib.getRandIndex(countOfLicence),
        lib.getRandIndex(countOfTypes),
        lib.getRandIndex(countOfAddresses)
    ])