import var
import lib

names = [(0,"Борошно"),(0,"Какао"),(20,"Кофеїн"),(0,"Какао масло"),
         (0,"Жовток яєчний"),(18,"Етиловий спирт"),
         (0,"Сіль кухонна"),(0,"Цукор"),(2,"Сода")]


file = lib.CSV_exporter("Ingredient.csv",
                        [
                            "name",
                            "min_age"
                        ]
                        )
for name in names:
    file.writeRecord([
        name[1],
        name[0]
    ])
