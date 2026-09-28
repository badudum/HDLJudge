CLOCK = "clk"

TRACES = [
    ('legal: correct counter', 0, {'rst': '1100000000', 'en': '0011110110', 'count': [0, 0, 0, 1, 2, 3, 4, 4, 5, 6]}),
    ('violation: skips a value', 1, {'rst': '1100000000', 'en': '0011111111', 'count': [0, 0, 0, 1, 2, 4, 5, 6, 7, 8]}),
    ('violation: counts while disabled', 1, {'rst': '110000000', 'en': '001100000', 'count': [0, 0, 0, 1, 2, 3, 3, 3, 3]}),
    ('violation: not zero after reset', 1, {'rst': '11000000', 'en': '00000000', 'count': [7, 7, 7, 7, 7, 7, 7, 7]}),
    ('legal: wraps from 15 to 0', 0, {'rst': '1100000000000000000000', 'en': '0011111111111111111110', 'count': [0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 1, 2, 3]}),
]
