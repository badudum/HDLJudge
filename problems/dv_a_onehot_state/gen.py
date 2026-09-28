CLOCK = "clk"

TRACES = [
    ('legal: walking one', 0, {'rst': '110', 'state': [0, 0, 1, 2, 4, 8, 1, 1]}),
    ('violation: all zero', 1, {'rst': '110', 'state': [0, 0, 1, 2, 0, 4]}),
    ('violation: two bits set', 1, {'rst': '110', 'state': [0, 0, 1, 3, 2]}),
    ('violation: all ones', 1, {'rst': '110', 'state': [0, 0, 8, 8, 15, 8]}),
]
