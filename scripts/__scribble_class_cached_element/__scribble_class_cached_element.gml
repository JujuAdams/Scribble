// Feather disable all

/// @param string
/// @param uniqueID

function __scribble_class_cached_element(_string, _unique_id) : __scribble_class_shared_element(_string) constructor
{
    static __ecache_array      = __scribble_system().__cache_state.__ecache_array;
    static __ecache_dict       = __scribble_system().__cache_state.__ecache_dict;
    static __ecache_weak_array = __scribble_system().__cache_state.__ecache_weak_array;
    static __ecache_name_array = __scribble_system().__cache_state.__ecache_name_array;
    
    
    
    __unique_id  = _unique_id;
    __cache_name = ((_unique_id == undefined)? SCRIBBLE_DEFAULT_UNIQUE_ID : (string(_unique_id) + ":")) + _string;
    
    if (__SCRIBBLE_DEBUG) __scribble_trace("Caching element \"" + __cache_name + "\"");
    
    //Defensive programming to prevent memory leaks when accidentally rebuilding a model for a given cache name
    var _weak = __ecache_dict[$ __cache_name];
    if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.__flushed)
    {
        __scribble_trace("Warning! Flushing element \"", __cache_name, "\" due to cache name collision");
        _weak.ref.flush();
    }
    
    //Add this text element to the global cache
    __ecache_dict[$ __cache_name] = weak_ref_create(self);
    array_push(__ecache_array, self);
    array_push(__ecache_weak_array, weak_ref_create(self));
    array_push(__ecache_name_array, __cache_name);
    
    
    
    /// @param x
    /// @param y
    /// @param [typist_UNUSED]
    static draw = function(_x, _y, _typist_UNUSED = undefined)
    {
        if (_typist_UNUSED != undefined)
        {
            __scribble_error("Typists have been removed in favour of `scribble_unique()`. Please refer to documentation");
        }
        
        if (SCRIBBLE_FLOOR_DRAW_COORDINATES)
        {
            _x = floor(_x);
            _y = floor(_y);
        }
        
        //Get our model, and create one if needed
        var _model = __get_model(true);
        if (!is_struct(_model)) return undefined;
        
        //If enough time has elapsed since we drew this element then update our animation time
        if (__last_drawn < __scribble_state.__frames)
        {
            __animation_time += __animation_speed*SCRIBBLE_TICK_SIZE;
            if (SCRIBBLE_SAFELY_WRAP_TIME) __animation_time = __animation_time mod 16383; //Cheeky wrapping to prevent GPUs with low accuracy flipping out
        }
        
        __last_drawn = __scribble_state.__frames;
        
        with(__scribble_state)
        {
            //Update the blink state
            if ((not __shader_anim_disabled) && __blink_on_duration + __blink_off_duration > 0)
            {
                other.__animation_blink_state = (((other.__animation_time + __blink_time_offset) mod (__blink_on_duration + __blink_off_duration)) < __blink_on_duration);
            }
            else
            {
                other.__animation_blink_state = true;
            }
        }
        
        shader_set(__shd_scribble);
        __set_standard_uniforms();
        
        //...aaaand set the matrix
        var _old_matrix = matrix_get(matrix_world);
        var _matrix = matrix_multiply(__update_matrix(_model, _x, _y), _old_matrix);
        matrix_set(matrix_world, _matrix);
        
        //Submit the model
        _model.__submit(__page, (__sdf_outline_thickness > 0) || (__sdf_shadow_alpha > 0));
        
        //Make sure we reset the world matrix
        matrix_set(matrix_world, _old_matrix);
        shader_reset();
        
        if (SCRIBBLE_SHOW_WRAP_BOUNDARY) debug_draw_bbox(_x, _y);
        
        if (SCRIBBLE_DRAW_RETURNS_SELF)
        {
            return self;
        }
        else
        {
            static _null = new __scribble_class_null_element();
            return _null;
        }
    }
    
    static flush = function()
    {
        //Don't forget to update scribble_flush_everything() if you change anything here!
        
        if (__flushed) return undefined;
        if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing element \"" + string(__cache_name) + "\"");
        
        //Remove reference from cache
        variable_struct_remove(__ecache_dict, __cache_name);
        
        var _array = __ecache_array;
        var _i = 0;
        repeat(array_length(_array))
        {
            if (_array[_i] == self)
            {
                array_delete(_array, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
        
        //Set as __flushed
        __flushed = true;
    }
    
    /// @param string
    /// @param [uniqueID]
    static overwrite = function(_text, _unique_id = __unique_id)
    {
        __text      = _text;
        __unique_id = _unique_id;
        
        var _new_cache_name = ((_unique_id == undefined)? SCRIBBLE_DEFAULT_UNIQUE_ID : (string(_unique_id) + ":")) + __text;
        if (__cache_name != _new_cache_name)
        {
            flush();
            __flushed = false;
            
            __model_cache_name_dirty = true;
            __cache_name = _new_cache_name;
            
            var _weak = __ecache_dict[$ __cache_name];
            if ((_weak != undefined) && weak_ref_alive(_weak) && !_weak.ref.__flushed)
            {
                __scribble_trace("Warning! Flushing element \"", __cache_name, "\" due to cache name collision (try choosing a different unique ID)");
                _weak.ref.flush();
            }
            
            //Add this text element to the global cache
            __ecache_dict[$ __cache_name] = weak_ref_create(self);
            array_push(__ecache_array, self);
            array_push(__ecache_name_array, __cache_name);
        }
        
        return self;
    }
}
