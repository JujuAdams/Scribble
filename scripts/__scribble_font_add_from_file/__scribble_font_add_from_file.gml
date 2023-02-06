#macro __font_add__  font_add
#macro font_add      __scribble_font_add_from_file



function __scribble_font_add_from_file(_filename, _point_size, _bold, _italic, _first, _last) 
{
    static _font_data_map = __scribble_get_font_data_map();
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Called font_add(\"" + _filename + "\", ", _point_size, ", ", _bold, ", ", _italic, ", ", _first, ", ", _last, ")");
    
    if (font_texture_page_size != SCRIBBLE_GAMEMAKER_FONT_ADD_CACHE_SIZE)
    {
        font_texture_page_size = SCRIBBLE_GAMEMAKER_FONT_ADD_CACHE_SIZE;
        __scribble_trace("Forcing GameMaker's native font_add() texture page size to ", SCRIBBLE_GAMEMAKER_FONT_ADD_CACHE_SIZE);
    }
    
    var _asset = __font_add__(_filename, _point_size, _bold, _italic, _first, _last);
    if (!font_exists(_asset)) __scribble_error("Failed to load \"", _filename, "\"");
    
    //Test code:
    //font_enable_sdf(_asset, true);
    
    var _sdf = font_get_sdf_enabled(_asset);
    
    if (ds_map_exists(_font_data_map, _filename))
    {
        __scribble_trace("Warning! A font for \"", _filename, "\" has already been added. Destroying the old font and creating a new one");
        _font_data_map[? _filename].__destroy();
    }
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Adding \"", _filename, "\" as a font_add() font", (_sdf? " as SDF" : ""));
    
    var _scribble_state = __scribble_get_state();
    if (_scribble_state.__default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_filename) + "\"");
        _scribble_state.__default_font = _filename;
    }
    
    try
    {
        //Create a glyph cache
        var _font_cache = new __scribble_class_font_add_cache(_asset, _first, _last);
        
        //Find out how many glyphs we can store at once
        var _size = _font_cache.__get_max_glyph_count();
        
        //Create a font representation we can use for interaction with other Scribble font functions
        var _font_data = new __scribble_class_font(_filename, _size, font_get_sdf_enabled(_asset));
        
        //Bind the font_add() cache to the font struct
        _font_data.__font_add_cache = _font_cache;
        
        //Finalise the font_add() cache so we have enough information for recaching
        var _font_info = font_get_info(_asset);
        var _info_glyphs_dict = _font_info.glyphs;
        var _space_struct = _info_glyphs_dict[$ " "];
        
        with(_font_cache)
        {
            __glyph_data_grid = _font_data.__glyph_data_grid;
            __glyphs_map      = _font_data.__glyphs_map;
            __space_width     = _space_struct.shift;
            __space_height    = string_height(" ");
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
        
        _font_data.__calculate_font_height();
    }
    catch(_error)
    {
        __scribble_trace(_error);
        __scribble_error("There was an error whilst reading \"", _filename, "\"\nPlease ensure that the font file exists before using font_add()\nIf this issue persists, please report it");
    }
    
	// We return the font ID provided by font_add
	return _asset;
}