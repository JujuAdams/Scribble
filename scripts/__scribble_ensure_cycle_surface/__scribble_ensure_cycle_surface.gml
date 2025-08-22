// Feather disable all

function __scribble_ensure_cycle_surface()
{
    static _system = __scribble_system();
    
    with(_system)
    {
        if (not surface_exists(__cycle_surface))
        {
            __cycle_surface = surface_create(SCRIBBLE_CYCLE_TEXTURE_WIDTH, SCRIBBLE_CYCLE_TEXTURE_HEIGHT);
            
            surface_set_target(__cycle_surface);
            draw_clear(c_white);
            
            var _key = ds_map_find_first(__cycle_data_map);
            repeat(array_length(ds_map_size(__cycle_data_map)))
            {
                __scribble_cycle_draw(_key);
                _key = ds_map_find_next(__cycle_data_map, _key);
            }
            
            surface_reset_target();
        }
        
        return __cycle_surface;
    }
}