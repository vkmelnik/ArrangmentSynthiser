import math
import copy
import random
import music21
from music21 import *
from midi_parser import *

class TheoryWorker:
    def transpose(self, notes, fromScale, toScale):
        newNotes = []
        for note in notes:
            fromPitch = note.pitch.transpose(interval.Interval(-1))
            degree = fromScale.getScaleDegreeFromPitch(fromPitch)
            if not (degree is None):
                pitch = toScale.pitchFromDegree(degree).transpose(interval.Interval(1))
                offset = interval.Interval(fromScale.pitchFromDegree(degree), fromPitch)
                newNotes.append(MelodyNote(pitch.transpose(offset), note.duration, note.position, note.velocity))
        return newNotes
