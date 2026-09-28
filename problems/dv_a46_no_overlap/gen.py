CLOCK = "clk"

TRACES = [
    ('legal: clean handover with a gap', 0, {'rst': '110', 'gnt_a': '000110000000', 'gnt_b': '000000110000'}),
    ('violation: overlap', 1, {'rst': '110', 'gnt_a': '000111000', 'gnt_b': '000001100'}),
    ('violation: no idle cycle on handover', 1, {'rst': '110', 'gnt_a': '000110000', 'gnt_b': '000001100'}),
    ('legal: only one master', 0, {'rst': '110', 'gnt_a': '000111011100', 'gnt_b': '000000000000'}),
]
