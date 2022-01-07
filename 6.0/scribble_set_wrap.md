`scribble_set_wrap(maxBoxWidth, [maxBoxHeight], [characterWrap])`

**Returns:** N/A (`0`)

|Argument|Name             |Purpose                                                               |
|--------|-----------------|----------------------------------------------------------------------|
|0       |`maxBoxWidth`    |Maximum width for the whole textbox. Use a negative number (the default) for no limit|
|1       |`maxBoxHeight`   |Maximum height for the whole textbox. Use a negative number (the default) for no limit|
|[2]     |`[characterWrap]`|Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for very tight textboxes and some East Asian languages|

Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/text/draw_text_ext.html). If text exceeds the horizontal maximum width then text will be pushed onto the next line. If text exceeds the maximum height of the textbox then a new page will be created (see [`scribble_page_set()`](scribble_page_set) and [`scribble_page_get()`](scribble_page_get)).

This script sets part of Scribble's global state. All text drawn with [`scribble_draw()`](scribble_draw) or cached with [`scribble_cache()`](scribble_cache) will use these settings until they're overwritten, either by calling this script again or by calling [`scribble_reset()`](scribble_reset) or [`scribble_set_state()`](scribble_set_state).