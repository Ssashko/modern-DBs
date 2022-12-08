import random
class CSV_exporter:
    def __init__(self,name,lst):
        self.file = open(name,"w", encoding='utf-8')
        self.file.write(','.join([str(el) for el in lst]) + '\n')
    
    def writeRecord(self,lst):
        self.file.write(','.join([str(el) for el in lst]) + '\n')
    
    def __del__(self):
        self.file.close()
        
def getRandElement(lst):
    return lst[random.randint(0,len(lst)-1)]

def getRandIndex(index):
    return random.randint(1,len(index))
def getRandDate(year = 2021):
    return str(random.randint(1, 12)) + "." + str(random.randint(1, 28)) + "." + str(year)
def getRandTime(hour = -1):
    if(hour == -1):
        return str(random.randint(0, 23)) + ":" + str(random.randint(0, 59))
    else:
        return str(hour) + ":" + str(random.randint(0, 59))
