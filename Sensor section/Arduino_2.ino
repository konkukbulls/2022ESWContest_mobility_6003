#include <SoftwareSerial.h>
#include <TinyGPS.h>
#include <Wire.h>
#include <BH1750.h>
#include <DFRobot_TFmini.h>

BH1750 lightMeter;
TinyGPS gps;
SoftwareSerial ss(3,2);
SoftwareSerial mySerial(9, 6); // RX, TX
DFRobot_TFmini  TFmini;

//출력값(주행중)-GPS위치(E,A),속력,조도,제동거리
//출력값(주차중)-GPS위치(E,A),속력,조도,움직임

int pirPin =8;
const int BUTTON_PIN = 7;
int currentButtonState;
int lastButtonState;
int ledState = LOW;
int car = 0;
int km_h =0;
uint16_t distance;

void setup(){
  Serial.begin(9600);
  pinMode(BUTTON_PIN, INPUT);
  Wire.begin();
  ss.begin(9600);
  lightMeter.begin();
  pinMode(pirPin, INPUT);
  currentButtonState = digitalRead(BUTTON_PIN);
  TFmini.begin(mySerial);
}

void loop()
{
  bool newData = false;
  unsigned long chars;
  unsigned short sentences, failed;
  
  for (unsigned long start = millis(); millis() - start < 1000;)
  {
    while (ss.available())
    {
      char c = ss.read();
      if (gps.encode(c)) 
        newData = true;   
    }
  }

  if (newData)
  {
    float flat, flon;
    unsigned long age;
    gps.f_get_position(&flat, &flon, &age);
    Serial.println(flat == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flat, 6);
    Serial.println(flon == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flon, 6);
    Serial.println(gps.f_speed_kmph());
    km_h = gps.f_speed_kmph();
    
    swich();
    lightvalue();
    delay(100);
    if(car == 0){
      movement();
    }
    else{
      brakingdistance();
    }
}
}

int brakingdistance(){//제동거리안에 차량이 있는지 출력해주는 함수-거리안에있을경우 1 없을경우 0
  
  if (TFmini.measure()) {                  
    distance = TFmini.getDistance();       
  int vvvv = gps.f_speed_kmph();
  int mdistance = (0.005*(vvvv*vvvv)+0.2*(vvvv)/100);
  
  if (distance < mdistance){
    Serial.println(1);
    Serial.println(distance);
  }
  else{
    Serial.println(0);
    Serial.println(distance);
  }
  
}
}

int lightvalue(){//조도의 상태를 출력해주는 함수-밝으면 1 어두우면 0
  int lux = lightMeter.readLightLevel();
  if(lux > 30){
    Serial.println("1");
    }
  else{
    Serial.println("0");
    }
}

int movement(){//움직임상태를 출력해주는 함수-움직임(1),안움직임(0)
  int state = digitalRead(pirPin);
  Serial.println(state);

}

int swich(){//주행중인지 주차중인지 출력해주는 함수-주행(1),주차(0)
  lastButtonState = currentButtonState;
  currentButtonState = digitalRead(BUTTON_PIN);
  
   if(lastButtonState == HIGH && currentButtonState == LOW) {

    if(ledState == LOW){
      ledState = HIGH;
     return car = 1;
    }
    else{
      ledState = LOW;
     return car = 0;
    }
  }
  
}

//VCC - 5V
//GND - GND
//IN - 7

//VCC - 5V
//GND - GND
//OUT - 8

//3.3V - VCC
//GND - GND
//A5 - SCL
//A4 - SDA

//5V - VCC
//GND - GND
//RX - 2
//TX - 3

//VCC - 5V
//GND-GND
//green - 9
//white - 6
