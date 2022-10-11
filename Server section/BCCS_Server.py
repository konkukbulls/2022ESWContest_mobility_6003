import socket
import cv2
import pickle
import struct
import datetime
import pyrebase
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import random
from moviepy.editor import *


x = "load"
type2 = ".mp4"
type1 = ".jpg"

class Socket():
    def __init__(self) -> None:
        # Socket Create
        server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        host_name = socket.gethostname()
        host_ip = socket.gethostbyname(host_name)
        print('HOST IP:', host_ip)
        port = 9800
        socket_address = (host_ip, port)

        # Socket Bind
        server_socket.bind(socket_address)

        # Socket Listen
        server_socket.listen(1)
        print("LISTENING AT:", socket_address)
        self.client_socket, addr = server_socket.accept()
        print('GOT CONNECTION FROM:', addr)
        self.data = b""
        self.PAYLOAD_SIZE = struct.calcsize("Q")

    def recv_data(self):
        while len(self.data) < self.PAYLOAD_SIZE:
            packet = self.client_socket.recv(4*1024)  # 4K

            if not packet:
                break
            self.data += packet
        packed_msg_size = self.data[:self.PAYLOAD_SIZE]
        self.data = self.data[self.PAYLOAD_SIZE:]

        if len(packed_msg_size)<8:
            x = "강종"
            return x

        frame_size = struct.unpack("Q", packed_msg_size)[0]  #

        while len(self.data) < frame_size:
            self.data += self.client_socket.recv(4*1024)
        data_byte = self.data[:frame_size]
        self.data = self.data[frame_size:]
        return data_byte

    def get_data(self):
        data_byte = self.recv_data()
        if data_byte == "강종":
            data_byte = self.recv_data()
            gps_str = "a"

            data_byte = self.recv_data()
            shock_str = "aaaa"

            end_flag = self.recv_data()
            end_data = "aa"
            return (data_byte, gps_str, shock_str, end_data == "data_finish")

        frame = pickle.loads(data_byte)
        data_byte = self.recv_data()
        gps_str = data_byte.decode()

        #----------------------------------------shock추가
        data_byte = self.recv_data()
        sock_str = data_byte.decode()

        #-------------------------------
        end_flag = self.recv_data()
        end_data = end_flag.decode()
        return (frame, gps_str, sock_str,end_data == "data_finish")


