`scribble_state_set(stateStruct)`

**Returns:** N/A (`0`)

|Argument|Name         |Purpose                                                            |
|--------|-------------|-------------------------------------------------------------------|
|0       |`stateStruct`|Data struct that will be copied into Scribble's internal draw state|

Updates Scribble's current draw state from a struct. This function is intended to be used in combination with [`scribble_state_get()`](scribble_state_get).

To learn more about Scribble draw state and state variables, please read the [Draw State](draw-state) article.