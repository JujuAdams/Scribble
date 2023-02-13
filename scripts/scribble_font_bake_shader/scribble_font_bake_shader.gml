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

    static _font_data_map = __scribble_get_font_data_map();
    var _src_font_data = _font_data_map[? _source_font_name];
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
    _new_font_data.__runtime = true;
    var _new_glyphs_grid = _new_font_data.__glyph_data_grid;
    
    //Copy the raw data over from the source font (this include the glyph map, glyph grid, and other assorted properties)
    _src_font_data.__copy_to(_new_font_data, false);
    
    
    
    //We spin up vertex buffers on demand based on what textures are being used
    var _vbuff_data_map = ds_map_create();
    
    var _line_x      = 0;
    var _line_y      = 0;
    var _line_height = 0;
    
    var _i = 0;
    repeat(_glyph_count)
    {
        var _texture = _src_glyph_grid[# _i, SCRIBBLE_GLYPH.TEXTURE];
        var _width   = _src_glyph_grid[# _i, SCRIBBLE_GLYPH.WIDTH  ];
        var _height  = _src_glyph_grid[# _i, SCRIBBLE_GLYPH.HEIGHT ];
        var _u0      = _src_glyph_grid[# _i, SCRIBBLE_GLYPH.U0     ];
        var _v0      = _src_glyph_grid[# _i, SCRIBBLE_GLYPH.V0     ];
        var _u1      = _src_glyph_grid[# _i, SCRIBBLE_GLYPH.U1     ];
        var _v1      = _src_glyph_grid[# _i, SCRIBBLE_GLYPH.V1     ];
        
        //Ignore any glyphs with invalid textures
        //Due to HTML5 being dogshit, we can't use is_ptr()
        if (is_numeric(_texture) || is_undefined(_texture))
        {
            ++_i;
            continue;
        }
        
        var _width_ext  = _width  + _border + _l_pad + _r_pad;
        var _height_ext = _height + _border + _t_pad + _b_pad;
        
        //Check to see if we have space on this texture page
        if (_line_y + _height_ext >= _texture_size)
        {
            __scribble_error("No space left on ", _texture_size, "x", _texture_size, " texture page\nPlease increase the size of the texture page");
            vertex_end(_vbuff);
            vertex_delete_buffer(_vbuff);
            return;
        }
        
        //Line wrap glyphs
        if (_line_x + _width_ext >= _texture_size)
        {
            _line_x       = 0;
            _line_y      += _line_height;
            _line_height  = 0;
        }
        
        //Find a vertex buffer for this particular glyph's texture
        var _vbuff_data = _vbuff_data_map[? string(_texture)];
        if (_vbuff_data == undefined)
        {
            static _vertex_format = undefined;
            if (_vertex_format == undefined)
            {
                vertex_format_begin();
                vertex_format_add_position(); //12 bytes
                vertex_format_add_color();    // 4 bytes
                vertex_format_add_texcoord(); // 8 bytes
                _vertex_format = vertex_format_end();
            }
            
            //If we don't have a vertex buffer for this texture, create a new one and store a reference to it
            var _vbuff = vertex_create_buffer();
            vertex_begin(_vbuff, _vertex_format);
            
            _vbuff_data_map[? string(_texture)] = {
                __vertex_buffer: _vbuff,
                __texture: _texture,
            };
        }
        else
        {
            var _vbuff = _vbuff_data.__vertex_buffer;
        }
        
        var _l = _l_pad + _line_x;
        var _t = _t_pad + _line_y;
        var _r = _l + _width;
        var _b = _t + _height;
        
        vertex_position(_vbuff, _l, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v0);
        vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
        vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
        
        vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
        vertex_position(_vbuff, _r, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u1, _v1);
        vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_white, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
            
        _new_glyphs_grid[# _i, SCRIBBLE_GLYPH.U0] = _line_x;
        _new_glyphs_grid[# _i, SCRIBBLE_GLYPH.V0] = _line_y;
        _new_glyphs_grid[# _i, SCRIBBLE_GLYPH.U1] = _line_x + _width  + _l_pad + _r_pad;;
        _new_glyphs_grid[# _i, SCRIBBLE_GLYPH.V1] = _line_y + _height + _t_pad + _b_pad;;
        
        _line_x += _width_ext;
        _line_height = max(_line_height, _height_ext);
        
        ++_i;
    }
    
    //Draw the vertex buffers to a surface, then bake that surface into a sprite
    var _surface_0 = surface_create(_texture_size, _texture_size);
    
    //Draw the source glyphs to a surface
    surface_set_target(_surface_0);
    draw_clear_alpha(c_white, 0.0);
    gpu_set_blendenable(false);
    
    //Iterate over all vertex buffers we created and draw those vertex buffers to the first surface
    var _vbuff_data_array = ds_map_values_to_array(_vbuff_data_map);
    var _i = 0;
    repeat(array_length(_vbuff_data_array))
    {
        var _vbuff_data = _vbuff_data_array[_i];
        var _vbuff = _vbuff_data.__vertex_buffer;
        
        vertex_end(_vbuff);
        vertex_submit(_vbuff, pr_trianglelist, _vbuff_data.__texture);
        vertex_delete_buffer(_vbuff);
        
        ++_i;
    }
    
    ds_map_destroy(_vbuff_data_map);
    var _surface_1 = surface_create(_texture_size, _texture_size);
    
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
    
    surface_free(_surface_0);
    
    //Make a sprite from the effect surface to make the texture stick
    var _sprite = sprite_create_from_surface(_surface_1, 0, 0, _texture_size, _texture_size, false, false, 0, 0);
    _new_font_data.__source_sprite = _sprite;
    surface_free(_surface_1);
    
    
    
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
