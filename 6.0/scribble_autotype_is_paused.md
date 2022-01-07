`scribble_autotype_is_paused(textElement, [occuranceName])`

**Returns:** Whether the text element has been paused, `true` or `false`

|Argument|Name         |Purpose                                                               |
|--------|-------------|----------------------------------------------------------------------|
|0       |`textElement`|Text element to target. This element must have been created previously by [`scribble_draw()`](scribble_draw) or [`scribble_cache()`](scribble_cache)|
|[1]     |`[occuranceName]`|ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)             |