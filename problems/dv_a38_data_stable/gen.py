CLOCK = "clk"

TRACES = [
    ('legal: data held while stalled', 0, {'rst': '110', 'valid': '000111100', 'ready': '000000100', 'data': [0, 0, 0, 5, 5, 5, 5, 0, 0]}),
    ('violation: data changes while stalled', 1, {'rst': '110', 'valid': '0000111100', 'ready': '0000000010', 'data': [0, 0, 0, 0, 7, 8, 8, 8, 8, 0]}),
    ('legal: data may change after a transfer', 0, {'rst': '110', 'valid': '000011110', 'ready': '000010101', 'data': [0, 0, 0, 0, 1, 2, 2, 3, 3]}),
    ('violation: change on the last stall cycle', 1, {'rst': '110', 'valid': '00001111000', 'ready': '00000001000', 'data': [0, 0, 0, 0, 4, 4, 9, 9, 0, 0, 0]}),
    ('legal: data changes when valid is low', 0, {'rst': '110', 'valid': '000000000', 'ready': '000000000', 'data': [0, 0, 1, 2, 3, 4, 5, 6, 7]}),
]
