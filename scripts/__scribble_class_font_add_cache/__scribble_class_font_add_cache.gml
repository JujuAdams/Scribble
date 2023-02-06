/// @param fontAsset
/// @param minGlyph
/// @param maxGlyph

function __scribble_class_font_add_cache(_font, _min_glyph, _max_glyph) constructor
{
    var _font_add_cache_array = __scribble_get_state().__font_add_cache_array;
    array_push(_font_add_cache_array, weak_ref_create(self));
    
    __in_use  = true;
    __surface = undefined;
    
    __min_glyph = 0;
    __max_glyph = 0;
    
    __cells_x     = 1;
    __cells_y     = 1;
    __cell_width  = SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE;
    __cell_height = SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE;
    
    __map = undefined;
    
    __next_index = 0;
    
    __font = _font;
    
    __model_array = [];
    
    //These get copied over from the font in __scribble_font_add_from_file()
    __glyph_data_grid = undefined;
    __glyphs_map      = undefined;
    __space_width     = 0;
    __space_height    = 0;
    
    __scribble_trace("Creating font_add() cache (size=", SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE, ")");
    
    __min_glyph = _min_glyph;
    __max_glyph = _max_glyph;
    
    var _cell_width  = 1;
    var _cell_height = 1;
    
    var _font_info = font_get_info(__font);
    var _info_glyphs_dict = _font_info.glyphs;
    
    var _unicode = _min_glyph;
    repeat(1 + _max_glyph - _min_glyph)
    {
        var _glyph_dict = _info_glyphs_dict[$ chr(_unicode)];
        if (_glyph_dict != undefined)
        {
            _cell_width  = max(_cell_width,  _glyph_dict.w);
            _cell_height = max(_cell_height, _glyph_dict.h);
        }
         
        ++_unicode;
    }
    
    __cell_width  = _cell_width;
    __cell_height = _cell_height;
    
    __cells_x = max(1, floor(SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE / __cell_width ));
    __cells_y = max(1, floor(SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE / __cell_height));
    
    __map = ds_map_create();
    __next_index = 0;
    
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
            else if (_found_model.ref == _new_model)
            {
                //Model already registered as in use
                return;
            }
            
            ++_i;
        }
        
        array_push(__model_array, weak_ref_create(_new_model));
    }
    
    static __fetch_unknown = function(_unicode)
    {
        var _character = chr(_unicode);
        
        var _font_glyph_grid = __glyph_data_grid;
        var _font_glyph_map  = __glyphs_map;
        
        var _index = __next_index;
        _font_glyph_map[? _unicode] = _index;
        
        ++__next_index;
        if (__next_index >= __cells_x*__cells_y)
        {
            if (SCRIBBLE_VERBOSE) __scribble_trace("Warning! Ran out of space for glyphs");
            __invalidate();
            __next_index = 0;
        }
        
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
        gpu_set_blendmode_ext(bm_one, bm_zero);
        gpu_set_colorwriteenable(false, false, false, true);
        
        surface_set_target(__surface);
        
        //Clear out the existing glyph
        draw_rectangle(_x, _y, _x + __cell_width, _y + __cell_height, false);
        draw_set_alpha(1);
        
        draw_text(_x, _y, _character);
        surface_reset_target();
        
        draw_set_colour(_old_colour);
        draw_set_alpha( _old_alpha );
        draw_set_font(  _old_font  );
        draw_set_halign(_old_halign);
        draw_set_valign(_old_valign);
        gpu_set_blendmode(bm_normal);
        gpu_set_colorwriteenable(true, true, true, true);
        
        var _font_info = font_get_info(__font);
        var _info_glyphs_dict = _font_info.glyphs;
        var _glyph_dict = _info_glyphs_dict[$ _character];
        
        var _w = string_width( _character);
        var _h = string_height(_character);
        
        var _u0 = _x/SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE;
        var _v0 = _y/SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE;
        var _u1 = _u0 + _w/SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE;
        var _v1 = _v0 + _h/SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE;
        
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.CHARACTER           ] = _character;
        
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.UNICODE             ] = _unicode;
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.BIDI                ] = __scribble_unicode_get_bidi(_unicode);
        
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.X_OFFSET            ] = 0;
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.Y_OFFSET            ] = 0;
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.WIDTH               ] = _w;
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.HEIGHT              ] = _h;
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.FONT_HEIGHT         ] = _h;
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.SEPARATION          ] = _glyph_dict.shift;
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.LEFT_OFFSET         ] = -_glyph_dict.offset;
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.FONT_SCALE          ] = 1;
        
        //Set on create (or reset when regenerating the surface)
        //_font_glyph_grid[# _index, SCRIBBLE_GLYPH.TEXTURE             ] = _texture;
        
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.U0                  ] = _u0;
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.U1                  ] = _u1;
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.V0                  ] = _v0;
        _font_glyph_grid[# _index, SCRIBBLE_GLYPH.V1                  ] = _v1;
        
        //These are set on create, or are modified elsewhere
        //_font_glyph_grid[# _index, SCRIBBLE_GLYPH.SDF_PXRANGE         ] = undefined;
        //_font_glyph_grid[# _index, SCRIBBLE_GLYPH.SDF_THICKNESS_OFFSET] = undefined;
        //_font_glyph_grid[# _index, SCRIBBLE_GLYPH.BILINEAR            ] = undefined;
        
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
    
    static __invalidate = function()
    {
        if (SCRIBBLE_VERBOSE) __scribble_trace("Invalidating font_add() glyph cache");
        
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
                _weak_ref.ref.__flush();
            }
            
            ++_i;
        }
    }
    
    static __clear_glyph_map = function()
    {
        var _font_glyph_grid = __glyph_data_grid;
        var _font_glyph_map  = __glyphs_map;
        
        ds_map_clear(_font_glyph_map);
        
        _font_glyph_map[? 32] = 0;
        
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.CHARACTER           ] = " ";
        
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.UNICODE             ] = 0x20;
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.BIDI                ] = __SCRIBBLE_BIDI.WHITESPACE;
        
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.X_OFFSET            ] = 0;
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.Y_OFFSET            ] = 0;
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.WIDTH               ] = __space_width;
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.HEIGHT              ] = __space_height;
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.FONT_HEIGHT         ] = __space_height;
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.SEPARATION          ] = __space_width;
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.LEFT_OFFSET         ] = 0;
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.FONT_SCALE          ] = 1;
        
        //Set on create (or reset when regenerating the surface)
        //_font_glyph_grid[# 0, SCRIBBLE_GLYPH.TEXTURE             ] = _texture;
        
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.U0                  ] = 0;
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.V0                  ] = 0;
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.U1                  ] = 0;
        _font_glyph_grid[# 0, SCRIBBLE_GLYPH.V1                  ] = 0;
        
        //These are set on create, or are modified elsewhere
        //_font_glyph_grid[# _index, SCRIBBLE_GLYPH.SDF_PXRANGE         ] = undefined;
        //_font_glyph_grid[# _index, SCRIBBLE_GLYPH.SDF_THICKNESS_OFFSET] = undefined;
        //_font_glyph_grid[# _index, SCRIBBLE_GLYPH.BILINEAR            ] = undefined;
        
        __next_index = 1;
        __invalidate();
    }
    
    static __tick = function()
    {
        if (__in_use && ((__surface == undefined) || !surface_exists(__surface)))
        {
            if (__surface != undefined) __clear_glyph_map();
            
            __surface = surface_create(SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE, SCRIBBLE_INTERNAL_FONT_ADD_CACHE_SIZE);
            surface_set_target(__surface);
            draw_clear_alpha(c_white, 0);
            surface_reset_target();
        }
    }
}