CLOCK = "clk"

TRACES = [
    ('legal: two in flight', 0, {'rst': '110', 'req': '001100000', 'rsp': '000001100'}),
    ('violation: third request', 1, {'rst': '110', 'req': '0011100', 'rsp': '0000000'}),
    ('violation: response without request', 1, {'rst': '110', 'req': '000000', 'rsp': '000100'}),
    ('legal: request and response together at the limit', 0, {'rst': '110', 'req': '0011100', 'rsp': '0000110'}),
]
