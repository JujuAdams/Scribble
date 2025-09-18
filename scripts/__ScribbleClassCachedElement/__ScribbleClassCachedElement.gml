// Feather disable all

/// @param text
/// @param uniqueID

function __ScribbleClassCachedElement(_text, _uniqueID) : __ScribbleClassElementParent(_text) constructor
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
            
            if (__SCRIBBLE_DEBUG) __ScribbleTrace("Flushing element \"" + string(__cacheName) + "\"");
            
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
            
            __model = new __ScribbleClassModel(ref);
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
            static _elementCacheMap = __ScribbleSystem().__elementCacheMap;
            
            if ((not __inCache) && (not __flushed) && (not ds_map_exists(_elementCacheMap, __cacheName)))
            {
                __inCache = true;
                _elementCacheMap[? __cacheName] = ref; //Strong reference
            }
        }
        
        __RemoveFromCache = function()
        {
            static _elementCacheMap = __ScribbleSystem().__elementCacheMap;
            
            if (weak_ref_alive(self) && (_elementCacheMap[? __cacheName] == ref))
            {
                ds_map_delete(_elementCacheMap, __cacheName);
            }
            
            __inCache = false;
        }
        
        
        
        __AddToCache();
        array_push(__ScribbleSystem().__elementWeakArray, self);
        
        __gcTimeSource = time_source_create(time_source_global, __ScribbleRandomRange(__SCRIBBLE_ELEMENT_SELFCHECK_MIN, __SCRIBBLE_ELEMENT_SELFCHECK_MAX), time_source_units_seconds,
                                            function()
                                            {
                                                static _system = __ScribbleSystem();
                                                
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
            __animationTime += __animationSpeed*_system.__tickSize;
            if (SCRIBBLE_SAFELY_WRAP_TIME) __animationTime = __animationTime mod 16383; //Cheeky wrapping to prevent GPUs with low accuracy flipping out
        }
        
        __lastDrawn = _system.__frames;
        __weakRef.__AddToCache();
        
        __AutoScroll();
        
        shader_set(__shdScribble);
        __SetStandardUniforms();
        __SetRevealUniforms(_revealIndex);
        
        matrix_stack_push(__UpdateMatrix(_model, _x, _y));
        matrix_set(matrix_world, matrix_stack_top());
        _model.__Draw(__page + __pageFraction, __scrollXArray, __scrollYArray, __clip, (__sdfOutlineThickness > 0) || (__sdfShadowAlpha > 0));
        
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
        return __SetPage(_page);
    }
    
    static in = function()
    {
        __ScribbleError("Cannot use typist functions on cached Scribble text elements\nPlease refer to documentation and use `scribble_unique()` instead");
    }
}
