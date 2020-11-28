function scribble_flush_everything()
{
    //Flush all models
    var _i = 0;
    repeat(ds_list_size(global.__scribble_model_cache_list))
    {
        global.__scribble_model_cache_list[| _i].flush();
        ++_i;
    }
    
    ds_map_clear(global.__scribble_model_cache);
    ds_list_clear(global.__scribble_model_cache_list);
    global.__scribble_model_cache_test_index = 0;
    
    //Flush elements
    var _i = 0;
    repeat(ds_list_size(global.__scribble_element_cache_list))
    {
        global.__scribble_element_cache_list[| _i].flush();
        ++_i;
    }
    
    ds_map_clear(global.__scribble_element_cache);
    ds_list_clear(global.__scribble_element_cache_list);
    global.__scribble_element_cache_test_index = 0;
    
    //Flush the callstack cache too
    ds_map_clear(global.__scribble_callstack_cache);
}