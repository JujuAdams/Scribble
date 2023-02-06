#macro SCRIBBLE_FONT_ADD_CACHE_SIZE  512

function __scribble_class_font_add_cache(_font) constructor
{
    __in_use  = false;
    __surface = undefined;
    
    __min_glyph = 0;
    __max_glyph = 0;
    
    __cells_x     = 1;
    __cells_y     = 1;
    __cell_width  = SCRIBBLE_FONT_ADD_CACHE_SIZE;
    __cell_height = SCRIBBLE_FONT_ADD_CACHE_SIZE;
    
    __grid = undefined;
    __map  = undefined;
    
    __next_index = 0;
    
    __font = _font;
    
    
    
    static __fetch = function(_unicode)
    {
        static _result = {
            __left:   0,
            __top:    0,
            __right:  0,
            __bottom: 0,
        };
        
        if ((_unicode < __min_glyph) || (_unicode > __max_glyph))
        {
            with(_result)
            {
                __left   = 0;
                __top    = 0;
                __right  = 0;
                __bottom = 0;
            }
            
            return _result;
        }
        
        var _index = __map[? _unicode];
        if (_index != undefined)
        {
            var _x = __cell_width  * (_index mod __cells_x);
            var _y = __cell_height * (_index div __cells_x);
        }
        else
        {
            _index = __next_index;
            __map[? _unicode] = _index;
            __next_index = (_index + 1) mod (__cells_x*__cells_y);
            
            var _x = __cell_width  * (_index mod __cells_x);
            var _y = __cell_height * (_index div __cells_x);
            
            var _old_colour = draw_get_colour();
            var _old_alpha  = draw_get_alpha();
            var _old_font   = draw_get_font();
            var _old_halign = draw_get_halign();
            var _old_valign = draw_get_valign();
            
            draw_set_colour(c_white);
            draw_set_alpha( 1      );
            draw_set_font(  __font );
            draw_set_halign(fa_left);
            draw_set_valign(fa_top );
            gpu_set_blendmode_ext(bm_one, bm_zero);
            gpu_set_colorwriteenable(false, false, false, true);
            
            surface_set_target(__surface);
            
            var _character = chr(_unicode);
            draw_text(_x, _y, _character);
            var _glyph_width  = string_width( _character);
            var _glyph_height = string_height(_character);
            
            surface_reset_target();
            
            draw_set_colour(_old_colour);
            draw_set_alpha( _old_alpha );
            draw_set_font(  _old_font  );
            draw_set_halign(_old_halign);
            draw_set_valign(_old_valign);
            gpu_set_blendmode(bm_normal);
            gpu_set_colorwriteenable(true, true, true, true);
        }
        
        with(_result)
        {
            __left   =  _x                            / SCRIBBLE_FONT_ADD_CACHE_SIZE;
            __top    =  _y                            / SCRIBBLE_FONT_ADD_CACHE_SIZE;
            __right  = (_x + other.__cell_width  - 1) / SCRIBBLE_FONT_ADD_CACHE_SIZE;
            __bottom = (_y + other.__cell_height - 1) / SCRIBBLE_FONT_ADD_CACHE_SIZE;
        }
        
        return _result;
    }
    
    static __activate = function(_min_glyph, _max_glyph, _cell_width, _cell_height)
    {
        if (!__in_use)
        {
            __in_use = true;
            __scribble_trace("Activating font_add() cache (size=", SCRIBBLE_FONT_ADD_CACHE_SIZE, ")");
            
            __min_glyph = _min_glyph;
            __max_glyph = _max_glyph;
            
            __cell_width  = _cell_width;
            __cell_height = _cell_height;
            
            __cells_x = max(1, floor(SCRIBBLE_FONT_ADD_CACHE_SIZE / _cell_width ));
            __cells_y = max(1, floor(SCRIBBLE_FONT_ADD_CACHE_SIZE / _cell_height));
            
            __grid = ds_grid_create(__cells_x, __cells_y);
            ds_grid_clear(__grid, undefined);
            
            __map = ds_map_create();
            __next_index = 0;
            
            __tick();
        }
    }
    
    static __deactivate = function()
    {
        if (__in_use)
        {
            __in_use = false;
            
            __scribble_trace("Deactivating font_add() cache (size=", SCRIBBLE_FONT_ADD_CACHE_SIZE, ")");
            
            __invalidate();
            
            if (__surface != undefined)
            {
                surface_free(__surface);
                __surface = undefined;
            }
            
            if (__grid != undefined)
            {
                ds_grid_destroy(__grid);
                __grid = undefined;
            }
            
            if (__map != undefined)
            {
                ds_map_destroy(__map);
                __map = undefined;
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
        ds_map_clear(__map);
        
        //TODO
    }
    
    static __tick = function()
    {
        if (__in_use && ((__surface == undefined) || !surface_exists(__surface)))
        {
            if (__surface != undefined) __invalidate();
            
            __surface = surface_create(SCRIBBLE_FONT_ADD_CACHE_SIZE, SCRIBBLE_FONT_ADD_CACHE_SIZE);
            surface_set_target(__surface);
            draw_clear_alpha(c_white, 0);
            surface_reset_target();
        }
    }
}