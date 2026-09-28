CLOCK = "clk"

TRACES = [
    ('legal: aligned accesses', 0, {'rst': '110', 'valid': '000111', 'ready': '000111', 'size': [0, 0, 0, 2, 1, 0], 'addr': [0, 0, 0, 64, 66, 67]}),
    ('violation: misaligned word', 1, {'rst': '110', 'valid': '0001', 'ready': '0001', 'size': [0, 0, 0, 2], 'addr': [0, 0, 0, 65]}),
    ('violation: misaligned halfword', 1, {'rst': '110', 'valid': '0001', 'ready': '0001', 'size': [0, 0, 0, 1], 'addr': [0, 0, 0, 19]}),
    ('violation: reserved size', 1, {'rst': '110', 'valid': '0001', 'ready': '0001', 'size': [0, 0, 0, 3], 'addr': [0, 0, 0, 0]}),
    ('violation: address changes while stalled', 1, {'rst': '110', 'valid': '000111', 'ready': '000001', 'size': [0, 0, 0, 2, 2, 2], 'addr': [0, 0, 0, 64, 68, 68]}),
    ('legal: stall with stable address', 0, {'rst': '110', 'valid': '0001110', 'ready': '0000010', 'size': [0, 0, 0, 2, 2, 2, 0], 'addr': [0, 0, 0, 128, 128, 128, 51]}),
]
