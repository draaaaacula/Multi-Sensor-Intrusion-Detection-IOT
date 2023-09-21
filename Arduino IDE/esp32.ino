//ESP32

#include <WiFi.h>
#include <FirebaseESP32.h> // Firebase library for ESP32
// Replace with your Wi-Fi credentials
const char* ssid = "iPhone 15 Pro Max";
const char* password = "55555555";

// Firebase configuration
#define FIREBASE_HOST "https://smart-home-security-syst-48432-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "AIzaSyAvTVh6YMJm-Ebq19Mfib9biuG-vBR292U"

#define FLAME_PIN 35 
#define GAS_PIN 25
#define flamec 5
#define gasc 18
#define lockc 21
#define exhaust 22
#define current 23
#define fan 13
#define light 12

WiFiClient wifiClient;
FirebaseData firebaseData;

void setup() {
  Serial.begin(115200);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  
  pinMode(FLAME_PIN, INPUT);
  pinMode(GAS_PIN, INPUT);
 
  pinMode(flamec, OUTPUT);
  pinMode(gasc, OUTPUT);
 pinMode(lockc, OUTPUT);
  pinMode(exhaust, OUTPUT);
  pinMode(current, OUTPUT);
  pinMode(fan, OUTPUT);
pinMode(light, OUTPUT);
}

void loop() {
  int flameValue = digitalRead(FLAME_PIN); 
  int gasValue = digitalRead(GAS_PIN); 
 

if (flameValue == HIGH || gasValue == LOW ) { 
    digitalWrite(fan, HIGH);
  } 
  else 
  {
   digitalWrite(fan, LOW); 
  }
  delay(100);
 readFirebaseData();
}


void readFirebaseData() {
  if (Firebase.getString(firebaseData, "/devices/Door Lock")) {
    bool receivedData = firebaseData.boolData();
    
      if(receivedData == true)
      {digitalWrite(lockc, HIGH);
      Serial.print("Door Lock ");
      }else
      {digitalWrite(lockc, LOW);
      }}
       if (Firebase.getString(firebaseData, "/devices/Door Light")) {
    bool receivedData = firebaseData.boolData();
    
      if(receivedData == true)
      {digitalWrite(light, HIGH);
      Serial.print("Door Light ");
      }else
      {digitalWrite(light, LOW);
      }}
        if (Firebase.getString(firebaseData, "/devices/Gas")) {
    bool receivedData = firebaseData.boolData();

      if(receivedData == true)
      {digitalWrite(gasc, HIGH);
      Serial.print("gas");
      }else
      {digitalWrite(gasc, LOW);
      }}
       if (Firebase.getString(firebaseData, "/devices/Flame")) {
    bool receivedData = firebaseData.boolData();
   
      if(receivedData == true)
      {digitalWrite(flamec, HIGH);
         Serial.print("Flame");
      }else
      {digitalWrite(flamec, LOW);
      }}
       if (Firebase.getString(firebaseData, "/devices/Exhaust")) {
    bool receivedData = firebaseData.boolData();
    
      if(receivedData == true)
      {digitalWrite(exhaust, HIGH);
      Serial.print("fan");
      }else
      {digitalWrite(exhaust, LOW);
      }}
       if (Firebase.getString(firebaseData, "/devices/Current")) {
    bool receivedData = firebaseData.boolData();
    
    
      if(receivedData == true)
      {digitalWrite(current, HIGH);
        Serial.print("Current ");
      }else
      {digitalWrite(current, LOW);
      }}}
