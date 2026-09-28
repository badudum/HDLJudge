CLOCK = "clk"

TRACES = [
    ('legal: well-spaced pulses', 0, {'rst': '110', 'strobe': '000100100100'}),
    ('violation: two-cycle pulse', 1, {'rst': '110', 'strobe': '000110000'}),
    ('violation: pulses too close', 1, {'rst': '110', 'strobe': '000101000'}),
    ('legal: long gaps', 0, {'rst': '110', 'strobe': '001000001000'}),
]
