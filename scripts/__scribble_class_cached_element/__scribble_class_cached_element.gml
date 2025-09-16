// Feather disable all

/// @param text
/// @param uniqueID

function __scribble_class_cached_element(_text, _uniqueID) : __scribble_class_element_parent(_text) constructor
{
    __uniqueID = _uniqueID;
    
    __weakRef = weak_ref_create(self);
    with(__weakRef)
    {
        __cacheName = ((_uniqueID == undefined)? SCRIBBLE_DEFAULT_UNIQUE_ID : (string(_uniqueID) + ":")) + _text;
        __flushed   = false;
        __model     = undefined;
        __inCache   = false;
        
        
        
        __Flush = function()
        {
            if (__flushed) return;
            
            if (__SCRIBBLE_DEBUG) __scribble_trace("Flushing element \"" + string(__cacheName) + "\"");
            
            //Get rid of our model
            if (is_struct(__model))
            {
                __model.__Flush();
                __model = undefined;
            }
            
            __RemoveFromCache();
            __flushed = true;
            
            time_source_stop(__gcTimeSource);
            time_source_destroy(__gcTimeSource);
        }
        
        __Refresh = function()
        {
            if (__flushed) return undefined;
            
            //Get rid of the existing model
            if (is_struct(__model))
            {
                __model.__Flush();
            }
            
            __model = new __scribble_class_model(ref);
            return __model;
        }
        
        __Overwrite = function(_textChanged)
        {
            var _text     = ref.__text;
            var _uniqueID = ref.__uniqueID;
            
            var _newCacheName = ((_uniqueID == undefined)? SCRIBBLE_DEFAULT_UNIQUE_ID : (string(_uniqueID) + ":")) + _text;
            if (__cacheName != _newCacheName)
            {
                if (_textChanged)
                {
                    //If the text has changed then immediately dump the model
                    __Flush();
                    __flushed = false;
                }
                else
                {
                    //Otherwise we only changed the cache name and don't need to regenerate the model
                    __RemoveFromCache();
                }
                
                __cacheName = _newCacheName;
                __AddToCache();
            }
        }
        
        __AddToCache = function()
        {
            static _elementCacheMap = __scribble_system().__elementCacheMap;
            
            if ((not __inCache) && (not __flushed) && (not ds_map_exists(_elementCacheMap, __cacheName)))
            {
                __inCache = true;
                _elementCacheMap[? __cacheName] = ref; //Strong reference
            }
        }
        
        __RemoveFromCache = function()
        {
            static _elementCacheMap = __scribble_system().__elementCacheMap;
            
            if (weak_ref_alive(self) && (_elementCacheMap[? __cacheName] == ref))
            {
                ds_map_delete(_elementCacheMap, __cacheName);
            }
            
            __inCache = false;
        }
        
        
        
        __AddToCache();
        array_push(__scribble_system().__elementWeakArray, self);
        
        __gcTimeSource = time_source_create(time_source_global, __scribble_random_range(__SCRIBBLE_ELEMENT_SELFCHECK_MIN, __SCRIBBLE_ELEMENT_SELFCHECK_MAX), time_source_units_seconds,
                                            function()
                                            {
                                                static _system = __scribble_system();
                                                
                                                if (not weak_ref_alive(self))
                                                {
                                                    __Flush();
                                                }
                                                else
                                                {
                                                    if (_system.__frames - ref.__lastDrawn > __SCRIBBLE_CACHE_TIMEOUT)
                                                    {
                                                        __RemoveFromCache();
                                                    }
                                                }
                                            }, [], -1);
        time_source_start(__gcTimeSource);
    }
    
    
    
    flush = __weakRef.__Flush;
    
    /// @param x
    /// @param y
    /// @param [revealIndex]
    static draw = function(_x, _y, _revealIndex = undefined)
    {
        if (SCRIBBLE_FLOOR_DRAW_COORDINATES)
        {
            _x = floor(_x);
            _y = floor(_y);
        }
        
        //Get our model, and create one if needed
        var _model = __EnsureModel();
        if (not is_struct(_model)) return undefined;
        
        //If enough time has elapsed since we drew this element then update our animation time
        if (__lastDrawn < _system.__frames)
        {
            __animation_time += __animation_speed*_system.__tickSize;
            if (SCRIBBLE_SAFELY_WRAP_TIME) __animation_time = __animation_time mod 16383; //Cheeky wrapping to prevent GPUs with low accuracy flipping out
        }
        
        __lastDrawn = _system.__frames;
        __weakRef.__AddToCache();
        
        shader_set(__shd_scribble);
        __SetStandardUniforms();
        __SetRevealUniforms(_revealIndex);
        
        matrix_stack_push(__update_matrix(_model, _x, _y));
        matrix_set(matrix_world, matrix_stack_top());
        _model.__submit(__page, (__sdf_outline_thickness > 0) || (__sdf_shadow_alpha > 0));
        
        shader_reset();
        matrix_stack_pop();
        matrix_set(matrix_world, matrix_stack_top());
        
        if (SCRIBBLE_SHOW_WRAP_BOUNDARY) debug_draw_bbox(_x, _y);
    }
    
    /// @param string
    /// @param [uniqueID]
    static overwrite = function(_text, _uniqueID = __uniqueID)
    {
        var _textChanged = (__text != _text);
        if (_textChanged)
        {
            __text = _text;
            __modelDirty = true;
        }
        
        __uniqueID = _uniqueID;
        __weakRef.__Overwrite(_textChanged);
        
        return self;
    }
    
    static page = function(_page)
    {
        return __set_page(_page);
    }
    
    static in = function()
    {
        __scribble_error("Cannot use typist functions on cached Scribble text elements\nPlease refer to documentation and use `scribble_unique()` instead");
    }
}
