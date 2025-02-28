# Gerenciamento de Filas IoT - GENSUS - HandOn-Intermediary-2A1R

Este projeto utiliza uma combinação de sensores, como NFC (RFID) e biometria (sensor de impressão digital), para controlar o acesso de usuários e permitir que escolham um serviço através de um menu. O sistema é integrado com um servidor via Wi-Fi para enviar os dados de acesso. O usuário pode acessar serviços como "Atendimento", "Exame" e "Farmácia". A interface de usuário é apresentada em um display LCD.

## Requisitos de Hardware

- **Placa principal:** ESP32 (ou similar)
- **LCD:** 20x4 LCD (usando interface de 4 pinos)
- **NFC:** PN532 para leitura de tags RFID
- **Sensor biométrico:** Sensor de impressões digitais (exemplo: R307)
- **LEDs:** LEDs RGB para indicar o status de acesso
- **Botões:** 3 botões para selecionar o serviço (Atendimento, Exame, Farmácia)
- **Wi-Fi:** Rede Wi-Fi para enviar os dados ao servidor

### Conexões:

- **LCD (LiquidCrystal):** 
  - RS -> GPIO 4
  - E -> GPIO 16
  - D4 -> GPIO 17
  - D5 -> GPIO 5
  - D6 -> GPIO 18
  - D7 -> GPIO 19
- **NFC (PN532):**
  - SDA -> GPIO 21
  - SCL -> GPIO 22
- **Sensor biométrico (R307):**
  - RX -> GPIO 26
  - TX -> GPIO 27
- **Botões:**
  - Atendimento -> GPIO 34
  - Exame -> GPIO 35
  - Farmácia -> GPIO 32
- **LEDs:**
  - LED Vermelho -> GPIO 23
  - LED Verde -> GPIO 25

## Requisitos de Software

- **Arduino IDE** com suporte para a placa ESP32.
- **Bibliotecas Arduino**:
  - `Adafruit_PN532` para NFC.
  - `Adafruit_Fingerprint` para o sensor biométrico de impressão digital.
  - `LiquidCrystal` para controlar o LCD.
  - `WiFi` para conectar à rede Wi-Fi.
  - `HTTPClient` para fazer requisições HTTP.
  - `ArduinoJson` para manipulação de JSON.

## Funcionamento do Sistema

1. **Conexão Wi-Fi**: O sistema conecta-se automaticamente à rede Wi-Fi especificada usando o SSID e a senha definidos no código.

2. **Leitura RFID**: O sistema espera que o usuário aproxime um cartão RFID. Quando o cartão é lido, o sistema verifica se o usuário está registrado no servidor. Caso o usuário esteja registrado, a leitura é bem-sucedida.

3. **Autenticação Biométrica**: Após a leitura do RFID, o sistema solicita que o usuário coloque o dedo no sensor biométrico para realizar a autenticação de impressão digital. O usuário tem 15 tentativas para a validação da digital.

4. **Menu de Seleção de Serviço**: Após a validação, o usuário é apresentado a um menu no LCD com as opções:
   - 1. Atendimento
   - 2. Exame
   - 3. Farmácia

   O usuário escolhe uma opção pressionando o botão correspondente.

5. **Envio de Dados**: O sistema envia os dados de acesso para o servidor via HTTP. O RFID do usuário e o número do serviço escolhido são enviados como dados JSON.

6. **Indicadores Visuais**: O sistema utiliza LEDs para indicar o status:
   - LED Verde: Acesso autorizado
   - LED Vermelho: Acesso negado

7. **Feedback no LCD**: O LCD exibe mensagens de status durante o processo, como "Acesso autorizado", "Acesso negado", "Dados enviados", etc.

## Fluxo de Execução

- O sistema começa inicializando os componentes de hardware, como LCD, NFC e sensor biométrico.
- Em seguida, ele aguarda que o usuário aproxime um cartão RFID.
- O sistema valida o cartão RFID e, se for válido, solicita a autenticação biométrica (digital).
- Após a autenticação, o usuário escolhe um serviço no menu.
- O sistema envia os dados ao servidor e exibe a confirmação no LCD.
- O ciclo se repete, aguardando uma nova aproximação do cartão RFID.

## Funções Principais

- **connectWiFi()**: Conecta o sistema à rede Wi-Fi.
- **showLCDMessage()**: Exibe uma mensagem no LCD.
- **enviarDados()**: Envia os dados para o servidor via HTTP.
- **verificarRFID()**: Verifica se o RFID é válido consultando o servidor.
- **getFingerprintID()**: Realiza a captura e busca da impressão digital.
- **verificarDigital()**: Solicita ao usuário a colocação do dedo e tenta a autenticação biométrica.
- **processarMenu()**: Exibe o menu de serviços e processa a escolha do usuário.

## Possíveis Melhorias

1. **Segurança**: Considerar criptografar a comunicação com o servidor (HTTPS) para proteger os dados.
2. **Feedback do Servidor**: Mostrar uma mensagem mais detalhada sobre a resposta do servidor (ex: sucesso ou erro na inserção dos dados).
3. **Aprimorar Interface**: Melhorar a interface do LCD com mais informações sobre o status do usuário ou um histórico de atendimentos.

## Dependências

- `Adafruit_PN532` - Biblioteca para o módulo NFC.
- `Adafruit_Fingerprint` - Biblioteca para o sensor biométrico.
- `LiquidCrystal` - Biblioteca para o display LCD.
- `WiFi` - Biblioteca para conectar à rede Wi-Fi.
- `HTTPClient` - Biblioteca para realizar requisições HTTP.
- `ArduinoJson` - Biblioteca para manipulação de dados JSON.

## Licença

Este projeto é licenciado sob a [MIT License](LICENSE). 

## Autores

Este projeto foi desenvolvido por [Seu Nome].
