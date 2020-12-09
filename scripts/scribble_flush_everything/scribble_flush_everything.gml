/// This function will clear out all memory that Scribble is currently using. You will not normally need
/// to call this function (Scribble automatically garbage collects resources that haven't been used recently)
/// but it's occasionally useful when you need memory to be available immediately.

function scribble_flush_everything()
{
    if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing everything");
    
    //Flush elements
    var _i = 0;
    repeat(array_length(global.__scribble_ecache_array))
    {
        global.__scribble_ecache_array[_i].flushed = true;
        ++_i;
    }
    
    //Destroy all vertex buffers
    var _i = 0;
    repeat(array_length(global.__scribble_gc_vbuff_ids))
    {
        vertex_delete_buffer(global.__scribble_gc_vbuff_ids[_i]);
        ++_i;
    }
    
    //Clean out the cache structures
    ds_map_clear(global.__scribble_ecache_dict);
    global.__scribble_ecache_array       = [];
    global.__scribble_ecache_array_index = 0;
    
    ds_map_clear(global.__scribble_mcache_dict);
    
    global.__scribble_gc_vbuff_index = 0;
    global.__scribble_gc_vbuff_refs  = [];
    global.__scribble_gc_vbuff_ids   = [];
}