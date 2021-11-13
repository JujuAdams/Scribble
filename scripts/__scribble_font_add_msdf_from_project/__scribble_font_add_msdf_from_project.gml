function __scribble_font_add_msdf_from_project(_sprite)
{
    var _name = sprite_get_name(_sprite);
    
    if (ds_map_exists(global.__scribble_font_data, _name))
    {
        __scribble_error("Font \"", _name, "\" has already been defined");
        return undefined;
    }
    
    if (global.__scribble_default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_name) + "\"");
        global.__scribble_default_font = _name;
    }
    
    var _global_glyph_bidi_map = global.__scribble_glyph_data.bidi_map;
    
    var _font_data = new __scribble_class_font(_name);
    _font_data.msdf = true;
    var _font_glyphs_map = _font_data.glyphs_map;
    
    if (SCRIBBLE_VERBOSE) __scribble_trace("Defined \"" + _name + "\" as an MSDF font");
    
    var _sprite_width  = sprite_get_width(_sprite);
    var _sprite_height = sprite_get_height(_sprite);
    var _sprite_uvs    = sprite_get_uvs(_sprite, 0);
    var _texture       = sprite_get_texture(_sprite, 0);
    
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
    
    _font_data.msdf_pxrange = _msdf_pxrange;
    
    var _size = ds_list_size(_json_glyph_list);
    if (SCRIBBLE_VERBOSE) __scribble_trace("\"" + _name + "\" has " + string(_size) + " characters");
    
    var _i = 0;
    repeat(_size)
    {
        var _json_glyph_map = _json_glyph_list[| _i];
        var _plane_map = _json_glyph_map[? "planeBounds"];
        var _atlas_map = _json_glyph_map[? "atlasBounds"];
        
        var _index = _json_glyph_map[? "unicode"];
        var _char  = chr(_index);
        
        if (__SCRIBBLE_DEBUG) __scribble_trace("     Adding data for character \"" + string(_char) + "\" (" + string(_index) + ")");
        
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
        
        var _bidi = _global_glyph_bidi_map[? _index];
        if (_bidi == undefined) _bidi = __SCRIBBLE_BIDI.L2R;
        
        var _array = array_create(SCRIBBLE_GLYPH.__SIZE, undefined);
        _array[@ SCRIBBLE_GLYPH.CHARACTER ] = _char;
        _array[@ SCRIBBLE_GLYPH.INDEX     ] = _index;
        _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _w;
        _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _h;
        _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _xoffset;
        _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = _yoffset;
        _array[@ SCRIBBLE_GLYPH.SEPARATION] = _xadvance;
        _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _texture;
        _array[@ SCRIBBLE_GLYPH.U0        ] = _u0;
        _array[@ SCRIBBLE_GLYPH.V0        ] = _v0;
        _array[@ SCRIBBLE_GLYPH.U1        ] = _u1;
        _array[@ SCRIBBLE_GLYPH.V1        ] = _v1;
        _array[@ SCRIBBLE_GLYPH.BIDI      ] = _bidi;
        
        _font_glyphs_map[? _index] = _array;
        
        ++_i;
    }
    
    //Now handle the space character
    var _array = _font_glyphs_map[? 32];
    if (_array == undefined)
    {
        __scribble_error("Space character not found in character string for MSDF font \"", _name, "\"");
    }
    else
    {
        _array[@ SCRIBBLE_GLYPH.WIDTH ] = _array[SCRIBBLE_GLYPH.SEPARATION];
        _array[@ SCRIBBLE_GLYPH.HEIGHT] = _json_line_height;
    }
    
    ds_map_destroy(_json);
    
    _font_data.calculate_font_height();
}