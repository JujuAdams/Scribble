/// Adds a normal font for use with Scribble
///
/// @param fontName   Name of the font to add, as a string
/// @param [yyPath]   File path for the font's .yy file, including the .yy extension, relative to the font directory defined by scribble_init()
///                   If not specified, Scribble will look in the root of the font directory
/// @param [texture]  Texture to use for this font e.g. returned by sprite_get_texture()
///
/// Scribble requires that you explicitly initialise fonts for use with Scribble. This is a three-step process:
/// 
///  1. Add a normal GameMaker font resource through the IDE
///  2. Click the Regenerate button in font dialogue inside the GameMaker IDE, then add the font's .yy file as an Included File (found in the
///     font's folder in the project directory)
///  3. Call scribble_add_font() targeting the font
/// 
/// Scribble needs to access information that GameMaker generates. All this information is contained in a single .yy file in the font's folder
/// on disk inside the project directory. This file can sometimes be frustrating to locate, but fortunately there's a shortcut we can take.
/// In the IDE, Navigate to the font resource you wish to add and right click on it. From the drop-down menu, select "Show In Explorer". A
/// window will open showing various files for the font resource. You can drag-and-drop the .yy file into the GameMaker IDE to add it as an
/// Included File.

function scribble_font_add()
{
    var _name    = argument[0];
    var _path    = (argument_count > 1)? argument[1] : undefined;
    var _texture = (argument_count > 2)? argument[2] : undefined;
    
    //Ensure we're initialised
    __scribble_init();
    
    if (ds_map_exists(global.__scribble_font_data, _name))
    {
        if (SCRIBBLE_WARNING_REDEFINITION)
        {
            __scribble_error("Font \"", _name, "\" has already been defined\n\n(Set SCRIBBLE_WARNING_REDEFINITION to <false> to turn off this error)");
        }
        else
        {
            __scribble_trace("Warning! Font \"", _name, "\" has already been defined");
        }
        
        return undefined;
    }
    
    if (!is_string(_name))
    {
        if (is_real(_name) && (asset_get_type(font_get_name(_name)) == asset_font))
        {
            __scribble_error("Fonts should be initialised using their name as a string.\n(Input was \"", _name, "\", which might be font \"", font_get_name(_name), "\")");
        }
        else
        {
            __scribble_error("Fonts should be initialised using their name as a string.\n(Input was an invalid datatype)");
        }
        exit;
    }
    
    if (asset_get_type(_name) == asset_sprite)
    {
        __scribble_error("To add a spritefont, please use scribble_font_add_from_sprite()");
        return scribble_font_add_from_sprite(_name);
    }
    
    if (asset_get_type(_name) != asset_font)
    {
        __scribble_error("Font \"", _name, "\" not found in the project.\nScribble font \"", _name, "\" will not be available");
        return undefined;
    }
    
    if (_path == undefined) _path = _name + ".yy";
    _path = global.__scribble_font_directory + _path;
    
    if (!file_exists(_path))
    {
        __scribble_error("Could not find \"", _path, "\" in Included Files. Please add this file to your project.\nScribble font \"", _name, "\" will not be available");
        return undefined;
    }
    
    
    
    if (global.__scribble_default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_name) + "\"");
        global.__scribble_default_font = _name;
    }
    
    
    var _font_data = new __scribble_class_font(_name, "standard");
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Processing font \"" + _name + "\"");

    if (_texture == undefined)
    {
        if (!is_string(_name))
        {
            __scribble_error("<character> argument is the wrong datatype (", typeof(_name), "), expected a string");
            return undefined;
        }
    
        if (asset_get_type(_name) == asset_sprite)
        {
            __scribble_error("Asset \"", _name, "\" is a sprite\n \nPlease use scribble_font_add_spritefont() instead");
            return undefined;
        }
    
        if (asset_get_type(_name) != asset_font)
        {
            __scribble_error("Could not find font asset \"", _name, "\" in the project");
            return undefined;
        }
        
        if (!file_exists(_path))
        {
            if (global.__scribble_autoscanning)
            {
                if (SCRIBBLE_WARNING_AUTOSCAN_YY_NOT_FOUND)
                {
                    __scribble_error("Could not find \"", _path, "\" in Included Files\nSet SCRIBBLE_WARNING_AUTOSCAN_MISSING_YY to <false> to ignore this warning");
                    return undefined;
                }
                else
                {
                    __scribble_trace("WARNING! Could not find \"", _path, "\" in Included Files");
                }
                
                return undefined;
            }
            else
            {
                __scribble_error("Could not find \"", _path, "\" in Included Files");
                return undefined;
            }
        }
        
        var _asset       = asset_get_index(_name);
        var _texture     = font_get_texture(_asset);
        var _texture_uvs = font_get_uvs(_asset);
    }
    else
    {
        var _texture_uvs = texture_get_uvs(_texture);
    }

    var _texture_tw = texture_get_texel_width(_texture);
    var _texture_th = texture_get_texel_height(_texture);
    var _texture_w  = (_texture_uvs[2] - _texture_uvs[0])/_texture_tw; //texture_get_width(_texture);
    var _texture_h  = (_texture_uvs[3] - _texture_uvs[1])/_texture_th; //texture_get_height(_texture);

    if (SCRIBBLE_VERBOSE)
    {
        __scribble_trace("  \"" + _name +"\""
                         + ", asset = " + string(_asset)
                         + ", texture = " + string(_texture)
                         + ", size = " + string(_texture_w) + " x " + string(_texture_h)
                         + ", texel = " + string_format(_texture_tw, 1, 10) + " x " + string_format(_texture_th, 1, 10)
                         + ", uvs = " + string_format(_texture_uvs[0], 1, 10) + "," + string_format(_texture_uvs[1], 1, 10)
                         + " -> " + string_format(_texture_uvs[2], 1, 10) + "," + string_format(_texture_uvs[3], 1, 10));
    }

    var _json_buffer = buffer_load(_path);
    var _json_string = buffer_read(_json_buffer, buffer_text);
    buffer_delete(_json_buffer);
    var _json = json_decode(_json_string);

    var _fail = false;
    //Check to see if the JSON was successfully decoded
    if (_json < 0)
    {
        __scribble_error("Failed to decode JSON for \"", _path, "\"");
        _fail = true;
    }

    //Additional check to verify we have glyph data
    if (!ds_map_exists(_json, "glyphs"))
    {
        __scribble_error("Failed to find \"glyphs\" key for \"", _path, "\"");
        _fail = true;
    }

    //If either of the checks have failed, delete the data array and abort
    if (_fail)
    {
        if (__SCRIBBLE_DEBUG) __scribble_trace("JSON string that failed is \"", _json_string, "\"");
        ds_map_delete(global.__scribble_font_data, _name);
        exit;
    }
    
    //Now parse the JSON for glyph data!
    if (ds_map_exists(_json, "mvc"))
    {
        //Version 2.2.5 and before
        var _yy_glyphs_list = _json[? "glyphs"];
    }
    else
    {
        //Version 2.3.0
        //We rebuild the new 2.3.0 JSON structure to match 2.2.5 for the sake of keeping things simple
        var _yy_glyphs_map = _json[? "glyphs"];
        ds_map_delete(_json, "glyphs");
    
        var _yy_glyphs_list = ds_list_create();
        ds_map_add_list(_json, "glyphs", _yy_glyphs_list);
    
        var _key = ds_map_find_first(_yy_glyphs_map);
        repeat(ds_map_size(_yy_glyphs_map))
        {
            var _new_map = ds_map_create();
            ds_list_add(_yy_glyphs_list, _new_map);
            ds_list_mark_as_map(_yy_glyphs_list, ds_list_size(_yy_glyphs_list)-1);
        
            _new_map[? "Key"] = real(_key);
            ds_map_add_map(_new_map, "Value", _yy_glyphs_map[? _key]);
            _yy_glyphs_map[? _key] = undefined;
        
            _key = ds_map_find_next(_yy_glyphs_map, _key);
        }
    
        ds_map_destroy(_yy_glyphs_map);
    }

    var _size = ds_list_size(_yy_glyphs_list);
    if (SCRIBBLE_VERBOSE) __scribble_trace("  \"" + _name + "\" has " + string(_size) + " characters");



    var _ds_map_fallback = true;

    if (__SCRIBBLE_SEQUENTIAL_GLYPH_TRY)
    {
        #region Sequential glyph index
    
        if (SCRIBBLE_VERBOSE) __scribble_trace("  Trying sequential glyph index...");
    
        var _glyph_map = ds_map_create();
    
        var _yy_glyph_map = _yy_glyphs_list[| 0];
            _yy_glyph_map = _yy_glyph_map[? "Value"];
    
        var _glyph_min = _yy_glyph_map[? "character"];
        var _glyph_max = _glyph_min;
        _glyph_map[? _glyph_min ] = 0;
     
        for(var _i = 1; _i < _size; _i++)
        {
            var _yy_glyph_map = _yy_glyphs_list[| _i];
                _yy_glyph_map = _yy_glyph_map[? "Value"];
            var _index = _yy_glyph_map[? "character"];
        
            _glyph_map[? _index] = _i;
            _glyph_min = min(_glyph_min, _index);
            _glyph_max = max(_glyph_max, _index);
        }
        
        _font_data.glyph_min = _glyph_min;
        _font_data.glyph_max = _glyph_max;
        
        var _glyph_count = 1 + _glyph_max - _glyph_min;
        if (SCRIBBLE_VERBOSE) __scribble_trace("  Glyphs start at " + string(_glyph_min) + " and end at " + string(_glyph_max) + ". Range is " + string(_glyph_count-1));
    
        if ((_glyph_count-1) > __SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE)
        {
            if (SCRIBBLE_VERBOSE) __scribble_trace("  Glyph range exceeds maximum (" + string(__SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE) + ")!");
        }
        else
        {
            var _holes = 0;
            for(var _i = _glyph_min; _i <= _glyph_max; _i++) if (!ds_map_exists(_glyph_map, _i)) _holes++;
            ds_map_destroy(_glyph_map);
            var _fraction = _holes / _glyph_count;
        
            if (SCRIBBLE_VERBOSE) __scribble_trace("  There are " + string(_holes) + " holes, " + string(_fraction*100) + "%");
        
            if (_fraction > __SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES)
            {
                if (SCRIBBLE_VERBOSE) __scribble_trace("  Hole proportion exceeds maximum (" + string(__SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES*100) + "%)!");
            }
            else
            {
                if (SCRIBBLE_VERBOSE) __scribble_trace("  Using an array to index glyphs");
                _ds_map_fallback = false;
            
                var _font_glyphs_array = array_create(_glyph_count, undefined);
                _font_data.glyphs_array = _font_glyphs_array;
                
                var _i = 0;
                repeat(_size)
                {
                    var _yy_glyph_map = _yy_glyphs_list[| _i];
                        _yy_glyph_map = _yy_glyph_map[? "Value"];
                
                    var _index = _yy_glyph_map[? "character"];
                    var _char  = chr(_index);
                    var _x     = _yy_glyph_map[? "x"];
                    var _y     = _yy_glyph_map[? "y"];
                    var _w     = _yy_glyph_map[? "w"];
                    var _h     = _yy_glyph_map[? "h"];
                
                    var _u0    = _x*_texture_tw + _texture_uvs[0];
                    var _v0    = _y*_texture_th + _texture_uvs[1];
                    var _u1    = _u0 + _w * _texture_tw;
                    var _v1    = _v0 + _h * _texture_th;
                
                    var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
                    _array[@ SCRIBBLE_GLYPH.CHARACTER ] = _char;
                    _array[@ SCRIBBLE_GLYPH.INDEX     ] = _index;
                    _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _w;
                    _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _h;
                    _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _yy_glyph_map[? "offset"];
                    _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
                    _array[@ SCRIBBLE_GLYPH.SEPARATION] = _yy_glyph_map[? "shift"];
                    _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _texture;
                    _array[@ SCRIBBLE_GLYPH.U0        ] = _u0;
                    _array[@ SCRIBBLE_GLYPH.V0        ] = _v0;
                    _array[@ SCRIBBLE_GLYPH.U1        ] = _u1;
                    _array[@ SCRIBBLE_GLYPH.V1        ] = _v1;
                
                    _font_glyphs_array[@ _index - _glyph_min] = _array;
                    
                    ++_i;
                }
            }
        }
    
        #endregion
    }

    if (_ds_map_fallback)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("  Using a ds_map to index glyphs");
        
        var _font_glyphs_map = ds_map_create();
        _font_data.glyphs_map = _font_glyphs_map;
        
        var _i = 0;
        repeat(_size)
        {
            var _yy_glyph_map = _yy_glyphs_list[| _i];
                _yy_glyph_map = _yy_glyph_map[? "Value"];
            
            var _index = _yy_glyph_map[? "character"];
            var _char  = chr(_index);
            var _x     = _yy_glyph_map[? "x"];
            var _y     = _yy_glyph_map[? "y"];
            var _w     = _yy_glyph_map[? "w"];
            var _h     = _yy_glyph_map[? "h"];
            
            var _u0    = _x*_texture_tw + _texture_uvs[0];
            var _v0    = _y*_texture_th + _texture_uvs[1];
            var _u1    = _u0 + _w*_texture_tw;
            var _v1    = _v0 + _h*_texture_th;
            
            var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
            _array[@ SCRIBBLE_GLYPH.CHARACTER ] = _char;
            _array[@ SCRIBBLE_GLYPH.INDEX     ] = _index;
            _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _w;
            _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _h;
            _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _yy_glyph_map[? "offset"];
            _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
            _array[@ SCRIBBLE_GLYPH.SEPARATION] = _yy_glyph_map[? "shift"];
            _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _texture;
            _array[@ SCRIBBLE_GLYPH.U0        ] = _u0;
            _array[@ SCRIBBLE_GLYPH.V0        ] = _v0;
            _array[@ SCRIBBLE_GLYPH.U1        ] = _u1;
            _array[@ SCRIBBLE_GLYPH.V1        ] = _v1;
            
            _font_glyphs_map[? ord(_char)] = _array;
            
            ++_i;
        }
    }

    ds_map_destroy(_json);

    if (SCRIBBLE_VERBOSE) __scribble_trace("Added \"" + _name + "\" as a standard font");
}