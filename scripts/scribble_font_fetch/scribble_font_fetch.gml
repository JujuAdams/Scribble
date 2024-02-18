/// @param name
/// @param glyphRange

function scribble_font_fetch(_font, _glyph_range)
{
    var _font_data = __scribble_get_font_data(_font);
    var _font_add_cache_array = _font_data.__font_add_cache_array;
    
    if (_font_add_cache_array == undefined)
    {
        __scribble_trace("Warning! Font \"", _font, "\" was not created with scribble_font_add(), cannot fetch any glyphs");
        return;
    }
    
    //Build an array of glyphs to adjust
    var _glyph_array = __scribble_parse_glyph_range_root(_glyph_range, _font);
    var _i = 0;
    repeat(array_length(_glyph_array))
    {
        var _glyph = _glyph_array[_i];
        var _font_group = __scribble_config_glyph_index_to_font_group(_glyph);
        var _font_add_cache = _font_add_cache_array[_font_group];
        if (_font_add_cache != undefined) _font_add_cache.__fetch_unknown(_glyph, undefined);
        ++_i;
    }
}