import var
import lib 

nameStack = ["Готівка","Картою","Google Pay","Apple Pay","Nova Pay"]

file = lib.CSV_exporter("TypeOfPurchase.csv", [
    "name"
])
for i in nameStack:
    file.writeRecord([
        i
])