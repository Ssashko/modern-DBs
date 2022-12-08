import var
import lib

nameStack = ["Бакалія","Фрукти","Овочі","Молочна продукція","Консервація","М'ясна продукція"]

file = lib.CSV_exporter("TypeOfProduct.csv",[
    "name"
])
for i in nameStack:
    file.writeRecord([
        i
    ])