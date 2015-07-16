
#define LED_PIN 13 // White led
#define PULSE_PIN 11 // Get Heartbeat
#define RESET_PIN 9 // Port to send reset

#define WATCHDOG_DELAY 10000 // Wait 10s before sending reset
#define ARDUINO_REBOOT_TIME 60000 // Wait 1 min for master Arduino to restart

unsigned long lastHeartbeat = 0;
unsigned long lastUptimeReport = 0;

void setup() {  
  digitalWrite(LED_PIN, HIGH);
  delay(ARDUINO_REBOOT_TIME);
  lastHeartbeat = millis();
  digitalWrite(LED_PIN, LOW);
}

void loop() {
  // Get last pulse
  boolean pulse = digitalRead(PULSE_PIN);

  if (pulse == HIGH) { // Got pulse
    digitalWrite(LED_PIN, HIGH);
    lastHeartbeat = millis();
    delay(1000);
    digitalWrite(LED_PIN, LOW);
    delay(1000);
  }

  unsigned long uptime = millis();
  if ((uptime - lastHeartbeat) >= WATCHDOG_DELAY) { //too long
    //Serial.println("Uptime: " + String((uptime - (uptime % 5000)) / 1000) + " seconds (" + String((uptime - lastHeartbeat) / 1000) + " seconds since last heartbeat)");
    sendReset();
  }
  //delay(200); // needed for prod ?
}

void sendReset() {
  // Send reset to main Arduino by sending LOW
  //Serial.println("Reset.. and wait");
  digitalWrite(LED_PIN, HIGH);
  digitalWrite(RESET_PIN, LOW);
  delay(1000);
  digitalWrite(RESET_PIN, HIGH);
  // Wait Main arduino to reboot
  delay(ARDUINO_REBOOT_TIME);
  digitalWrite(LED_PIN, LOW);
  delay(5000);
  lastHeartbeat = millis();
  //Serial.println("Back on line ?");
}
