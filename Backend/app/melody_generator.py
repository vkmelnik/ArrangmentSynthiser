import math
import copy
import random
import music21
from music21 import *

class Melody:
    def __init__(self, notes, mutationRate, function):
        self.notes = notes
        self.mutationRate = mutationRate
        self.function = function
        self.vocabulary = list(set(map(lambda x: x.pitch, notes)))

    def mutate(self):
        for i in range(len(self.notes)):
            if random.uniform(0, 1) < self.mutationRate:
                self.notes[i].pitch = random.choice(self.vocabulary)

    def calculateFunction(self):
        self.score = self.function(self.notes)

class MelodyGenerator:
    def coherenceFunction(self, notes):
        score = 0
        for i in range(len(notes)):
            score += ord(notes[i].pitch.step[0]) - ord('A')

        return score

    def __init__(self, notes, numberOfIndividums, crossoverRate, mutationRate, numberLives):
        self.initial_melody = notes
        self.numberOfIndividums = numberOfIndividums
        self.crossoverRate = crossoverRate
        self.mutationRate = mutationRate
        self.numberLives = numberLives
        self.function = self.coherenceFunction
        
    def crossover(self, melody1, melody2):
        newNotes = []
        for i in range(len(melody1.notes)):
            if random.uniform(0, 1) < 0.5:
                newNotes.append(copy.copy(melody1.notes[i]))
            else:
                newNotes.append(copy.copy(melody2.notes[i]))

        return Melody(newNotes, melody1.mutationRate, melody1.function)

    def generate(self):
        # Initialization of genetic algorithm.
        population = [Melody(self.initial_melody, self.mutationRate, self.coherenceFunction) for i in range(self.numberOfIndividums)]
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
