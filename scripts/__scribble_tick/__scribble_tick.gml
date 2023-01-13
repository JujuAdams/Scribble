function __scribble_tick()
{
    ++global.__scribble_frames;
    
    
    
    //If there's been a change in os_is_paused() state then force a refresh of shader uniforms
    static _os_is_paused = undefined;
    if (os_is_paused() != _os_is_paused)
    {
        _os_is_paused = os_is_paused();
        
        static _scribble_state = __scribble_get_state();
        with(_scribble_state)
        {
            __standard_anim_desync            = true;
            __standard_anim_desync_to_default = true;
            __msdf_anim_desync                = true;
            __msdf_anim_desync_to_default     = true;
        }
    }
    
    
    
    #region Scan through the cache to see if any text elements have elapsed
    
    var _array = global.__scribble_ecache_array;
    var _size  = array_length(_array);
    
    static _ecache_list_index = 0;
    _ecache_list_index = min(_ecache_list_index, _size);
    
    repeat(max(__SCRIBBLE_GC_STEP_SIZE, ceil(sqrt(_size)))) //Choose a step size that scales with the size of the cache, but doesn't get too big
    {
        //Move backwards through the cache list so we are always trying to check the oldest stuff before looping round
        _ecache_list_index--;
        
        //Check to see if we need to wrap around
        if (_ecache_list_index < 0)
        {
            //If we do, jump to the end of the list
            _ecache_list_index += array_length(_array);
            
            //If the size of the list is 0 then we'll still be negative
            if (_ecache_list_index < 0)
            {
                _ecache_list_index = 0; //Clamp to 0
                break;
            }
        }
        
        //Only flush if we want to garbage collect this text element and it hasn't been drawn for a while
        var _element = _array[_ecache_list_index];
        if (_element.__last_drawn + __SCRIBBLE_CACHE_TIMEOUT < global.__scribble_frames)
        {
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("\"", _element.__cache_name, "\" has timed out (", global.__scribble_frames, " > ", _element.__last_drawn, " + ", __SCRIBBLE_CACHE_TIMEOUT, ")");
            array_delete(_array, _ecache_list_index, 1);
            variable_struct_remove(global.__scribble_ecache_dict, _element.__cache_name);
        }
    }
    
    #endregion
    
    
    
    #region Check through text elements to clean anything up
    
    var _array = global.__scribble_ecache_name_array;
    var _size  = array_length(_array);
    var _dict  = global.__scribble_ecache_dict;
    
    static _ecache_name_index = 0;
    _ecache_name_index = min(_ecache_name_index, _size);
    
    repeat(max(__SCRIBBLE_GC_STEP_SIZE, ceil(sqrt(_size)))) //Choose a step size that scales with the size of the cache, but doesn't get too big
    {
        _ecache_name_index--;
        if (_ecache_name_index < 0)
        {
            _ecache_name_index += array_length(_array);
            if (_ecache_name_index < 0)
            {
                _ecache_name_index = 0;
                break;
            }
        }
        
        var _name = _array[_ecache_name_index];
        var _weak = _dict[$ _name];
        if ((_weak == undefined) || !weak_ref_alive(_weak))
        {
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Removing element \"", _name, "\" from cache");
            variable_struct_remove(_dict, _name);
            array_delete(_array, _ecache_name_index, 1);
        }
    }
    
    #endregion
    
    
    
    #region Check through text models to clean anything up
    
    var _array = global.__scribble_mcache_name_array;
    var _size  = array_length(_array);
    var _dict  = global.__scribble_mcache_dict;
    
    static _mcache_name_index = 0;
    _mcache_name_index = min(_mcache_name_index, _size);
    
    repeat(max(__SCRIBBLE_GC_STEP_SIZE, ceil(sqrt(_size)))) //Choose a step size that scales with the size of the cache, but doesn't get too big
    {
        _mcache_name_index--;
        if (_mcache_name_index < 0)
        {
            _mcache_name_index += array_length(_array);
            if (_mcache_name_index < 0)
            {
                _mcache_name_index = 0;
                break;
            }
        }
        
        var _name = _array[_mcache_name_index];
        var _weak = _dict[$ _name];
        if ((_weak == undefined) || !weak_ref_alive(_weak))
        {
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Removing model \"", _name, "\" from cache");
            variable_struct_remove(_dict, _name);
            array_delete(_array, _mcache_name_index, 1);
        }
    }
    
    #endregion
    
    
    
    #region Check through vertex buffer weak references to clean anything up
    
    var _ref_array = global.__scribble_gc_vbuff_refs;
    var _id_array  = global.__scribble_gc_vbuff_ids;
    var _size      = array_length(_ref_array);
    
    static _vbuff_index = 0;
    _vbuff_index = min(_vbuff_index, _size);
    
    repeat(max(__SCRIBBLE_GC_STEP_SIZE, ceil(sqrt(_size)))) //Choose a step size that scales with the size of the cache, but doesn't get too big
    {
        _vbuff_index--;
        if (_vbuff_index < 0)
        {
            _vbuff_index += array_length(_ref_array);
            if (_vbuff_index < 0)
            {
                _vbuff_index = 0;
                break;
            }
        }
        
        var _weak = _ref_array[_vbuff_index];
        if (!weak_ref_alive(_weak))
        {
            if (__SCRIBBLE_VERBOSE_GC) __scribble_trace("Cleaning up vertex buffer ", _id_array[_vbuff_index]);
            vertex_delete_buffer(_id_array[_vbuff_index]);
            array_delete(_ref_array, _vbuff_index, 1);
            array_delete(_id_array , _vbuff_index, 1);
        }
    }
    
    #endregion
}