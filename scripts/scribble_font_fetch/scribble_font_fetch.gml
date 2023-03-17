/// @param name
/// @param glyphRange

function scribble_font_fetch(_font, _glyph_range)
{
    var _font_data = __scribble_get_font_data(_font);
    var _font_add_cache = _font_data.__font_add_cache;
    
    if (_font_add_cache == undefined)
    {
        __scribble_trace("Warning! Font \"", _font, "\" was not created with scribble_font_add(), cannot fetch any glyphs");
        return;
    }
    
    //Build an array of glyphs to adjust
    var _glyph_array = __scribble_parse_glyph_range_root(_glyph_range, _font);
    
    var _count = array_length(_glyph_array);
    if (_count > _font_add_cache.__cell_count)
    {
        __scribble_trace("Warning! Attempting to fetch ", _count, " glyphs but font cache for \"", _font, "\" has a maximum cache of ", _font_add_cache.__cell_count, " glyphs");
        _count = _font_add_cache.__cell_count;
    }
    
    var _i = 0;
    repeat(_count)
    {
        _font_add_cache.__fetch_unknown(_glyph_array[_i]);
        ++_i;
    }
}