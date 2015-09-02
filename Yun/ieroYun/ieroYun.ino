#include <Bridge.h>
#include <YunServer.h>
#include <YunClient.h>
#include <dht.h>

// Radiateurs
#define SWITCH_2F_PIN 2   // Chambre Parents 2 kW et SDB RDC 1 kW
#define SWITCH_1G_PIN 3   // Cuisine 0.9 kW et SDB Etage 1 kW
#define SWITCH_3H_PIN 4   // Salon - cuisine 2 kW
#define SWITCH_3I_PIN 5   // Salon - videoproj 1.5 kW
#define SWITCH_2C_PIN 6  // Salon - salle a manger 1.5 kW
#define SWITCH_3C_PIN 7  // Entree 0.9 kW

#define SWITCH_2J_PIN 8   // Chauffe eau
//#define SWITCH_3A_PIN 9   // Lumiere jardin
int MAX_OUTPUT = 9 ; // Last pin used for output

#define DHT22_PIN 10 // Temp et Hum

boolean SWITCH_STATE[13] ; // State of relays. true if ON.

void readTemperature(YunClient client);
void readTHumidity(YunClient client);
void switchON(int PIN) ;
void switchOFF(int PIN) ;
boolean switchSTATE(int PIN) ;
void resetAllSwitches() ;

YunServer server;
dht DHT;

void setup() {
  Bridge.begin();
  server.listenOnLocalhost();
  server.begin();
  
  for (int i=2; i <= MAX_OUTPUT; i++){ 
    pinMode(i,OUTPUT);
  }
    
  resetAllSwitches();  
}

void loop() {

  YunClient client = server.accept();
  if (client) {
    String command = client.readString();
    command.trim();
    if (command == "temperature") readTemperature(client);
    else if (command == "humidity") readHumidity(client);

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

    else if (command == "2J/On") switchON(SWITCH_2J_PIN);
    else if (command == "2J/Off") switchOFF(SWITCH_2J_PIN);
    else if (command == "2J/Status") client.print(switchSTATE(SWITCH_2J_PIN));

    //else if (command == "3A/On") switchON(SWITCH_3A_PIN);
    //else if (command == "3A/Off") switchOFF(SWITCH_3A_PIN);
    //else if (command == "3A/Status") client.print(switchSTATE(SWITCH_3A_PIN));

    client.stop();
  } 
  delay(2000);
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
    for (int i=2; i <= MAX_OUTPUT; i++){ 
      switchOFF(i);
  }
}

