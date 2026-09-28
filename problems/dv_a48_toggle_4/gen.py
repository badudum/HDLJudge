CLOCK = "clk"

TRACES = [
    ('legal: toggles every 4 cycles', 0, {'rst': '110', 'q': '00000011110000111100001'}),
    ('violation: toggles after 3 cycles', 1, {'rst': '110', 'q': '000000111000111000'}),
    ('violation: toggles after 5 cycles', 1, {'rst': '110', 'q': '0000001111100000'}),
    ('legal: never starts toggling', 0, {'rst': '110', 'q': '000000000000'}),
]
