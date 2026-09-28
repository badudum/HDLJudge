### How it works

Every UVM message passes through the registered catchers before it reaches the report server. A catcher can
change the severity, id, message or verbosity (`set_severity()` etc.) and then `THROW` the message on, or
swallow it by returning `CAUGHT`:

```
`uvm_error("KNOWN_BUG", …) → catcher → set_severity(UVM_WARNING) → THROW → counted as a warning
`uvm_info("NOISY", …)      → catcher → CAUGHT                     → never printed or counted
```

### Watch out for
- Match on `get_id()` (the message id), not on the message text.
- Anything you don't handle must be passed on with `THROW`.
