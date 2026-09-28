When a power domain is switched off its outputs float at random levels. **Isolation cells** at the domain boundary clamp them to safe values, and the safe value depends on the signal: 0 for data and active-high strobes, 1 for active-low requests.

### Interface

| Port | Direction | Width |
|------|-----------|-------|
| `iso_en` | input | 1 |
| `pd_data` | input | 8 |
| `pd_valid` | input | 1 |
| `pd_req_n` | input | 1 |
| `ao_data` | output | 8 |
| `ao_valid` | output | 1 |
| `ao_req_n` | output | 1 |
