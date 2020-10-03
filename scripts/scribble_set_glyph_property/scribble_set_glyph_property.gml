/// Modifies a particular value for a character in a font previously added to Scribble.
/// 
/// Returns: The new value of the property that was modified.
/// @param fontName     The target font, as a string
/// @param character    Target character, as a string
/// @param property     Property to return, see below
/// @param value        The value to set
/// @param [relative]   Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to false, overwriting the existing value
/// 
/// Fonts can often be tricky to render correctly, and this script allows you to change certain properties.
/// Properties can be adjusted at any time, but existing/cached Scribble text will not be updated to match new properties.
/// 
/// Three properties are suggested for modification:
/// SCRIBBLE_GLYPH.X_OFFSET:   The relative x-offset to draw the glyph
/// SCRIBBLE_GLYPH.Y_OFFSET:   The relative y-offset to draw the glyph
/// SCRIBBLE_GLYPH.SEPARATION: Effective width of the glyph, the distance between this glyph's left edge and the
///                            left edge of the next glyph. This can be a negative value!

function scribble_set_glyph_property()
{
    var _font      = argument[0];
    var _character = argument[1];
    var _property  = argument[2];
    var _value     = argument[3];
    var _relative  = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : false;
    
    if (!variable_global_exists("__scribble_lcg"))
    {
        show_error("Scribble:\nscribble_glyph_property() should be called after initialising Scribble.\n ", false);
        exit;
    }
    
    if (!ds_map_exists(global.__scribble_font_data, _font))
    {
        show_error("Scribble:\nFont \"" + string(_font) + "\" not found\n ", false);
        exit;
    }
    
    var _font_data = global.__scribble_font_data[? _font];
    
    if ((_character == all) || (_character == "all"))
    {
        var _array = _font_data[__SCRIBBLE_FONT.GLYPHS_ARRAY];
        if (_array == undefined)
        {
            //If the glyph array doesn't exist for this font, use the ds_map fallback
            var _map = _font_data[__SCRIBBLE_FONT.GLYPHS_MAP];
            
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
        var _array = _font_data[__SCRIBBLE_FONT.GLYPHS_ARRAY];
        if (_array == undefined)
        {
            //If the glyph array doesn't exist for this font, use the ds_map fallback
            var _map = _font_data[__SCRIBBLE_FONT.GLYPHS_MAP];
            var _glyph_data = _map[? ord(_character)];
        }
        else
        {
            var _glyph_data = _array[ord(_character) - _font_data[ __SCRIBBLE_FONT.GLYPH_MIN]];
        }
        
        if (_glyph_data == undefined)
        {
            show_error("Scribble:\nCharacter \"" + _character + "\" not found for font \"" + _font + "\"", false);
            exit;
        }
        
        var _new_value = _relative? (_glyph_data[_property] + _value) : _value;
        _glyph_data[@ _property] = _new_value;
        return _new_value;
    }
}