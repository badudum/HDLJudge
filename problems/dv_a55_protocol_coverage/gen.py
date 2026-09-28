CLOCK = "clk"

TRACES = [
    ('legal: one transaction', 0, {'rst': '110', 'req': '000100000000', 'gnt': '000001000000', 'done': '000000001000'}),
    ('legal: back-to-back transactions', 0, {'rst': '110', 'req': '0001000100000', 'gnt': '0000100010000', 'done': '0000010001000'}),
    ('violation: grant too late', 1, {'rst': '110', 'req': '00010000000000', 'gnt': '00000001000000', 'done': '00000000100000'}),
    ('violation: done too late', 1, {'rst': '110', 'req': '0001000000000', 'gnt': '0000100000000', 'done': '0000000000100'}),
    ('violation: overlapping request', 1, {'rst': '110', 'req': '000101000000', 'gnt': '000010000000', 'done': '000000010000'}),
]
