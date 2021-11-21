function __scribble_gen_2_line_heights()
{
    //Set up line height limits
    var _element = global.__scribble_generator_state.element;
    var _line_height_min = _element.line_height_min;
    var _line_height_max = _element.line_height_max;
    
    if (_line_height_min < 0)
    {
        var _font_data = __scribble_get_font_data(_element.starting_font);
        var _font_glyphs_map  = _font_data.glyphs_map;
        var _space_glyph_data = _font_glyphs_map[? 32];
        if (_space_glyph_data == undefined)
        {
            __scribble_error("The space character is missing from font definition for \"", _font_name, "\"");
            return false;
        }
        var _font_line_height = _space_glyph_data[SCRIBBLE_GLYPH.HEIGHT];
        _line_height_min = _font_line_height;
    }
    
    if (_line_height_max < 0) _line_height_max = infinity;
    
    with(global.__scribble_generator_state)
    {
        line_height_min = _line_height_min;
        line_height_max = _line_height_max;
    }
}