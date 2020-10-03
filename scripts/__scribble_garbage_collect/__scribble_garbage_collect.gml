function __scribble_garbage_collect()
{
	if (SCRIBBLE_CACHE_TIMEOUT > 0)
	{
	    //Scan through the cache to see if any text elements have elapsed - though cap out at max 100 iterations
	    repeat(100)
	    {
	        var _size = ds_list_size(global.__scribble_global_cache_list);
	        if (_size <= 0) break;
            
	        //Move backwards through the cache list so we are always trying to check the oldest stuff
	        global.__scribble_cache_test_index = (global.__scribble_cache_test_index - 1 + _size) mod _size;
            
	        //Only flush if we want to garbage collect this text element and it hasn't been drawn for a while
	        var _cache_array = global.__scribble_global_cache_list[| global.__scribble_cache_test_index]
	        if (_cache_array[SCRIBBLE.GARBAGE_COLLECT] && (_cache_array[SCRIBBLE.DRAWN_TIME] + SCRIBBLE_CACHE_TIMEOUT < current_time))
	        {
	            scribble_flush(_cache_array);
	        }
	        else
	        {
	            //If we haven't flushed this text element, break out of the loop
	            break;
	        }
	    }
	}
}