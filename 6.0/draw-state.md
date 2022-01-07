|Variable                           |Purpose                                                                |
|-----------------------------------|-----------------------------------------------------------------------|
|`scribble_state_color`             |Blend color used when drawing text, applied multiplicatively|
|`scribble_state_alpha`             |Alpha used when drawing text, 0 being fully transparent and 1 being fully opaque|
|`scribble_state_xscale`            |x-scale of the text element|
|`scribble_state_yscale`            |y-scale of the text element|
|`scribble_state_angle`             |Rotation angle of the text element|
|`scribble_state_fallback_character`|Character used to replace a missing character in a font. This is usually `□` (U+25A1 "white square") but `?` can be used as well (and Scribble defaults to `?`)|
|`scribble_state_box_halign`        |Horizontal alignment of the **entire textbox** relative to the draw coordinate. Accepts `fa_left`, `fa_right`, and `fa_center`|
|`scribble_state_box_valign`        |Vertical alignment of the **entire textbox** relative to the draw coordinate. Accepts `fa_top`, `fa_bottom`, and `fa_middle`|
|`scribble_state_line_min_height`   |Minimum line height for each line of text. Use a negative number (the default) for the height of a space character of the default font|
|`scribble_state_max_width`         |Maximum width for the whole textbox. Use a negative number (the default) for no limit
|`scribble_state_max_height`        |Maximum height for the whole textbox. Use a negative number (the default) for no limit|
`scribble_state_character_wrap`     |Whether to wrap text per character (rather than per word). Defaults to `false`. This is useful for very tight textboxes and East Asian languages|

The blend colour/alpha is applied at the end of the drawing pipeline. This is a little different to the interaction between [`draw_set_color()`](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/colour/draw_set_colour.html) and [`draw_text()` functions](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/text/). Scribble's blend colour is instead similar to [`draw_sprite_ext()`](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/sprites_and_tiles/draw_sprite_ext.html)'s behaviour: The blend colour/alpha is applied multiplicatively with the source colour, in this case the source colour is whatever colour has been set using formatting tags in the input text string.

The scaling and rotation transform operates relative to the origin of the text element i.e. rotation will happen using the origin as the centre of rotation. [`scribble_set_box_alignment()`](scribble_draw_set_box_align) can be used to draw text offset from the origin.

Scribble's text wrapping operates in a very similar way to GameMaker's native [`draw_text_ext()`](https://docs2.yoyogames.com/source/_build/3_scripting/4_gml_reference/drawing/text/draw_text_ext.html) function ("sep" is `minLineHeight` and "w" is `maxBoxWidth`).