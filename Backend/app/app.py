from flask import Flask
from flask import request
from flask import send_file
from midi_parser import *
from melody_generator import MelodyGenerator
from rhythm_generator import RhythmGenerator
from chord_generator import ChordsGenerator
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

@app.route('/rhythm', methods=['POST'])
def get_rhythm():
    midi_data = request.data

    notes = MelodyParser.parse(midi_data)

    generator = RhythmGenerator(notes, 20, 0.5, 0.3, 2)
    newNotes = generator.generate()

    filename = MelodyParser.encode(newNotes)
    return send_file(filename, mimetype='audio/midi')

@app.route('/chords', methods=['POST'])
def get_chords():
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

    generator = ChordsGenerator(notes, 5, 0.5, 0.3, 5, scale)
    newNotes = generator.generate()

    filename = MelodyParser.encode(newNotes)
    return send_file(filename, mimetype='audio/midi')

if __name__ == '__main__':
    app.run()
