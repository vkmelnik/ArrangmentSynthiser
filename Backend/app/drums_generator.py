import math
import copy
import random
import music21
from music21 import *
from midi_parser import *

class Drums:
    def __init__(self, hits, mutationRate, function):
        self.hits = hits
        self.mutationRate = mutationRate
        self.function = function

    def mutate(self):
        for i in range(len(self.hits)):
            if random.uniform(0, 1) < self.mutationRate:
                self.hits[i] = Drums.randomHits()[i]

    def setDrumFragments(drumsFragments):
        Drums.drumsFragments = drumsFragments

    def randomHits():
        return random.choice(Drums.drumsFragments)

    def calculateFunction(self):
        self.score = self.function(self.hits)

class DrumsGenerator:
    def coherenceFunction(self, hits):
        drums = ['cr', 'ri', 'ho', 'hh', 'sd', 'bd']
        chordProbability = 0
        beatProbability = 0
        snareAccents = 0
        bassAccents = 0
        snareTotal = 0
        bassTotal = 0
        cymbalsOffnotes = 0
        total = 0

        for drumIndex in range(len(drums)):
            if hits[drumIndex] in self.beats[drums[drumIndex]]:
                beatProbability += self.beats[drums[drumIndex]][hits[drumIndex]]

        for i in range(48):
            chord = ''.join([hits[j][i] for j in range(6)])
            if chord in self.chords:
                chordProbability += self.chords[chord]

        for i in range(48):
            for j in range(6):
                if hits[j][i] == 'o':
                    total += 1
            if hits[4][i] == 'o':
                snareTotal += 1
                if self.positionsWithNotes[i] == 1:
                    snareAccents += 1
            if hits[5][i] == 'o':
                bassTotal += 1
                if self.positionsWithNotes[i] == 1:
                    bassAccents += 1
            if (hits[0][i] == 'o' or hits[1][i] == 'o') and self.positionsWithNotes[i] == 0:
                cymbalsOffnotes += 1

        snareScore = (snareAccents / snareTotal) if snareTotal != 0 else 0
        bassScore = (bassAccents / bassTotal) if bassTotal != 0 else 0
        syncopationScore = abs((snareScore + bassScore) - self.syncopation)
        complexityScore = abs(total - self.complexity)
        return 40000 / (beatProbability + 1) + 10000 / (chordProbability / 48 / 6 + 1) + syncopationScore + complexityScore + cymbalsOffnotes / 5

    def __init__(self, melody, numberOfIndividums, crossoverRate, mutationRate, numberLives, beats, chords, drumsFragments, syncopation, complexity):
        self.start = melody[0].position
        self.end = melody[-1].position
        self.initial_melody = melody
        self.numberOfIndividums = numberOfIndividums
        self.crossoverRate = crossoverRate
        self.mutationRate = mutationRate
        self.numberLives = numberLives
        self.beats = beats
        self.chords = chords
        self.drumsFragments = drumsFragments
        Drums.drumsFragments = drumsFragments
        self.syncopation = syncopation
        self.complexity = complexity
        self.function = self.coherenceFunction

        # Marking positions, which contain notes from initial melody.
        self.positionsWithNotes = [0 for i in range(48)]
        for note in melody:
            self.positionsWithNotes[int(note.position * 12) % 48] = 1

    def crossover(self, drums1, drums2):
        newhits = []
        part = random.choice([-1, 1])
        for i in range(6):
            if part == 1:
                newhits.append(drums1.hits[i][0:24] + drums2.hits[i][24:48])
            else:
                newhits.append(drums2.hits[i][0:24] + drums1.hits[i][24:48])

        return Drums(newhits, drums1.mutationRate, drums2.function)

    def generate(self):
        # Initialization of genetic algorithm.
        population = [Drums(Drums.randomHits(), self.mutationRate, self.coherenceFunction) for i in range(self.numberOfIndividums)]
        bestPopulation = population[:int(self.numberOfIndividums * self.crossoverRate)]
        bestScore = math.inf
        bestDrums = population[0]

        for _ in range(self.numberLives):
            # Crossover.
            children = []
            for drums1 in bestPopulation:
                drums2 = random.choice(bestPopulation)
                while drums1 == drums2:
                    drums2 = random.choice(bestPopulation)
                children.append(self.crossover(drums1, drums2))

            population.extend(children)

            # Mutation.
            for individ in population:
                individ.mutate()
                individ.calculateFunction()

            population = sorted(population, key=lambda item: item.score)
            population = population[:self.numberOfIndividums]
            bestPopulation = population[:int(self.numberOfIndividums * self.crossoverRate)]
        
        if population[0].score < bestScore:
            bestScore = population[0].score
            bestDrums = population[0]

        drumNotes = []
        midiPitches = [49, 51, 46, 44, 38, 35]
        for repeat in range(max(int(self.initial_melody[-1].position * 12 / 48), 1)):
            for i in range(6):
                for j in range(len(bestDrums.hits[i])):
                    if bestDrums.hits[i][j] == 'o':
                        drumNotes.append(MelodyNote(midiPitches[i], 0.25 / 3, 0.25 / 3 * j, 127))

        return sorted(drumNotes, key = lambda x: x.position)
