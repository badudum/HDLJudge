CLOCK = "clk"

TRACES = [
    ('legal: done 4 cycles after start', 0, {'rst': '110', 'start': '00010000000', 'done': '00000010000'}),
    ('violation: done without start', 1, {'rst': '110', 'start': '000000000', 'done': '000001000'}),
    ('violation: done too late', 1, {'rst': '110', 'start': '0001000000000000', 'done': '0000000000000001'}),
    ('legal: done exactly 10 cycles later', 0, {'rst': '110', 'start': '000100000000000', 'done': '000000000000010'}),
    ('violation: done in the same cycle as start', 1, {'rst': '110', 'start': '000010000', 'done': '000010000'}),
]
