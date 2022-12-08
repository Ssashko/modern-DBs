import var
import lib

countEmployee = var.Variables.count_cashier
count = var.Variables.count_schedule


file = lib.CSV_exporter("Schedule.csv", [
    "id_employee",
    "date",
    "begin_of_workday",
    "end_of_workday"
])
for i in range(count):
    file.writeRecord([
        lib.getRandIndex(countEmployee),
        lib.getRandDate(2020),
        lib.getRandTime(12),
        lib.getRandTime(23)
    ])
