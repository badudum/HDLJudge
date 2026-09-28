CLOCK = "clk"

TRACES = [
    ('legal: accesses in range', 0, {'rst': '110', 'we': '000101', 're': '000010', 'addr': [0, 0, 0, 0, 11, 5]}),
    ('violation: write to 12', 1, {'rst': '110', 'we': '0001', 're': '0000', 'addr': [0, 0, 0, 12]}),
    ('violation: read of 15', 1, {'rst': '110', 'we': '0000', 're': '0001', 'addr': [0, 0, 0, 15]}),
    ('violation: read and write together', 1, {'rst': '110', 'we': '0001', 're': '0001', 'addr': [0, 0, 0, 3]}),
    ('legal: large address while idle', 0, {'rst': '110', 'we': '000000', 're': '000000', 'addr': [0, 0, 15, 12, 13, 14]}),
]
