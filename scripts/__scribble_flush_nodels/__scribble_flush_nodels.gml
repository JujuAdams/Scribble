// Feather disable all

function __scribble_flush_nodels()
{
    if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing models");
    
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
        
        
        
        var _names_array = variable_struct_get_names(__mcache_dict);
        var _i = 0;
        repeat(array_length(_names_array))
        {
            variable_struct_remove(__mcache_dict, _names_array[_i]);
            ++_i;
        }
        array_resize(__mcache_name_array, 0);
    }
}
