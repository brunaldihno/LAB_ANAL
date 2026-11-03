import numpy as np

fc = 48000
denominador = 2**16

IDs = ["0D", "16", "15", "1E", "1D", "24", "25", "2D", "2E", "2C", "36", "35", "3C", "3E", "43", "46", "44", "4D", "4E", "54", "55", "56",   "5D", "5A"]
###   ["tab", "1", "Q",   "2",  "W",  "E",  "4",  "R",  "5",  "T",  "6",  "Y",  "U",  "8",  "I",  "9",  "O",  "P",  "-",  "[",  "=",  "]", "back","enter"]

A3 = 220
d = 2**(1/12)
saltos = [i-9 for i in range(24)]
f = np.array([A3*d**s for s in saltos])

Nt = 512
inc = Nt*f/fc

entero = np.floor(inc)
frac = (inc-entero)*denominador

with open("frecs.txt", "w", encoding="utf-8") as archivo:
    for i in range(24):
        archivo.write(f"16'h{IDs[i]}: begin\n{" "*4}inc  <= 3'd{round(entero[i])};\n{" "*4}frac <= 16'd{round(frac[i])};\nend\n")

for i in range(24):
    print(
        f"Frecuencia: {f[i]:>7.3f}; "
        f"Salto: {inc[i]:>5.3f}  ---> "
        f"inc = {round(entero[i]):>2}; "
        f"frac = {round(frac[i]):>5}"
    )
