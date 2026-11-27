


    def Interpolar (x_0,x_1,x_2,x_3,x_4,y_0,y_1,y_2,y_3,y_4,data):
        if data >= 0 and data < 25:
            m = (y_1 - y_0)/(x_1 - x_0)
            valor = data*m

            return valor

        elif data >= 25 and data < 50:
                m = (y_2 - y_1)/(x_2 - x_1)
                valor = y_1 +(data-25)*m
                return valor
        elif data >= 50 and data < 75:
                m = (y_3 - y_2)/(x_3 - x_2)
                valor = y_2 + (data-50)*m
                return valor

        elif data >= 75 and data <= 100:
                m = (y_4 - y_3)/(x_4 - x_3)
                valor = y_3 + (data-75)*m
                return valor

    print(Interpolar(0,25,50,75,100,0,200,300,350,375,50)) 