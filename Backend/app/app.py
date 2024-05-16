from flask import Flask
from flask import request
from flask import send_file
from midi_parser import *
from melody_generator import MelodyGenerator
from rhythm_generator import RhythmGenerator
from chord_generator import ChordsGenerator
from drums_generator import DrumsGenerator
from drums_analyzer import DrumsAnalyzer
from theory_worker import TheoryWorker
import music21
from music21 import *

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024
drumBeatsProbabilities, drumChordsProbabilities, drumsFragments = DrumsAnalyzer().read_and_parse_file("drum_patterns.txt")
print("Drum patterns analysis complete.")

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

@app.route('/transpose', methods=['POST'])
def get_transpose():
    midi_data = request.data

    notes = MelodyParser.parse(midi_data)

    fromTonic = request.args.get('fromTonic')
    fromScaleName = request.args.get('fromScale')
    fromScale = None
    if fromTonic != None:
        if fromScaleName == "Major":
            fromScale = music21.scale.MajorScale(fromTonic)
        elif fromScaleName == "Minor":
            fromScale = music21.scale.MinorScale(fromTonic)
    toTonic = request.args.get('toTonic')
    toScaleName = request.args.get('toScale')
    toScale = None
    if fromTonic != None:
        if toScaleName == "Major":
            toScale = music21.scale.MajorScale(toTonic)
        elif toScaleName == "Minor":
            toScale = music21.scale.MinorScale(toTonic)

    generator = TheoryWorker()
    newNotes = generator.transpose(notes, fromScale, toScale)

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

@app.route('/drums', methods=['POST'])
def get_drums():
    midi_data = request.data

    notes = MelodyParser.parse(midi_data)
    syncopation = float(request.args.get('syncopation'))
    complexity = float(request.args.get('complexity'))

    generator = DrumsGenerator(notes, 5, 0.5, 0.01, 10, drumBeatsProbabilities, drumChordsProbabilities, drumsFragments, syncopation, complexity)
    newNotes = generator.generate()

    filename = MelodyParser.encode(newNotes)
    return send_file(filename, mimetype='audio/midi')

if __name__ == '__main__':
    app.run()
