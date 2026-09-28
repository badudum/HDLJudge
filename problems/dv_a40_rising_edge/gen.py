CLOCK = "clk"

TRACES = [
    ('legal: pulse exactly on rising edges', 0, {'rst': '110', 'a': '000011100110', 'pulse': '000010000100'}),
    ('violation: missing pulse', 1, {'rst': '110', 'a': '0000111000', 'pulse': '0000000000'}),
    ('violation: extra pulse while a stays high', 1, {'rst': '110', 'a': '000011110', 'pulse': '000011000'}),
    ('legal: no activity', 0, {'rst': '110', 'a': '000000000', 'pulse': '000000000'}),
]
