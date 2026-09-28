CLOCK = "clk"

TRACES = [
    ('legal: rises and stays high', 0, {'rst': '110', 'pwr_good': '000001111111'}),
    ('violation: glitch after rising', 1, {'rst': '110', 'pwr_good': '000011101111'}),
    ('legal: never rises', 0, {'rst': '110', 'pwr_good': '000000000000'}),
    ('legal: reset clears the obligation', 0, {'rst': '11000011000', 'pwr_good': '00111100111'}),
    ('violation: drops at the end', 1, {'rst': '110', 'pwr_good': '000111111000'}),
]
