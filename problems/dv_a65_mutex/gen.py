CLOCK = "clk"

TRACES = [
    ('legal: lock handed over', 0, {'rst': '110', 'lock_req': [0, 0, 0, 1, 5, 5, 4, 4, 0, 0], 'lock_gnt': [0, 0, 0, 1, 1, 1, 1, 4, 4, 0]}),
    ('violation: two owners', 1, {'rst': '110', 'lock_req': [0, 0, 0, 5], 'lock_gnt': [0, 0, 0, 5]}),
    ('violation: grant to a non-requester', 1, {'rst': '110', 'lock_req': [0, 0, 0, 1], 'lock_gnt': [0, 0, 0, 2]}),
    ('violation: lock revoked while requested', 1, {'rst': '110', 'lock_req': [0, 0, 0, 3, 3, 3], 'lock_gnt': [0, 0, 0, 1, 2, 2]}),
]
