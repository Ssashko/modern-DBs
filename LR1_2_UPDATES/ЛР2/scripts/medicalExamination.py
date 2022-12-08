import var
import lib

countEmployee = var.Variables.count_cashier
count = var.Variables.count_medicalExamination

resultExplanationStack = ["Наче такий результат","Наче такий от результат","Ну наче такий результат","Як бачите","Нічого добавити"]
resultStack = ["false","true"]


file = lib.CSV_exporter("medicalExamination.csv",[
    "id_employee",
    "date",
    "result",
    "result_explanation"
])

for i in range(count):
    file.writeRecord([
        lib.getRandIndex(countEmployee),
        lib.getRandDate(),
        lib.getRandElement(resultStack),
        lib.getRandElement(resultExplanationStack)
])