def main():
    gpsdata = []
    network = Socket()
    is_record = False 
    fourcc = cv2.VideoWriter_fourcc('m', 'p', '4', 'v')    

    config = {
    "apiKey": "AIzaSyAz3jpOUmoyFn4eXcZGlNDkFDM",
    "authDomain": "konkukbulls-2dab.firebaseapp.com",
    "databaseURL": "",
    "projectId": "konkukbulls-27ab",
    "storageBucket": "konkukbulls-2d7ab.appspot.com",
    "serviceAccount": "C:/Users/Dongwon/Documents/serviceAccountKey.json"
    }

    firebase = pyrebase.initialize_app(config)
    storage = firebase.storage()

    cred = credentials.Certificate('C:/Users/Dongwon/Documents/serviceAccountKey.json')
    firebase_admin.initialize_app(cred,{
        'databaseURL' : 'https://konkukbulls-2ab-default-rtdb.firebaseio.com/' 
    })
 
    while True:
        
        while True:

            frame, gps_str,shock_str, end_flag= network.get_data()
            if frame == "강종":
                print("강제로 꺼짐")

            gpsdata.append(gps_str)
            drivestatus = shock_str
            print(drivestatus)
            if end_flag == False and is_record == False:
                now = datetime.datetime.now()
                nowDatetime = now.strftime('%Y-%m-%d %H:%M:%S')
                nowDatetime_path = now.strftime('%Y_%m_%d_%H_%M_%S') 
                ti = now.strftime('%Y년 %m월 %d일 %H:%M:%S') 
                string1 = now.strftime('%Y%m%d')
                is_record = True
                video = cv2.VideoWriter("C:/Users/Dongwon/Desktop/Temp/" + nowDatetime_path + type2, fourcc, 5.0, (frame.shape[1], frame.shape[0]))
                cv2.imwrite( "C:/Users/Dongwon/Desktop/Temp/" + nowDatetime_path + ".jpg", frame)
                audioclip = AudioFileClip("C:/1s.mp3")
                new_audioclip = CompositeAudioClip([audioclip])

                def fulltime():           
                    return nowDatetime_path
        
                def onlydate():
                    return string1

                def ti1():
                    return ti

                full = fulltime()
                only = onlydate()
                time1 = ti1()

                def fulltime_return():           
                    return full
                def onlydate_retrun():
                    return only
                def nowtime_return():
                    return time1


                def storage_upload():
                    storage.child("Folder/"+onlydate_retrun()+"/"+fulltime_return()+type2).put("C:/Users/Dongwon/Desktop/Temp/"+fulltime_return()+"_"+type2)
                    storage.child("Folder/"+onlydate_retrun()+"/"+fulltime_return()+type1).put("C:/Users/Dongwon/Desktop/Temp/"+fulltime_return()+type1)
                    fileUrl  = storage.child("Folder/"+onlydate_retrun()+"/"+fulltime_return()+type2).get_url(1)    
                    fileUrl1  = storage.child("Folder/"+onlydate_retrun()+"/"+fulltime_return()+type1).get_url(1)   

                def db_upload_parking():
                    ref = db.reference("park"+"/"+onlydate_retrun()+"/"+stringDB) #경로가 없으면 생성한다.
                    ref.update({'time' : nowtime_return()})
                    split = gpsdata[0]
                    splitgps = split.split(",")
                    lat = splitgps[0]
                    lon = splitgps[1]
                    ref.update({'lat' : lat})#'37.54187,127.080207'
                    ref.update({'lon' : lon})#'37.54187,127.080207'
                    ref.update({'parkmediaurl' : fileUrl})
                    ref.update({'parkthumbnail' : fileUrl1})
                    ref.update({'notice' : "주차 중 이벤트가 발생했습니다."})
                    ref1 = db.reference('notification')
                    ref1.update({'status' : 'park'})
                    ref1.update({'status' : 'no'})
                    gpsdata.clear()   

                def db_upload_driving(): 
                    ref = db.reference("drive"+"/"+onlydate_retrun()+"/"+stringDB) #경로가 없으면 생성한다.
                    ref.update({'time' : nowtime_return()})
                    split = gpsdata[0]
                    splitgps = split.split(",")
                    lat = splitgps[0]
                    lon = splitgps[1]
                    ref.update({'lat' : lat})#'37.54187,127.080207'
                    ref.update({'lon' : lon})#'37.54187,127.080207'
                    ref.update({'drivemediaurl' : fileUrl})
                    ref.update({'drivethumbnail' : fileUrl1})
                    ref.update({'notice' : "주행 중 이벤트가 발생했습니다."})
                    ref1 = db.reference('notification')
                    ref1.update({'status' : 'drive'})
                    ref1.update({'status' : 'no'})
                    gpsdata.clear()

                def db_upload_forced_end(): 
                    ref = db.reference("drive"+"/"+onlydate_retrun()+"/"+stringDB) #경로가 없으면 생성한다.
                    ref.update({'time' : nowtime_return()})
                    split = gpsdata[0]
                    splitgps = split.split(",")
                    lat = splitgps[0]
                    lon = splitgps[1]
                    ref.update({'lat' : lat})#'37.54187,127.080207'
                    ref.update({'lon' : lon})#'37.54187,127.080207'
                    ref.update({'drivemediaurl' : fileUrl})
                    ref.update({'drivethumbnail' : fileUrl1})
                    ref.update({'notice' : "강제종료 이벤트가 발생했습니다."})
                    ref1 = db.reference('notification')
                    ref1.update({'status' : 'drive'})
                    ref1.update({'status' : 'no'})
                    gpsdata.clear()


            elif end_flag == True and is_record == True :
                is_record = False
                drivestatus = shock_str
                print(drivestatus)
                stringDB = fulltime_return()
                video.release()
                videoclip = VideoFileClip("C:/Users/Dongwon/Desktop/Temp/"+fulltime_return()+type2)
                videoclip.audio = new_audioclip   
                videoclip.write_videofile("C:/Users/Dongwon/Desktop/Temp/"+fulltime_return()+"_"+type2)

                storage_upload()

                if drivestatus == 'driving':
                    db_upload_driving()
                else:
                    db_upload_parking()

            elif frame == "강종" and is_record == True:
                print("Forced close")
                is_record = False
                stringDB = fulltime_return()
                video.release()
                videoclip = VideoFileClip("C:/Users/Dongwon/Desktop/Temp/"+fulltime_return()+type2)
                videoclip.audio = new_audioclip        
                videoclip.write_videofile("C:/Users/Dongwon/Desktop/Temp/"+fulltime_return()+"_"+type2)
                storage_upload()
                db_upload_forced_end()
                

            if is_record == True:
                video.write(frame)

            cv2.imshow("RECEIVING VIDEO", frame)

            if end_flag :
                print("정상종료")

            key = cv2.waitKey(1) & 0xFF
            if key == ord('q'):
                break

        print("END FLAG")
        while True:
            pass


if __name__ == '__main__':
    main()