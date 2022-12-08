import random
import var
import lib

count = var.Variables.count_street
count_city = var.Variables.count_city

nameStack = ["Незалежності","Головна","Зелена","Миру","Ентузіастів","Театральна"]


file = lib.CSV_exporter("Street.csv",[
    "id_city",
    "name"
])
for i in range(count):
    file.writeRecord([
        lib.getRandIndex(count_city),
        lib.getRandElement(nameStack)
])