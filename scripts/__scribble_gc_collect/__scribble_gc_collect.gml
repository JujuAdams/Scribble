function __scribble_gc_collect()
{
    if (current_time - global.__scribble_cache_check_time < __SCRIBBLE_EXPECTED_FRAME_TIME) exit;
    global.__scribble_cache_check_time = current_time;
    
    //If there's been a change in os_is_paused() state then force a refresh of shader uniforms
    if (os_is_paused() != global.__scribble_os_is_paused)
    {
        global.__scribble_os_is_paused = os_is_paused();
        
        global.__scribble_anim_shader_desync             = true;
        global.__scribble_anim_shader_msdf_desync        = true;
        global.__scribble_standard_shader_uniforms_dirty = true;
        global.__scribble_msdf_shader_uniforms_dirty     = true;
    }
    
    
    
    #region Scan through the cache to see if any text elements have elapsed
    
    var _array = global.__scribble_ecache_array;
    var _size  = array_length(_array);
    var _index = min(global.__scribble_ecache_list_index, _size);
    repeat(max(__SCRIBBLE_GC_STEP_SIZE, ceil(sqrt(_size)))) //Choose a step size that scales with the size of the cache, but doesn't get too big
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
        if (_element.__last_drawn + __SCRIBBLE_CACHE_TIMEOUT < current_time)
        {
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("\"", _element.__cache_name, "\" has timed out (", current_time, " > ", _element.__last_drawn, " + ", __SCRIBBLE_CACHE_TIMEOUT, ")");
            array_delete(_array, _index, 1);
            variable_struct_remove(global.__scribble_ecache_dict, _element.__cache_name);
        }
    }
    
    global.__scribble_ecache_list_index = _index;
    
    #endregion
    
    
    
    #region Check through text elements to clean anything up
    
    var _index = global.__scribble_ecache_name_index;
    var _array = global.__scribble_ecache_name_array;
    var _dict  = global.__scribble_ecache_dict;
    repeat(max(__SCRIBBLE_GC_STEP_SIZE, ceil(sqrt(array_length(_array))))) //Choose a step size that scales with the size of the cache, but doesn't get too big
    {
        _index--;
        if (_index < 0)
        {
            _index += array_length(_array);
            if (_index < 0)
            {
                _index = 0;
                break;
            }
        }
        
        var _name = _array[_index];
        var _weak = _dict[$ _name];
        if ((_weak == undefined) || !weak_ref_alive(_weak))
        {
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Removing element \"", _name, "\" from cache");
            variable_struct_remove(_dict, _name);
            array_delete(_array, _index, 1);
        }
    }
    
    global.__scribble_ecache_name_index = _index;
    
    #endregion
    
    
    
    #region Check through text models to clean anything up
    
    var _index = global.__scribble_mcache_name_index;
    var _array = global.__scribble_mcache_name_array;
    var _dict  = global.__scribble_mcache_dict;
    repeat(max(__SCRIBBLE_GC_STEP_SIZE, ceil(sqrt(array_length(_array))))) //Choose a step size that scales with the size of the cache, but doesn't get too big
    {
        _index--;
        if (_index < 0)
        {
            _index += array_length(_array);
            if (_index < 0)
            {
                _index = 0;
                break;
            }
        }
        
        var _name = _array[_index];
        var _weak = _dict[$ _name];
        if ((_weak == undefined) || !weak_ref_alive(_weak))
        {
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Removing model \"", _name, "\" from cache");
            variable_struct_remove(_dict, _name);
            array_delete(_array, _index, 1);
        }
    }
    
    global.__scribble_mcache_name_index = _index;
    
    #endregion
    
    
    
    #region Check through vertex buffer weak references to clean anything up
    
    var _index     = global.__scribble_gc_vbuff_index;
    var _ref_array = global.__scribble_gc_vbuff_refs;
    var _id_array  = global.__scribble_gc_vbuff_ids;
    
    repeat(max(__SCRIBBLE_GC_STEP_SIZE, ceil(sqrt(array_length(_ref_array))))) //Choose a step size that scales with the size of the cache, but doesn't get too big
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
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Cleaning up vertex buffer ", _id_array[_index]);
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
    if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Adding vertex buffer ", _vbuff, " to tracking");
    array_push(global.__scribble_gc_vbuff_refs, weak_ref_create(_struct));
    array_push(global.__scribble_gc_vbuff_ids, _vbuff);
}

function __scribble_gc_remove_vbuff(_vbuff)
{
    var _index = __scribble_array_find_index(global.__scribble_gc_vbuff_ids, _vbuff);
    if (_index >= 0)
    {
        if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Manually removing vertex buffer ", _vbuff, " from tracking");
        array_delete(global.__scribble_gc_vbuff_refs, _index, 1);
        array_delete(global.__scribble_gc_vbuff_ids,  _index, 1);
    }
}
