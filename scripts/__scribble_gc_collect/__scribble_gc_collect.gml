/// @param forceCollect

function __scribble_gc_collect(_force_collect)
{
    #region Scan through the cache to see if any text elements have elapsed
    
    var _index = global.__scribble_ecache_array_index;
    var _array = global.__scribble_ecache_array;
    repeat(__SCRIBBLE_GC_STEP_SIZE)
    {
        //Move backwards through the cache list so we are always trying to check the oldest stuff before looping round
        _index--;
        
        //Check to see if we need to wrap around
        if (_index < 0)
        {
            //If we do, jump to the end of the list
            _index += array_length(_array);
            
            //If the size of the list is 0 then we'll still be negative
            if (_index < 0)
            {
                _index = 0; //Clamp to 0
                break;
            }
        }
        
        //Only flush if we want to garbage collect this text element and it hasn't been drawn for a while
        var _element = _array[_index];
        if (_element.last_drawn + __SCRIBBLE_CACHE_TIMEOUT < current_time)
        {
            if (__SCRIBBLE_DEBUG) __scribble_trace("Removing \"", _element.cache_name, "\" from cache array");
            array_delete(_array, _index, 1);
        }
    }
    
    global.__scribble_ecache_array_index = _index;
    
    #endregion
    
    
    
    #region Do a full GC sweep every few seconds
    
    if (_force_collect || (global.__scribble_gc_collect_time + SCRIBBLE_CACHE_COLLECT_FREQ < current_time))
    {
        global.__scribble_gc_collect_time = current_time;
        global.__scribble_gc_just_collected = true;
        
        if (__SCRIBBLE_DEBUG) __scribble_trace("Calling gc_collect()");
        gc_collect();
    }
    //else if (global.__scribble_gc_just_collected && (global.__scribble_gc_collect_time + 35 < current_time))
    {
        global.__scribble_gc_just_collected = false;
        
        if (__SCRIBBLE_DEBUG) __scribble_trace("Performing sweep");
        
        var _dict = global.__scribble_ecache_dict;
        var _names = ds_map_keys_to_array(_dict);
        var _i = 0;
        repeat(array_length(_names))
        {
            var _name = _names[_i];
            var _weak = _dict[? _name];
            if (!weak_ref_alive(_weak))
            {
                if (__SCRIBBLE_DEBUG) __scribble_trace("Fully removing element \"", _name, "\" from cache dict");
                ds_map_delete(_dict, _name);
            }
            
            ++_i;
        }
        
        var _dict = global.__scribble_mcache_dict;
        var _names = ds_map_keys_to_array(_dict);
        var _i = 0;
        repeat(array_length(_names))
        {
            var _name = _names[_i];
            var _weak = _dict[? _name];
            if (!weak_ref_alive(_weak))
            {
                if (__SCRIBBLE_DEBUG) __scribble_trace("Fully removing model \"", _name, "\" from cache dict");
                ds_map_delete(_dict, _name);
            }
            
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Check through vertex buffer weak references to clean anything up
    
    var _index     = global.__scribble_gc_vbuff_index;
    var _ref_array = global.__scribble_gc_vbuff_refs;
    var _id_array  = global.__scribble_gc_vbuff_ids;
    
    repeat(__SCRIBBLE_GC_STEP_SIZE)
    {
        _index--;
        if (_index < 0)
        {
            _index += array_length(_ref_array);
            if (_index < 0)
            {
                _index = 0;
                break;
            }
        }
        
        var _weak = _ref_array[_index];
        if (!weak_ref_alive(_weak))
        {
            vertex_delete_buffer(_id_array[_index]);
            array_delete(_ref_array, _index, 1);
            array_delete(_id_array , _index, 1);
        }
    }
    
    global.__scribble_gc_vbuff_index = _index;
    
    #endregion
}

function __scribble_gc_add_vbuff(_struct, _vbuff)
{
    array_push(global.__scribble_gc_vbuff_refs, weak_ref_create(_struct));
    array_push(global.__scribble_gc_vbuff_ids, _vbuff);
}

function __scribble_gc_remove_vbuff(_vbuff)
{
    var _index = __scribble_array_find_index(global.__scribble_gc_vbuff_ids, _vbuff);
    if (_index >= 0)
    {
        array_delete(global.__scribble_gc_vbuff_refs, _index, 1);
        array_delete(global.__scribble_gc_vbuff_ids , _index, 1);
    }
}