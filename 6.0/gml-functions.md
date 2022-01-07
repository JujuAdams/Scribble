### Core Scripts

*Configuration*

- [`__scribble_macros()`](__scribble_macros)
- [`scribble_reset()`](scribble_reset)

*Initialisation*

- [`scribble_init(fontDirectory, defaultFont, autoScan)`](scribble_init)
- [`scribble_add_font(fontName, [yyPath], [texture])`](scribble_add_font)
- [`scribble_add_spritefont(fontName, mapString, separation, [spaceWidth], [proportional])`](scribble_add_spritefont)
- [`scribble_add_color(tagName, color, [colorIsGameMakerBGR])`](scribble_add_color)
- [`scribble_bake_outline(sourceFontName, newFontName, thickness, samples, color, smooth)`](scribble_bake_outline)

*Drawing*

- [`scribble_draw(x, y, content, [occuranceName])`](scribble_draw)
- [`scribble_get_bbox(x, y, content, [leftPad], [topPad], [rightPad], [bottomPad])`](scribble_get_bbox)
- [`scribble_get_width(content)`](scribble_get_width)
- [`scribble_get_height(content)`](scribble_get_height)
- [`scribble_cache(string, [occuranceName], [garbageCollect], [freeze])`](scribble_cache)

*Drawing Options*

- [`scribble_set_starting_format(fontName, fontColor, textHAlign)`](scribble_set_starting_format)
- [`scribble_set_wrap(maxBoxWidth, maxBoxHeight, [characterWrap])`](scribble_set_wrap)
- [`scribble_set_line_height(minLineHeight, maxLineHeight)`](scribble_set_line_height)
- [`scribble_set_blend(color, alpha)`](scribble_set_blend)
- [`scribble_set_animation(animProperty, value)`](scribble_set_animation)
- [`scribble_set_transform(xscale, yscale, angle)`](scribble_set_transform)
- [`scribble_set_box_align(boxHAlign, boxVAlign)`](scribble_set_box_align)
- [`scribble_set_bezier(x1, y1, x2, y2, x3, y3, x4, y4)`](scribble_set_bezier)
- [`scribble_get_state([ignoreAnimation])`](scribble_get_state)
- [`scribble_set_state(stateArray)`](scribble_set_state)

&nbsp;

### Extra Functionality

*Typewriter*

- [`scribble_autotype_fade_in(element, speed, smoothness, perLine, [occuranceName])`](scribble_autotype_fade_in)
- [`scribble_autotype_fade_out(element, speed, smoothness, perLine, [occuranceName])`](scribble_autotype_fade_out)
- [`scribble_autotype_skip(element, [occuranceName])`](scribble_autotype_skip)
- [`scribble_autotype_get(element, [occuranceName])`](scribble_autotype_get)
- [`scribble_autotype_set_sound(element, soundArray, overlap, pitchMin, pitchMax, [occuranceName])`](scribble_autotype_set_sound)
- [`scribble_autotype_set_sound_per_char(element, soundArray, pitchMin, pitchMax, [occuranceName])`](scribble_autotype_set_sound_per_char)
- [`scribble_autotype_set_pause(content, state, [occuranceName])`](scribble_autotype_set_pause)
- [`scribble_autotype_is_paused(content, [occuranceName])`](scribble_autotype_is_paused)
- [`scribble_add_autotype_event(name, script)`](scribble_add_autotype_event)

*Pages*

- [`scribble_page_set(element, page, [occuranceName])`](scribble_page_set)
- [`scribble_page_get(element, [occuranceName])`](scribble_page_get)
- [`scribble_page_count(element)`](scribble_page_count)
- [`scribble_page_on_last(element, [occuranceName])`](scribble_page_on_last)

*Advanced*

- [`scribble_flush([textElement])`](scribble_flush)
- [`scribble_set_glyph_property(fontName, character, property, value, [relative])`](scribble_set_glyph_property)
- [`scribble_get_glyph_property(fontName, character, property)`](scribble_get_glyph_property)
- [`scribble_add_shader_effect(tagName, index)`](scribble_add_shader_effect)
- [`scribble_whitelist_sprite(spriteIndex, [spriteIndex], ...)`](scribble_whitelist_sprite)
- [`scribble_bake_shader(sourceFontName, newFontName, shader, emptyBorderSize, leftPad, topPad, rightPad, bottomPad, glyphSeparation, smooth, [surfaceSize])`](scribble_bake_shader)
- [`scribble_autotype_function(element, callbackFunction, [occuranceName])`](scribble_autotype_function)
- [`scribble_add_autotype_character_delay(character, delay)`](scribble_add_autotype_character_delay)