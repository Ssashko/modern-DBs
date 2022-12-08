import random
import lib
import var

count = var.Variables.count_cashier

nameStack = ["Петро","Іван","Федор","Олег","Василь"]
surnameStack = ["Шпак","Абоба","Іваненко","Петренко"]
midnameStack = ["Васильович","Петрович","Степанович","Альбертович"]


file = lib.CSV_exporter("Employee.csv",[
    "name",
    "surname",
    "midname",
    "date_of_employment",
    "hourly_pay",
    "margin"
])
for i in range(count):
    file.writeRecord([
        lib.getRandElement(nameStack),
        lib.getRandElement(surnameStack),
        lib.getRandElement(midnameStack),
        lib.getRandDate(2020),
        random.randint(9000, 50000)/100,
        random.randint(2, 10)/100
        
    ])