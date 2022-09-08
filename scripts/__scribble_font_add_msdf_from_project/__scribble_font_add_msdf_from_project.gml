function __scribble_font_add_msdf_from_project(_sprite)
{
    var _name = sprite_get_name(_sprite);
    
    if (ds_map_exists(global.__scribble_font_data, _name))
    {
        __scribble_trace("Warning! An MSDF font for \"", _name, "\" has already been added. Destroying the old MSDF font and creating a new one");
        global.__scribble_font_data[? _name].__destroy();
    }
    
    if (global.__scribble_default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_name) + "\"");
        global.__scribble_default_font = _name;
    }
    
    var _is_krutidev = __scribble_asset_is_krutidev(_sprite, asset_sprite);
    var _global_glyph_bidi_map = global.__scribble_glyph_data.__bidi_map;
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Defined \"" + _name + "\" as an MSDF font");
    
    var _sprite_width  = sprite_get_width(_sprite);
    var _sprite_height = sprite_get_height(_sprite);
    var _sprite_uvs    = sprite_get_uvs(_sprite, 0);
    var _texture       = sprite_get_texture(_sprite, 0);
    
    //Correct for source sprites having their edges clipped off
    var _texel_w = texture_get_texel_width(_texture);
    var _texel_h = texture_get_texel_height(_texture);
    _sprite_uvs[0] -= _texel_w*_sprite_uvs[4];
    _sprite_uvs[1] -= _texel_h*_sprite_uvs[5];
    _sprite_uvs[2] += _texel_w*_sprite_width*(1 - _sprite_uvs[6]);
    _sprite_uvs[3] += _texel_h*_sprite_height*(1 - _sprite_uvs[7]);
    
    var _json_buffer = buffer_load(global.__scribble_font_directory + _name + ".json");
    
    if (_json_buffer < 0)
    {
        _json_buffer = buffer_load(global.__scribble_font_directory + _name);
    }
    
    if (_json_buffer < 0)
    {
        __scribble_error("Could not find \"", global.__scribble_font_directory + _name + ".json\"\nPlease add it to the project's Included Files");
    }
    
    var _json_string = buffer_read(_json_buffer, buffer_text);
    buffer_delete(_json_buffer);
    var _json = json_decode(_json_string); //TODO - Replace with json_parse()
    
    var _metrics_map     = _json[? "metrics"];
    var _json_glyph_list = _json[? "glyphs" ];
    var _atlas_map       = _json[? "atlas"  ];
    
    var _em_size      = _atlas_map[? "size"         ];
    var _msdf_pxrange = _atlas_map[? "distanceRange"];
    
    var _json_line_height = _em_size*_metrics_map[? "lineHeight"];
    
    var _size = ds_list_size(_json_glyph_list);
    if (SCRIBBLE_VERBOSE) __scribble_trace("\"" + _name + "\" has " + string(_size) + " characters");
    
    var _font_data = new __scribble_class_font(_name, _size, true);
    _font_data.__runtime = true;
    
    var _font_glyphs_map      = _font_data.__glyphs_map;
    var _font_glyph_data_grid = _font_data.__glyph_data_grid;
    if (_is_krutidev) _font_data.__is_krutidev = true;
    _font_data.__msdf_pxrange = _msdf_pxrange;
    
    var _i = 0;
    repeat(_size)
    {
        var _json_glyph_map = _json_glyph_list[| _i];
        var _plane_map = _json_glyph_map[? "planeBounds"];
        var _atlas_map = _json_glyph_map[? "atlasBounds"];
        
        var _unicode  = _json_glyph_map[? "unicode"];
        var _char = chr(_unicode);
        
        if (__SCRIBBLE_DEBUG) __scribble_trace("     Adding data for character \"" + string(_char) + "\" (" + string(_unicode) + ")");
        
        if (_atlas_map != undefined)
        {
            var _tex_l = _atlas_map[? "left"] + 1;
            var _tex_t = _sprite_height - _atlas_map[? "top"] + 1; //This atlas format is weird
            var _tex_r = _atlas_map[? "right"] - 1;
            var _tex_b = _sprite_height - _atlas_map[? "bottom"] - 1;
        }
        else
        {
            var _tex_l = 0;
            var _tex_t = 0;
            var _tex_r = 0;
            var _tex_b = 0;
        }
        
        var _w = _tex_r - _tex_l;
        var _h = _tex_b - _tex_t;
        
        if (_plane_map != undefined)
        {
            var _xoffset  = _em_size*_plane_map[? "left"];
            var _yoffset  = _em_size - _em_size*_plane_map[? "top"]; //So, so weird
            var _xadvance = round(_em_size*_json_glyph_map[? "advance"]); //_w - _msdf_pxrange - round(_em_size*_plane_map[? "left"]);
        }
        else
        {
            var _xoffset  = 0;
            var _yoffset  = 0;
            var _xadvance = round(_em_size*_json_glyph_map[? "advance"]);
        }
        
        if (SCRIBBLE_MSDF_BORDER_TRIM > 0)
        {
            _tex_l += SCRIBBLE_MSDF_BORDER_TRIM;
            _tex_t += SCRIBBLE_MSDF_BORDER_TRIM;
            _tex_r -= SCRIBBLE_MSDF_BORDER_TRIM;
            _tex_b -= SCRIBBLE_MSDF_BORDER_TRIM;
            
            _w -= 2*SCRIBBLE_MSDF_BORDER_TRIM;
            _h -= 2*SCRIBBLE_MSDF_BORDER_TRIM;
            
            _xoffset += SCRIBBLE_MSDF_BORDER_TRIM;
            _yoffset += SCRIBBLE_MSDF_BORDER_TRIM;
        }
        
        //if (_xoffset < 0) __scribble_trace("char = ", _char, ", offset = ", _xoffset);
        
        if (__SCRIBBLE_DEBUG)
        {
            __scribble_trace(_char, "    ", _w, " x ", _h, ", advance=", _xadvance, ", dy=", _yoffset, ", diff=", _w - _xadvance);
            if (_plane_map != undefined)
            {
                __scribble_trace(_char, "    ", round(_em_size*(_plane_map[? "right"] - _plane_map[? "left"])));
                __scribble_trace(_char, "    ", _xadvance);
            }
        }
        
        var _u0 = lerp(_sprite_uvs[0], _sprite_uvs[2], _tex_l/_sprite_width );
        var _v0 = lerp(_sprite_uvs[1], _sprite_uvs[3], _tex_t/_sprite_height);
        var _u1 = lerp(_sprite_uvs[0], _sprite_uvs[2], _tex_r/_sprite_width );
        var _v1 = lerp(_sprite_uvs[1], _sprite_uvs[3], _tex_b/_sprite_height);
        
        if ((_unicode >= 0x3000) && (_unicode <= 0x303F)) //CJK Symbols and Punctuation
        {
            var _bidi = __SCRIBBLE_BIDI.SYMBOL;
        }
        else if ((_unicode >= 0x3040) && (_unicode <= 0x30FF)) //Hiragana and Katakana
        {
            var _bidi = __SCRIBBLE_BIDI.ISOLATED_CJK;
        }
        else if ((_unicode >= 0x4E00) && (_unicode <= 0x9FFF)) //CJK Unified ideographs block
        {
            var _bidi = __SCRIBBLE_BIDI.ISOLATED_CJK;
        }
        else if ((_unicode >= 0xFF00) && (_unicode <= 0xFF0F)) //Fullwidth symbols
        {
            var _bidi = __SCRIBBLE_BIDI.SYMBOL;
        }
        else if ((_unicode >= 0xFF1A) && (_unicode <= 0xFF1F)) //More fullwidth symbols
        {
            var _bidi = __SCRIBBLE_BIDI.SYMBOL;
        }
        else if ((_unicode >= 0xFF5B) && (_unicode <= 0xFF64)) //Yet more fullwidth symbols
        {
            var _bidi = __SCRIBBLE_BIDI.SYMBOL;
        }
        else
        {
            var _bidi = _global_glyph_bidi_map[? _unicode];
            if (_bidi == undefined) _bidi = __SCRIBBLE_BIDI.L2R;
        }
        
        if (_is_krutidev)
        {
            if (_bidi != __SCRIBBLE_BIDI.WHITESPACE)
            {
                _bidi = __SCRIBBLE_BIDI.L2R_DEVANAGARI;
                _unicode += __SCRIBBLE_DEVANAGARI_OFFSET;
            }
        }
        
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.CHARACTER   ] = _char;
        
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.UNICODE     ] = _unicode;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BIDI        ] = _bidi;
        
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.X_OFFSET    ] = _xoffset;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.Y_OFFSET    ] = _yoffset;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.WIDTH       ] = _w;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.HEIGHT      ] = _h;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_HEIGHT ] = _json_line_height;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.SEPARATION  ] = _xadvance;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.LEFT_OFFSET ] = 1 - _xoffset - 0.5*_msdf_pxrange;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.FONT_SCALE  ] = 1;
        
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.TEXTURE     ] = _texture;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U0          ] = _u0;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V0          ] = _v0;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.U1          ] = _u1;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.V1          ] = _v1;
        
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.MSDF_PXRANGE] = _msdf_pxrange;
        _font_glyph_data_grid[# _i, SCRIBBLE_GLYPH.BILINEAR    ] = true;
        
        _font_glyphs_map[? _unicode] = _i;
        
        ++_i;
    }
    
    //Now handle the space character
    var _space_index = _font_glyphs_map[? 32];
    if (_space_index == undefined)
    {
        __scribble_error("Space character not found in character string for MSDF font \"", _name, "\"");
    }
    else
    {
        _font_glyph_data_grid[# _space_index, SCRIBBLE_GLYPH.WIDTH ] = _font_glyph_data_grid[# _space_index, SCRIBBLE_GLYPH.SEPARATION];
        _font_glyph_data_grid[# _space_index, SCRIBBLE_GLYPH.HEIGHT] = _json_line_height;
    }
    
    ds_map_destroy(_json);
    
    _font_data.__calculate_font_height();
}