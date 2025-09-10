// Feather disable all

/// This function will clear out all memory that Scribble is currently using. You will not normally need
/// to call this function (Scribble automatically garbage collects resources that haven't been used recently)
/// but it's occasionally useful when you need memory to be available immediately.

function scribble_flush_everything()
{
    if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing everything");
    
    with(__scribble_system())
    {
        var _array = __elementWeakArray;
        var _i = 0;
        repeat(array_length(_array))
        {
            var _weakRef = _array[_i];
            if (weak_ref_alive(_weakRef))
            {
                _weakRef.__Flush();
            }
            
            ++_i;
        }
        
        array_resize(_array, 0);
    }
}
