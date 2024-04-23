import math
import copy
import random
import music21
from music21 import *
from midi_parser import *

class Chord:
    def __init__(self, notes):
        self.notes = notes

    def randomChord(scale):
        chordNotes = [random.choice(scale.pitches)]
        chordNotes.append(scale.nextPitch(scale.nextPitch(chordNotes[0])))
        if random.choice([0, 1]) == 0:
            chordNotes.append(scale.nextPitch(scale.nextPitch(chordNotes[1])))
        return Chord(chordNotes)

class ChordSequence:
    def __init__(self, notes, chords, mutationRate, function, scale=None):
        self.notes = notes
        self.mutationRate = mutationRate
        self.function = function
        self.vocabulary = list(set(map(lambda x: x.pitch, notes)))
        self.scale = scale
        if scale == None:
            self.scale = music21.scale.MajorScale().derive(self.vocabulary)
        self.chords = chords
        if chords == None:
            self.chords = [Chord.randomChord(self.scale) for i in range(len(notes))]

    def mutate(self):
        for i in range(len(self.chords)):
            if random.uniform(0, 1) < self.mutationRate:
                self.chords[i] = Chord.randomChord(self.scale)

    def calculateFunction(self):
        self.score = self.function(self.notes, self.chords)

class ChordsGenerator:
    def coherenceFunction(self, notes, chords):
        score_chords = 0
        score_notes = 0
        for i in range(len(notes)):
            pitch1 = notes[i].pitch
            chord1 = chords[i]
            chord2 = chords[(i + 1) % len(notes)]
            for chord_pitch1 in chord1.notes:
                for chord_pitch2 in chord2.notes:
                    if not music21.interval.Interval(chord_pitch1, chord_pitch2).isConsonant():
                        score_chords += 1

            for chord_pitch1 in chord1.notes:
                if not music21.interval.Interval(pitch1, chord_pitch1).isConsonant():
                        score_notes += 1 

        return score_chords + score_notes * 15

    def __init__(self, notes, numberOfIndividums, crossoverRate, mutationRate, numberLives, scale=None):
        self.initial_melody = notes
        self.numberOfIndividums = numberOfIndividums
        self.crossoverRate = crossoverRate
        self.mutationRate = mutationRate
        self.numberLives = numberLives
        self.function = self.coherenceFunction
        self.scale = scale
        
    def crossover(self, melody1, melody2):
        newChords = []
        part = random.choice([-1, 1])
        for i in range(len(melody1.chords)):
            if part * i * 2 < part * len(melody1.chords):
                newChords.append(copy.copy(melody1.chords[i]))
            else:
                newChords.append(copy.copy(melody2.chords[i]))

        return ChordSequence(melody1.notes, newChords, melody1.mutationRate, melody1.function, self.scale)

    def generate(self):
        # Initialization of genetic algorithm.
        population = [ChordSequence(self.initial_melody, None, self.mutationRate, self.coherenceFunction, self.scale) for i in range(self.numberOfIndividums)]
        bestPopulation = population[:int(self.numberOfIndividums * self.crossoverRate)]
        bestScore = math.inf
        bestMelody = population[0]

        for _ in range(self.numberLives):
            # Crossover.
            children = []
            for melody1 in bestPopulation:
                melody2 = random.choice(bestPopulation)
                while melody1 == melody2:
                    melody2 = random.choice(bestPopulation)
                children.append(self.crossover(melody1, melody2))

            population.extend(children)

            # Mutation.
            for individ in population:
                individ.mutate()
                individ.calculateFunction()

            population = sorted(population, key=lambda item: item.score)
            population = population[:self.numberOfIndividums]
            bestPopulation = population[:int(self.numberOfIndividums*self.crossoverRate)]
        
        if population[0].score < bestScore:
            bestScore = population[0].score
            bestMelody = population[0]

        for i in range(len(bestMelody.chords)):
            chord = bestMelody.chords[i]
            baseNote = bestMelody.notes[i]
            for note in chord.notes:
                bestMelody.notes.append(MelodyNote(note, baseNote.duration, baseNote.position, baseNote.velocity))

        print(bestMelody.notes)
        return sorted(bestMelody.notes, key = lambda x: x.position)
