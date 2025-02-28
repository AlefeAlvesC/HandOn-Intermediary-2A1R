#include <SPI.h>
#include <Adafruit_PN532.h>
#include <LiquidCrystal.h>
#include <Adafruit_Fingerprint.h>
#include <HardwareSerial.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// Definição dos pinos do LCD
#define RS 4
#define E 16
#define D4 17
#define D5 5
#define D6 18
#define D7 19

// Pinos do LED e botões
#define RED_LED_PIN 23
#define GREEN_LED_PIN 25
#define BUTTON_ATENDIMENTO_PIN 34
#define BUTTON_EXAME_PIN 35
#define BUTTON_FARMACIA_PIN 32

// Inicialização do LCD e NFC
LiquidCrystal lcd(RS, E, D4, D5, D6, D7);
Adafruit_PN532 nfc(21, 22);

// Inicialização do sensor biométrico
HardwareSerial mySerial(2);
Adafruit_Fingerprint finger(&mySerial);

// Conexão Wi-Fi e servidor
const char* ssid = "CIT_Alunos";
const char* password = "alunos@2024";
const String serverUrl = "http://172.22.68.216:5000";

String rfidTag = "";
bool acessoAutorizado = false;

void connectWiFi() {
  Serial.print("Conectando-se à rede Wi-Fi");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConectado!");
}

void showLCDMessage(String line1, String line2 = "", String line3 = "", String line4 = "") {
  lcd.clear();
  lcd.setCursor(0, 0); lcd.print(line1);
  if (!line2.isEmpty()) { lcd.setCursor(0, 1); lcd.print(line2); }
  if (!line3.isEmpty()) { lcd.setCursor(0, 2); lcd.print(line3); }
  if (!line4.isEmpty()) { lcd.setCursor(0, 3); lcd.print(line4); }
}

void enviarDados(String rfid, int option) {
  if (option == 1) showLCDMessage("", "   Atendimento");
  if (option == 2) showLCDMessage("", "   Exame");
  if (option == 3) showLCDMessage("", "   Farmacia");
  delay(1000);

  HTTPClient http;
  http.begin(serverUrl + "/add_attendance");
  http.addHeader("Content-Type", "application/json");

  DynamicJsonDocument doc(256);
  doc["rfid"] = rfid;
  doc["number"] = option;
  String payload;
  serializeJson(doc, payload);

  int responseCode = http.POST(payload);
  Serial.printf("HTTP Response: %d\n", responseCode);


  if (responseCode == 200) {
    for (int i = 5; i > 0 ; i--) {
      showLCDMessage("Dados enviados!", "Proximo em: " + String(i));
     delay(1000);
    }
    showLCDMessage("","      Aguarde");
    delay(1000);
  }
  else showLCDMessage("Falha ao enviar", "Codigo: " + String(responseCode));

  delay(5000);
  http.end();
}

bool verificarRFID(String rfid) {
  HTTPClient http;
  http.begin(serverUrl + "/check_rfid");
  http.addHeader("Content-Type", "application/json");

  DynamicJsonDocument doc(128);
  doc["rfid"] = rfid;
  String payload;
  serializeJson(doc, payload);

  int code = http.POST(payload);
  if (code == 200) {
    deserializeJson(doc, http.getString());
    return doc["success"].as<bool>();
  }

  http.end();
  return false;
}

bool getFingerprintID() {
  uint8_t p = finger.getImage();
  if (p != FINGERPRINT_OK) return false;

  p = finger.image2Tz();
  if (p != FINGERPRINT_OK) return false;
  
  p = finger.fingerFastSearch();
  if (p != FINGERPRINT_OK) {
    return true;
  }
}

bool verificarDigital() {
  showLCDMessage("Coloque a digital");
  for (int tentativas = 0; tentativas < 15; tentativas++) {
    if (getFingerprintID()) {
      return true;
    }
    delay(500);
  }
  showLCDMessage("Digital falhou");
  delay(2000);
  return false;
}

void processarMenu() {
  showLCDMessage("Escolha:", "1-Atendimemto", "2-Exame", "3-Farmacia");

  while (true) {
    if (digitalRead(BUTTON_ATENDIMENTO_PIN) == HIGH) { enviarDados(rfidTag, 1); break; }
    if (digitalRead(BUTTON_EXAME_PIN) == HIGH) { enviarDados(rfidTag, 2); break; }
    if (digitalRead(BUTTON_FARMACIA_PIN) == HIGH) { enviarDados(rfidTag, 3); break; }
    delay(100);
  }
  acessoAutorizado = false;
}

void setup() {
  Serial.begin(115200);
  connectWiFi();

  lcd.begin(20, 4);
  showLCDMessage("Iniciando sistema");

  pinMode(RED_LED_PIN, OUTPUT); pinMode(GREEN_LED_PIN, OUTPUT);
  pinMode(BUTTON_ATENDIMENTO_PIN, INPUT_PULLUP);
  pinMode(BUTTON_EXAME_PIN, INPUT_PULLUP);
  pinMode(BUTTON_FARMACIA_PIN, INPUT_PULLUP);

  nfc.begin();
  if (!nfc.getFirmwareVersion()) { Serial.println("Erro NFC"); while (true); }
  nfc.SAMConfig();

  mySerial.begin(57600, SERIAL_8N1, 26, 27);
  finger.begin(57600);
  if (!finger.verifyPassword()) { Serial.println("Erro sensor biom."); while (true); }
}

void loop() {
  if (!acessoAutorizado) {
    showLCDMessage("Aproxime o cartao");

    uint8_t uid[7]; uint8_t uidLength;
    if (nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, uid, &uidLength)) {
      rfidTag = "";
      for (uint8_t i = 0; i < uidLength; i++) rfidTag += String(uid[i], HEX);

      if (verificarRFID(rfidTag) && verificarDigital()) {
        acessoAutorizado = true;
        digitalWrite(GREEN_LED_PIN, HIGH); digitalWrite(RED_LED_PIN, LOW);
        showLCDMessage("Acesso autorizado");
        delay(1000);
        processarMenu();
      } else {
        showLCDMessage("Acesso negado");
        digitalWrite(RED_LED_PIN, HIGH); digitalWrite(GREEN_LED_PIN, LOW);
        delay(2000);
      }
    }
  }
}
