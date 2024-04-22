from flask import Flask
from flask import request
from flask import send_file
from midi_parser import *
from melody_generator import MelodyGenerator
import music21
from music21 import *

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024

@app.route('/melody', methods=['POST'])
def get_melody():
    midi_data = request.data

    notes = MelodyParser.parse(midi_data)

    tonic = request.args.get('tonic')
    scaleName = request.args.get('scale')
    scale = None
    if tonic != None:
        if scaleName == "Major":
            scale = music21.scale.MajorScale(tonic)
        elif scaleName == "Minor":
            scale = music21.scale.MinorScale(tonic)

    generator = MelodyGenerator(notes, 5, 0.5, 0.3, 5, scale)
    newNotes = generator.generate()

    filename = MelodyParser.encode(newNotes)
    return send_file(filename, mimetype='audio/midi')

if __name__ == '__main__':
    app.run()
