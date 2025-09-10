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
        
        __AddToCache();
        
        __gcTimeSource = time_source_create(time_source_global, random_range(0.5, 2), time_source_units_seconds,
                                            function()
                                            {
                                                if (not weak_ref_alive(self))
                                                {
                                                    __Flush();
                                                }
                                            }, [], -1);
        time_source_start(__gcTimeSource);
        
        
        
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
            
            //Remove reference from cache
            ds_map_delete(__scribble_system().__elementCacheMap, __cacheName);
            
            //Set as flushed
            __flushed = true;
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
        
        __Overwrite = function()
        {
            var _text     = ref.__text;
            var _uniqueID = ref.__uniqueID;
            
            var _newCacheName = ((_uniqueID == undefined)? SCRIBBLE_DEFAULT_UNIQUE_ID : (string(_uniqueID) + ":")) + _text;
            if (__cacheName != _newCacheName)
            {
                __Flush();
                
                __flushed = false;
                __cacheName = _newCacheName;
                
                __AddToCache();
                ref.__modelDirty = true;
            }
        }
        
        __AddToCache = function()
        {
            //Defensive programming to prevent memory leaks when accidentally rebuilding a model for a given cache name
            var _elementCacheMap = __scribble_system().__elementCacheMap;
            
            var _weak = _elementCacheMap[? __cacheName];
            if ((_weak != undefined) && weak_ref_alive(_weak) && (not _weak.__flushed))
            {
                __scribble_trace("Warning! Flushing element \"", __cacheName, "\" due to cache name collision");
                _weak.__Flush();
            }
            
            //Add this text element to the global cache
            _elementCacheMap[? __cacheName] = self;
        }
    }
    
    
    
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
        if (!is_struct(_model)) return undefined;
        
        //If enough time has elapsed since we drew this element then update our animation time
        if (__last_drawn < __scribble_state.__frames)
        {
            __animation_time += __animation_speed*_system.__tickSize;
            if (SCRIBBLE_SAFELY_WRAP_TIME) __animation_time = __animation_time mod 16383; //Cheeky wrapping to prevent GPUs with low accuracy flipping out
        }
        
        __last_drawn = __scribble_state.__frames;
        
        shader_set(__shd_scribble);
        __SetStandardUniforms();
        __SetRevealUniforms(_revealIndex);
        
        //...aaaand set the matrix
        var _old_matrix = matrix_get(matrix_world); //FIXME - Use a matrix stack here?
        var _matrix = matrix_multiply(__update_matrix(_model, _x, _y), _old_matrix);
        matrix_set(matrix_world, _matrix);
        
        //Submit the model
        _model.__submit(__page, (__sdf_outline_thickness > 0) || (__sdf_shadow_alpha > 0));
        
        //Make sure we reset the world matrix
        matrix_set(matrix_world, _old_matrix);
        shader_reset();
        
        if (SCRIBBLE_SHOW_WRAP_BOUNDARY) debug_draw_bbox(_x, _y);
    }
    
    flush = __weakRef.__Flush;
    
    /// @param string
    /// @param [uniqueID]
    static overwrite = function(_text, _uniqueID = __uniqueID)
    {
        __text     = _text;
        __uniqueID = _uniqueID;
        
        __weakRef.__Overwrite();
        
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
