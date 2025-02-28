import firebase_admin
from firebase_admin import credentials, firestore
from flask import Flask, request, jsonify
from flask_cors import CORS  # Adicionado para lidar com CORS

# Path to your service account key JSON file. **Keep this secure!**
cred = credentials.Certificate("key JSON file")
firebase_admin.initialize_app(cred)

db = firestore.client()
app = Flask(__name__)

@app.after_request
def add_cors_headers(response):
    response.headers["Access-Control-Allow-Origin"] = '*'
    response.headers["Access-Control-Allow-Methods"] = 'POST, OPTIONS'
    response.headers["Access-Control-Allow-Headers"] = 'Content-Type'
    return response


# Habilitando CORS para permitir requisições de qualquer origem
CORS(app)

@app.route('/check_rfid', methods=['POST'])
def check_rfid():
    data = request.get_json()
    app.logger.debug(f"Requisição recebida: {data}")

    # Verificando se o RFID foi enviado na requisição
    if not data or 'rfid' not in data:
        return jsonify({'error': 'RFID é necessário'}), 400

    rfid = data['rfid']
    

    try:
        # Buscando o RFID na coleção 'pessoas'
        docs = db.collection('pessoas').where('rid', '==', rfid).stream()
        person_exists = any(docs)  # Verifica se algum documento foi encontrado
        print(person_exists)

        if person_exists:
            return jsonify({'success': True})  # RFID encontrado
            
        else:
            return jsonify({'valid': False, 'message': 'RFID não encontrado'}), 404  # RFID não encontrado

    except Exception as e:
        # Log de erro mais detalhado
        app.logger.error(f"Erro ao verificar o RFID: {str(e)}")
        return jsonify({'error': 'Erro ao verificar o RFID', 'message': str(e)}), 500


@app.route('/add_attendance', methods=['POST'])
def add_attendance():
    data = request.get_json()

    # Verificando se o RFID e o número de atendimento foram enviados
    if not data or 'rfid' not in data or 'number' not in data:
        return jsonify({'error': 'RFID e número de atendimento são necessários'}), 400

    rfid = data['rfid']
    attendance_number = data['number']

    # Verificando se o número de atendimento é válido
    if not isinstance(attendance_number, int) or attendance_number <= 0:
        return jsonify({'error': 'Número de atendimento inválido'}), 400

    try:
        # Adicionando um novo documento na coleção 'atendimentos'
        db.collection('atendimentos').add({'rfid': rfid, 'number': attendance_number})
        return jsonify({'success': True, 'message': 'Atendimento registrado com sucesso'}), 200

    except Exception as e:
        # Log de erro mais detalhado
        app.logger.error(f"Erro ao adicionar atendimento: {str(e)}")
        return jsonify({'error': 'Erro ao adicionar atendimento', 'message': str(e)}), 500


if __name__ == '__main__':
    # Abertura do servidor Flask em todas as interfaces (0.0.0.0)
    app.run(debug=True, host='0.0.0.0', port=5000)
