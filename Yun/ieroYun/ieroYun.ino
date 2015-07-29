/* 
  iero Yun
     Written by G. FABRE 22/07/2015
     Website: https://github.com/iero
     This program can handle :
     - Relays
     - DHT22
     - RF 433 MHz receiver
     - Cheapduino Watchdog
     Everything is controlled by a web server.

     For cheapduino watchdog :
     - Create /root/pulse.sh with
       #!/bin/sh
       wget -O /dev/null -q --user=root --password=YOURPASS http://localhost/arduino/pulse &> /dev/null
     - Add * /1 * * * * /root/pulse.sh > /dev/null to crontab
*/

#include <Bridge.h>
#include <YunServer.h>
#include <YunClient.h>
#include <dht.h>
#include <VirtualWire.h> // For RF433

// Radiateurs
#define SWITCH_2F_PIN 2  // Chambre Parents 2kW et SDB RDC 1 kW
#define SWITCH_1G_PIN 3  // Cuisine 0.9 kW et SDB Etage 1 kW
#define SWITCH_3H_PIN 4  // Salon - cuisine 2 kW
#define SWITCH_3I_PIN 5  // Salon - videoproj 1.5 kW
#define SWITCH_2C_PIN 6  // Salon - salle a manger 1.5 kW
#define SWITCH_3C_PIN 7  // Entree 0.9 kW
#define SWITCH_3J_PIN 8  // Chauffe eau

boolean SWITCH_STATE[13] ; // State of relays. true if ON.

// Others
#define DHT22_PIN 9     // Temp et Hum
#define WATCHDOG_PIN 10  // Heartbeat for WatchDog

// RF com
#define RF_RX_PIN 11      // For RF 433MHz receiver
#define RF_TX_PIN 12      // For RF 433MHz transmitter

// Watchdog
#define LED_PIN 13       // LED for heart beat
volatile int state = LOW; // heart beat state

int humExt[3] ;
YunServer server;
dht DHT;

void heartBeat();
void readTemperature(YunClient client);
void readTHumidity(YunClient client);
void switchON(int PIN) ;
void switchOFF(int PIN) ;
boolean switchSTATE(int PIN) ;
void resetAllSwitches() ;

void setup() {
  Bridge.begin();
  server.listenOnLocalhost();
  server.begin();
  
  for (int i=2; i<=8; i++) pinMode(i,OUTPUT);
  resetAllSwitches();

  // RF reception
  for (int i=0; i<=2; i++) humExt[i]=0;
  vw_set_rx_pin(RF_RX_PIN);
  vw_setup(300);   // Bits per sec
  vw_rx_start();   // Start the receiver PLL running
}

void loop() {
  YunClient client = server.accept();
  if (client) {
    String command = client.readString();
    command.trim();
    
    if (command == "temperature") readTemperature(client);
    else if (command == "humidity") readHumidity(client);

    else if (command == "All/Off") resetAllSwitches();

    else if (command == "2F/On") switchON(SWITCH_2F_PIN);
    else if (command == "2F/Off") switchOFF(SWITCH_2F_PIN);
    else if (command == "2F/Status") client.print(switchSTATE(SWITCH_2F_PIN));

    else if (command == "1G/On") switchON(SWITCH_1G_PIN);
    else if (command == "1G/Off") switchOFF(SWITCH_1G_PIN);
    else if (command == "1G/Status") client.print(switchSTATE(SWITCH_1G_PIN));

    else if (command == "3H/On") switchON(SWITCH_3H_PIN);
    else if (command == "3H/Off") switchOFF(SWITCH_3H_PIN);
    else if (command == "3H/Status") client.print(switchSTATE(SWITCH_3H_PIN));

    else if (command == "3I/On") switchON(SWITCH_3I_PIN);
    else if (command == "3I/Off") switchOFF(SWITCH_3I_PIN);
    else if (command == "3I/Status") client.print(switchSTATE(SWITCH_3I_PIN));

    else if (command == "2C/On") switchON(SWITCH_2C_PIN);
    else if (command == "2C/Off") switchOFF(SWITCH_2C_PIN);
    else if (command == "2C/Status") client.print(switchSTATE(SWITCH_2C_PIN));

    else if (command == "3C/On") switchON(SWITCH_3C_PIN);
    else if (command == "3C/Off") switchOFF(SWITCH_3C_PIN);
    else if (command == "3C/Status") client.print(switchSTATE(SWITCH_3C_PIN));

    else if (command == "3J/On") switchON(SWITCH_3J_PIN);
    else if (command == "3J/Off") switchOFF(SWITCH_3J_PIN);
    else if (command == "3J/Status") client.print(switchSTATE(SWITCH_3J_PIN));

    //else if (command == "3A/On") switchON(SWITCH_3A_PIN);
    //else if (command == "3A/Off") switchOFF(SWITCH_3A_PIN);
    //else if (command == "3A/Status") client.print(switchSTATE(SWITCH_3A_PIN));

    else if (command == "uptime") client.print(millis());
    else if (command == "pulse") heartBeat();

    // Garden humidity
    else if (command == "ext00/humitity0") client.print(humExt[0]);
    else if (command == "ext00/humitity1") client.print(humExt[1]);
    else if (command == "ext00/humitity2") client.print(humExt[2]);

    client.stop();
    delay(50);
  }
  
 // Parse RF
 uint8_t buf[VW_MAX_MESSAGE_LEN];
 uint8_t buflen = VW_MAX_MESSAGE_LEN;
 word hum ;
 
 if (vw_get_message(buf, &buflen)) { // Non-blocking
   digitalWrite(LED_PIN, HIGH); 
   if (buf[0] == '0' && buf[1] == '0') { // Garden humidity sensor
     word hum;
     for (int i=0 ; i<=2 ; i++) {
        hum = word(buf[3*i+3], buf[3*i+4]) ;
        humExt[i] = int(hum);
     }
   }
   digitalWrite(LED_PIN , LOW);
 } 
}

void heartBeat() {
  if (state==LOW) state=HIGH;
  else state=LOW;
  digitalWrite(LED_PIN, state);   
  digitalWrite(WATCHDOG_PIN, state);
}

void readTemperature(YunClient client) {
  DHT.read22(DHT22_PIN);
  client.print(DHT.temperature); 
}

void readHumidity(YunClient client) {
  DHT.read22(DHT22_PIN);
  client.print(DHT.humidity); 
}

void switchON(int PIN) {
  digitalWrite(PIN, HIGH);
  SWITCH_STATE[PIN]=true;
}

void switchOFF(int PIN) {
  digitalWrite(PIN, LOW);
  SWITCH_STATE[PIN]=false;
}

boolean switchSTATE(int PIN) {
  return SWITCH_STATE[PIN];
}

void resetAllSwitches() {
  for (int i=2; i<=8; i++) switchOFF(i);
  digitalWrite(WATCHDOG_PIN, LOW);
  digitalWrite(LED_PIN, LOW);
}
