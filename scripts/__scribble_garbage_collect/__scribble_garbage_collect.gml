function __scribble_garbage_collect()
{
    //Scan through the cache to see if any text elements have elapsed - though cap out at max 5 iterations
    repeat(5)
    {
        //Move backwards through the cache list so we are always trying to check the oldest stuff before looping round
        global.__scribble_element_cache_test_index--;
        
        //Check to see if we need to wrap around
        if (global.__scribble_element_cache_test_index < 0)
        {
            //If we do, jump to the end of the list
            global.__scribble_element_cache_test_index += ds_list_size(global.__scribble_element_cache_list);
            
            //If the size of the list is 0 then we'll still be negative
            if (global.__scribble_element_cache_test_index < 0)
            {
                global.__scribble_element_cache_test_index = 0; //Clamp to 0
                break; //And break out of the repeat loop
            }
        }
        
        //Only flush if we want to garbage collect this text element and it hasn't been drawn for a while
        var _element = global.__scribble_element_cache_list[| global.__scribble_element_cache_test_index];
        if (_element.last_drawn + SCRIBBLE_CACHE_ELEMENT_TIMEOUT < current_time) _element.flush();
    }
    
    //Do the same for models
    repeat(5)
    {
        global.__scribble_model_cache_test_index--;
        
        if (global.__scribble_model_cache_test_index < 0)
        {
            global.__scribble_model_cache_test_index += ds_list_size(global.__scribble_model_cache_list);
            if (global.__scribble_model_cache_test_index < 0)
            {
                global.__scribble_model_cache_test_index = 0;
                break;
            }
        }
        
        var _model = global.__scribble_model_cache_list[| global.__scribble_model_cache_test_index];
        if (_model.last_drawn + SCRIBBLE_CACHE_MODEL_TIMEOUT < current_time) _model.flush();
    }
}