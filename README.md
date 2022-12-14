# BCCS (Built-in Cam Cloud System)

![KakaoTalk_20221012_004141897](https://user-images.githubusercontent.com/110047222/195141843-af22560d-8526-42bb-b4e5-804fb8b508ff.png)



## 목차
1. 작품 소개
2. 작품 시연
3. 어플리케이션 UI
4. Hardware 구성
5. Software 구성
6. 기술스택

## 1. 작품 소개

### 작품 설명
본 시스템은 차량에서 발생한 이벤트를 별도의 저장소 없이 클라우드에서 관리하여 자료의 유실을 방지하고, 사용자가 해당 정보를 편리하게 관리할 수 있는 플랫폼이다. 주행 중/주차 중 이벤트로 나누어 차량에서 발생하는 다양한 상황으로부터 위험을 감지한 경우 서버와 클라우드에 영상 정보 및 차량 정보 데이터를 실시간으로 전송한다. 이는 어플리케이션에서 실시간으로 사용자에게 제공된다.

### 작품 개요

![개요요요](https://user-images.githubusercontent.com/110047222/195034032-bcd2695d-05c6-4e82-be7d-d881650d778f.png)



- 센서 영역 : 위험 상황 감지에 필요한 외부 정보를 받아오는 센서들이 작동하는 영역이다.

- 빌트인 캠 영역 : 상시 촬영을 하며 위험상황이 감지되었을 때 서버에 영상의 프레임 및 기타 주행 정보를 전송한다.

- 서버 영역 : 빌트인 캠에서 수신받은 데이터를 처리하여 클라우드의 데이터베이스에 저장한다.

- 클라우드 영역 : 서버에서 수신받은 데이터를 필요한 정보별로 분류하여 데이터베이스에 저장한다.

- 어플리케이션 영역 : 클라우드의 데이터베이스에 접근하여 필요한 정보를 iOS와 안드로이드 어플을 통하여 받아볼 수 있다.


### 작품의 필요성 및 기대효과
- 블랙박스는 데이터를 오직 SD카드에 의존하여 저장한다. 내장된 SD카드 등의 플래시메모리는 영상정보를 입력하고 삭제하는 방식으로 사용하기에 장기간 사용 시 고장이 잦다. 그렇기에 SD카드의 오작동으로 인하여 이를 활용하지 못할 가능성이 높다. 하지만 ‘빌트인 캠 클라우드 시스템’은 위험 상황이 감지되면 즉시 녹화하여 클라우드에 업로드 하기 때문에 어플리케이션을 통해 시간과 장소에 구애받지 않고 즉시 확인 가능하다.

- 차량의 형체를 알아볼 수 없을 정도의 큰 사고나 전소 상황의 경우 블랙박스의 데이터 유실 가능성이 매우 높다. 하지만 ‘빌트인 캠 클라우드 시스템’은 위험 상황이 감지되면 즉시 녹화하여 서버에 업로드하기 때문에 대형 사고 발생 직전까지의 정보를 서버에서 처리할 수 있다. 때문에 빌트인 캠이 완전히 파손되기 직전까지 정보를 클라우드에 전송하여 사고 데이터 유실을 방지한다.

- 전기차의 수요와 공급이 늘어나고 전기차에 대한 소비자의 관심은 나날이 높아지고 있다. 하지만 전기차의 배터리에서 발생하는 화재 이슈는 소비자에게 있어 큰 불안감으로 다가온다. 또한 화재의 원인을 규명하기 위해서는 블랙박스 데이터가 필요하지만 블랙박스가 전소된 경우에는 데이터를 확보할 수 없게 된다. ‘빌트인 캠 클라우드 시스템’은 화재 상황을 위험 상황으로 감지하여 클라우드에 저장한다. 사전에 녹화된 데이터의 유실도 막고 화재 상황까지도 클라우드에 저장되기 때문에 화재 원인 규명 및 데이터 확보에 용이하다.


## 2. 작품 시연
### [시연 영상(현재 링크에서 확인 가능)](https://www.youtube.com/watch?v=tWeJjAyStjo)
### 1) 주행상황
![쥬쥬행](https://user-images.githubusercontent.com/110047222/195046425-5ad06c1a-d991-4155-880a-b4fab2f059b6.png)


### 2) 주차상황

<img width="1512" alt="KakaoTalk_20221012_002323731" src="https://user-images.githubusercontent.com/110047222/195143863-ab873d9c-12f3-4285-afab-2d8996918bd3.png">


## 3. 어플리케이션 UI
### 1) 홈 화면
![KakaoTalk_20221012_010750291](https://user-images.githubusercontent.com/110047222/195143823-d3eb322b-5b21-40cc-bf18-dd5ec668e2dd.png)


### 2) 녹화영상 화면
![KakaoTalk_20221011_220812268_01](https://user-images.githubusercontent.com/110047222/195100649-3bd5a63f-ab1e-4b1d-b700-9f65749a5908.png)
### 3) 알림 화면
![KakaoTalk_20221011_220812268_02](https://user-images.githubusercontent.com/110047222/195100697-5270141b-9249-4b20-a74f-edc550b6d264.png)
### 4) 설정 화면
![KakaoTalk_20221011_220812268_03](https://user-images.githubusercontent.com/110047222/195100763-8d3e6a1c-d58f-471c-8754-16d456cb416d.png)



## 4. Hardware 구성
### 1) 작품 외관
![KakaoTalk_20221011_172331219](https://user-images.githubusercontent.com/110047222/195049676-94660c75-07b4-4fe2-955c-0e6a604c378e.jpg)

### 2) 센서 회로도
![KakaoTalk_20221007_161456742](https://user-images.githubusercontent.com/110047222/195049883-2b69fcba-2838-4fb2-a09e-daa54e58322c.png)

![KakaoTalk_20221007_155658144](https://user-images.githubusercontent.com/110047222/195049941-39a3c943-562a-4fa2-8c38-9a7a1f141105.png)


## 5. Software 구성
### Software 전체 구조

![zzzzzzzzzzzzzz](https://user-images.githubusercontent.com/110047222/195095368-50325eb9-fc91-483f-bec6-634f8e6a2cbd.png)

### 1) 센서 영역 동작 원리

![aaaaaaaaaaaaaaaaaaaaa](https://user-images.githubusercontent.com/110047222/195096035-671a8b18-e8aa-4d5a-9a58-a80d62a96f5a.png)


###  2) 주차 시 위험상황 판단 및 데이터 송신 과정

![주차상황ㅁㅁㅁㅁㅁㅁㅁ](https://user-images.githubusercontent.com/110047222/195095851-19360cd5-83a9-4930-801b-8f3cdc065963.png)


### 3) 주행 시 위험상황 판단 및 데이터 송신 과정

![주줒주줗해ㅐㅎ해ㅐ해행](https://user-images.githubusercontent.com/110047222/195095881-333ec8d3-f8b6-423b-88ef-7d61e30f6da3.png)


### 4) 서버 영역 동작 원리

![서버 새로운거](https://user-images.githubusercontent.com/110047222/195096166-7ea9efd4-72f6-405c-8250-6826cd781831.png)


### 5) 데이터베이스 구조

![데이터 베이스 플로차트](https://user-images.githubusercontent.com/110047222/195096252-d23bead9-c158-447c-94e6-6ae9401f7a77.png)



<br>



## 6. 기술 스택

| 하드웨어 | 빌트인 캠 |  서버   |  클라우드   |어플리케이션|
| :--------: | :--------: | :------: | :------------: | :-----: |
| <br> ![Arduino](https://img.shields.io/badge/-Arduino-00979D?style=for-the-badge&logo=Arduino&logoColor=white) <br> ![C](https://img.shields.io/badge/c-%2300599C.svg?style=for-the-badge&logo=c&logoColor=white) 	![C++](https://img.shields.io/badge/c++-%2300599C.svg?style=for-the-badge&logo=c%2B%2B&logoColor=white)  | <br>![Raspberry Pi](https://img.shields.io/badge/-RaspberryPi-C51A4A?style=for-the-badge&logo=Raspberry-Pi) <br> ![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54) ![OpenCV](https://img.shields.io/badge/opencv-%23white.svg?style=for-the-badge&logo=opencv&logoColor=white) ![NumPy](https://img.shields.io/badge/numpy-%23013243.svg?style=for-the-badge&logo=numpy&logoColor=white)   <br> | <br> ![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54) <br> ![OpenCV](https://img.shields.io/badge/opencv-%23white.svg?style=for-the-badge&logo=opencv&logoColor=white) ![NumPy](https://img.shields.io/badge/numpy-%23013243.svg?style=for-the-badge&logo=numpy&logoColor=white)  |![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white) |![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) <br> ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)  ![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white) ![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white) <br>|

<br>


