/// Modifies a particular value for characters in a font previously added to Scribble.
/// 
/// Returns: The new value of the property that was modified.
/// @param fontName           The target font, as a string
/// @param glyphRange         Range of glyphs to target
/// @param property           Property to return, see below
/// @param value              The value to set
/// @param [relative=false]   Whether to add the new value to the existing value, or to overwrite the existing value. Defaults to false, overwriting the existing value
/// 
/// Fonts can often be tricky to render correctly, and this script allows you to change certain properties.
/// Properties can be adjusted at any time, but existing/cached Scribble text will not be updated to match new properties.
/// 
/// Three properties are suggested for modification:
/// __SCRIBBLE_GLYPH.__X_OFFSET:   The relative x-offset to draw the glyph
/// __SCRIBBLE_GLYPH.__Y_OFFSET:   The relative y-offset to draw the glyph
/// __SCRIBBLE_GLYPH.__SEPARATION: Effective width of the glyph, the distance between this glyph's left edge and the
///                            left edge of the next glyph. This can be a negative value!

function __scribble_glyph_set(_font, _glyph_range, _property, _value, _relative = false)
{
    var _font_data = __scribble_get_font_data(_font);
    
    var _grid = _font_data.__glyph_data_grid;
    var _map  = _font_data.__glyphs_map;
    
    //Optimisation for adjusting all glyphs
    if ((_glyph_range == all) || (_glyph_range == "all"))
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
        if (_property == __SCRIBBLE_GLYPH.__SEPARATION) _grid[# _glyph_index, __SCRIBBLE_GLYPH.__WIDTH     ] = _grid[# _glyph_index, __SCRIBBLE_GLYPH.__SEPARATION];
        if (_property == __SCRIBBLE_GLYPH.__WIDTH     ) _grid[# _glyph_index, __SCRIBBLE_GLYPH.__SEPARATION] = _grid[# _glyph_index, __SCRIBBLE_GLYPH.__WIDTH     ];
        
        //Changing the height of the space character also changes its font height
        if (_property == __SCRIBBLE_GLYPH.__HEIGHT     ) _grid[# _glyph_index, __SCRIBBLE_GLYPH.__FONT_HEIGHT] = _grid[# _glyph_index, __SCRIBBLE_GLYPH.__HEIGHT     ];
        if (_property == __SCRIBBLE_GLYPH.__FONT_HEIGHT) _grid[# _glyph_index, __SCRIBBLE_GLYPH.__HEIGHT     ] = _grid[# _glyph_index, __SCRIBBLE_GLYPH.__FONT_HEIGHT];
        
        //Ensure that a change to the height of a space character also sets the font height for the whole font
        if ((_property == __SCRIBBLE_GLYPH.__HEIGHT) || (_property == __SCRIBBLE_GLYPH.__FONT_HEIGHT))
        {
            ds_grid_set_region(_grid, 0, __SCRIBBLE_GLYPH.__FONT_HEIGHT, ds_grid_width(_grid)-1, __SCRIBBLE_GLYPH.__FONT_HEIGHT, _grid[# _glyph_index, __SCRIBBLE_GLYPH.__FONT_HEIGHT]);
            _font_data.__calculate_font_height();
        }
    }
    else
    {
        //Build an array of glyphs to adjust
        var _glyph_array = __scribble_parse_glyph_range_root(_glyph_range, _font);
        
        var _i = 0;
        repeat(array_length(_glyph_array))
        {
            var _unicode = _glyph_array[_i];
            
            //Figure out the grid index this Unicode value is assigned to
            var _glyph_index = _map[? _unicode];
            if (_glyph_index == undefined)
            {
                __scribble_trace("Warning! Glyph ", __scribble_unicode_u(_unicode), " (", _unicode, ") not found for font \"", _font, "\"");
            }
            else
            {
                var _new_value = _relative? (_grid[# _glyph_index, _property] + _value) : _value;
                _grid[# _glyph_index, _property] = _new_value;
                
                if (_unicode == 0x20) //Space character separation and width should always be the same
                {
                    //Changing the width of the space character also changes the separation
                    if (_property == __SCRIBBLE_GLYPH.__SEPARATION) _grid[# _glyph_index, __SCRIBBLE_GLYPH.__WIDTH     ] = _new_value;
                    if (_property == __SCRIBBLE_GLYPH.__WIDTH     ) _grid[# _glyph_index, __SCRIBBLE_GLYPH.__SEPARATION] = _new_value;
                    
                    //Changing the height of the space character also changes its font height
                    if (_property == __SCRIBBLE_GLYPH.__HEIGHT     ) _grid[# _glyph_index, __SCRIBBLE_GLYPH.__FONT_HEIGHT] = _new_value;
                    if (_property == __SCRIBBLE_GLYPH.__FONT_HEIGHT) _grid[# _glyph_index, __SCRIBBLE_GLYPH.__HEIGHT     ] = _new_value;
                    
                    //Ensure that a change to the height of a space character also sets the font height for the whole font
                    if ((_property == __SCRIBBLE_GLYPH.__HEIGHT) || (_property == __SCRIBBLE_GLYPH.__FONT_HEIGHT))
                    {
                        ds_grid_set_region(_grid, 0, __SCRIBBLE_GLYPH.__FONT_HEIGHT, ds_grid_width(_grid)-1, __SCRIBBLE_GLYPH.__FONT_HEIGHT, _new_value);
                        _font_data.__calculate_font_height();
                    }
                }
            }
            
            ++_i;
        }
    }
}