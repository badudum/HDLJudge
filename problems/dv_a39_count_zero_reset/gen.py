CLOCK = "clk"

TRACES = [
    ('legal: counter clears on reset', 0, {'rst': '1100000', 'count': [0, 0, 0, 1, 2, 3, 4]}),
    ('violation: counter not cleared', 1, {'rst': '1100000', 'count': [0, 5, 5, 6, 7, 8, 9]}),
    ('legal: counting after reset', 0, {'rst': '10000000', 'count': [0, 0, 1, 2, 3, 4, 5, 6]}),
    ('violation: reset in the middle is ignored', 1, {'rst': '10001000', 'count': [0, 0, 1, 2, 3, 4, 5, 6]}),
]
