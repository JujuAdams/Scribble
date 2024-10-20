// Feather disable all
function scribble_refresh_everything()
{
    if (__SCRIBBLE_DEBUG) __scribble_trace("Refreshing everything");
    
    with(__scribble_initialize().__cache_state)
    {
        var _array = __ecache_weak_array;
        var _i = 0;
        repeat(array_length(_array))
        {
            var _weak_ref = _array[_i];
            if (weak_ref_alive(_weak_ref))
            {
                _weak_ref.ref.refresh();
                ++_i;
            }
            else
            {
                array_delete(_array, _i, 1);
            }
        }
    }
}
