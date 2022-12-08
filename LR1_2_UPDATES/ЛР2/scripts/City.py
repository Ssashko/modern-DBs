import var
import lib

name = [(1,"Одеса"), (1,"Київ"),(7,"Нью Йорк"),(6,"Манчестер"),(7,"Бостон"),(2,"Краків"),(3,"Бухарест"),(4,"Анкара"), (5,"Таллін"), (8,"Мілан")]

file = lib.CSV_exporter("City.csv", [
    "name",
    "id_country"
])

for i in name:
    file.writeRecord([
        name[0],
        name[1]
    ])
