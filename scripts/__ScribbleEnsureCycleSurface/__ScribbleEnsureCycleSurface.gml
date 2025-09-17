// Feather disable all

function __ScribbleEnsureCycleSurface()
{
    static _system = __ScribbleSystem();
    
    with(_system)
    {
        if (not surface_exists(__cycleSurface))
        {
            __cycleSurface = surface_create(SCRIBBLE_CYCLE_TEXTURE_WIDTH, SCRIBBLE_CYCLE_TEXTURE_HEIGHT);
            
            surface_set_target(__cycleSurface);
            draw_clear(c_white);
            
            var _key = ds_map_find_first(__cycleDataMap);
            repeat(array_length(ds_map_size(__cycleDataMap)))
            {
                __ScribbleDrawCycle(_key);
                _key = ds_map_find_next(__cycleDataMap, _key);
            }
            
            surface_reset_target();
        }
        
        return __cycleSurface;
    }
}