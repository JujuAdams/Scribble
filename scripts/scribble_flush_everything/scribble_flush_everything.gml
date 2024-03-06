// Feather disable all
/// This function will clear out all memory that Scribble is currently using. You will not normally need
/// to call this function (Scribble automatically garbage collects resources that haven't been used recently)
/// but it's occasionally useful when you need memory to be available immediately.

function scribble_flush_everything()
{
    if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing everything");
    
    with(__scribble_get_cache_state())
    {
        //Flush elements
        var _i = 0;
        repeat(array_length(__ecache_array))
        {
            __ecache_array[_i].__flushed = true;
            ++_i;
        }
        
        
        
        //Destroy all vertex buffers
        var _i = 0;
        repeat(array_length(__gc_vbuff_ids))
        {
            if (__SCRIBBLE_DEBUG) __scribble_trace("Deleting vertex buffer ", __gc_vbuff_ids[_i]);
            vertex_delete_buffer(__gc_vbuff_ids[_i]);
            ++_i;
        }
        
        
        
        var _names_array = variable_struct_get_names(__ecache_dict);
        var _i = 0;
        repeat(array_length(_names_array))
        {
            variable_struct_remove(__ecache_dict, _names_array[_i]);
            ++_i;
        }
        array_resize(__ecache_name_array, 0);
        array_resize(__ecache_array, 0);
        
        
        
        var _names_array = variable_struct_get_names(__mcache_dict);
        var _i = 0;
        repeat(array_length(_names_array))
        {
            variable_struct_remove(__mcache_dict, _names_array[_i]);
            ++_i;
        }
        array_resize(__mcache_name_array, 0);
        
        
        
        if (__SCRIBBLE_DEBUG) __scribble_trace("Clearing vertex buffer cache");
        array_resize(__gc_vbuff_refs, 0);
        array_resize(__gc_vbuff_ids,  0);
    }
}
