`scribble_autotype_set_pause(textElement, state, [occuranceName])`

**Returns:** N/A (`0`)

|Argument|Name         |Purpose                                                               |
|--------|-------------|----------------------------------------------------------------------|
|0       |`textElement`|Text element to target. This element must have been created previously by [`scribble_draw()`](scribble_draw)|
|1       |`state`      |Value to set for the pause state, `true` or `false`|
|2       |`[occuranceName]`|ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)             |