CLOCK = "clk"

TRACES = [
    ('legal: 3-cycle pulse', 0, {'rst': '110', 'en': '000111000'}),
    ('violation: 2-cycle pulse', 1, {'rst': '110', 'en': '000110000'}),
    ('legal: long pulse', 0, {'rst': '110', 'en': '00011111100'}),
    ('violation: 1-cycle glitch', 1, {'rst': '110', 'en': '000100111000'}),
]
