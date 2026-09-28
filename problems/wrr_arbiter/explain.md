### How it works

Weighted round-robin gives each requester a *turn* of up to W[i] consecutive grants, then passes the turn
to the next requester in round-robin order. With all three requesting, the pattern is 0, 0, 0, 1, 1, 2 and repeats, so the
bandwidth shares are 3 : 2 : 1, and nobody starves.

### Watch out for
- A turn ends early when the owner stops requesting.
- If only the current owner requests after its turn, it starts a new turn (cnt = 1).
