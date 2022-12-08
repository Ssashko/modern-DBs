import random
import var
import lib

countAddress = var.Variables.count_address

count = var.Variables.count_vendor

name = ["ООО Мегалюлю","Порошен","Авокадо","Телеком","Метро","ООО Немегалюль"]



contact_phone = [str("+380" + str(random.randint(600000000,999999999))) for i in range(count)]
place_of_registration = [str(random.randint(1,len(countAddress))) for i in range(count)]


file = lib.CSV_exporter("Vendor.csv",[
    "name",
    "contact_phone",
    "place_of_registration"
    
])
for i in range(count):
    file.writeRecord([
        name[i],
        contact_phone[i],
        place_of_registration[i]
    ])

