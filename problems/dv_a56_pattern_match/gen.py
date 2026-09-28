CLOCK = "clk"

TRACES = [
    ('legal: lock follows the pattern', 0, {'rst': '110', 'din': '00011010000', 'lock': '00000001000'}),
    ('violation: no lock', 1, {'rst': '110', 'din': '0001101000', 'lock': '0000000000'}),
    ('violation: lock one cycle late', 1, {'rst': '110', 'din': '00011010000', 'lock': '00000000100'}),
    ('legal: near miss', 0, {'rst': '110', 'din': '000100110010', 'lock': '000000000000'}),
]
