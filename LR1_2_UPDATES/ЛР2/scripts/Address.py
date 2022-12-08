import random
import var
import lib
file = open("Address.csv","w")

count = var.Variables.count_address
count_Street = var.Variables.count_street

count_numbers = 99
nameStack = ["A", "B", "C" , "Д", "СС","","","","", ""]


file = lib.CSV_exporter("",[
    "number",
    "street_id"
])

for i in range(count):
    file.writeRecord([
       lib.getRandElement(nameStack) + lib.getRandIndex(count_numbers),
       lib.getRandIndex(count_Street)
    ])