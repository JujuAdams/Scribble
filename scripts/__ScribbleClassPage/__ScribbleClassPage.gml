// Feather disable all

/// @param model

function __ScribbleClassPage(_model) constructor
{
    static _system = __ScribbleSystem();
    
    __model = _model;
    
    __text = "";
    __glyphGrid = undefined;
    
    __createdFrame = _system.__frames;
    __frozen = undefined;
    
    __revealCount = 0;
    
    __glyphStart = undefined;
    __glyphEnd   = undefined;
    __glyphCount = 0;
    
    __lineStart = undefined;
    __lineEnd   = undefined;
    __lineCount = 0;
    
    __lineDataArray = undefined; //Only set to an array if we're allowing the line data getter
    
    __width  = 0;
    __height = 0;
    __minX  = 0;
    __minY  = 0;
    __maxX  = 0;
    __maxY  = 0;
    
    __vertexBufferArray = [];
    __textureToVertexBufferDict = {};
    
    __eventsDict  = {};
    __regionArray = [];
    
    static __Finalize = function(_pageEndLine)
    {
        static _animationRandomizeArray = [];
        static _generatorState = __ScribbleSystem().__generatorState;
        
        with(_generatorState)
        {
            var _glyphGrid     = __glyphGrid;
            var _wordGrid      = __wordGrid;
            var _lineArray     = __lineArray;
            var _modelMaxHeight = __modelMaxHeight;
        }
        
        __lineEnd    = _pageEndLine;
        __lineCount  = 1 + __lineEnd - __lineStart;
        __glyphEnd   = _wordGrid[# _lineArray[__lineEnd].wordEnd, __SCRIBBLE_GEN_WORD_GLYPH_END];
        __glyphCount = 1 + __glyphEnd - __glyphStart;
        
        var _pageWidth = 0;
        var _i = __lineStart;
        repeat(__lineCount)
        {
            _pageWidth = max(_pageWidth, _lineArray[_i].width);
            ++_i;
        }
        
        __width = _pageWidth;
        
        var _lineMaxY = _lineArray[_pageEndLine].y + _lineArray[_pageEndLine].height;
        __height = _lineMaxY;
            
        //Correct page position for vertical alignment
        var _vAlign = __model.__vAlign;
        if (_vAlign == fa_middle)
        {
            __minY = -(_lineMaxY div 2);
            __maxY =  (_lineMaxY div 2);
        }
        else if (_vAlign == fa_bottom)
        {
            __minY = -_lineMaxY;
            __maxY = 0;
        }
        else if (_vAlign == __SCRIBBLE_PIN_MIDDLE)
        {
            if (SCRIBBLE_PIN_ALIGNMENT_USES_PAGE_SIZE || (_modelMaxHeight == infinity))
            {
                __minY = -(_lineMaxY div 2);
                __maxY =  (_lineMaxY div 2);
            }
            else
            {
                var _delta = _modelMaxHeight - _lineMaxY;
                __minY = 0.5*_delta;
                __maxY = _modelMaxHeight - 0.5*_delta;
            }
        }
        else if (_vAlign == __SCRIBBLE_PIN_BOTTOM)
        {
            if (SCRIBBLE_PIN_ALIGNMENT_USES_PAGE_SIZE || (_modelMaxHeight == infinity))
            {
                __minY = -_lineMaxY;
                __maxY = 0;
            }
            else
            {
                __minY = _modelMaxHeight - _lineMaxY;
                __maxY = _modelMaxHeight;
            }
        }
        else //fa_top or pin_top
        {
            __minY = 0;
            __maxY = _lineMaxY;
        }
            
        //Correct line positions for vertical alignment
        if (__minY != 0)
        {
            var _i = __lineStart;
            repeat(__lineCount)
            {
                _lineArray[_i].y += __minY;
                ++_i;
            }
        }
            
        // Set up the character indexes for the page, relative to the character index of the first glyph on the page
        var _pageRevealStart = _glyphGrid[# __glyphStart, __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX];
        var _pageRevealEnd   = _glyphGrid[# __glyphEnd,   __SCRIBBLE_GEN_GLYPH_REVEAL_INDEX];
        __revealStart = _pageRevealStart;
        __revealEnd   = _pageRevealEnd;
        __revealCount = 1 + _pageRevealEnd - _pageRevealStart;
        
        __lineDataArray = [];
        
        var _line = __lineStart;
        repeat(__lineCount)
        {
            var _lineStruct = _lineArray[_line];
            
            var _glyphStart = _wordGrid[# _lineStruct.wordStart, __SCRIBBLE_GEN_WORD_GLYPH_START] - __glyphStart;
            var _glyphEnd   = _wordGrid[# _lineStruct.wordEnd,   __SCRIBBLE_GEN_WORD_GLYPH_END  ] - __glyphStart;
            
            _lineStruct.glyphStart = _glyphStart;
            _lineStruct.glyphEnd   = _glyphEnd;
            _lineStruct.glyphCount = 1 + _glyphEnd - _glyphStart;
            
            array_push(__lineDataArray, _lineStruct);
            
            ++_line;
        }
            
        if (__model.__randomizeAnimation)
        {
            array_resize(_animationRandomizeArray, __revealCount);
            
            var _line = 0;
            repeat(__revealCount)
            {
                _animationRandomizeArray[@ _line] = _line;
                ++_line;
            }
            
            array_sort(_animationRandomizeArray, function() { return choose(-1, 1); }); //FIXME - Swap this out for a PRNG
            
            var _glyphStart = __glyphStart;
            var _line = 0;
            repeat(__revealCount)
            {
                _glyphGrid[# _glyphStart + _line, __SCRIBBLE_GEN_GLYPH_ANIMATION_INDEX] = _animationRandomizeArray[_line];
                ++_line;
            }
        }
    }
    
    static __Submit = function(_doubleDraw)
    {
        static _u_vTexel              = shader_get_uniform(__shdScribble, "u_vTexel"             );
        static _u_fSDFRange           = shader_get_uniform(__shdScribble, "u_fSDFRange"          );
        static _u_fSDFThicknessOffset = shader_get_uniform(__shdScribble, "u_fSDFThicknessOffset");
        static _u_fSecondDraw         = shader_get_uniform(__shdScribble, "u_fSecondDraw"        );
        static _u_fRenderType         = shader_get_uniform(__shdScribble, "u_fRenderType"        );
        
        if (SCRIBBLE_INCREMENTAL_FREEZE && (not __frozen) && (__createdFrame < _system.__frames))
        {
            __Freeze();
        }
        
        var _i = 0;
        repeat(array_length(__vertexBufferArray))
        {
            var _data = __vertexBufferArray[_i];
            var _material = _data.__material;
            
            var _bilinear = _material.__bilinear;
            if (_bilinear != undefined)
            {
                var _oldTexFilter = gpu_get_tex_filter();
                gpu_set_tex_filter(_bilinear);
            }
            
            if (_material.__renderType == __SCRIBBLE_RENDER_RASTER)
            {
                shader_set_uniform_f(_u_fRenderType, __SCRIBBLE_RENDER_RASTER);
                vertex_submit(_data.__vertexBuffer, pr_trianglelist, _material.__texture);
            }
            else if (_material.__renderType == __SCRIBBLE_RENDER_SDF)
            {
                //Set shader uniforms unique to the SDF shader
                shader_set_uniform_f(_u_fRenderType, __SCRIBBLE_RENDER_SDF);
                shader_set_uniform_f(_u_vTexel, _material.__texelWidth, _material.__texelHeight);
                shader_set_uniform_f(_u_fSDFRange, (_material.__sdfPxRange ?? 0));
                shader_set_uniform_f(_u_fSDFThicknessOffset, _system.__state.__sdfThicknessOffset + (_material.__sdfThicknessOffset ?? 0));
                
                vertex_submit(_data.__vertexBuffer, pr_trianglelist, _material.__texture);
                
                if (_doubleDraw)
                {
                    shader_set_uniform_f(_u_fSecondDraw, 1);
                    vertex_submit(_data.__vertexBuffer, pr_trianglelist, _material.__texture);
                    shader_set_uniform_f(_u_fSecondDraw, 0);
                }
            }
            else if (_material.__renderType == __SCRIBBLE_RENDER_RASTER_WITH_EFFECTS)
            {
                shader_set_uniform_f(_u_fRenderType, __SCRIBBLE_RENDER_RASTER_WITH_EFFECTS);
                vertex_submit(_data.__vertexBuffer, pr_trianglelist, _material.__texture);
                
                if (_doubleDraw)
                {
                    shader_set_uniform_f(_u_fSecondDraw, 1);
                    vertex_submit(_data.__vertexBuffer, pr_trianglelist, _material.__texture);
                    shader_set_uniform_f(_u_fSecondDraw, 0);
                }
            }
            
            if (_bilinear != undefined)
            {
                //Reset the texture filtering
                gpu_set_tex_filter(_oldTexFilter);
            }
            
            ++_i;
        }
    }
    
    static __Freeze = function()
    {
        if (not __frozen)
        {
            if (SCRIBBLE_VERBOSE)
            {
                var _t = get_timer();
            }
            
            var _i = 0;
            repeat(array_length(__vertexBufferArray))
            {
                vertex_freeze(__vertexBufferArray[_i].__vertexBuffer);
                ++_i;
            }
            
            __frozen = true;
            
            if (SCRIBBLE_VERBOSE)
            {
                __ScribbleTrace("Incrementally froze page vertex buffers, time taken = ", (get_timer() - _t)/1000, "ms");
            }
        }
    }
    
    static __GetLineData = function(_index)
    {
        return __lineDataArray[clamp(_index, 0, __lineCount-1)];
    }
    
    static __GetGlyphData = function(_index)
    {
        //TODO - Static struct return needed here?
        
        if (_index < 0)
        {
            return {
                unicode:  0,
                left:     __glyphGrid[# 0, __SCRIBBLE_GLYPH_LAYOUT_LEFT    ],
                top:      __glyphGrid[# 0, __SCRIBBLE_GLYPH_LAYOUT_TOP     ],
                right:    __glyphGrid[# 0, __SCRIBBLE_GLYPH_LAYOUT_LEFT    ],
                bottom:   __glyphGrid[# 0, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM  ],
                y_offset: __glyphGrid[# 0, __SCRIBBLE_GLYPH_LAYOUT_Y_OFFSET],
            };
        }
        else if (_index >= __glyphCount-1)
        {
            _index = __glyphCount-2;
            
            return {
                unicode:  0,
                left:     __glyphGrid[# _index, __SCRIBBLE_GLYPH_LAYOUT_RIGHT   ],
                top:      __glyphGrid[# _index, __SCRIBBLE_GLYPH_LAYOUT_TOP     ],
                right:    __glyphGrid[# _index, __SCRIBBLE_GLYPH_LAYOUT_RIGHT   ],
                bottom:   __glyphGrid[# _index, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM  ],
                y_offset: __glyphGrid[# _index, __SCRIBBLE_GLYPH_LAYOUT_Y_OFFSET],
            };
        }
        else
        {
            return {
                unicode:  __glyphGrid[# _index, __SCRIBBLE_GLYPH_LAYOUT_UNICODE ],
                left:     __glyphGrid[# _index, __SCRIBBLE_GLYPH_LAYOUT_LEFT    ],
                top:      __glyphGrid[# _index, __SCRIBBLE_GLYPH_LAYOUT_TOP     ],
                right:    __glyphGrid[# _index, __SCRIBBLE_GLYPH_LAYOUT_RIGHT   ],
                bottom:   __glyphGrid[# _index, __SCRIBBLE_GLYPH_LAYOUT_BOTTOM  ],
                y_offset: __glyphGrid[# _index, __SCRIBBLE_GLYPH_LAYOUT_Y_OFFSET],
            };
        }
    }
    
    static __GetVertexBuffer = function(_material)
    {
        //TODO - Replace struct-based look-up with a ds_map
        var _data = __textureToVertexBufferDict[$ _material.__key];
        if (_data != undefined)
        {
            return _data.__vertexBuffer;
        }
        
        //TODO - Move this to `__ScribbleSystem()`
        static _vertexFormat = undefined;
        if (_vertexFormat == undefined)
        {
            vertex_format_begin();
            vertex_format_add_position_3d();                                  //12 bytes
            vertex_format_add_normal();                                       //12 bytes
            vertex_format_add_colour();                                       // 4 bytes
            vertex_format_add_custom(vertex_type_float4, vertex_usage_color); //16 bytes
            _vertexFormat = vertex_format_end();                              //44 bytes per vertex, 132 bytes per tri, 264 bytes per glyph
        }
        
        var _vbuff = vertex_create_buffer(); //TODO - Can we preallocate this? i.e. copy "for text" system we had in the old version
        vertex_begin(_vbuff, _vertexFormat);
        
        //TODO - Convert this data into just a material reference
        
        var _data = {
            __vertexBuffer: _vbuff,
            __material:      _material,
        };
        
        array_push(__vertexBufferArray, _data);
        __textureToVertexBufferDict[$ _material.__key] = _data;
        
        return _vbuff;
    }
    
    static __EnsureGlyphGrid = function()
    {
        if (__glyphGrid == undefined)
        {
            __glyphGrid = ds_grid_create(__glyphCount, __SCRIBBLE_GLYPH_LAYOUT_SIZE);
        }
        
        return __glyphGrid;
    }
    
    static __FinalizeVertexBuffers = function()
    {
        var _i = 0;
        repeat(array_length(__vertexBufferArray))
        {
            var _vbuff = __vertexBufferArray[_i].__vertexBuffer;
            vertex_end(_vbuff);
            ++_i;
        }
        
        __frozen = false;
    }
    
    static __Flush = function()
    {
        var _i = 0;
        repeat(array_length(__vertexBufferArray))
        {
            vertex_delete_buffer(__vertexBufferArray[_i].__vertexBuffer);
            ++_i;
        }
        
        array_resize(__vertexBufferArray, 0);
        __textureToVertexBufferDict = {};
        
        if (__glyphGrid != undefined)
        {
            ds_grid_destroy(__glyphGrid);
            __glyphGrid = undefined;
        }
    }
}
