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
        
        //Clean out the cache structures
        __ecache_dict = {};
        __ecache_name_array = [];
    
        __ecache_array = [];
    
        __mcache_dict = {};
        __mcache_name_array = [];
    
        if (__SCRIBBLE_DEBUG) __scribble_trace("Clearing vertex buffer cache");
        __gc_vbuff_refs = [];
        __gc_vbuff_ids  = [];
    }
}