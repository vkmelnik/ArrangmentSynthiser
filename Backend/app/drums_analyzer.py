
class DrumsAnalyzer:
    def read_and_parse_file(self, file_path):
        drums = ['cr', 'ri', 'ho', 'hh', 'sd', 'bd']
        beats = {'cr': dict(), 'ri': dict(), 'ho': dict(), 'hh': dict(), 'sd': dict(), 'bd': dict()}
        chords = dict()

        with open(file_path, 'r') as file:
            lines = file.readlines()

        data = []
        for i in range(len(lines)):
            if 'frequency' in lines[i]:
                freq = int(lines[i].split(':')[-1].split(')')[-2])
                fragment = lines[i+2: i+12]
                data.append((freq, fragment))

        fragments = []
        for freq, fragment in data:
            if len(fragment[5]) != 48 + 5:
                continue
            simplified_fragment = []
            fragments.append([])
            for row in fragment:
                drum = row[0:2]
                if drum in drums:
                    beat = row[4:-1]
                    was = beats[drum][beat] if beat in beats[drum] else 0
                    beats[drum][beat] = was + freq
                    simplified_fragment.append(beat)
                    fragments[-1].append(beat)

            for i in range(len(simplified_fragment[0])):
                chord = ''.join([line[i] for line in simplified_fragment])
                was = chords[chord] if chord in chords else 0
                chords[chord] = was + freq
        
        return beats, chords, fragments
