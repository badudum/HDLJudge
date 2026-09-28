CLOCK = "clk"

TRACES = [
    ('legal: 3-beat packet', 0, {'rst': '110', 'valid': '0001110', 'data': [0, 0, 0, 3, 7, 129, 0], 'parity': '0000100', 'last': '0000010'}),
    ('violation: bad parity', 1, {'rst': '110', 'valid': '00011', 'data': [0, 0, 0, 3, 1], 'parity': '00000', 'last': '00001'}),
    ('violation: last without valid', 1, {'rst': '110', 'valid': '000100', 'data': [0, 0, 0, 0, 0, 0], 'parity': '000000', 'last': '000010'}),
    ('violation: packet too long', 1, {'rst': '110', 'valid': '0001111111110', 'data': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 'parity': '0000000000000', 'last': '0000000000000'}),
    ('legal: 8-beat packet', 0, {'rst': '110', 'valid': '000111111110', 'data': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 'parity': '000000000000', 'last': '000000000010'}),
]
