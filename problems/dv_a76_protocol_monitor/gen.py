CLOCK = "clk"

TRACES = [
    ('legal: single write', 0, {'rst': '110', 'awvalid': '0001100', 'awready': '0000100', 'wvalid': '0001110', 'wready': '0000010', 'bvalid': '000000110', 'bready': '000000010'}),
    ('legal: data before address', 0, {'rst': '110', 'awvalid': '0000110', 'awready': '0000010', 'wvalid': '000100', 'wready': '000100', 'bvalid': '000000010', 'bready': '000000010'}),
    ('violation: response before data', 1, {'rst': '110', 'awvalid': '00010', 'awready': '00010', 'wvalid': '00000', 'wready': '00000', 'bvalid': '000001', 'bready': '000001'}),
    ('violation: awvalid dropped', 1, {'rst': '110', 'awvalid': '000100', 'awready': '000000', 'wvalid': '000000', 'wready': '000000', 'bvalid': '000000', 'bready': '000000'}),
    ('violation: bvalid dropped', 1, {'rst': '110', 'awvalid': '00010', 'awready': '00010', 'wvalid': '00010', 'wready': '00010', 'bvalid': '0000010', 'bready': '0000000'}),
]
