import numpy as np

a = 2**(-1/4)

amplitud_relativa = a**0

A = 127.5*amplitud_relativa

tiempos = np.linspace(0,127,128).astype(int)
ft = np.linspace(0,np.pi/2,128)

with open("sine_table.txt", "w", encoding="utf-8") as archivo:
    for t in tiempos:
        sine = 127.5 + A*np.sin(ft[t])
        archivo.write(f"{round(sine)},")
