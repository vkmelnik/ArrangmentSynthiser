from flask import Flask
from flask import request
from flask import send_file
from midi_parser import *
from melody_generator import MelodyGenerator

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/melody', methods=['POST'])
def get_melody():
    midi_data = request.data

    notes = MelodyParser.parse(midi_data)
    print(notes)

    generator = MelodyGenerator(notes, 5, 0.5, 0.3, 5)
    newNotes = generator.generate()

    filename = MelodyParser.encode(newNotes)
    return send_file(filename, mimetype='audio/midi')

if __name__ == '__main__':
    app.run()
