/*
 * CheapWatchDog
 * G. FABRE - July 2015
 *
 * Garden Humidity
 * Wait for heartbeat from Arduino and send reset
 * if it doesn't catch any life sign.
 */

#include <VirtualWire.h>

#define LED_PIN 13    // White led
#define RF_TX_PIN 9  // For RF 433MHz transmitter

#define HUM_PIN_0 0
#define HUM_PIN_1 4
#define HUM_PIN_2 5

#define LOOP_DELAY 500

int getHumidity(int val);

void setup() {
  Serial.begin(9600);
  pinMode(LED_PIN, OUTPUT) ;
  digitalWrite(LED_PIN, LOW) ;
  vw_set_tx_pin(RF_TX_PIN) ;
  vw_setup(300) ;
}

void loop() {
  char msg[11] ;
  msg[0] ='0';
  msg[1] ='0';
  for (int i=0 ; i<=2 ; i++) {
    int hum = getHumidity(i);
    Serial.println(hum);
    msg[3*i+2] = ':' ;
    msg[3*i+3] = highByte(hum) ;
    msg[3*i+4] = lowByte(hum) ;
  }

  digitalWrite(LED_PIN, HIGH) ;
  vw_send((uint8_t *) msg, 11) ;
  Serial.println("Message : ");
  Serial.println(msg);
  Serial.println("End Message");
  digitalWrite(LED_PIN, LOW) ;
  delay(LOOP_DELAY);

}

int getHumidity(int val) {
  if (val == 0) return analogRead(HUM_PIN_0) ;
  else if (val == 1) return analogRead(HUM_PIN_1) ;
  else if (val == 2) return analogRead(HUM_PIN_2) ;
}
