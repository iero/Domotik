
#define LED_PIN 13 // White led
#define PULSE_PIN 11 // Get Heartbeat
#define RESET_PIN 9 // Port to send reset

#define WATCHDOG_DELAY 5000 // Wait x ms before sending reset
#define ARDUINO_REBOOT_TIME 10000 // Wait x ms for master Arduino to restart

unsigned long lastHeartbeat = 0;
unsigned long lastUptimeReport = 0;

void setup() {
    // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);  
  Serial.println("Arduino reset");
  
  // put your setup code here, to run once:
  digitalWrite(LED_PIN, HIGH);
  delay(2000) ;
  lastHeartbeat = millis();
  digitalWrite(LED_PIN, LOW);
}

void loop() {
  // Get last pulse
  boolean pulse = digitalRead(PULSE_PIN);
  if (pulse == HIGH) {
    lastHeartbeat = millis();
    Serial.println("Pulse !");
  }
  
  unsigned long uptime = millis();
  if ((uptime - lastHeartbeat) >= WATCHDOG_DELAY) { //too long
    Serial.println("Uptime: " + String((uptime - (uptime % 5000)) / 1000) + " seconds (" + String((uptime - lastHeartbeat) / 1000) + " seconds since last heartbeat)");
    sendReset();

  }
  delay(2000); // needed for prod ?
}

void sendReset() {
  // Send reset to main Arduino
  Serial.println("Reset.. and wait");
  digitalWrite(LED_PIN, HIGH);
  digitalWrite(RESET_PIN, HIGH);
  delay(1000);
  digitalWrite(RESET_PIN, LOW);
  // Wait Main arduino to reboot
  delay(ARDUINO_REBOOT_TIME);
  digitalWrite(LED_PIN, LOW);
  delay(5000);
  lastHeartbeat = millis();
  Serial.println("Back on line ?");
}
