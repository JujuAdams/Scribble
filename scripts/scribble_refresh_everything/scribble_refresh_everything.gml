// Feather disable all
function scribble_refresh_everything()
{
    if (__SCRIBBLE_DEBUG) __scribble_trace("Refreshing everything");
    
    with(__scribble_system())
    {
        var _array = __elementWeakArray;
        var _i = 0;
        repeat(array_length(_array))
        {
            var _weakRef = _array[_i];
            if (weak_ref_alive(_weakRef))
            {
                _weakRef.ref.refresh();
                ++_i;
            }
            else
            {
                array_delete(_array, _i, 1);
            }
        }
    }
}
