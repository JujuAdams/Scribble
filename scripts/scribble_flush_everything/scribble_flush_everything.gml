// Feather disable all

/// This function will clear out all memory that Scribble is currently using. You will not normally need
/// to call this function (Scribble automatically garbage collects resources that haven't been used recently)
/// but it's occasionally useful when you need memory to be available immediately.

function scribble_flush_everything()
{
    if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing everything");
    
    with(__scribble_system().__cache_state)
    {
        //Destroy all vertex buffers
        var _i = 0;
        repeat(array_length(__gc_vbuff_ids))
        {
            if (__SCRIBBLE_DEBUG) __scribble_trace("Deleting vertex buffer ", __gc_vbuff_ids[_i]);
            vertex_delete_buffer(__gc_vbuff_ids[_i]);
            ++_i;
        }
        if (__SCRIBBLE_DEBUG) __scribble_trace("Clearing vertex buffer cache");
        array_resize(__gc_vbuff_refs, 0);
        array_resize(__gc_vbuff_ids,  0);
        
        
        
        //Destroy all glyph grids
        var _i = 0;
        repeat(array_length(__gc_grid_ids))
        {
            if (__SCRIBBLE_DEBUG) __scribble_trace("Deleting glyph grid ", __gc_grid_ids[_i]);
            ds_grid_destroy(__gc_grid_ids[_i]);
            ++_i;
        }
        
        if (__SCRIBBLE_DEBUG) __scribble_trace("Clearing glyph grid cache");
        array_resize(__gc_grid_refs, 0);
        array_resize(__gc_grid_ids,  0);
    }
    
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
