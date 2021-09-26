/// Modifies a particular value for a character in a font previously added to Scribble.
/// 
/// Returns: The new value of the property that was modified.
/// @param fontName           The target font, as a string
/// @param character          Target character, as a string
/// @param property           Property to return, see below
/// @param value              The value to set
/// @param [relative=false]   Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to false, overwriting the existing value
/// 
/// Fonts can often be tricky to render correctly, and this script allows you to change certain properties.
/// Properties can be adjusted at any time, but existing/cached Scribble text will not be updated to match new properties.
/// 
/// Three properties are suggested for modification:
/// SCRIBBLE_GLYPH.X_OFFSET:   The relative x-offset to draw the glyph
/// SCRIBBLE_GLYPH.Y_OFFSET:   The relative y-offset to draw the glyph
/// SCRIBBLE_GLYPH.SEPARATION: Effective width of the glyph, the distance between this glyph's left edge and the
///                            left edge of the next glyph. This can be a negative value!

function scribble_glyph_set(_font, _character, _property, _value, _relative = false)
{
    if (!ds_map_exists(global.__scribble_font_data, _font))
    {
        __scribble_error("Font \"", _font, "\" not found");
        exit;
    }
    
    var _font_data = global.__scribble_font_data[? _font];
    
    var _array = _font_data.glyphs_array;
    var _map   = _font_data.glyphs_map;
    
    if ((_character == all) || (_character == "all"))
    {
        if (_array == undefined)
        {
            //If the glyph array doesn't exist for this font, use the ds_map fallback
            var _map = _font_data.glyphs_map;
            
            var _key = ds_map_find_first(_map);
            repeat(ds_map_size(_map))
            {
                var _glyph_data = _map[? _key];
                _glyph_data[@ _property] = _relative? (_glyph_data[_property] + _value) : _value;
                _key = ds_map_find_next(_map, _key);
            }
        }
        else
        {
            var _i = 0;
            repeat(array_length(_array))
            {
                var _glyph_data = _array[_i];
                if (is_array(_glyph_data)) _glyph_data[@ _property] = _relative? (_glyph_data[_property] + _value) : _value;
                ++_i;
            }
        }
    }
    else
    {
        var _ord = ord(_character);
        
        if (_array == undefined)
        {
            //If the glyph array doesn't exist for this font, use the ds_map fallback
            var _glyph_data = _map[? _ord];
        }
        else
        {
            var _glyph_data = _array[_ord - _font_data.glyph_min];
        }
        
        if (_glyph_data == undefined)
        {
            __scribble_error("Character \"", _character, "\" not found for font \"", _font, "\"");
            exit;
        }
        
        var _new_value = _relative? (_glyph_data[_property] + _value) : _value;
        _glyph_data[@ _property] = _new_value;
        
        if (_ord == 0x20) //Space character separation and width should always be the same
        {
            if (_property == SCRIBBLE_GLYPH.SEPARATION) _glyph_data[@ SCRIBBLE_GLYPH.WIDTH] = _new_value;
            if (_property == SCRIBBLE_GLYPH.WIDTH) _glyph_data[@ SCRIBBLE_GLYPH.SEPARATION] = _new_value;
        }
        
        return _new_value;
    }
}