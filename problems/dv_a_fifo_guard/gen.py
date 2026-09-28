CLOCK = "clk"

TRACES = [
    ('legal: normal traffic', 0, {'rst': '110', 'push': '0011000', 'pop': '0000110', 'full': '0000000', 'empty': '0010000'}),
    ('violation: push while full', 1, {'rst': '110', 'push': '0000100', 'pop': '0000000', 'full': '0000110'}),
    ('legal: push and pop while full', 0, {'rst': '110', 'push': '0000100', 'pop': '0000100', 'full': '0000110', 'empty': '0000000'}),
    ('violation: pop while empty', 1, {'rst': '110', 'push': '0000000', 'pop': '0001000', 'full': '0000000', 'empty': '0011111'}),
]
