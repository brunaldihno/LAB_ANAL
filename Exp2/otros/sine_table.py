import numpy as np

a = 2**(-1/4)

amplitud_relativa = a**3

A = 127.5*amplitud_relativa

tiempos = np.linspace(0,255,256).astype(int)
ft = np.linspace(0,2*np.pi,257)

with open("sine_table.txt", "w", encoding="utf-8") as archivo:
    for t in tiempos:
        sine = 127.5 + A*np.sin(ft[t])
        archivo.write(f"8'd{t}: sine_table = 8'd{round(sine)};\n")
