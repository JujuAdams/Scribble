/// @param string
/// @param font
/// @param preScale
/// @param maxWidth
/// @param maxHeight
/// @param scaleToBox

function __ScribbleClassFast(_string, _font, _preScale, _maxWidth, _maxHeight, _scaleToBox) constructor
{
    static _fitSafeMode   = true;
    static _fitIterations = 6;
    
    __string     = _string;
    __scale      = 1;
    __wrapWidth  = -1;
    __drawMethod = __Draw;
    
    static __Draw = function(_x, _y)
    {
        draw_text(_x, _y, __string);
    }
    
    static __DrawScale = function(_x, _y)
    {
        draw_text_transformed(_x, _y, __string, __scale, __scale, 0);
    }
    
    static __DrawWrap = function(_x, _y)
    {
        draw_text_ext(_x, _y, __string, -1, __wrapWidth);
    }
    
    static __DrawFit = function(_x, _y)
    {
        draw_text_ext_transformed(_x, _y, __string, -1, __wrapWidth, __scale, __scale, 0);
    }
    
    if (is_infinity(_maxWidth))
    {
        //No limits!
        
        if (_preScale != 1)
        {
            __scale = _preScale;
            __drawMethod = __DrawScale;
        }
    }
    else if (_scaleToBox)
    {
        //Scale down as appropriate
        var _width = string_width(_string);
        if (is_infinity(_maxHeight))
        {
            __scale = min(_preScale, _maxWidth / _width);
        }
        else
        {
            var _height = string_height(_string);
            __scale = min(_preScale, _maxWidth / _width, _maxHeight / _height);
        }
        
        __drawMethod = __DrawScale;
    }
    else if (is_infinity(_maxHeight))
    {
        //No height limit, just draw wrapped as usual
        
        if (_preScale == 1)
        {
            __wrapWidth  = _maxWidth;
            __drawMethod = __DrawWrap;
        }
        else
        {
            __scale      = _preScale;
            __wrapWidth  = _maxWidth/_preScale;
            __drawMethod = __DrawFit;
        }
    }
    else
    {
        var _height = _preScale*string_height_ext(_string, -1, _maxWidth/_preScale);
        if (_height <= _maxHeight)
        {
            //Height limit is enough, just draw wrapped as usual
        
            if (_preScale == 1)
            {
                __wrapWidth  = _maxWidth;
                __drawMethod = __DrawWrap;
            }
            else
            {
                __scale      = _preScale;
                __wrapWidth  = _maxWidth/_preScale;
                __drawMethod = __DrawFit;
            }
        }
        else
        {
            var _upperScale = _preScale;
            var _lowerScale = 0;
            
            //Perform a binary search to find the best fit
            repeat(_fitIterations)
            {
                //Bias scale search very slighty to be larger
                //This usually finds the global maxima rather than narrowing down on a local maxima
                var _tryScale = 0.51*(_lowerScale + _upperScale);
                
                var _adjustedWidth  = _maxWidth/_tryScale;
                var _adjustedHeight = _maxHeight/_tryScale;
                
                if (_fitSafeMode)
                {
                    var _width  = string_width_ext( _string, -1, _adjustedWidth);
                    var _height = string_height_ext(_string, -1, _adjustedWidth-1);
                    if ((_width > _adjustedWidth) || (_height > _adjustedHeight))
                    {
                        _upperScale = _tryScale;
                    }
                    else
                    {
                        _lowerScale = _tryScale;
                    }
                }
                else
                {
                    //Subtract 1 here to fix on off-by-one in GameMaker's text layout
                    var _height = string_height_ext(_string, -1, _adjustedWidth-1);
                    if (_height > _adjustedHeight)
                    {
                        _upperScale = _tryScale;
                    }
                    else
                    {
                        _lowerScale = _tryScale;
                    }
                }
            }
            
            __scale      = _lowerScale;
            __wrapWidth  = _maxWidth/_lowerScale;
            __drawMethod = __DrawFit;
        }
    }
}