CLOCK = "clk"

TRACES = [
    ('legal: a then b', 0, {'rst': '110', 'a': '000100000', 'b': '000001010'}),
    ('violation: b before any a', 1, {'rst': '110', 'a': '000000100', 'b': '000010000'}),
    ('violation: a and b in the same cycle', 1, {'rst': '110', 'a': '000010000', 'b': '000010000'}),
    ('legal: reset, then a again before b', 0, {'rst': '11000000011000', 'a': '00100000000100', 'b': '00010000000001'}),
]
