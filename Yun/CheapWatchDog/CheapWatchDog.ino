/* 
  iero Cheap WatchDog
     Written by G. FABRE July 2015
     Website: https://github.com/iero
     Wait for heartbeat from Arduino and send reset 
       if it doesn't catch any life sign.
*/

#define LED_PIN 13 // White led
#define PULSE_PIN 11 // Get Heartbeat
#define RESET_PIN 9 // Port to send reset

#define WATCHDOG_DELAY 300000 // Wait 5 min before sending reset
#define ARDUINO_REBOOT_TIME 60000 // Wait 1 min for master Arduino to restart

volatile int state = LOW; // heart beat state

unsigned long lastHeartbeat = 0;

void(* reboot) (void) = 0; //declare reset function @ address 0

void setup() {  
  boot();
}

void loop() {
  // Get last pulse
  boolean pulse = digitalRead(PULSE_PIN);

  if (pulse != state) { // Got pulse change
    lastHeartbeat = millis();
    state = pulse ;
  }

  unsigned long uptime = millis();
  if ((uptime - lastHeartbeat) >= WATCHDOG_DELAY) {
    sendReset();
  }
}

void sendReset() {
  // Send reset to main Arduino by sending LOW
  digitalWrite(RESET_PIN, LOW);
  delay(1000);
  digitalWrite(RESET_PIN, HIGH);
  
  // Wait Main arduino to reboot
  reboot();
}

void boot(){
  digitalWrite(LED_PIN, HIGH);
  delay(ARDUINO_REBOOT_TIME);
  lastHeartbeat = millis();
  digitalWrite(LED_PIN, LOW);
}
