#include <DFRobot_TFmini.h>

SoftwareSerial mySerial(9,6); // RX, TX
DFRobot_TFmini  TFmini;

uint16_t distance;   // 거리를 담는 변수
const int BUTTON_PIN1 = 7;
int currentButtonState;
int sensorPin = A1;

void setup() {
  Serial.begin(115200);
  TFmini.begin(mySerial);
   pinMode(A0,INPUT);
   pinMode(BUTTON_PIN1, INPUT);
   pinMode(sensorPin, INPUT);
}

void loop() {
   if (TFmini.measure()) {                
    distance = TFmini.getDistance();       
    //Serial.println("거리");
    Serial.println(distance);
    
    int x = analogRead(A0);
    //Serial.println("불꽃");
    Serial.println(x);
    
    currentButtonState = digitalRead(BUTTON_PIN1);
    //Serial.println("스위치");
    Serial.println(currentButtonState);
    int val = analogRead(A1);
    //Serial.println("충격");
    Serial.println(val);
    
    delay(100);
}
}



//거리
//VCC - 5V
//GND-GND
//green - 9
//white - 6  

//불꽃감지
//VCC-5V
//GND-GND
//A0 - R - A0

//경적
//VCC-5V
//GND-GND
//PIN7

//충격
//VCC-5V
//GND-GND
//A0-A1
