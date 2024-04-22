import math
import copy
import random
import music21
from music21 import *

class Melody:
    def __init__(self, notes, mutationRate, function, scale=None):
        self.notes = notes
        self.mutationRate = mutationRate
        self.function = function
        self.vocabulary = list(set(map(lambda x: x.pitch, notes)))
        self.scale = scale
        if scale == None:
            self.scale = music21.scale.MajorScale().derive(self.vocabulary)

    def mutate(self):
        for i in range(len(self.notes)):
            if random.uniform(0, 1) < self.mutationRate:
                choice = random.choice([0, 1])
                if choice == 0:
                    self.notes[i].pitch = random.choice(self.vocabulary)
                elif choice == 1:
                    self.notes[i].pitch = self.scale.nextPitch(self.notes[i].pitch, direction=random.choice([-1, 1]))

    def calculateFunction(self):
        self.score = self.function(self.notes)

class MelodyGenerator:
    def coherenceFunction(self, notes):
        def isclose(a, b, rel_tol=1e-09, abs_tol=0.0):
            return abs(a - b) <= max(rel_tol * max(abs(a), abs(b)), abs_tol)

        interval_weights = {
            "P1": 1.0 / 25,
            "A1": 1.0 / 15,
            "M2": 1.0 / 25,
            "A2": 1.0 / 10,
            "M3": 1.0 / 7,
            "P4": 1.0 / 6,
            "A4": 1.0 / 0.1,
            "P5": 1.0 / 3,
            "A5": 1.0 / 0.1,
            "M6": 1.0 / 2,
            "m7": 1.0 / 2,
            "M7": 1.0 / 3
        }

        direction_weights = {
            "00": 6,
            "0-1": 2,
            "01": 2,
            "-1-1": 1,
            "-10": 2,
            "-11": 3,
            "1-1": 3,
            "10": 2,
            "11": 1
        }

        score_int = 0
        for i in range(len(notes)):
            pitch1 = notes[i].pitch
            pitch2 = notes[(i + 1) % len(notes)].pitch
            interval = music21.interval.Interval(pitch1, pitch2).simpleName
            score_int += interval_weights.get(interval, 12)

        score_dir = 0
        for i in range(len(notes) - 1):
            pitch1 = notes[i].pitch
            pitch2 = notes[(i + 1) % len(notes)].pitch
            pitch3 = notes[(i + 2) % len(notes)].pitch
            interval1 = music21.interval.Interval(pitch1, pitch2).direction
            interval2 = music21.interval.Interval(pitch2, pitch3).direction
            score_dir += direction_weights.get(str(interval1) + str(interval2), 12)

        score_chords = 0
        for i in range(len(notes)):
            pitch1 = notes[i].pitch
            pitch2 = notes[(i + 1) % len(notes)].pitch
            if isclose(notes[i].position, notes[(i + 1) % len(notes)].position) and not music21.interval.Interval(pitch1, pitch2).isConsonant():
                score_chords += 1

        score_range = music21.interval.Interval(min(map(lambda x: x.pitch, notes)), max(map(lambda x: x.pitch, notes))).semitones

        return score_int + score_dir * 0.1 + 30 * score_chords + len(notes) * score_range / 5

    def __init__(self, notes, numberOfIndividums, crossoverRate, mutationRate, numberLives, scale=None):
        self.initial_melody = notes
        self.numberOfIndividums = numberOfIndividums
        self.crossoverRate = crossoverRate
        self.mutationRate = mutationRate
        self.numberLives = numberLives
        self.function = self.coherenceFunction
        self.scale = scale
        
    def crossover(self, melody1, melody2):
        newNotes = []
        part = random.choice([-1, 1])
        for i in range(len(melody1.notes)):
            if part * i * 2 < part * len(melody1.notes):
                newNotes.append(copy.copy(melody1.notes[i]))
            else:
                newNotes.append(copy.copy(melody2.notes[i]))

        return Melody(newNotes, melody1.mutationRate, melody1.function, self.scale)

    def generate(self):
        # Initialization of genetic algorithm.
        population = [Melody(self.initial_melody, self.mutationRate, self.coherenceFunction, self.scale) for i in range(self.numberOfIndividums)]
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

        return bestMelody.notes
