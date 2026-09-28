CLOCK = "clk"

TRACES = [
    ('legal: fill and drain', 0, {'rst': '110', 'push': '00011000', 'pop': '00000110', 'count': [0, 0, 0, 0, 1, 2, 1, 0], 'full': '00000000', 'empty': '00110001'}),
    ('legal: fill completely', 0, {'rst': '110', 'push': '0001111111110', 'pop': '0000000000000', 'count': [0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 8], 'full': '0000000000011', 'empty': '0011000000000'}),
    ('violation: full at 7', 1, {'rst': '110', 'push': '0001111111', 'pop': '0000000000', 'count': [0, 0, 0, 0, 1, 2, 3, 4, 5, 6], 'full': '0000000001', 'empty': '0011000000'}),
    ('violation: count not updated', 1, {'rst': '110', 'push': '000100', 'pop': '000000', 'count': [0, 0, 0, 0, 0, 0], 'full': '000000', 'empty': '001111'}),
    ('violation: pop from empty decrements', 1, {'rst': '110', 'push': '00000', 'pop': '00010', 'count': [0, 0, 0, 0, 15], 'full': '00000', 'empty': '00110'}),
]
