CLOCK = "clk"

TRACES = [
    ('legal: frozen data', 0, {'rst': '110', 'en': '000011110', 'data': [0, 0, 0, 0, 9, 9, 9, 9, 3]}),
    ('violation: data changes while enabled', 1, {'rst': '110', 'en': '000011110', 'data': [0, 0, 0, 0, 9, 9, 8, 8, 0]}),
    ('legal: data loads as en rises', 0, {'rst': '110', 'en': '000001110', 'data': [0, 0, 0, 1, 2, 3, 3, 3, 4]}),
    ('violation: change on the last enabled cycle', 1, {'rst': '110', 'en': '000011100', 'data': [0, 0, 0, 0, 5, 5, 6, 6, 6]}),
]
