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
    
    if (_src_font_data.__msdf)
    {
    	__scribble_error("Source font cannot be an MSDF font");
    	return undefined;
    }
    
    
    
    var _src_glyph_grid = _src_font_data.__glyph_data_grid;
    var _glyph_count = ds_grid_width(_src_glyph_grid);
    
    //Create a new font
    var _new_font_data = new __scribble_class_font(_new_font_name, _glyph_count, false);
    var _new_glyphs_grid = _new_font_data.__glyph_data_grid;
    
    //Copy the raw data over from the source font (this include the glyph map, glyph grid, and other assorted properties)
    _src_font_data.__copy_to(_new_font_data);
    
    
    
    //Build a priority queue of glyphs, wide assets first
    var _priority_queue = ds_priority_create();
    var _i = 0;
    repeat(_glyph_count)
    {
        var _unicode = _src_glyph_grid[# _i, SCRIBBLE_GLYPH.UNICODE];
        if (_unicode != 32)
        {
            var _width      = _src_glyph_grid[# _i, SCRIBBLE_GLYPH.WIDTH ];
            var _height     = _src_glyph_grid[# _i, SCRIBBLE_GLYPH.HEIGHT];
            var _width_ext  = _width  + _border + _l_pad + _r_pad;
            var _height_ext = _height + _border + _t_pad + _b_pad;
            
            var _priority = _width_ext*_texture_size + _height_ext;
            ds_priority_add(_priority_queue, _i, _priority);
            //__scribble_trace("Queuing \"" + _unicode + "\" (" + string(_i) + ") for packing (size=" + string(_width_ext) + "x" + string(_height_ext) + ", weight=" + string(_priority) + ")");
        }
    
        ++_i;
    }
    
    var _layout_count = ds_priority_size(_priority_queue);
    
    
    
    //Pack glyphs on the texture page
    //__scribble_trace("" + string(ds_priority_size(_priority_queue)) + " glyphs to pack");
    
    var _layout_grid = ds_grid_create(_layout_count, 5);
    var _free_right_list = ds_list_create();
    var _free_bottom_list = ds_list_create();
    var _added_count = 0;
    while(!ds_priority_empty(_priority_queue))
    {
        var _index       = ds_priority_delete_max(_priority_queue);
        var _width       = _src_glyph_grid[# _index, SCRIBBLE_GLYPH.WIDTH ];
        var _height      = _src_glyph_grid[# _index, SCRIBBLE_GLYPH.HEIGHT];
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
                var _j = 0;
                repeat(ds_list_size(_free_right_list))
                {
                    var _adj_index = _free_right_list[| _j];
                    
                    var _l = _layout_grid[# _adj_index, 2] + 1;
                    var _t = _layout_grid[# _adj_index, 1];
                    var _r = _l + _width_ext  - 1;
                    var _b = _t + _height_ext - 1;
                
                    if ((_r < _texture_size) && (_b < _texture_size))
                    {
                        _found = true;
                        //__scribble_trace("   Trying to the right of \"" + string(_target_array[5]) + "\"");
                        
                        var _k = 0;
                        repeat(_added_count) //TODO - Write a faster AABB check
                        {
                            var _check_l = _layout_grid[# _k, 0];
                            var _check_t = _layout_grid[# _k, 1];
                            var _check_r = _layout_grid[# _k, 2];
                            var _check_b = _layout_grid[# _k, 3];
                        
                            if ((_l <= _check_r) && (_r >= _check_l) && (_t <= _check_b) && (_b >= _check_t))
                            {
                                _found = false;
                                break;
                            }
                            
                            ++_k;
                        }
                        
                        if (_found)
                        {
                            ds_list_delete(_free_right_list, _adj_index);
                            break;
                        }
                    }
                    
                    ++_j;
                }
            }
        
            //If we've not found a free space yet, try scanning underneath each font texture
            if (!_found)
            {
                var _j = 0;
                repeat(ds_list_size(_free_bottom_list))
                {
                    var _adj_index = _free_bottom_list[| _j];
                    
                    var _l = _layout_grid[# _j, 0];
                    var _t = _layout_grid[# _j, 3] + 1;
                    var _r = _l + _width_ext  - 1;
                    var _b = _t + _height_ext - 1;
                
                    if ((_r < _texture_size) && (_b < _texture_size))
                    {
                        _found = true;
                        //__scribble_trace("   Trying beneath \"" + string(_target_array[5]) + "\"");
                        
                        var _k = 0;
                        repeat(_added_count) //TODO - Write a faster AABB check
                        {
                            var _check_l = _layout_grid[# _k, 0];
                            var _check_t = _layout_grid[# _k, 1];
                            var _check_r = _layout_grid[# _k, 2];
                            var _check_b = _layout_grid[# _k, 3];
                        
                            if ((_l <= _check_r) && (_r >= _check_l) && (_t <= _check_b) && (_b >= _check_t))
                            {
                                _found = false;
                                break;
                            }
                            
                            ++_k;
                        }
                    
                        if (_found)
                        {
                            ds_list_delete(_free_bottom_list, _adj_index);
                            break;
                        }
                    }
                    
                    ++_j;
                }
            }
        }
    
        if (_found)
        {
            _layout_grid[# _added_count, 0] = _l;
            _layout_grid[# _added_count, 1] = _t;
            _layout_grid[# _added_count, 2] = _r;
            _layout_grid[# _added_count, 3] = _b;
            _layout_grid[# _added_count, 4] = _index;
            
            ds_list_add(_free_right_list, _added_count);
            ds_list_add(_free_bottom_list, _added_count);
            
            _new_glyphs_grid[# _index, SCRIBBLE_GLYPH.U0] = _l;
            _new_glyphs_grid[# _index, SCRIBBLE_GLYPH.V0] = _t;
            _new_glyphs_grid[# _index, SCRIBBLE_GLYPH.U1] = _l + _new_glyphs_grid[# _index, SCRIBBLE_GLYPH.WIDTH ] + _l_pad + _r_pad;;
            _new_glyphs_grid[# _index, SCRIBBLE_GLYPH.V1] = _t + _new_glyphs_grid[# _index, SCRIBBLE_GLYPH.HEIGHT] + _t_pad + _b_pad;;
            
            //__scribble_trace("   " + string(_l) + "," + string(_t) + " -> " + string(_r) + "," + string(_b));
            ++_added_count;
        }
        else
        {
            break;
        }
    }
    
    ds_priority_destroy(_priority_queue);
    ds_list_destroy(_free_right_list);
    ds_list_destroy(_free_bottom_list);
    
    if (!_found)
    {
        __scribble_error("No space left on ", _texture_size, "x", _texture_size, " texture page\nPlease increase the size of the texture page");
        return;
    }
    
    
    
    //Build a vertex buffer for all the glyphs
    var _vbuff = vertex_create_buffer();
    vertex_begin(_vbuff, global.__scribble_passthrough_vertex_format);
    
    var _i = 0;
    repeat(_layout_count)
    {
        var _index = _layout_grid[# _i, 4];
        
        var _l  = _layout_grid[# _i, 0] + _l_pad; //Offset by the L,T padding
        var _t  = _layout_grid[# _i, 1] + _t_pad;
        var _r  = _l + _src_glyph_grid[# _index, SCRIBBLE_GLYPH.WIDTH ];
        var _b  = _t + _src_glyph_grid[# _index, SCRIBBLE_GLYPH.HEIGHT];
        var _u0 = _src_glyph_grid[# _index, SCRIBBLE_GLYPH.U0];
        var _v0 = _src_glyph_grid[# _index, SCRIBBLE_GLYPH.V0];
        var _u1 = _src_glyph_grid[# _index, SCRIBBLE_GLYPH.U1];
        var _v1 = _src_glyph_grid[# _index, SCRIBBLE_GLYPH.V1];
        
        vertex_position(_vbuff, _l, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v0);
        vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
        vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
        
        vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
        vertex_position(_vbuff, _r, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v1);
        vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
        
        ++_i;
    }
    
    vertex_end(_vbuff);
    
    
    
    //Draw the vertex buffer to a surface, then bake that surface into a sprite
    var _texture = _src_glyph_grid[# 0, SCRIBBLE_GLYPH.TEXTURE]; //FIXME - Don't assume every glyph is on the same texture page
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
    
    
    
    //Make bulk corrections to various glyph properties based on the input parameters
    ds_grid_add_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.X_OFFSET,    _glyph_count-1, SCRIBBLE_GLYPH.X_OFFSET,    -_l_pad);
    ds_grid_add_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.Y_OFFSET,    _glyph_count-1, SCRIBBLE_GLYPH.Y_OFFSET,    -_t_pad);
    ds_grid_add_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.WIDTH,       _glyph_count-1, SCRIBBLE_GLYPH.WIDTH,       _l_pad + _r_pad);
    ds_grid_add_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.HEIGHT,      _glyph_count-1, SCRIBBLE_GLYPH.HEIGHT,      _t_pad + _b_pad);
    ds_grid_add_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.FONT_HEIGHT, _glyph_count-1, SCRIBBLE_GLYPH.FONT_HEIGHT, _t_pad + _b_pad);
    ds_grid_add_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.SEPARATION,  _glyph_count-1, SCRIBBLE_GLYPH.SEPARATION,  _separation);
    ds_grid_set_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.TEXTURE,     _glyph_count-1, SCRIBBLE_GLYPH.TEXTURE,     sprite_get_texture(_sprite, 0));
    ds_grid_set_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.BILINEAR,    _glyph_count-1, SCRIBBLE_GLYPH.BILINEAR,    _smooth);
    
    //Figure out the new UVs using some bulk commands
    var _sprite_uvs = sprite_get_uvs(_sprite, 0);
    var _sprite_u0 = _sprite_uvs[0];
    var _sprite_v0 = _sprite_uvs[1];
    var _sprite_u1 = _sprite_uvs[2];
    var _sprite_v1 = _sprite_uvs[3];
    
    ds_grid_multiply_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.U0, _glyph_count-1, SCRIBBLE_GLYPH.V1, 1/_texture_size);
    ds_grid_multiply_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.U0, _glyph_count-1, SCRIBBLE_GLYPH.U1, _sprite_u1 - _sprite_u0); //Note we're adjusting U0 and U1 in the same pass
    ds_grid_multiply_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.V0, _glyph_count-1, SCRIBBLE_GLYPH.V1, _sprite_v1 - _sprite_v0); //Note we're adjusting V0 and V1 in the same pass
    ds_grid_add_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.U0, _glyph_count-1, SCRIBBLE_GLYPH.U1, _sprite_u0); //Note we're adjusting U0 and U1 in the same pass
    ds_grid_add_region(_new_glyphs_grid, 0, SCRIBBLE_GLYPH.V0, _glyph_count-1, SCRIBBLE_GLYPH.V1, _sprite_v0); //Note we're adjusting V0 and V1 in the same pass
}