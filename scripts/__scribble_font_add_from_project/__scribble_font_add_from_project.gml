/// @param font

function __scribble_font_add_from_project(_font)
{
    __scribble_trace("Adding \"", font_get_name(_font), "\"");
    
    var _name = font_get_name(_font);
    
    if (global.__scribble_default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_name) + "\"");
        global.__scribble_default_font = _name;
    }
    
    var _font_data = new __scribble_class_font(_name, "standard");
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Processing font \"" + _name + "\"");
    
    var _asset       = asset_get_index(_name);
    var _texture     = font_get_texture(_asset);
    var _texture_uvs = font_get_uvs(_asset);
    
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
    
    //Get font info from the runtime
    var _font_info = font_get_info(_font);
    var _info_glyphs_dict = _font_info.glyphs;
    
    //
    var _info_glyph_names = variable_struct_get_names(_info_glyphs_dict);
    var _size = array_length(_info_glyph_names);
    if (SCRIBBLE_VERBOSE) __scribble_trace("  \"" + _name + "\" has " + string(_size) + " characters");
    
    //
    var _info_glyphs_array = array_create(array_length(_info_glyph_names));
    var _i = 0;
    repeat(_size)
    {
        var _glyph = _info_glyph_names[_i];
        var _struct = _info_glyphs_dict[$ _glyph];
        _info_glyphs_array[@ _i] = _struct;
        ++_i;
    }
    
    var _ds_map_fallback = true;
    
    if (__SCRIBBLE_SEQUENTIAL_GLYPH_TRY)
    {
        #region Sequential glyph index
        
        if (SCRIBBLE_VERBOSE) __scribble_trace("  Trying sequential glyph index...");
        
        var _glyph_index_min = infinity;
        var _glyph_index_max = 0;
        var _glyph_count     = 0;
        
        var _i = 0;
        repeat(_size)
        {
            var _index = _info_glyphs_array[_i].char;
            _glyph_index_min = min(_glyph_index_min, _index);
            _glyph_index_max = max(_glyph_index_max, _index);
            ++_glyph_count;
            ++_i;
        }
        
        _font_data.glyph_min = _glyph_index_min;
        _font_data.glyph_max = _glyph_index_max;
        
        var _glyph_index_range = 1 + _glyph_index_max - _glyph_index_min;
        if (SCRIBBLE_VERBOSE) __scribble_trace("  Glyphs start at " + string(_glyph_index_min) + " and end at " + string(_glyph_index_max) + ". Range is " + string(_glyph_index_range-1));
    
        if ((_glyph_index_range-1) > __SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE)
        {
            if (SCRIBBLE_VERBOSE) __scribble_trace("  Glyph range exceeds maximum (" + string(__SCRIBBLE_SEQUENTIAL_GLYPH_MAX_RANGE) + ")!");
        }
        else
        {
            var _holes = _glyph_index_range - _glyph_count;
            var _fraction = _holes / _glyph_count;
        
            if (SCRIBBLE_VERBOSE) __scribble_trace("  There are " + string(_holes) + " holes, " + string(_fraction*100) + "%");
        
            if (_fraction > __SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES)
            {
                if (SCRIBBLE_VERBOSE) __scribble_trace("  Hole proportion exceeds maximum (" + string(__SCRIBBLE_SEQUENTIAL_GLYPH_MAX_HOLES*100) + "%)");
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
                    var _glyph_dict = _info_glyphs_array[_i];
                    
                    var _index = _glyph_dict.char;
                    var _char  = chr(_index);
                    var _x     = _glyph_dict.x;
                    var _y     = _glyph_dict.y;
                    var _w     = _glyph_dict.w;
                    var _h     = _glyph_dict.h;
                
                    var _u0    = _x*_texture_tw;
                    var _v0    = _y*_texture_th;
                    var _u1    = _u0 + _w * _texture_tw;
                    var _v1    = _v0 + _h * _texture_th;
                
                    var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
                    _array[@ SCRIBBLE_GLYPH.CHARACTER ] = _char;
                    _array[@ SCRIBBLE_GLYPH.INDEX     ] = _index;
                    _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _w;
                    _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _h;
                    _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _glyph_dict.offset;
                    _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
                    _array[@ SCRIBBLE_GLYPH.SEPARATION] = _glyph_dict.shift;
                    _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _texture;
                    _array[@ SCRIBBLE_GLYPH.U0        ] = _u0;
                    _array[@ SCRIBBLE_GLYPH.V0        ] = _v0;
                    _array[@ SCRIBBLE_GLYPH.U1        ] = _u1;
                    _array[@ SCRIBBLE_GLYPH.V1        ] = _v1;
                
                    _font_glyphs_array[@ _index - _glyph_index_min] = _array;
                    
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
            var _glyph_dict = _info_glyphs_array[_i];
            
            var _index = _glyph_dict.char;
            var _char  = chr(_index);
            var _x     = _glyph_dict.x;
            var _y     = _glyph_dict.y;
            var _w     = _glyph_dict.w;
            var _h     = _glyph_dict.h;
            
            var _u0    = _x*_texture_tw;
            var _v0    = _y*_texture_th;
            var _u1    = _u0 + _w*_texture_tw;
            var _v1    = _v0 + _h*_texture_th;
            
            var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
            _array[@ SCRIBBLE_GLYPH.CHARACTER ] = _char;
            _array[@ SCRIBBLE_GLYPH.INDEX     ] = _index;
            _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _w;
            _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _h;
            _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _glyph_dict.offset;
            _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = 0;
            _array[@ SCRIBBLE_GLYPH.SEPARATION] = _glyph_dict.shift;
            _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _texture;
            _array[@ SCRIBBLE_GLYPH.U0        ] = _u0;
            _array[@ SCRIBBLE_GLYPH.V0        ] = _v0;
            _array[@ SCRIBBLE_GLYPH.U1        ] = _u1;
            _array[@ SCRIBBLE_GLYPH.V1        ] = _v1;
            
            _font_glyphs_map[? ord(_char)] = _array;
            
            ++_i;
        }
    }
}