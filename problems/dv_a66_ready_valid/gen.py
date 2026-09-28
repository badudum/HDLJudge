CLOCK = "clk"

TRACES = [
    ('legal: wait states', 0, {'rst': '110', 'valid': '00011110', 'ready': '00000010', 'data': [0, 0, 0, 7, 7, 7, 7, 1]}),
    ('legal: streaming', 0, {'rst': '110', 'valid': '00011110', 'ready': '00011110', 'data': [0, 0, 0, 1, 2, 3, 4, 0]}),
    ('violation: valid withdrawn', 1, {'rst': '110', 'valid': '0001100', 'ready': '0000000', 'data': [0, 0, 0, 5, 5, 5, 5]}),
    ('violation: data changed while waiting', 1, {'rst': '110', 'valid': '0001110', 'ready': '0000010', 'data': [0, 0, 0, 5, 6, 6, 0]}),
]
