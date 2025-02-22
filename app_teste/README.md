# Flutter Firebase App

Este é um app desenvolvido em Flutter que se conecta ao Firebase para realizar operações de cadastro, exibição e busca de usuários. O projeto está integrado com o Firebase usando o arquivo `google-services.json` e oferece as seguintes funcionalidades:

- Tela de cadastro de novos usuários
- Tela de exibição de usuários cadastrados
- Tela de busca de usuários específicos

## Requisitos

- Flutter 3.0 ou superior
- Android Studio ou VSCode
- Conta no Firebase
- Conexão com a internet para acessar o Firebase

## Como rodar o projeto

Siga as etapas abaixo para configurar o seu ambiente de desenvolvimento e rodar o app.

### 1. Clonar o repositório

Clone este repositório para o seu computador:

```bash
git clone https://link-para-o-seu-repositorio.git
cd nome-do-repositorio
```
### 2. Isstalar as dependências
Certifique-se de ter o Flutter instalado. Se ainda não tiver, siga a documentação oficial para instalá-lo.
Dentro do diretório do seu projeto, execute o seguinte comando para baixar as dependências:

```bash
flutter pub get
```
### 3. Configurar o Firebase
**3.1 Criar um projeto no Firebase**

1. Acesse o console do Firebase.
2. Crie um novo projeto no Firebase ou use um projeto existente.
3. Adicione o app Android no seu projeto do Firebase. Para isso, siga os passos abaixo:

**3.2 Baixar o arquivo google-services.json**

1. No console do Firebase, vá até Configurações do Projeto > Configurações do App.
2. Baixe o arquivo google-services.json e coloque-o no diretório android/app do seu projeto Flutter.

**3.3 Configurar o Firebase no Android**
1. Abra o arquivo android/build.gradle e adicione o classpath do Google Services:

```gradle
  buildscript {
      dependencies {
          classpath 'com.google.gms:google-services:4.3.15'  // Adicione esta linha
      }
  }
```
2. No arquivo android/app/build.gradle, adicione a linha abaixo no final do arquivo:

```gradle
  apply plugin: 'com.google.gms.google-services'  // Adicione esta linha
```

**3.4 Ativar os serviços do Firebase**
Certifique-se de ativar os serviços que você utilizará no Firebase (como Firestore, Authentication, etc.) na interface do console do Firebase.

### 4. Configurar as permissões (Android)
No arquivo android/app/src/main/AndroidManifest.xml, adicione as permissões necessárias para que seu app funcione corretamente com o Firebase (exemplo para internet e rede):
```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### 5. Rodar o app
Agora que você configurou o Firebase e as permissões, basta rodar o app no emulador ou dispositivo físico:

```bash
  flutter run
```
### 6. Atualizar Firebase para seu app
Se você precisa atualizar as configurações do Firebase no seu projeto, como alterar a chave do Firebase ou configurar outros serviços, basta seguir os passos abaixo:

1. Acesse o console do Firebase.
2. Atualize as configurações necessárias (como o Firebase Authentication, Firestore, etc.).
3 Se for necessário, substitua o arquivo google-services.json com a nova versão baixada no console do Firebase e sobrescreva o arquivo existente no diretório android/app.

### 7. Estrutura do projeto
Aqui está uma visão geral das pastas e arquivos importantes do projeto:

```bash
/lib
  /screens
    cadastro_screen.dart   # Tela de Cadastro
    exibir_screen.dart     # Tela de Exibição
    buscar_screen.dart     # Tela de Busca
  main.dart                # Arquivo principal do app
/android
  /app/src/main/AndroidManifest.xml
  /app/google-services.json  # Arquivo de configuração do Firebase
  build.gradle            # Arquivo de configuração de build
  /app/build.gradle
```

## Contribuindo
Se você deseja contribuir para este projeto, faça um fork deste repositório e crie um pull request com suas alterações.

1. Faça um fork deste repositório.
2. Crie uma branch para suas alterações:

```bash
git checkout -b minha-nova-funcionalidade
```
3. Faça commit das suas alterações:
```bash
git commit -am 'Adicionando nova funcionalidade'
```
4. Envie para o repositório remoto:
```bash
git push origin minha-nova-funcionalidade
```
5. Crie um Pull Request.

# Lincença

Este projeto está licenciado sob a MIT License.

```txt

Esse arquivo `README.md` fornece as instruções claras para o desenvolvimento, configuração e execução do seu projeto. Você pode personalizar conforme necessário, caso haja algo específico que queira incluir.

```


