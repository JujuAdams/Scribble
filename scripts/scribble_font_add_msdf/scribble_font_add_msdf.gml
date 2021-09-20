/// Adds a MSDF font definition for Scribble
///
/// As of September 14th 2020, Scribble only accepts MSDF fonts that have been made with the following tool:
/// https://github.com/donmccurdy/msdf-bmfont-web
/// https://msdf-bmfont.donmccurdy.com/
/// A valid branch of this tool can be found here:
/// https://github.com/donmccurdy/msdf-bmfont-web
///
/// @param fontName     String name of the font to add
/// @param sprite       Source sprite to use as the glyph texture atlas
/// @param jsonName     Path to the JSON file that contains glyph data, relative to Scribble's root directory in Included Files

function scribble_font_add_msdf(_font, _sprite, _json_name)
{
    //Ensure we're initialised
    __scribble_init();
    
    if (ds_map_exists(global.__scribble_font_data, _font))
    {
        if (SCRIBBLE_WARNING_REDEFINITION)
        {
            __scribble_error("Font \"", _font, "\" has already been defined\n\n(Set SCRIBBLE_WARNING_REDEFINITION to <false> to turn off this error)");
        }
        else
        {
            __scribble_trace("Warning! Font \"", _font, "\" has already been defined");
        }
        
        return undefined;
    }
    
    if (global.__scribble_default_font == undefined)
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Setting default font to \"" + string(_font) + "\"");
        global.__scribble_default_font = _font;
    }
    
    var _font_data = new __scribble_class_font(_font, "msdf");
    
    if (SCRIBBLE_VERBOSE) show_debug_message( "Scribble: Defined \"" + _font + "\" as an MSDF font" );
    
    var _sprite_width  = sprite_get_width(_sprite);
    var _sprite_height = sprite_get_height(_sprite);
    var _sprite_uvs    = sprite_get_uvs(_sprite, 0);
    var _texture       = sprite_get_texture(_sprite, 0);
    
    var _json_buffer = buffer_load(global.__scribble_font_directory + _json_name);
    var _json_string = buffer_read(_json_buffer, buffer_text);
    buffer_delete(_json_buffer);
    var _json = json_decode(_json_string);
    
    var _metrics_map     = _json[? "metrics"];
    var _json_glyph_list = _json[? "glyphs" ];
    var _atlas_map       = _json[? "atlas"  ];
    
    var _em_size    = _atlas_map[? "size"         ];
    var _msdf_range = _atlas_map[? "distanceRange"];
    
    var _json_line_height = _em_size*_metrics_map[? "lineHeight"];
    
    _font_data.msdf_range = _msdf_range;
    
    var _size = ds_list_size(_json_glyph_list);
    if (SCRIBBLE_VERBOSE) __scribble_trace("\"" + _font + "\" has " + string(_size) + " characters");
    
    var _font_glyphs_map = ds_map_create();
    _font_data.glyphs_map = _font_glyphs_map;
    
    var _i = 0;
    repeat(_size)
    {
        var _json_glyph_map = _json_glyph_list[| _i];
        var _plane_map = _json_glyph_map[? "planeBounds"];
        var _atlas_map = _json_glyph_map[? "atlasBounds"];
        
        var _index = _json_glyph_map[? "unicode"];
        var _char  = chr(_index);
        
        if (__SCRIBBLE_DEBUG) show_debug_message("Scribble:     Adding data for character \"" + string(_char) + "\" (" + string(_index) + ")");
        
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
            var _xadvance = round(_em_size*_json_glyph_map[? "advance"]); //_w - _msdf_range - round(_em_size*_plane_map[? "left"]);
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
        
        _font_glyphs_map[? _index] = _array;
        
        ++_i;
    }
    
    //Now handle the space character
    var _array = _font_glyphs_map[? 32];
    if (_array == undefined)
    {
        __scribble_error("Space character not found in character string for MSDF font \"", _font, "\"");
    }
    else
    {
        _array[@ SCRIBBLE_GLYPH.WIDTH ] = _array[SCRIBBLE_GLYPH.SEPARATION];
        _array[@ SCRIBBLE_GLYPH.HEIGHT] = _json_line_height;
    }
    
    ds_map_destroy(_json);
}