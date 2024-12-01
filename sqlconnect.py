import mysql.connector
from tkinter import *
from tkinter import ttk

cnx = mysql.connector.connect(user='root', password = 'airpods4sale', database='NBA')

cursor = cnx.cursor()

query = ("SELECT P_NAME FROM PLAYER")

cursor.execute(query)

def print_names():
    for (P_NAME) in cursor:
        print(P_NAME)

root = Tk()
frm = ttk.Frame(root, padding=100)
frm.grid()
ttk.Label(frm, text=print_names).grid(column=0, row=0)
ttk.Button(frm, text="Quit", command=root.destroy).grid(column=1, row=0)
root.mainloop()

cursor.close()
cnx.close()




