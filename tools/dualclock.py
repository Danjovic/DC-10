#
# Conventional Time versus Decimal time
# danjovic 2016 - http://hackaday.io/danjovic
#
# based on vegasead Tkinter digital clock
# https://www.daniweb.com/programming/software-development/code/216785/tkinter-digital-clock-python
#

from Tkinter import *
import time
root = Tk()
time1 = ''
title1 = Label(root, font=('times', 15, 'bold'), bg='black', fg='#bd9f5c',text='Conventional Time')
title2 = Label(root, font=('times', 15, 'bold'), fg='black', bg='#bd9f5c', text='Decimal Time')
clock = Label(root, font=('times', 40, 'bold'), fg='#bd9f5c', bg='black')
dc10  = Label(root, font=('times', 40, 'bold'), bg='#bd9f5c', fg='black')
title1.pack(fill=BOTH, expand=1)
clock.pack(fill=BOTH, expand=1)
title2.pack(fill=BOTH, expand=1)
dc10.pack(fill=BOTH, expand=1)
root.title("DC-10")
def tick():
    global time1
    # get the current local time from the PC
    time2 = time.strftime('%H:%M:%S')
    
    #get the total amount of seconds from midnight
    t=time.localtime()
    seconds_run = t.tm_sec + 60 * t.tm_min + 60*60*t.tm_hour
    # add 6 hours offset. C10 time begin at 6:00 (AM)
    dc10_seconds = ( 6 * 60 * 60 + seconds_run ) % ( 60*60*24 )

    #format string
    dc10_time = '0000' + str (dc10_seconds * 10000 / (60 * 60 * 24))    
    dc10time=str (dc10_time[-4:])
    
    # if time string has changed, update it
    if time2 != time1:
        time1 = time2
        clock.config(text=time2)
        dc10.config(text=dc10time)
    # calls itself every 200 milliseconds
    # to update the time display as needed
    # could use >200 ms, but display gets jerky
    clock.after(200, tick)
tick()
root.mainloop(  )

