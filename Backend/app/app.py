from flask import Flask
from flask import request
from mido import MidiFile

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/melody', methods=['POST'])
def get_melody():
    midi_data = request.data
    print(midi_data)

    file_path = "midi.mid"

    with open(file_path, "wb") as file:
        file.write(midi_data)
    
    mid = MidiFile('midi.mid')
    for i, track in enumerate(mid.tracks):
        print('Track {}: {}'.format(i, track.name))
        for msg in track:
            print(msg)

    return "jsonify([i.serialize for i in songs.all()])"

if __name__ == '__main__':
    app.run()
