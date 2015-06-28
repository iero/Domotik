#define LED_PIN 13 // White led
#define WATCHDOG_PIN 11 // Cheapduino Heartbeat
#define DELAY 2000       // Heartbeat rate

void setup() {
  digitalWrite(WATCHDOG_PIN, LOW);
  digitalWrite(LED_PIN, LOW);
}

void loop() {
   // Send heartbeat and wait before continuing
  digitalWrite(LED_PIN, HIGH);
  digitalWrite(WATCHDOG_PIN, HIGH);
  delay(DELAY); // wait enough time to allow watchdog to see the signal
  digitalWrite(WATCHDOG_PIN, LOW);
  digitalWrite(LED_PIN, LOW);
  delay(DELAY); // wait enough time to allow watchdog to see the signal
}
