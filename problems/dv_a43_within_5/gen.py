CLOCK = "clk"

TRACES = [
    ('legal: ack after 2 cycles', 0, {'rst': '110', 'req': '000100000000', 'ack': '000001000000'}),
    ('violation: late ack', 1, {'rst': '110', 'req': '00010000000000', 'ack': '00000000010000'}),
    ('legal: ack after exactly 5', 0, {'rst': '110', 'req': '000100000000', 'ack': '000000001000'}),
    ('violation: no ack at all', 1, {'rst': '110', 'req': '000100000000', 'ack': '000000000000'}),
    ('legal: back-to-back requests', 0, {'rst': '110', 'req': '000110000000', 'ack': '000000110000'}),
]
