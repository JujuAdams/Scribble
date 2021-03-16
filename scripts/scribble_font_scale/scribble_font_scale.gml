/// Scales a font's glyphs permanently across all future text elements
/// 
/// Returns: N/A (undefined)
/// @param fontName  The target font, as a string
/// @param xscale    x-scaling factor to apply
/// @param yscale    y-scaling factor to apply

function scribble_font_scale(_font, _xscale, _yscale)
{
    if (!ds_map_exists(global.__scribble_font_data, _font))
    {
        __scribble_error("Font \"", _font, "\" not found");
        exit;
    }
    
    var _font_data = global.__scribble_font_data[? _font];
    
    var _array = _font_data.glyphs_array;
    var _map   = _font_data.glyphs_map;
    
    _font_data.xscale *= _xscale;
    _font_data.yscale *= _yscale;
    _font_data.scale_dist = point_distance(0, 0, _font_data.xscale, _font_data.yscale);
    
    if (_array == undefined)
    {
        //If the glyph array doesn't exist for this font, use the ds_map fallback
        var _map = _font_data.glyphs_map;
        
        var _key = ds_map_find_first(_map);
        repeat(ds_map_size(_map))
        {
            var _glyph_data = _map[? _key];
            _glyph_data[@ SCRIBBLE_GLYPH.X_OFFSET  ] *= _xscale;
            _glyph_data[@ SCRIBBLE_GLYPH.Y_OFFSET  ] *= _yscale;
            _glyph_data[@ SCRIBBLE_GLYPH.WIDTH     ] *= _xscale;
            _glyph_data[@ SCRIBBLE_GLYPH.HEIGHT    ] *= _yscale;
            _glyph_data[@ SCRIBBLE_GLYPH.SEPARATION] *= _xscale;
            _key = ds_map_find_next(_map, _key);
        }
    }
    else
    {
        var _i = 0;
        repeat(array_length(_array))
        {
            var _glyph_data = _array[_i];
            if (is_array(_glyph_data))
            {
                _glyph_data[@ SCRIBBLE_GLYPH.X_OFFSET  ] *= _xscale;
                _glyph_data[@ SCRIBBLE_GLYPH.Y_OFFSET  ] *= _yscale;
                _glyph_data[@ SCRIBBLE_GLYPH.WIDTH     ] *= _xscale;
                _glyph_data[@ SCRIBBLE_GLYPH.HEIGHT    ] *= _yscale;
                _glyph_data[@ SCRIBBLE_GLYPH.SEPARATION] *= _xscale;
            }
            
            ++_i;
        }
    }
}