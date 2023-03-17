/// @param name
/// @param filename
/// @param size
/// @param startChar
/// @param endChar
/// @param SDF
/// @param [spread]
/// @param [bold=false]
/// @param [italic=false]

function scribble_font_add(_name, _filename, _point_size, _startChar, _endChar, _sdf, _spread = undefined, _bold = false, _italic = false)
{
    static _font_original_name_dict = __scribble_get_state().__font_original_name_dict;
    
    __scribble_initialize();
    
    if (SCRIBBLE_VERBOSE)
    {
        __scribble_trace("Adding \"", _filename, "\" as \"", _name, "\"");
        __scribble_trace("|-- size = ", _point_size);
        __scribble_trace("|-- characters = ", _startChar, " -> ", _endChar);
        __scribble_trace("|-- SDF = ", _sdf);
        __scribble_trace("|-- spread = ", _spread);
        __scribble_trace("|-- bold = ", _bold);
        __scribble_trace("\\-- italic = ", _italic);
    }
    
    var _asset = font_add(_filename, _point_size, _bold, _italic, _startChar, _endChar);
    if (!font_exists(_asset)) __scribble_error("Failed to load \"", _filename, "\"");
    font_enable_sdf(_asset, _sdf);
    if (_spread != undefined) font_sdf_spread(_asset, _spread);
    
    var _asset_name = font_get_name(_asset);
    
    //Make an extra check
    __scribble_font_check_name_conflicts(_asset_name);
    
    var _scribble_state = __scribble_get_state();
    if (_scribble_state.__default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_name) + "\"");
        _scribble_state.__default_font = _name;
    }
    
    try
    {
        //Create a glyph cache
        var _font_cache = new __scribble_class_font_add_cache(_asset, _name, _startChar, _endChar);
        
        //Find out how many glyphs we can store at once
        var _size = _font_cache.__get_max_glyph_count();
        
        //Create a font representation we can use for interaction with other Scribble font functions
        var _font_data = new __scribble_class_font(_asset_name, _name, _size, font_get_sdf_enabled(_asset));
        _font_original_name_dict[$ _asset_name] = _font_data;
        
        with(_font_data)
        {
            //Bind the font_add() cache to the font struct
            __font_add_cache = _font_cache;
            
            //We use this data to reconstruct a font when font_enable_sdf() is called
            with(__font_add_data)
            {
                __filename   = _filename;
                __point_size = _point_size;
                __bold       = _bold;
                __italic     = _italic;
                __first      = _startChar;
                __last       = _endChar;
            }
        }
        
        var _is_krutidev = __scribble_asset_is_krutidev(_asset, asset_font);
        if (_is_krutidev) _font_data.__is_krutidev = true;
        
        //Finalise the font_add() cache so we have enough information for recaching
        var _font_info = font_get_info(_asset);
        var _info_glyphs_dict = _font_info.glyphs;
        var _space_struct = _info_glyphs_dict[$ " "];
        
        with(_font_cache)
        {
            __font_data    = _font_data;
            __space_width  = _space_struct.shift;
            __space_height = string_height(" ");
        }
        
        //Pre-emptively fill in data grid so we have to do less work later
        var _font_glyph_data_grid = _font_data.__glyph_data_grid;
        ds_grid_set_region(_font_glyph_data_grid, 0, SCRIBBLE_GLYPH.CHARACTER,   _size-1, SCRIBBLE_GLYPH.CHARACTER,   ""                         );
        ds_grid_set_region(_font_glyph_data_grid, 0, SCRIBBLE_GLYPH.TEXTURE,     _size-1, SCRIBBLE_GLYPH.TEXTURE,     _font_cache.__get_texture());
        ds_grid_set_region(_font_glyph_data_grid, 0, SCRIBBLE_GLYPH.FONT_SCALE,  _size-1, SCRIBBLE_GLYPH.FONT_SCALE,  1                          );
        ds_grid_set_region(_font_glyph_data_grid, 0, SCRIBBLE_GLYPH.BILINEAR,    _size-1, SCRIBBLE_GLYPH.BILINEAR,    __SCRIBBLE_BIDI.SYMBOL     );
        
        ds_grid_set_region(_font_glyph_data_grid, 0, SCRIBBLE_GLYPH.SDF_PXRANGE,           _size-1, SCRIBBLE_GLYPH.SDF_PXRANGE,           font_get_sdf_enabled(_asset)? __SCRIBBLE_NATIVE_SDF_PXRANGE : undefined);
        ds_grid_set_region(_font_glyph_data_grid, 0, SCRIBBLE_GLYPH.SDF_THICKNESS_OFFSET,  _size-1, SCRIBBLE_GLYPH.SDF_THICKNESS_OFFSET,  font_get_sdf_enabled(_asset)? 0                             : undefined);
        ds_grid_set_region(_font_glyph_data_grid, 0, SCRIBBLE_GLYPH.BILINEAR ,             _size-1, SCRIBBLE_GLYPH.BILINEAR,              font_get_sdf_enabled(_asset)? true                          : undefined);
        
        //Clear the glyph map. This function also sets up the space character in index 0 which is necessary for other bits of Scribble to work
        _font_cache.__clear_glyph_map();
        _font_cache.__invalidate();
        
        _font_data.__calculate_font_height();
        
        //Prefetch as much of our initial range as possible
        scribble_font_fetch(_name, [_startChar, _endChar]);
    }
    catch(_error)
    {
        __scribble_trace(_error);
        __scribble_error("There was an error whilst reading \"", _filename, "\"\nPlease ensure that the font file exists before using font_add()\nIf this issue persists, please report it");
    }
    
	// We return the font ID provided by font_add()
    return _asset;
}