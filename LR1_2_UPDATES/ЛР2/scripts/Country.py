import var
import lib

name = ["Україна","Польша","Румунія","Туреччина","Естонія","Велика Британія", "США", "Італія" ]

file = lib.CSV_exporter("Country.csv", [
    "name"
])

for i in name:
    file.writeRecord([
        i
    ])
