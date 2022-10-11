import threading
from time import sleep
import cv2
import socket
import firebase
import pickle
import struct
import imutils
import datetime
from PIL import ImageFont, ImageDraw, Image
import numpy as np
import serial
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db

x = 0
list = ['0,0','1000','2','3','4']
list2 = ['1','2000','3','4']
drivecount = 0
intdistance = 0
bright = "1"

def set_brightness(img, scale):         # 입력변수는 영상, 밝기를 변경할 값
    return cv2.add(img, scale)  


def set_contrast(img, scale):           # 입력변수는 영상, 대비를 변경할 값
    return np.uint8(np.clip((1 + scale) * img - 128 * scale, 0, 255))   # 대비를 scale 비율로 변환

def warning_distance(velocity):
    distance = velocity*velocity/(254*0.8) + velocity*0.2/3.6
    return distance


def sensor_value_1():
    arduino1 = serial.Serial('/dev/ttyUSB0',115200)
    global list2
    while True:
        dis = arduino1.readline().decode('utf-8')
        fire = arduino1.readline().decode('utf-8')
        button = arduino1.readline().decode('utf-8')
        impact = arduino1.readline().decode('utf-8')
        dis = dis.strip('\r\n')
        fire = fire.strip('\r\n')
        button = button.strip('\r\n')
        impact = impact.strip('\r\n')

        list2 = [str(dis),str(fire),str(button),str(impact)]


def sensor_value_2():
    
    cred = credentials.Certificate('/home/pi/Downloads/serviceAccountKey.json')
    firebase_admin.initialize_app(cred,{
    'databaseURL' : 'https://konkukbulls-2db-default-rtdb.firebaseio.com/' 
    })

    arduino = serial.Serial('/dev/ttyACM0',115200)

    while True:
 
        global x
        global list
        global drivecount
        sleep(1)
        x = x +1
        gps = arduino.readline().decode('utf-8')
        velocity = arduino.readline().decode('utf-8')
        status = arduino.readline().decode('utf-8')
        light = arduino.readline().decode('utf-8')
        warn1 = arduino.readline().decode('utf-8')
        warn = "0"
 
        gps = gps.strip('\r\n')
        velocity = velocity.strip('\r\n')
        status = status.strip('\r\n')
        light = light.strip('\r\n')
        warn = warn.strip('\r\n')

        list= [str(gps),str(velocity),str(status),str(light),str(warn)]


        if list[2] == "0":
            drivecount = drivecount + 1


        if list[2] == "1":
            drivecount = 0

        if drivecount == 2:
            ref = db.reference("location")
            split = list[0]
            splitgps = split.split(",")
            lat = splitgps[0]
            lon = splitgps[1]
            ref.update({'lat2' : lat})#'37.54187,127.080207'
            ref.update({'lon2' : lon})#'37.54187,127.080207'
      

def sensor_value_1_thread():
	thread=threading.Thread(target=sensor_value_1) 
	thread.daemon=True 
	thread.start() 


def sensor_value_2_thread():
	thread=threading.Thread(target=sensor_value_2) 
	thread.daemon=True 
	thread.start() 


def video_stream():
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    host_ip = '172.20.10.4'  # paste your server ip address here
    port = 9800
    client_socket.connect((host_ip, port))  # a tuple

    vid = cv2.VideoCapture(0)
    cnt = 0
    warnon = 0
    plussecond = 0
    xcnt = 0
    drive = 0

    font = ImageFont.truetype('/home/pi/Documents/SCDream6.otf', 20) 

    global x
    global list
    global list2
      
    if not vid.isOpened():
        print("Could not open webcam")
        exit()
    while vid.isOpened():
        _, frame = vid.read()
        now = datetime.datetime.now()
        nowDatetime = now.strftime('%Y-%m-%d %H:%M:%S')
        cv2.rectangle(img=frame, pt1=(10, 15), pt2=(360, 35), color=(0,0,0), thickness=-1)
        frame = Image.fromarray(frame)    
        draw = ImageDraw.Draw(frame)    
        draw.text(xy=(10, 15),  text="건국불스 BCCS "+nowDatetime, font=font, fill=(255, 255, 255))
        frame = np.array(frame)
        frame = imutils.resize(frame, width=640)
        if list[3] == "0":
            constrast =  set_brightness(frame, 10)
            frame = constrast


        key = cv2.waitKey(1) & 0xFF

        a = pickle.dumps(frame)
        frame_message = struct.pack("Q", len(a))+a

        fire = int(list2[1])
        impact = int(list2[3])
        dist = int(list2[0])
        if fire<55: #화재 감지 시 위험상황
            list[4] = "1"
        
        if list2[2]=="1": # 경적 울림 시 위험상황
            list[4]="1"

        if float(dist) < warning_distance(float(list[1])): #안전거리 미 확보 시 위험상황
            list[4]="1"


        if list[4] == "1":
            warnon = 1

        if list[2] == "1":
            drive = 1

        if impact < 1000:
            plussecond = 30

        if warnon == 1 and drive == 0:
            xcnt += 1
            client_socket.sendall(frame_message)
            gps_str = list[0]
            gps_byte = gps_str.encode()
            gps_message = struct.pack("Q", len(gps_byte)) + gps_byte
            client_socket.sendall(gps_message)

        #---------------------------------------------------------------------주차 시 데이터 전송

            shock_str = f'parking'
            shock_byte = shock_str.encode()
            shock_message = struct.pack("Q", len(shock_byte)) + shock_byte
            client_socket.sendall(shock_message)

        #---------------------------------------

            end_byte = "data_more".encode()
            end_message = struct.pack("Q", len(end_byte)) + end_byte
            client_socket.sendall(end_message)     
            now = datetime.datetime.now()
            nowdate = now.strftime('%M_%S')

        if warnon == 1 and drive == 1:
            xcnt += 1
            client_socket.sendall(frame_message)
            gps_str = list[0]
            gps_byte = gps_str.encode()
            gps_message = struct.pack("Q", len(gps_byte)) + gps_byte
            client_socket.sendall(gps_message)

        #---------------------------------------------------------------------주행시 데이터 전송

            shock_str = f'driving'
            shock_byte = shock_str.encode()
            shock_message = struct.pack("Q", len(shock_byte)) + shock_byte
            client_socket.sendall(shock_message)

        #---------------------------------------

            end_byte = "data_more".encode()
            end_message = struct.pack("Q", len(end_byte)) + end_byte
            client_socket.sendall(end_message)
            now = datetime.datetime.now()
            nowdate = now.strftime('%M_%S')

        if xcnt == 60 + plussecond:            
            warnon = 0
            xcnt = 0
            plussecond = 0
            
    
            client_socket.sendall(frame_message)
            gps_str = list[0]
            gps_byte = gps_str.encode()
            gps_message = struct.pack("Q", len(gps_byte)) + gps_byte
            client_socket.sendall(gps_message)

            if drive == 0:
                shock_str = f'parking'
            else:
                shock_str = f'driving'
        
            shock_byte = shock_str.encode()
            shock_message = struct.pack("Q", len(shock_byte)) + shock_byte
            client_socket.sendall(shock_message)
            drive = 0
            end_byte = "data_finish".encode()
            end_message = struct.pack("Q", len(end_byte)) + end_byte
            client_socket.sendall(end_message)

        cv2.imshow('TRANSMITTING VIDEO', frame)

        if key == ord('q'):
            client_socket.close()
        

if __name__ == "__main__":
    sensor_value_1_thread()
    sensor_value_2_thread()
    video_stream()
    
    
  






