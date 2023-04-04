/// Creates a new font with an outline based on a given source font
///
/// @param sourceFontName       Name, as a string, of the font to use as a basis for the effect
/// @param newFontName          Name of the new font to create, as a string
/// @param offsetThickness      a
/// @param offsetSamples        a
/// @param shadowDX             a
/// @param shadowDY             a
/// @param smooth               Set to <true> to turn on linear interpolation
/// @param [surfaceSize=2048]   Size of the surface to use. Defaults to 2048x2048

function scribble_font_bake_effects(_source_font_name, _new_font_name, _outline_thickness, _outline_samples, _shadow_dx, _shadow_dy, _smooth, _texture_size = 2048)
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

    static _font_data_map = __scribble_get_state().__font_data_map;
    var _src_font_data = _font_data_map[? _source_font_name];
    if (!is_struct(_src_font_data))
    {
        __scribble_error("Source font \"", _source_font_name, "\" not found\n\"", _new_font_name, "\" will not be available");
        return undefined;
    }
    
    if (_src_font_data.__sdf)
    {
    	__scribble_error("Source font cannot be an SDF font");
    	return undefined;
    }
    
    var _border     = 2;
    var _l_pad      = _outline_thickness + max(0, -_shadow_dx);
    var _t_pad      = _outline_thickness + max(0, -_shadow_dy);
    var _r_pad      = _outline_thickness + max(0,  _shadow_dx); 
    var _b_pad      = _outline_thickness + max(0,  _shadow_dy);
    var _separation = _outline_thickness;
    
    
    
    var _src_glyph_grid = _src_font_data.__glyph_data_grid;
    var _glyph_count = ds_grid_width(_src_glyph_grid);
    
    //Create a new font
    var _new_font_data = new __scribble_class_font(_new_font_name, _new_font_name, _glyph_count, false);
    _new_font_data.__runtime = true;
    var _new_glyphs_grid = _new_font_data.__glyph_data_grid;
    
    //Copy the raw data over from the source font (this include the glyph map, glyph grid, and other assorted properties)
    _src_font_data.__copy_to(_new_font_data, false);
    
    //Create a vertex buffer for use in this function
    static _vertex_format = undefined;
    if (_vertex_format == undefined)
    {
        vertex_format_begin();
        vertex_format_add_position(); //12 bytes
        vertex_format_add_color();    // 4 bytes
        vertex_format_add_texcoord(); // 8 bytes
        _vertex_format = vertex_format_end();
    }
    
    //We spin up vertex buffers on demand based on what textures are being used
    var _vbuff_data_map = ds_map_create();
    
    var _line_x      = 0;
    var _line_y      = 0;
    var _line_height = 0;
    
    var _i = 0;
    repeat(_glyph_count)
    {
        var _texture = _src_glyph_grid[# _i, __SCRIBBLE_GLYPH.__TEXTURE];
        var _width   = _src_glyph_grid[# _i, __SCRIBBLE_GLYPH.__WIDTH  ];
        var _height  = _src_glyph_grid[# _i, __SCRIBBLE_GLYPH.__HEIGHT ];
        var _u0      = _src_glyph_grid[# _i, __SCRIBBLE_GLYPH.__U0     ];
        var _v0      = _src_glyph_grid[# _i, __SCRIBBLE_GLYPH.__V0     ];
        var _u1      = _src_glyph_grid[# _i, __SCRIBBLE_GLYPH.__U1     ];
        var _v1      = _src_glyph_grid[# _i, __SCRIBBLE_GLYPH.__V1     ];
        
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
        
        //Base glyph
        vertex_position(_vbuff, _l, _t); vertex_color(_vbuff, c_red, 1.0); vertex_texcoord(_vbuff, _u0, _v0);
        vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_red, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
        vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_red, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
        
        vertex_position(_vbuff, _r, _t); vertex_color(_vbuff, c_red, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
        vertex_position(_vbuff, _r, _b); vertex_color(_vbuff, c_red, 1.0); vertex_texcoord(_vbuff, _u1, _v1);
        vertex_position(_vbuff, _l, _b); vertex_color(_vbuff, c_red, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
        
        //Outline
        if (_outline_thickness > 0)
        {
            var _angle = 90;
            repeat(_outline_samples)
            {
                var _dx =  dcos(_angle);
                var _dy = -dsin(_angle);
                
                var _lo = _l;
                var _to = _t;
                var _ro = _r;
                var _bo = _b;
                
                repeat(_outline_thickness)
                {
                    _lo += _dx;
                    _to += _dy;
                    _ro += _dx;
                    _bo += _dy;
                    
                    vertex_position(_vbuff, _lo, _to); vertex_color(_vbuff, c_lime, 1.0); vertex_texcoord(_vbuff, _u0, _v0);
                    vertex_position(_vbuff, _ro, _to); vertex_color(_vbuff, c_lime, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
                    vertex_position(_vbuff, _lo, _bo); vertex_color(_vbuff, c_lime, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
                    
                    vertex_position(_vbuff, _ro, _to); vertex_color(_vbuff, c_lime, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
                    vertex_position(_vbuff, _ro, _bo); vertex_color(_vbuff, c_lime, 1.0); vertex_texcoord(_vbuff, _u1, _v1);
                    vertex_position(_vbuff, _lo, _bo); vertex_color(_vbuff, c_lime, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
                    
                    //Shadow
                    if ((_shadow_dx != 0) || (_shadow_dy != 0))
                    {
                        var _ls = _lo + _shadow_dx;
                        var _ts = _to + _shadow_dy;
                        var _rs = _ro + _shadow_dx;
                        var _bs = _bo + _shadow_dy;
                        
                        vertex_position(_vbuff, _ls, _ts); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u0, _v0);
                        vertex_position(_vbuff, _rs, _ts); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
                        vertex_position(_vbuff, _ls, _bs); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
                        
                        vertex_position(_vbuff, _rs, _ts); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
                        vertex_position(_vbuff, _rs, _bs); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u1, _v1);
                        vertex_position(_vbuff, _ls, _bs); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
                    }
                }
                
                _angle += 360 / _outline_samples;
            }
        }
        else
        {
            //Shadow
            if ((_shadow_dx != 0) || (_shadow_dy != 0))
            {
                var _ls = _l + _shadow_dx;
                var _ts = _t + _shadow_dy;
                var _rs = _r + _shadow_dx;
                var _bs = _b + _shadow_dy;
                
                vertex_position(_vbuff, _ls, _ts); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u0, _v0);
                vertex_position(_vbuff, _rs, _ts); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
                vertex_position(_vbuff, _ls, _bs); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
                
                vertex_position(_vbuff, _rs, _ts); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u1, _v0);
                vertex_position(_vbuff, _rs, _bs); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u1, _v1);
                vertex_position(_vbuff, _ls, _bs); vertex_color(_vbuff, c_blue, 1.0); vertex_texcoord(_vbuff, _u0, _v1);
            }
        }
            
        _new_glyphs_grid[# _i, __SCRIBBLE_GLYPH.__U0] = _line_x;
        _new_glyphs_grid[# _i, __SCRIBBLE_GLYPH.__V0] = _line_y;
        _new_glyphs_grid[# _i, __SCRIBBLE_GLYPH.__U1] = _line_x + _width  + _l_pad + _r_pad;;
        _new_glyphs_grid[# _i, __SCRIBBLE_GLYPH.__V1] = _line_y + _height + _t_pad + _b_pad;;
        
        _line_x += _width_ext;
        _line_height = max(_line_height, _height_ext);
        
        ++_i;
    }
    
    //Draw the vertex buffers to a surface, then bake that surface into a sprite
    var _surface = surface_create(_texture_size, _texture_size);
    
    //Draw the source glyphs to a surface
    surface_set_target(_surface);
    draw_clear_alpha(c_black, 0.0);
    
    var _old_filter = gpu_get_tex_filter();
    gpu_set_tex_filter(_smooth);
    gpu_set_blendmode_ext(bm_one, bm_one);
    shader_set(__shd_scribble_bake_effects);
    
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
    
    gpu_set_tex_filter(_old_filter);
    gpu_set_blendmode(bm_normal);
    shader_reset();
    surface_reset_target();
    
    //Make a sprite from the surface to make the texture stick
    var _sprite = sprite_create_from_surface(_surface, 0, 0, _texture_size, _texture_size, false, false, 0, 0);
    _new_font_data.__source_sprite = _sprite;
    surface_free(_surface);
    
    //Make bulk corrections to various glyph properties based on the input parameters
    ds_grid_add_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__X_OFFSET,    _glyph_count-1, __SCRIBBLE_GLYPH.__X_OFFSET,    -_l_pad);
    ds_grid_add_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__Y_OFFSET,    _glyph_count-1, __SCRIBBLE_GLYPH.__Y_OFFSET,    -_t_pad);
    ds_grid_add_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__WIDTH,       _glyph_count-1, __SCRIBBLE_GLYPH.__WIDTH,       _l_pad + _r_pad);
    ds_grid_add_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__HEIGHT,      _glyph_count-1, __SCRIBBLE_GLYPH.__HEIGHT,      _t_pad + _b_pad);
    ds_grid_add_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__FONT_HEIGHT, _glyph_count-1, __SCRIBBLE_GLYPH.__FONT_HEIGHT, _t_pad + _b_pad);
    ds_grid_add_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__SEPARATION,  _glyph_count-1, __SCRIBBLE_GLYPH.__SEPARATION,  _separation);
    ds_grid_set_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__TEXTURE,     _glyph_count-1, __SCRIBBLE_GLYPH.__TEXTURE,     sprite_get_texture(_sprite, 0));
    ds_grid_set_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__BILINEAR,    _glyph_count-1, __SCRIBBLE_GLYPH.__BILINEAR,    _smooth);
    
    //Figure out the new UVs using some bulk commands
    var _sprite_uvs = sprite_get_uvs(_sprite, 0);
    var _sprite_u0 = _sprite_uvs[0];
    var _sprite_v0 = _sprite_uvs[1];
    var _sprite_u1 = _sprite_uvs[2];
    var _sprite_v1 = _sprite_uvs[3];
    
    ds_grid_multiply_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__U0, _glyph_count-1, __SCRIBBLE_GLYPH.__V1, 1/_texture_size);
    ds_grid_multiply_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__U0, _glyph_count-1, __SCRIBBLE_GLYPH.__U1, _sprite_u1 - _sprite_u0); //Note we're adjusting U0 and U1 in the same pass
    ds_grid_multiply_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__V0, _glyph_count-1, __SCRIBBLE_GLYPH.__V1, _sprite_v1 - _sprite_v0); //Note we're adjusting V0 and V1 in the same pass
    ds_grid_add_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__U0, _glyph_count-1, __SCRIBBLE_GLYPH.__U1, _sprite_u0); //Note we're adjusting U0 and U1 in the same pass
    ds_grid_add_region(_new_glyphs_grid, 0, __SCRIBBLE_GLYPH.__V0, _glyph_count-1, __SCRIBBLE_GLYPH.__V1, _sprite_v0); //Note we're adjusting V0 and V1 in the same pass
}
