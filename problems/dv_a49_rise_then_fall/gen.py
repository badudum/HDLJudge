CLOCK = "clk"

TRACES = [
    ('legal: 3-cycle pulse', 0, {'rst': '110', 'a': '000111000000'}),
    ('violation: 1-cycle pulse', 1, {'rst': '110', 'a': '000100000000'}),
    ('violation: 5-cycle pulse', 1, {'rst': '110', 'a': '0001111100000'}),
    ('legal: 2- and 4-cycle pulses', 0, {'rst': '110', 'a': '0001100111100000'}),
]
