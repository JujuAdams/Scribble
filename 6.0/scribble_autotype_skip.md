`scribble_autotype_skip(element, [occuranceName])`

**Returns:** Real value from 0 to 2 (inclusive) that represents what proportion of text is visible, see [`scribble_autotype_get()`](scribble_autotype_get)

|Argument|Name        |Purpose                                                               |
|--------|------------|----------------------------------------------------------------------|
|0       |`element`   |Text element to target. This element must have been created previously by [`scribble_draw()`](scribble_draw) or [`scribble_cache()`](scribble_cache)|
|[1]     |`[occuranceName]`|ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)             |

This function will skip the fade in or fade out animation that has been started by [`scribble_autotype_fade_in()`](scribble_autotype_fade_in) or [`scribble_autotype_fade_out()`](scribble_autotype_fade_out).

If text was fading in, all remaining [events](scribble_autotype_add_event) will be executed.