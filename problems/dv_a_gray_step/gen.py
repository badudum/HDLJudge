CLOCK = "clk"

TRACES = [
    ('legal: Gray sequence', 0, {'rst': '110', 'cnt': [0, 0, 0, 1, 3, 2, 6, 7, 5, 4]}),
    ('legal: holding', 0, {'rst': '110', 'cnt': [0, 0, 0, 1, 1, 1, 3]}),
    ('violation: binary step', 1, {'rst': '110', 'cnt': [0, 0, 0, 1, 2]}),
    ('violation: jump', 1, {'rst': '110', 'cnt': [0, 0, 0, 1, 3, 2, 13, 13]}),
]
