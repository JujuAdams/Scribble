// Feather disable all

function __ScribbleGen9_BuildVBuffGrids()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    
    with(_generatorState)
    {
        var _glyphGrid    = __glyphGrid;
        var _vbuffPosGrid = __vbuffPosGrid;
        var _glyphCount   = __glyphCount;
        var _pathLength   = __pathLength;
    }
    
    //Transform glyph coordinates to lie along the path
    if (__path != undefined)
    {
        var _path      = __path;
        var _pathStart = __pathStart;
        var _pathDelta = __pathEnd - __pathStart;
        var _pathScale = __pathScale;
        
        var _scaleNegative = (_pathScale < 0);
        var _lineHeight = __lineHeight;
        
        var _i = 0;
        repeat(_glyphCount-1)
        {
            var _glyphLeft    = _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_X];
            var _glyphTop     = _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_Y];
            var _glyphWidth   = _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_WIDTH];
            var _glyphHeight  = _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_HEIGHT];
            var _glyphYOffset = _glyphTop + 0.5*_glyphHeight;
            
            var _pathParam = clamp(_glyphLeft / _pathLength, 0, 1);
            _pathParam = _pathStart + _pathDelta*_pathParam;
            if (_scaleNegative) _pathParam = 1 - _pathParam;
            
            if (_pathParam < 1)
            {
                var _pathX  = _pathScale*path_get_x(_path, _pathParam);
                var _pathY  = _pathScale*path_get_y(_path, _pathParam);
                var _pathX2 = _pathScale*path_get_x(_path, _pathParam + 0.001);
                var _pathY2 = _pathScale*path_get_y(_path, _pathParam + 0.001);
            }
            else
            {
                var _pathX  = _pathScale*path_get_x(_path, _pathParam - 0.001);
                var _pathY  = _pathScale*path_get_y(_path, _pathParam - 0.001);
                var _pathX2 = _pathScale*path_get_x(_path, _pathParam);
                var _pathY2 = _pathScale*path_get_y(_path, _pathParam);
            }
            
            var _angle = point_direction(_pathX, _pathY, _pathX2, _pathY2);
            var _cos   = dcos(-_angle);
            var _sin   = dsin(-_angle);
            
            var _newX = _pathX + 0.5*_glyphWidth*_cos - _glyphYOffset*_sin - 0.5*_glyphWidth;
            var _newY = _pathY + 0.5*_glyphWidth*_sin + _glyphYOffset*_cos - 0.5*_glyphHeight;
            
            _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_X    ] = _newX;
            _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_Y    ] = _newY;
            _glyphGrid[# _i, __SCRIBBLE_GEN_GLYPH_ANGLE] = _angle;
            
            ++_i;
        }
    }
    
    //Copy the x/y offset into the quad LTRB
    ds_grid_set_grid_region(_vbuffPosGrid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_X, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L);
    ds_grid_set_grid_region(_vbuffPosGrid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_X, _glyphCount-1, __SCRIBBLE_GEN_GLYPH_Y, 0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
    
    //Then add the deltas to give us the final quad LTRB positions
    //Note that the delta are already scaled via font scale / scaling tags etc
    ds_grid_add_grid_region(_vbuffPosGrid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_WIDTH,   _glyphCount-1, __SCRIBBLE_GEN_GLYPH_WIDTH,   0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
    ds_grid_add_grid_region(_vbuffPosGrid, _glyphGrid, 0, __SCRIBBLE_GEN_GLYPH_HEIGHT,  _glyphCount-1, __SCRIBBLE_GEN_GLYPH_HEIGHT,  0, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B);
    
    if (__visualBboxes)
    {
        var _modelMinX =  infinity;
        var _modelMinY =  infinity;
        var _modelMaxX = -infinity;
        var _modelMaxY = -infinity;
    
        var _p = 0;
        repeat(__pages)
        {
            var _pageData = __pagesArray[_p];
            with(_pageData)
            {
                var _pageGlyphStart = __glyphStart;
                var _pageGlyphEnd   = __glyphCount-1 + _pageGlyphStart;
                
                __minX = ds_grid_get_min(_vbuffPosGrid, _pageGlyphStart, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L, _pageGlyphEnd, __SCRIBBLE_GEN_VBUFF_POS_QUAD_L);
                __minY = ds_grid_get_min(_vbuffPosGrid, _pageGlyphStart, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T, _pageGlyphEnd, __SCRIBBLE_GEN_VBUFF_POS_QUAD_T);
                __maxX = ds_grid_get_max(_vbuffPosGrid, _pageGlyphStart, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R, _pageGlyphEnd, __SCRIBBLE_GEN_VBUFF_POS_QUAD_R);
                __maxY = ds_grid_get_max(_vbuffPosGrid, _pageGlyphStart, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B, _pageGlyphEnd, __SCRIBBLE_GEN_VBUFF_POS_QUAD_B);
                
                var _modelMinX = min(_modelMinX, __minX);
                var _modelMinY = min(_modelMinY, __minY);
                var _modelMaxX = max(_modelMaxX, __maxX);
                var _modelMaxY = max(_modelMaxY, __maxY);
            }
            
            ++_p;
        }
        
        __minX = is_infinity(_modelMinX)? 0 : _modelMinX;
        __minY = is_infinity(_modelMinY)? 0 : _modelMinY;
        __maxX = is_infinity(_modelMaxX)? 0 : _modelMaxX;
        __maxY = is_infinity(_modelMaxY)? 0 : _modelMaxY;
        
        __width  = 1 + __maxX - __minX;
        __height = 1 + __maxY - __minY;
    }
}
