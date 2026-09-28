CLOCK = "clk"

TRACES = [
    ('legal: values in range', 0, {'rst': '110', 'valid': '000111', 'temp': [0, 0, 0, 10, 55, 90]}),
    ('violation: too high', 1, {'rst': '110', 'valid': '000110', 'temp': [0, 0, 0, 50, 91, 0]}),
    ('violation: too low', 1, {'rst': '110', 'valid': '0001', 'temp': [0, 0, 0, 9]}),
    ('legal: out-of-range while invalid', 0, {'rst': '110', 'valid': '000101', 'temp': [0, 0, 200, 20, 5, 30]}),
]
