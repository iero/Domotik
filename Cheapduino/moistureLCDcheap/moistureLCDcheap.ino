/* 
  iero Moisture sensor
     Written by G. FABRE Octobre 2016
     Website: https://github.com/iero
     This program is based on excelent Gardenbot flip/flop moisture sensor :
     http://gardenbot.org/howTo/soilMoisture/
     
     The idea here is to reduce electrolysis by flipping voltage using two digital ports
     We read values on analogic port

     Testing calibration version with run on cheapduindo with LCD screen attached.
     Final version will get data every hour
*/

// for LCD
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

#define voltageFlipPin1 9
#define voltageFlipPin2 10
#define sensorPin A0

int flipTimer = 5000;

LiquidCrystal_I2C lcd(0x27,16,2); // LCD

void setup(){
  Serial.begin(9600);
  pinMode(voltageFlipPin1, OUTPUT);
  pinMode(voltageFlipPin2, OUTPUT);
  pinMode(sensorPin, INPUT);       
  Wire.begin();
  lcd.init();                      // initialize the lcd 
  lcd.backlight();
  lcd.print("iero Plant");
}

void setSensorPolarity(boolean flip) {
  if (flip) {
    digitalWrite(voltageFlipPin1, HIGH);
    digitalWrite(voltageFlipPin2, LOW);
  } else {
    digitalWrite(voltageFlipPin1, LOW);
    digitalWrite(voltageFlipPin2, HIGH);
  }
}

void loop(){ 
  setSensorPolarity(true);
  delay(flipTimer);
  int val1 = analogRead(sensorPin);

  delay(flipTimer);  
  setSensorPolarity(false);
  delay(flipTimer);
  // invert the reading
  int val2 = 1023 - analogRead(sensorPin);

  reportLevels(val1,val2);
}


void reportLevels(int val1, int val2){
  int avg = (val1 + val2) / 2;
  String msg="Moisture : ";
  msg += avg;
  
  Serial.println(msg);  
  lcd.clear();
  lcd.print(msg);
}
