import music21
from music21 import *

class MelodyNote:
    def __init__(self, pitch, duration, position, velocity):
        self.pitch = pitch
        self.duration = duration
        self.position = position
        self.velocity = velocity

    def __repr__(self):
        return str(self.pitch) + " " + str(self.duration) + " " + str(self.position) + " " + str(self.velocity)

class MelodyParser:
    def parse(midi_data):
        with open("midi.mid", "wb") as file:
            file.write(midi_data)

        song = converter.parse("midi.mid")
        # process the ties
        song = song.stripTies()

        # unfold repetitions
        i = 0
        for a in song:
            if a.isStream:
                e = repeat.Expander(a)
                s2 = e.process()
                timing = s2.secondsMap
                song[i] = s2
            i += 1

        def getMusicProperties(x, position):
            return MelodyNote(x.pitch, x.duration.quarterLength, position, x.volume.velocity)

        notes = []
        for a in song.recurse().notes:
            if (a.isNote):
                notes.append(getMusicProperties(a, a.getOffsetInHierarchy(song)))
            if (a.isChord):
                for x in a._notes:
                    s = getMusicProperties(x)
                    notes.append(getMusicProperties(x, x.getOffsetInHierarchy(None)))

        return sorted(notes, key=lambda note: note.position)

    def encode(notes):
        encoded_notes = []
        for note in notes:
            encoded_note = music21.note.Note(note.pitch)
            encoded_note.offset = note.position
            encoded_note.duration.quarterLength = note.duration
            encoded_notes.append(music21.note.Note(note.pitch))
        stream1 = stream.Stream()
        for i in range(0, len(encoded_notes)):
            stream1.append(encoded_notes[i])
            encoded_notes[i].offset = notes[i].position
            encoded_notes[i].duration.quarterLength = notes[i].duration

        return stream1.write('midi', fp='modded_midi.mid')
