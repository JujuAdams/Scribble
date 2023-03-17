/// @param fontAsset
/// @param fontName
/// @param glyphArray
/// @param spread

function __scribble_class_font_add_cache(_font, _font_name, _glyph_array, _spread) constructor
{
    static __scribble_state = __scribble_get_state();
    
    array_push(__scribble_state.__font_add_cache_array, weak_ref_create(self));
    
    __font      = _font;
    __font_name = _font_name;
    
    __in_use      = true;
    __surface     = undefined;
    __shift_dict  = {};
    __offset_dict = {};
    
    __model_array = [];
    
    //These get copied over from the font in __scribble_font_add_from_file()
    __font_data = undefined;
    
    var _cell_width  = 1;
    var _cell_height = 1;
    
    var _font_info = font_get_info(__font);
    var _info_glyphs_dict = _font_info.glyphs;
    
    //Cache the shift and offset values for faster access later
    var _info_glyphs_array = variable_struct_get_names(_info_glyphs_dict);
    var _i = 0;
    repeat(array_length(_info_glyphs_array))
    {
        var _glyph = _info_glyphs_array[_i];
        var _glyph_data = _info_glyphs_dict[$ _glyph];
        
        if (_glyph_data != undefined)
        {
             __shift_dict[$ _glyph] = _glyph_data.shift;
            __offset_dict[$ _glyph] = _glyph_data.offset;
        }
        
        ++_i;
    }
    
    //Determine the grid we'll use to store glyphs
    var _i = 0;
    repeat(array_length(_glyph_array))
    {
        var _unicode = _glyph_array[_i];
        
        var _glyph_dict = _info_glyphs_dict[$ chr(_unicode)];
        if (_glyph_dict != undefined)
        {
            _cell_width  = max(_cell_width,  _glyph_dict.w);
            _cell_height = max(_cell_height, _glyph_dict.h);
        }
        
        ++_i
    }
    
    __cell_width  = 2*(_spread + SCRIBBLE_INTERNAL_FONT_ADD_MARGIN) + _cell_width;
    __cell_height = 2*(_spread + SCRIBBLE_INTERNAL_FONT_ADD_MARGIN) + _cell_height;
    
    __cells_x    = max(1, floor(SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE / __cell_width ));
    __cells_y    = max(1, floor(SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE / __cell_height));
    __cell_count = __cells_x*__cells_y;
    
    __scribble_trace("Cache initialized for font \"", __font_name, "\"");
    __scribble_trace("|-- cell = ", __cell_width, " x ", __cell_height);
    __scribble_trace("|-- grid = ", __cells_x, " x ", __cells_y);
    __scribble_trace("\\-- max glyphs = ", __cell_count);
    
    __tick();
    
    
    
    static __get_texture = function()
    {
        return surface_get_texture(__surface);
    }
    
    static __get_max_glyph_count = function()
    {
        return __cells_x*__cells_y;
    }
    
    static __add_model = function(_new_model)
    {
        var _i = 0;
        repeat(array_length(__model_array))
        {
            var _found_model = __model_array[_i];
            if (!weak_ref_alive(_found_model))
            {
                array_delete(__model_array, _i, 1);
            }
            else
            {
                if (_found_model.ref == _new_model)
                {
                    //Model already registered as in use
                    return;
                }
                
                ++_i;
            }
        }
        
        array_push(__model_array, weak_ref_create(_new_model));
    }
    
    static __set_space_glyph = function()
    {
        var _font_glyph_grid = __font_data.__glyph_data_grid;
        var _font_glyph_map  = __font_data.__glyphs_map;
        
        var _old_font = draw_get_font();
        draw_set_font(__font);
        var _height = string_height(" ");
        draw_set_font(_old_font);
        
        _font_glyph_map[? 32] = 0;
        
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__CHARACTER  ] = " ";
        
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__UNICODE    ] = 0x20;
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__BIDI       ] = __SCRIBBLE_BIDI.WHITESPACE;
        
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__X_OFFSET   ] = 0;
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__Y_OFFSET   ] = 0;
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__WIDTH      ] = __shift_dict[$ " "];
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__HEIGHT     ] = _height;
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__FONT_HEIGHT] = _height;
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__SEPARATION ] = __shift_dict[$ " "];
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__LEFT_OFFSET] = 0;
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__FONT_SCALE ] = 1;
        
        //Set on create (or reset when regenerating the surface)
        //_font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__TEXTURE] = _texture;
        
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__U0] = 0;
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__V0] = 0;
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__U1] = 0;
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__V1] = 0;
        
        //These are set on create, or are modified elsewhere
        //_font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__SDF_PXRANGE         ] = undefined;
        //_font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__SDF_THICKNESS_OFFSET] = undefined;
        //_font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__BILINEAR            ] = undefined;
        
        _font_glyph_grid[# 0, __SCRIBBLE_GLYPH.__LAST_USED] = infinity; //Never replace space
    }
    
    static __fetch_unknown = function(_unicode, _current_model)
    {
        //Ignore non-printable characters
        if (_unicode <= 32) return;
        
        var _character = chr(_unicode);
        var _shift  =  __shift_dict[$ _character];
        var _offset = __offset_dict[$ _character];
        
        if ((_shift == undefined) || (_offset == undefined))
        {
            __scribble_trace("Warning! ", __scribble_unicode_u(_unicode), " (", _unicode, ") not supported by font \"", __font_name, "\"");
            return;
        }
        
        
        
        //TODO - Invalidating on every new character seems undesirable
        __invalidate(_current_model);
        
        
        
        //Sort out the link between the look-up map and the glyph grid
        var _font_glyph_grid = __font_data.__glyph_data_grid;
        var _font_glyph_map  = __font_data.__glyphs_map;
        
        //Find the minimum "last used" value i.e. the glyph that was generated the longest time ago
        var _min = ds_grid_get_min(_font_glyph_grid, 0, __SCRIBBLE_GLYPH.__LAST_USED, ds_grid_width(_font_glyph_grid), __SCRIBBLE_GLYPH.__LAST_USED);
        //Use the minimum value to find the index we want to replace
        var _index = ds_grid_value_x(_font_glyph_grid, 0, __SCRIBBLE_GLYPH.__LAST_USED, ds_grid_width(_font_glyph_grid), __SCRIBBLE_GLYPH.__LAST_USED, _min);
        
        //Remove the old glyph from our map
        var _old_unicode = _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__UNICODE];
        ds_map_delete(_font_glyph_map, _old_unicode);
        
        //And set up our new glyph
        _font_glyph_map[? _unicode] = _index;
        
        
        
        //Update the surface
        var _x = __cell_width  * (_index mod __cells_x);
        var _y = __cell_height * (_index div __cells_x);
        
        var _old_colour = draw_get_colour();
        var _old_alpha  = draw_get_alpha();
        var _old_font   = draw_get_font();
        var _old_halign = draw_get_halign();
        var _old_valign = draw_get_valign();
        
        draw_set_colour(c_white);
        draw_set_alpha( 0      );
        draw_set_font(  __font );
        draw_set_halign(fa_left);
        draw_set_valign(fa_top );
        
        //Grab the glyph width/height before we reset the font
        var _w = string_width( _character) + 2*SCRIBBLE_INTERNAL_FONT_ADD_MARGIN - _offset;
        var _h = string_height(_character) + 2*SCRIBBLE_INTERNAL_FONT_ADD_MARGIN;
        
        shader_set(__shd_scribble_passthrough);
        gpu_set_blendmode_ext(bm_one, bm_zero);
        gpu_set_colorwriteenable(false, false, false, true);
        
        surface_set_target(__surface);
        
        //Clear out the existing glyph
        draw_rectangle(_x, _y, _x + __cell_width, _y + __cell_height, false);
        draw_set_alpha(1);
        
        draw_text(_x + SCRIBBLE_INTERNAL_FONT_ADD_MARGIN - _offset, _y + SCRIBBLE_INTERNAL_FONT_ADD_MARGIN, _character);
        surface_reset_target();
        
        draw_set_colour(_old_colour);
        draw_set_alpha( _old_alpha );
        draw_set_font(  _old_font  );
        draw_set_halign(_old_halign);
        draw_set_valign(_old_valign);
        
        shader_reset();
        gpu_set_blendmode(bm_normal);
        gpu_set_colorwriteenable(true, true, true, true);
        
        
        
        //Now push the glyph data into the grid ready for use
        var _u0 = _x/SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE;
        var _v0 = _y/SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE;
        var _u1 = _u0 + _w/SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE;
        var _v1 = _v0 + _h/SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE;
        
        var _bidi = __scribble_unicode_get_bidi(_unicode);
        if (__font_data.__is_krutidev)
        {
            __SCRIBBLE_KRUTIDEV_HACK
        }
        
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__CHARACTER  ] = _character;
        
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__UNICODE    ] = _unicode;
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__BIDI       ] = _bidi;
        
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__X_OFFSET   ] = -SCRIBBLE_INTERNAL_FONT_ADD_MARGIN + _offset;
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__Y_OFFSET   ] = -SCRIBBLE_INTERNAL_FONT_ADD_MARGIN;
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__WIDTH      ] = _w;
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__HEIGHT     ] = _h;
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__FONT_HEIGHT] = _h;
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__SEPARATION ] = _shift;
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__LEFT_OFFSET] = -_offset;
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__FONT_SCALE ] = 1;
        
        //Set on create (or reset when regenerating the surface)
        //_font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__TEXTURE] = _texture;
        
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__U0] = _u0;
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__U1] = _u1;
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__V0] = _v0;
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__V1] = _v1;
        
        //These are set on create, or are modified elsewhere
        //_font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__SDF_PXRANGE         ] = undefined;
        //_font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__SDF_THICKNESS_OFFSET] = undefined;
        //_font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__BILINEAR            ] = undefined;
        
        _font_glyph_grid[# _index, __SCRIBBLE_GLYPH.__LAST_USED] = __scribble_state.__frames;
        
        return _index;
    }
    
    static __destroy = function()
    {
        if (__in_use)
        {
            __in_use = false;
            
            __scribble_trace("Destroying font_add() cache (size=", SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE, ")");
            
            __invalidate();
            
            if (__surface != undefined)
            {
                surface_free(__surface);
                __surface = undefined;
            }
        }
    }
    
    static __draw_debug = function(_left, _top, _right, _bottom)
    {
        draw_rectangle(_left, _top, _right, _bottom, true);
        
        if (__in_use)
        {
            draw_primitive_begin_texture(pr_trianglestrip, surface_get_texture(__surface));
            draw_vertex_texture(_left,  _top,    0, 0);
            draw_vertex_texture(_left,  _bottom, 0, 1);
            draw_vertex_texture(_right, _top,    1, 0);
            draw_vertex_texture(_right, _bottom, 1, 1);
            draw_primitive_end();
        }
        else
        {
            draw_line(_left, _top, _right, _bottom);
            draw_line(_right, _top, _left, _bottom);
        }
    }
    
    static __invalidate = function(_current_model)
    {
        //Flush all models that use this font cache
        var _i = 0;
        repeat(array_length(__model_array))
        {
            var _weak_ref = __model_array[_i];
            if (!weak_ref_alive(_weak_ref))
            {
                array_delete(__model_array, _i, 1);
            }
            else
            {
                if (_weak_ref.ref != _current_model) _weak_ref.ref.__flush();
                ++_i;
            }
        }
    }
    
    static __rebuild_surface = function()
    {
        if (__surface != undefined)
        {
            var _font_glyph_map  = __font_data.__glyphs_map;
            ds_map_clear(_font_glyph_map);
            __set_space_glyph();
            __invalidate();
        }
        
        if ((__surface == undefined) || !surface_exists(__surface)) __surface = surface_create(SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE, SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE);
        
        surface_set_target(__surface);
        draw_clear_alpha(c_white, 0);
        surface_reset_target();
    }
    
    static __tick = function()
    {
        if (__in_use && ((__surface == undefined) || !surface_exists(__surface))) __rebuild_surface();
    }
}