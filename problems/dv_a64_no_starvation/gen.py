CLOCK = "clk"

TRACES = [
    ('legal: every request served', 0, {'rst': '110', 'req': [0, 0, 0, 15, 14, 12, 8, 0, 0], 'gnt': [0, 0, 0, 1, 2, 4, 8, 0, 0]}),
    ('legal: immediate grant', 0, {'rst': '110', 'req': [0, 0, 0, 4, 0, 0, 0, 0], 'gnt': [0, 0, 0, 4, 0, 0, 0, 0]}),
    ('violation: master 3 starved', 1, {'rst': '110', 'req': [0, 0, 0, 9, 8, 8, 8, 8, 8, 8, 0], 'gnt': [0, 0, 0, 1, 0, 0, 0, 0, 0, 8, 0]}),
    ('violation: never granted', 1, {'rst': '110', 'req': [0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 2], 'gnt': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]}),
]
