`scribble_autotype_fade_out(element, speed, smoothness, perLine, [occuranceName])`

**Returns:** N/A (`0`)

|Argument|Name        |Purpose                                                               |
|--------|------------|----------------------------------------------------------------------|
|0       |`element`   |Text element to target. This element must have been created previously by [`scribble_draw()`](scribble_draw) or [`scribble_cache()`](scribble_cache)|
|1       |`speed`     |Amount of text to reveal per tick (1 tick is usually 1 frame). This is character or lines depending on the method defined above|
|2       |`smoothness`|How much text is visible during the fade. Higher numbers will allow more text to be visible as it fades out|
|3       |`perLine`   |Set to `true` to fade out one line at a time, otherwise text will fade out per-character|
|[4]     |`[occuranceName]`|ID to reference a specific unique occurance of a text element. This can be a string or a number. Defaults to [`SCRIBBLE_DEFAULT_OCCURANCE_NAME`](__scribble_macros)             |

The smoothness argument offers some customisation for how text fades out. A high value will cause text to be smoothly faded out whereas a smoothness of `0` will cause text to instantly pop onto the screen. For advanced users, custom shader code can be easily combined with the `smoothness` value to animate text in unique ways as it fades out.

[Events](scribble_autotype_add_event) will **not** be executed as text fades out.