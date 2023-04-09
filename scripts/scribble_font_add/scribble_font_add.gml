/// @param name
/// @param filename
/// @param size
/// @param glyphRange
/// @param SDF
/// @param [spread]
/// @param [bold=false]
/// @param [italic=false]

function scribble_font_add(_name, _filename, _point_size, _glyph_range, _sdf, _spread = undefined, _bold = false, _italic = false)
{
    static _font_original_name_dict = __scribble_get_state().__font_original_name_dict;
    
    __scribble_initialize();
    
    if (SCRIBBLE_VERBOSE)
    {
        __scribble_trace("Adding \"", _filename, "\" as \"", _name, "\"");
        __scribble_trace("|-- size = ", _point_size);
        __scribble_trace("|-- range = ", _glyph_range);
        __scribble_trace("|-- SDF = ", _sdf);
        __scribble_trace("|-- spread = ", _spread);
        __scribble_trace("|-- bold = ", _bold);
        __scribble_trace("\\-- italic = ", _italic);
    }
    
    var _glyph_array = __scribble_parse_glyph_range_root(_glyph_range, undefined, true);
    
    var _asset = font_add(_filename, _point_size, _bold, _italic, _glyph_array[0], _glyph_array[array_length(_glyph_array)-1]);
    if (!font_exists(_asset)) __scribble_error("Failed to load \"", _filename, "\"");
    font_enable_sdf(_asset, _sdf);
    
    if (_sdf)
    {
        if (_spread != undefined)
        {
            font_sdf_spread(_asset, _spread);
        }
        else
        {
            _spread = font_get_sdf_spread(_asset);
        }
    }
    else
    {
        _spread = 0;
    }
    
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
        var _font_cache = new __scribble_class_font_add_cache(_asset, _name, _glyph_array, _sdf? font_get_sdf_spread(_asset) : 0);
        
        //Find out how many glyphs we can store at once
        var _size = _font_cache.__get_max_glyph_count();
        
        //Create a font representation we can use for interaction with other Scribble font functions
        var _font_data = new __scribble_class_font(_asset_name, _name, _size);
        _font_data.__type_font_add = true;
        _font_data.__type_sdf      = _sdf;
        _font_data.__type_runtime  = true;
        
        //Set material properties
        _font_data.__material.__set_texture(_font_cache.__get_texture());
        _font_data.__material.__sdf        = font_get_sdf_enabled(_asset);
        _font_data.__material.__sdf_spread = 2*_spread;
        
        //Set the bilinear filtering state for the font after we set other properties
        _font_data.__set_bilinear(undefined);
        
        _font_original_name_dict[$ _asset_name] = _font_data;
        
        //Used to detect if the font is krutidev or not
        _font_data.__filename = _filename;
        
        //Link the font data and font cache together
        _font_cache.__font_data = _font_data;
        _font_data.__font_add_cache = _font_cache;
        
        var _is_krutidev = __scribble_asset_is_krutidev(_asset, asset_font);
        if (_is_krutidev) _font_data.__is_krutidev = true;
        
        //Pre-emptively fill in data grid so we have to do less work later
        var _font_glyph_data_grid = _font_data.__glyph_data_grid;
        ds_grid_set_region(_font_glyph_data_grid, 0, __SCRIBBLE_GLYPH.__CHARACTER,  _size-1, __SCRIBBLE_GLYPH.__CHARACTER,  ""                    );
        ds_grid_set_region(_font_glyph_data_grid, 0, __SCRIBBLE_GLYPH.__MATERIAL,   _size-1, __SCRIBBLE_GLYPH.__MATERIAL,   _name                 );
        ds_grid_set_region(_font_glyph_data_grid, 0, __SCRIBBLE_GLYPH.__BIDI,       _size-1, __SCRIBBLE_GLYPH.__BIDI,       __SCRIBBLE_BIDI.SYMBOL);
        
        //Set up the space character in index 0 which is necessary for other bits of Scribble to work
        _font_cache.__set_space_glyph();
        
        _font_data.__calculate_font_height();
        
        //Prefetch as much of our initial range as possible
        if (SCRIBBLE_FETCH_RANGE_ON_ADD) scribble_font_fetch(_name, _glyph_array);
    }
    catch(_error)
    {
        __scribble_trace(_error);
        __scribble_error("There was an error whilst reading \"", _filename, "\"\nPlease ensure that the font file exists before using font_add()\nIf this issue persists, please report it");
    }
    
	// We return the font ID provided by font_add()
    return _asset;
}