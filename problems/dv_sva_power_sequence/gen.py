CLOCK = "clk"

TRACES = [
    ('legal: full power cycle', 0, {'rst': '110', 'pwr_en': '001111100001111111', 'iso_en': '000111111111111100', 'save': '000010000000000000', 'restore': '000000000000001000'}),
    ('violation: power off before isolation', 1, {'rst': '110', 'pwr_en': '0011000', 'iso_en': '0000000', 'save': '0000000', 'restore': '0000000'}),
    ('violation: no save before power off', 1, {'rst': '110', 'pwr_en': '001111000', 'iso_en': '000111111', 'save': '000000000', 'restore': '000000000'}),
    ('violation: isolation released before restore', 1, {'rst': '110', 'pwr_en': '0011110000111110', 'iso_en': '0001111111111100', 'save': '0000100000000000', 'restore': '0000000000000000'}),
]
