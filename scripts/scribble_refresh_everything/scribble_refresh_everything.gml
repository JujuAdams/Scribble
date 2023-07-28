// Feather disable all
function scribble_refresh_everything()
{
    if (__SCRIBBLE_DEBUG) __scribble_trace("Refreshing everything");
    
    with(__scribble_get_cache_state())
    {
        var _i = 0;
        repeat(array_length(__ecache_array))
        {
            __ecache_array[_i].refresh();
            ++_i;
        }
    }
}
