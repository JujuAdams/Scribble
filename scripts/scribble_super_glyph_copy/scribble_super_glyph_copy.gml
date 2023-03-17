/// @param target
/// @param source
/// @param overwrite
/// @param glyphRange

function scribble_super_glyph_copy(_target, _source, _overwrite, _range)
{
    if (argument_count > 4)
    {
        __scribble_error("Optional arguments for scribble_super_glyph_copy() are no longer supported");
        return;
    }
    
    var _target_font_data = __scribble_get_font_data(_target);
    var _source_font_data = __scribble_get_font_data(_source);
    
    //Verify that the two fonts can be used together
    __scribble_super_glyph_copy_common(_target_font_data, _source_font_data);
    
    var _target_glyphs_map       = _target_font_data.__glyphs_map;
    var _target_glyph_data_grid  = _target_font_data.__glyph_data_grid;
    var _source_glyphs_map       = _source_font_data.__glyphs_map;
    var _source_glyphs_data_grid = _source_font_data.__glyph_data_grid;
    
    var _array = __scribble_parse_glyph_range_root(_range, _source);
    var _i = 0;
    repeat(array_length(_array))
    {
        __scribble_glyph_duplicate(_source_glyphs_map, _source_glyphs_data_grid, _target_glyphs_map, _target_glyph_data_grid, _array[_i], _overwrite);
        ++_i;
    }
    
    ds_grid_set_region(_target_glyph_data_grid, 0, __SCRIBBLE_GLYPH.__FONT_HEIGHT, ds_grid_width(_target_glyph_data_grid), __SCRIBBLE_GLYPH.__FONT_HEIGHT,
                       max(_target_font_data.__height, _source_font_data.__height));
}

function __scribble_super_glyph_copy_common(_target_font_data, _source_font_data)
{
    if (_source_font_data.__sdf == undefined)
    {
        __scribble_error("Cannot determine if the source font is an SDF font. Please add glyphs to it");
    }
    else if (_target_font_data.__sdf == undefined)
    {
        //Target font hasn't had anything added to it yet
    }
    else if (_target_font_data.__sdf || _source_font_data.__sdf)
    {
        if (_target_font_data.__sdf == false)
        {
            __scribble_error("Cannot mix standard/sprite fonts with SDF fonts (target is not an SDF font)");
        }
        
        if (_source_font_data.__sdf == false)
        {
            __scribble_error("Cannot mix standard/sprite fonts with SDF fonts (source is not an SDF font)");
        }
        
        if (_source_font_data.__sdf_pxrange == undefined)
        {
            __scribble_error("Source font's SDF pxrange must be defined before copying glyphs");
        }
        
        if ((_target_font_data.__sdf_pxrange != undefined) && (_target_font_data.__sdf_pxrange != _source_font_data.__sdf_pxrange))
        {
            __scribble_error("SDF font pxrange must match (target = ", _target_font_data.__sdf_pxrange, " vs. source = ", _source_font_data.__sdf_pxrange, ")");
        }
    }
    
    _target_font_data.__sdf = _source_font_data.__sdf;
    _target_font_data.__sdf_pxrange = _source_font_data.__sdf_pxrange;
}

function __scribble_glyph_duplicate(_source_map, _source_grid, _target_map, _target_grid, _glyph, _overwrite)
{
    var _source_x = _source_map[? _glyph];
    if (_source_x == undefined)
    {
        __scribble_trace("Warning! Glyph ", _glyph, " (", chr(_glyph), ") not found in source font");
        return;
    }
    
    var _target_x = _target_map[? _glyph];
    if (_target_x == undefined)
    {
        //Create a new column in the grid to store this glyph's data
        var _target_x = ds_grid_width(_target_grid);
        _target_map[? _glyph] = _target_x;
        ds_grid_resize(_target_grid, _target_x+1, __SCRIBBLE_GLYPH.__SIZE);
    }
    else
    {
        if (!_overwrite)
        {
            //Glyph already exists in target, skip it
            return;
        }
        
        //Copy data from source directly into the existing slot in the font's glyph table
    }
    
    //Do the actual copying
    ds_grid_set_grid_region(_target_grid, _source_grid, _source_x, 0, _source_x, __SCRIBBLE_GLYPH.__SIZE, _target_x, 0);
}