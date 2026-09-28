CLOCK = "clk"

TRACES = [
    ('legal: rotating grants', 0, {'rst': '110', 'req': [0, 0, 0, 15, 15, 15, 15, 0], 'gnt': [0, 0, 0, 1, 2, 4, 8, 0]}),
    ('legal: single requester may win repeatedly', 0, {'rst': '110', 'req': [0, 0, 0, 2, 2, 2, 0], 'gnt': [0, 0, 0, 2, 2, 2, 0]}),
    ('violation: two grants at once', 1, {'rst': '110', 'req': [0, 0, 0, 3], 'gnt': [0, 0, 0, 3]}),
    ('violation: grant without request', 1, {'rst': '110', 'req': [0, 0, 0, 1], 'gnt': [0, 0, 0, 4]}),
    ('violation: back-to-back grant while others wait', 1, {'rst': '110', 'req': [0, 0, 0, 5, 5, 0], 'gnt': [0, 0, 0, 1, 1, 0]}),
]
