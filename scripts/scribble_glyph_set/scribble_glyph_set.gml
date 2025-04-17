// Feather disable all
/// Modifies a particular value for a character in a font previously added to Scribble.
/// 
/// Returns: The new value of the property that was modified.
/// @param fontName           The target font, as a string
/// @param character          Target character, as a string. You may use the GameMaker constant `all` to adjust all characters in a font
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
    var _font_data = __scribble_get_font_data(_font);
    
    var _grid = _font_data.__glyph_data_grid;
    var _map  = _font_data.__glyphs_map;
    
    if ((_character == all) || (_character == "all"))
    {
        if (_relative)
        {
            ds_grid_add_region(_grid, 0, _property, ds_grid_width(_grid)-1, _property, _value);
        }
        else
        {
            ds_grid_set_region(_grid, 0, _property, ds_grid_width(_grid)-1, _property, _value);
        }
        
        //Space character separation and width should always be the same
        var _glyph_index = _map[? 0x20];
        if (_glyph_index == undefined)
        {
            __scribble_error("Space character not found for font \"", _font, "\"");
            exit;
        }
        
        //Changing the width of the space character also changes the separation
        if (_property == SCRIBBLE_GLYPH.SEPARATION) _grid[# _glyph_index, SCRIBBLE_GLYPH.WIDTH     ] = _grid[# _glyph_index, SCRIBBLE_GLYPH.SEPARATION];
        if (_property == SCRIBBLE_GLYPH.WIDTH     ) _grid[# _glyph_index, SCRIBBLE_GLYPH.SEPARATION] = _grid[# _glyph_index, SCRIBBLE_GLYPH.WIDTH     ];
        
        //Changing the height of the space character also changes its font height
        if (_property == SCRIBBLE_GLYPH.HEIGHT     ) _grid[# _glyph_index, SCRIBBLE_GLYPH.FONT_HEIGHT] = _grid[# _glyph_index, SCRIBBLE_GLYPH.HEIGHT     ];
        if (_property == SCRIBBLE_GLYPH.FONT_HEIGHT) _grid[# _glyph_index, SCRIBBLE_GLYPH.HEIGHT     ] = _grid[# _glyph_index, SCRIBBLE_GLYPH.FONT_HEIGHT];
        
        //Ensure that a change to the height of a space character also sets the font height for the whole font
        if ((_property == SCRIBBLE_GLYPH.HEIGHT) || (_property == SCRIBBLE_GLYPH.FONT_HEIGHT))
        {
            ds_grid_set_region(_grid, 0, SCRIBBLE_GLYPH.FONT_HEIGHT, ds_grid_width(_grid)-1, SCRIBBLE_GLYPH.FONT_HEIGHT, _grid[# _glyph_index, SCRIBBLE_GLYPH.FONT_HEIGHT]);
            _font_data.__calculate_font_height();
        }
    }
    else
    {
        var _unicode = is_real(_character)? _character : ord(_character);
        var _glyph_index = _map[? _unicode];
        
        if (_glyph_index == undefined)
        {
            __scribble_error("Character \"", _character, "\" not found for font \"", _font, "\"");
            exit;
        }
        
        var _new_value = _relative? (_grid[# _glyph_index, _property] + _value) : _value;
        _grid[# _glyph_index, _property] = _new_value;
        
        if (_unicode == 0x20) //Space character separation and width should always be the same
        {
            //Changing the width of the space character also changes the separation
            if (_property == SCRIBBLE_GLYPH.SEPARATION) _grid[# _glyph_index, SCRIBBLE_GLYPH.WIDTH     ] = _new_value;
            if (_property == SCRIBBLE_GLYPH.WIDTH     ) _grid[# _glyph_index, SCRIBBLE_GLYPH.SEPARATION] = _new_value;
            
            //Changing the height of the space character also changes its font height
            if (_property == SCRIBBLE_GLYPH.HEIGHT     ) _grid[# _glyph_index, SCRIBBLE_GLYPH.FONT_HEIGHT] = _new_value;
            if (_property == SCRIBBLE_GLYPH.FONT_HEIGHT) _grid[# _glyph_index, SCRIBBLE_GLYPH.HEIGHT     ] = _new_value;
        
            //Ensure that a change to the height of a space character also sets the font height for the whole font
            if ((_property == SCRIBBLE_GLYPH.HEIGHT) || (_property == SCRIBBLE_GLYPH.FONT_HEIGHT))
            {
                ds_grid_set_region(_grid, 0, SCRIBBLE_GLYPH.FONT_HEIGHT, ds_grid_width(_grid)-1, SCRIBBLE_GLYPH.FONT_HEIGHT, _new_value);
                _font_data.__calculate_font_height();
            }
        }
        
        return _new_value;
    }
}
