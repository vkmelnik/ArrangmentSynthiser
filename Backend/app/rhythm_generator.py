import math
import copy
import random
import music21
from music21 import *

class Rhythm:
    def __init__(self, notes, mutationRate, function):
        self.notes = notes
        self.mutationRate = mutationRate
        self.function = function

    def mutate(self):
        for i in range(len(self.notes)):
            if random.uniform(0, 1) < self.mutationRate:
                self.notes[i].position = max(0, self.notes[i].position + random.choice([-1/3, 1/3, -0.25, 0.25]))

        self.notes.sort(key = lambda x: x.position)

    def calculateFunction(self):
        self.score = self.function(self.notes)

class RhythmGenerator:
    def coherenceFunction(self, notes):
        dists = []
        same = 0
        for i in range(len(notes)):
            position1 = notes[i].position
            position2 = notes[(i + 1) % len(notes)].position
            dist = int((position2 - position1) * 6)
            if dist > 0:
                dists.append(dist)
            else:
                same += 1

        outOfBounds = abs(self.start - notes[0].position) + abs(notes[len(notes)-1].position - self.end)
        return len(set(dists)) + same + outOfBounds * 10

    def __init__(self, notes, numberOfIndividums, crossoverRate, mutationRate, numberLives):
        self.start = notes[0].position
        self.end = notes[-1].position
        self.initial_melody = notes
        self.numberOfIndividums = numberOfIndividums
        self.crossoverRate = crossoverRate
        self.mutationRate = mutationRate
        self.numberLives = numberLives
        self.function = self.coherenceFunction
        
    def crossover(self, melody1, melody2):
        newNotes = []
        part = random.choice([-1, 1])
        for i in range(len(melody1.notes)):
            if part * i * 2 < part * len(melody1.notes):
                newNotes.append(copy.copy(melody1.notes[i]))
            else:
                newNotes.append(copy.copy(melody2.notes[i]))

        newNotes.sort(key = lambda x: x.position)
        return Rhythm(newNotes, melody1.mutationRate, melody1.function)

    def generate(self):
        # Initialization of genetic algorithm.
        population = [Rhythm(self.initial_melody, self.mutationRate, self.coherenceFunction) for i in range(self.numberOfIndividums)]
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

        return sorted(bestMelody.notes, key = lambda x: x.position)
