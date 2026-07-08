# Checker vs DUT Bug Note

## Why This Matters

AXI4-Lite failures can come from RTL, stimulus, monitor sampling, scoreboard modeling, or assertion timing. Debug must classify the source before changing RTL.

## Classification Table

| Symptom | First suspect | Evidence to inspect |
|---|---|---|
| waveform violates valid-ready stability | DUT or driver | interface pins around failing SVA cycle |
| monitor reports wrong address/data | monitor sampling phase | monitor code and waveform at handshake edge |
| scoreboard mismatch after legal write/read | scoreboard latency or DUT storage | observed transaction stream and RTL register update |
| invalid address response unexpected | address map assumption | vPlan, DUT decode, error test sequence |
| test hangs | sequence/driver handshake | `start_item`, `finish_item`, `get_next_item`, `item_done` |

## Rule

Do not patch RTL until the failing transaction has been traced through stimulus, interface pins, monitor, scoreboard, and assertion context.
