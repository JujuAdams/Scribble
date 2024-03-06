// Feather disable all
function __scribble_get_cache_state()
{
    static _struct = {
        __mcache_dict:       {},
        __mcache_name_array: [],

        __ecache_dict:       {},
        __ecache_array:      [],
        __ecache_name_array: [],
        
        __gc_vbuff_refs: [],
        __gc_vbuff_ids:  [],
    };
    
    return _struct;
}
