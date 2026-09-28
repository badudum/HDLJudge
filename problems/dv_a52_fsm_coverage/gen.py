CLOCK = "clk"

TRACES = [
    ('legal: full transaction', 0, {'rst': '110', 'state': [0, 0, 0, 0, 1, 1, 2, 3, 3, 0, 0]}),
    ('legal: request withdrawn', 0, {'rst': '110', 'state': [0, 0, 0, 1, 0, 1, 1, 2, 3, 0]}),
    ('violation: IDLE to XFER', 1, {'rst': '110', 'state': [0, 0, 0, 0, 2, 3, 0]}),
    ('violation: XFER held for two cycles', 1, {'rst': '110', 'state': [0, 0, 0, 1, 2, 2, 3, 0]}),
    ('violation: DONE to REQ', 1, {'rst': '110', 'state': [0, 0, 0, 1, 2, 3, 1, 2, 3, 0]}),
]
