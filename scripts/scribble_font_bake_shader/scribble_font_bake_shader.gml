/// Creates a new font with an outline based on a given source font
///
/// @param sourceFontName       Name, as a string, of the font to use as a basis for the effect
/// @param newFontName          Name of the new font to create, as a string
/// @param shader               Shader to use
/// @param emptyBorderSize      Border around the outside of every output glyph, in pixels. A value of 2 is typical
/// @param leftPad              Padding around the outside of every *input* glyph. Positive values give more space. e.g. For a shader that adds a border of 2px around the entire glyph, *all* padding arguments should be set to <2>
/// @param topPad               "
/// @param rightPad             "
/// @param bottomPad            "
/// @param separationDelta      Change in every glyph's SCRIBBLE_GLYPH.SEPARATION value. For a shader that adds a border of 2px around the entire glyph, this value should be 4px
/// @param smooth               Set to <true> to turn on linear interpolation
/// @param [surfaceSize=2048]   Size of the surface to use. Defaults to 2048x2048

function scribble_font_bake_shader(_source_font_name, _new_font_name, _shader, _border, _l_pad, _t_pad, _r_pad, _b_pad, _separation, _smooth, _texture_size = 2048)
{
    if (!is_string(_source_font_name))
    {
        __scribble_error("Fonts should be specified using their name as a string.\n(Input was an invalid datatype)");
        exit;
    }
    
    if (!is_string(_new_font_name))
    {
        __scribble_error("Fonts should be specified using their name as a string.\n(Input was an invalid datatype)");
        exit;
    }
    
    if (_source_font_name == _new_font_name)
    {
        __scribble_error("Source font and new font cannot share the same name");
        return undefined;
    }

    var _src_font_data = global.__scribble_font_data[? _source_font_name];
    if (!is_struct(_src_font_data))
    {
        __scribble_error("Source font \"", _source_font_name, "\" not found\n\"", _new_font_name, "\" will not be available");
        return undefined;
    }
    
    if ((_src_font_data.type == "msdf") || (_src_font_data.type == "runtime msdf"))
    {
    	__scribble_error("Source font cannot be an MSDF font");
    	return undefined;
    }
    
    
    //Unpack source glyphs into an intermediate array
    var _src_glyphs_map = _src_font_data.glyphs_map;
    if (_src_glyphs_map != undefined)
    {
        var _uses_glyph_map = true;
        var _src_glyphs_array = array_create(ds_map_size(_src_glyphs_map));
    
        var _i = 0;
        var _key = ds_map_find_first(_src_glyphs_map);
        repeat(ds_map_size(_src_glyphs_map))
        {
            _src_glyphs_array[@ _i] = _src_glyphs_map[? _key];
            ++_i;
            _key = ds_map_find_next(_src_glyphs_map, _key);
        }
    }
    else
    {
        var _uses_glyph_map = false;
        var _src_glyphs_array = _src_font_data.glyphs_array;
    }



    //Build a priority queue, wide assets first
    var _priority_queue = ds_priority_create();
    var _i = 0;
    repeat(array_length(_src_glyphs_array))
    {
        var _glyph_array = _src_glyphs_array[_i];
        if (_glyph_array != undefined)
        {
            var _character   = _glyph_array[SCRIBBLE_GLYPH.CHARACTER];
            if (_character != " ")
            {
                var _width      = _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
                var _height     = _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
                var _width_ext  = _width  + _border + _l_pad + _r_pad;
                var _height_ext = _height + _border + _t_pad + _b_pad;
        
                var _priority = _width_ext*_texture_size + _height_ext;
                ds_priority_add(_priority_queue, _i, _priority);
                //__scribble_trace("Queuing \"" + _character + "\" (" + string(_i) + ") for packing (size=" + string(_width_ext) + "x" + string(_height_ext) + ", weight=" + string(_priority) + ")");
            }
        }
    
        ++_i;
    }



    //Pack glyphs on the texture page
    //__scribble_trace("" + string(ds_priority_size(_priority_queue)) + " glyphs to pack");

    var _surface_glyphs = [];
    var _added_count = 0;
    while(!ds_priority_empty(_priority_queue))
    {
        var _index       = ds_priority_delete_max(_priority_queue);
        var _glyph_array = _src_glyphs_array[_index];
        var _character   = _glyph_array[SCRIBBLE_GLYPH.CHARACTER];
        var _width       = _glyph_array[SCRIBBLE_GLYPH.WIDTH    ];
        var _height      = _glyph_array[SCRIBBLE_GLYPH.HEIGHT   ];
        var _width_ext   = _width  + _border + _l_pad + _r_pad;
        var _height_ext  = _height + _border + _t_pad + _b_pad;
    
        //__scribble_trace("Packing \"" + _character + "\" (" + string(_index) + "), size=" + string(_width_ext) + "," + string(_height_ext));
    
        if (_added_count == 0)
        {
            var _found = true;
        
            var _l = _border;
            var _t = _border;
            var _r = _l + _width_ext  - 1;
            var _b = _t + _height_ext - 1;
        }
        else
        {
            var _found = false;
        
            //Scan to the right of each glyph to try to find a free spot
            if (!_found)
            {
                for( var _j = 0; _j < _added_count; _j++ )
                {
                    var _target_array = _surface_glyphs[_j];
                    var _l = _target_array[2] + 1;
                    var _t = _target_array[1];
                    var _r = _l + _width_ext  - 1;
                    var _b = _t + _height_ext - 1;
                
                    if ((_r < _texture_size) && (_b < _texture_size))
                    {
                        _found = true;
                        //__scribble_trace("   Trying to the right of \"" + string(_target_array[5]) + "\"");
                    
                        for( var _k = 0; _k < _added_count; _k++ )
                        {
                            var _check_array = _surface_glyphs[_k];
                            var _check_l = _check_array[0];
                            var _check_t = _check_array[1];
                            var _check_r = _check_array[2];
                            var _check_b = _check_array[3];
                        
                            if ((_l <= _check_r) && (_r >= _check_l) && (_t <= _check_b) && (_b >= _check_t))
                            {
                                _found = false;
                                break;
                            }
                        }
                    
                        if (_found) break;
                    }
                }
            }
        
            //If we've not found a free space yet, try scanning underneath each font texture
            if (!_found)
            {
                for( var _j = 0; _j < _added_count; _j++ )
                {
                    var _target_array = _surface_glyphs[_j];
                    var _l = _target_array[0];
                    var _t = _target_array[3] + 1;
                    var _r = _l + _width_ext  - 1;
                    var _b = _t + _height_ext - 1;
                
                    if ((_r < _texture_size) && (_b < _texture_size))
                    {
                        _found = true;
                        //__scribble_trace("   Trying beneath \"" + string(_target_array[5]) + "\"");
                    
                        for(var _k = 0; _k < _added_count; _k++)
                        {
                            var _check_array = _surface_glyphs[_k];
                            var _check_l = _check_array[0];
                            var _check_t = _check_array[1];
                            var _check_r = _check_array[2];
                            var _check_b = _check_array[3];
                        
                            if ((_l <= _check_r) && (_r >= _check_l) && (_t <= _check_b) && (_b >= _check_t))
                            {
                                _found = false;
                                break;
                            }
                        }
                    
                        if (_found) break;
                    }
                }
            }
        }
    
        if (_found)
        {
            _surface_glyphs[@ _added_count] = [_l, _t, _r, _b, _index, _character];
            //__scribble_trace("   " + string(_l) + "," + string(_t) + " -> " + string(_r) + "," + string(_b));
            ++_added_count;
        }
        else
        {
            break;
        }
    }

    ds_priority_destroy(_priority_queue);



    if (!_found)
    {
        __scribble_error("No space left on ", _texture_size, "x", _texture_size, " texture page\nPlease increase the size of the texture page");
    }
    else
    {
        //Build a vertex buffer for all the glyphs
        var _vbuff = vertex_create_buffer();
        vertex_begin(_vbuff, global.__scribble_passthrough_vertex_format);
    
        var _i = 0;
        repeat(array_length(_surface_glyphs))
        {
            var _glyph_position = _surface_glyphs[_i];
            var _index = _glyph_position[4];
            var _glyph_array = _src_glyphs_array[_index];
        
            var _l  = _glyph_position[0] + _l_pad; //Offset by the L,T padding
            var _t  = _glyph_position[1] + _t_pad;
            var _r  = _l + _glyph_array[SCRIBBLE_GLYPH.WIDTH ];
            var _b  = _t + _glyph_array[SCRIBBLE_GLYPH.HEIGHT];
            var _u0 = _glyph_array[SCRIBBLE_GLYPH.U0];
            var _v0 = _glyph_array[SCRIBBLE_GLYPH.V0];
            var _u1 = _glyph_array[SCRIBBLE_GLYPH.U1];
            var _v1 = _glyph_array[SCRIBBLE_GLYPH.V1];
        
            vertex_position(_vbuff, _l, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v0);
            vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
            vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
        
            vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
            vertex_position(_vbuff, _r, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v1);
            vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
        
            ++_i;
        }
    
        vertex_end(_vbuff);
    
    
    
        var _texture = _glyph_array[SCRIBBLE_GLYPH.TEXTURE]; //TODO
        var _surface_0 = surface_create(_texture_size, _texture_size);
        var _surface_1 = surface_create(_texture_size, _texture_size);
    
        //Draw the source glyphs to a surface
        surface_set_target(_surface_0);
        draw_clear_alpha(c_white, 0.0);
        gpu_set_blendenable(false);
        vertex_submit(_vbuff, pr_trianglelist, _texture);
        gpu_set_blendenable(true);
        surface_reset_target();
    
        var _texture = surface_get_texture(_surface_0);
    
        //Draw one surface to another using the shader
        surface_set_target(_surface_1);
        draw_clear_alpha(c_white, 0.0);
    
        var _old_filter = gpu_get_tex_filter();
        gpu_set_tex_filter(_smooth);
        gpu_set_blendenable(false);
    
        shader_set(_shader);
        shader_set_uniform_f(shader_get_uniform(_shader, "u_vTexel"), texture_get_texel_width(_texture), texture_get_texel_height(_texture));
        draw_surface(_surface_0, 0, 0);
        shader_reset();
    
        gpu_set_tex_filter(_old_filter);
        gpu_set_blendenable(true);
        surface_reset_target();
    
        //Make a sprite from the effect surface to make the texture stick
        var _sprite = sprite_create_from_surface(_surface_1, 0, 0, _texture_size, _texture_size, false, false, 0, 0);
        surface_free(_surface_0);
        surface_free(_surface_1);
        vertex_delete_buffer(_vbuff);
    
    
    
        //Build a new font definition
        var _texture = sprite_get_texture(_sprite, 0);
        var _sprite_uvs = sprite_get_uvs(_sprite, 0);
        var _sprite_u0 = _sprite_uvs[0];
        var _sprite_v0 = _sprite_uvs[1];
        var _sprite_u1 = _sprite_uvs[2];
        var _sprite_v1 = _sprite_uvs[3];
    
        var _new_font_data = new __scribble_class_font(_new_font_name, "runtime");
        _src_font_data.copy_to(_new_font_data);
        _new_font_data.path              = undefined;
        _new_font_data.glyphs_array      = undefined;
        _new_font_data.glyphs_map        = undefined;
        _new_font_data.style_regular     = undefined;
        _new_font_data.style_bold        = undefined;
        _new_font_data.style_italic      = undefined;
        _new_font_data.style_bold_italic = undefined;
        
        //Initialise our glyph data structure, copying what the source font used
        if (_uses_glyph_map)
        {
            var _new_glyph_map = ds_map_create();
            _new_font_data.glyphs_map = _new_glyph_map;
        
            var _array = array_create(SCRIBBLE_GLYPH.__SIZE);
            array_copy(_array, 0, _src_glyphs_map[? 32], 0, SCRIBBLE_GLYPH.__SIZE);
            _new_glyph_map[? 32] = _array;
        }
        else
        {
            var _glyph_min = _new_font_data.glyph_min;
            var _glyph_max = _new_font_data.glyph_max;
            
            var _new_glyph_array = array_create(1 + _glyph_max - _glyph_min, undefined);
            _new_font_data.glyphs_array = _new_glyph_array;
            
            var _array = array_create(SCRIBBLE_GLYPH.__SIZE);
            array_copy(_array, 0, _src_glyphs_array[32 - _glyph_min], 0, SCRIBBLE_GLYPH.__SIZE);
            _new_glyph_array[@ 32 - _glyph_min] = _array;
        }
        
        //Copy across glyph data from the source, but using new UVs and dimensions
        var _i = 0;
        repeat(array_length(_surface_glyphs))
        {
            var _glyph_position = _surface_glyphs[_i];
            
            var _index = _glyph_position[4];
            var _src_glyph_array = _src_glyphs_array[_index];
            
            if (!is_array(_src_glyph_array))
            {
                if (_uses_glyph_map)
                {
                    _new_glyph_array[@ _ord - _glyph_min] = undefined;
                }
            }
            else
            {
                var _ord = _src_glyph_array[SCRIBBLE_GLYPH.INDEX];
            
                var _l = _glyph_position[0];
                var _t = _glyph_position[1];
                var _r = _l + _src_glyph_array[SCRIBBLE_GLYPH.WIDTH ] + _l_pad + _r_pad;
                var _b = _t + _src_glyph_array[SCRIBBLE_GLYPH.HEIGHT] + _t_pad + _b_pad;
            
                var _u0 = lerp(_sprite_u0, _sprite_u1, _l / _texture_size);
                var _v0 = lerp(_sprite_v0, _sprite_v1, _t / _texture_size);
                var _u1 = lerp(_sprite_u0, _sprite_u1, _r / _texture_size);
                var _v1 = lerp(_sprite_v0, _sprite_v1, _b / _texture_size);
            
                var _array = array_create(SCRIBBLE_GLYPH.__SIZE, 0);
                _array[@ SCRIBBLE_GLYPH.CHARACTER ] = _src_glyph_array[SCRIBBLE_GLYPH.CHARACTER ];
                _array[@ SCRIBBLE_GLYPH.INDEX     ] = _ord;
                _array[@ SCRIBBLE_GLYPH.WIDTH     ] = _src_glyph_array[SCRIBBLE_GLYPH.WIDTH     ] + _l_pad + _r_pad;
                _array[@ SCRIBBLE_GLYPH.HEIGHT    ] = _src_glyph_array[SCRIBBLE_GLYPH.HEIGHT    ] + _t_pad + _b_pad;
                _array[@ SCRIBBLE_GLYPH.X_OFFSET  ] = _src_glyph_array[SCRIBBLE_GLYPH.X_OFFSET  ] - _l_pad;
                _array[@ SCRIBBLE_GLYPH.Y_OFFSET  ] = _src_glyph_array[SCRIBBLE_GLYPH.Y_OFFSET  ] - _t_pad;
                _array[@ SCRIBBLE_GLYPH.SEPARATION] = _src_glyph_array[SCRIBBLE_GLYPH.SEPARATION] + _separation;
                _array[@ SCRIBBLE_GLYPH.TEXTURE   ] = _texture;
                _array[@ SCRIBBLE_GLYPH.U0        ] = _u0;
                _array[@ SCRIBBLE_GLYPH.V0        ] = _v0;
                _array[@ SCRIBBLE_GLYPH.U1        ] = _u1;
                _array[@ SCRIBBLE_GLYPH.V1        ] = _v1;
            
                if (_uses_glyph_map)
                {
                    _new_glyph_map[? _ord] = _array;
                }
                else
                {
                    _new_glyph_array[@ _ord - _glyph_min] = _array;
                }
            }
        
            ++_i;
        }
    }
}