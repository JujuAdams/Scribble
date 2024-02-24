// Feather disable all

/// @param x
/// @param y
/// @param string
/// @param [width]
/// @param [height]
/// @param [scaleToBox=false]

function ScribbleFastRaw(_x, _y, _string, _maxWidth = infinity, _maxHeight = infinity, _scaleToBox = false)
{
    static _safeMode = false;
    
    _maxWidth  = max(0, _maxWidth);
    _maxHeight = max(0, _maxHeight);
    
    if (is_infinity(_maxWidth))
    {
        //No limits!
        draw_text(_x, _y, _string);
    }
    else if (_scaleToBox)
    {
        //Scale down as appropriate
        var _width = string_width(_string);
        if (is_infinity(_maxHeight))
        {
            var _scale = min(1, _maxWidth/_width);
        }
        else
        {
            var _height = string_height(_string);
            var _scale = min(1, _maxWidth/_width, _maxHeight/_height);
        }
        
        draw_text_transformed(_x, _y, _string, _scale, _scale, 0);
    }
    else if (is_infinity(_maxHeight))
    {
        //No height limit, just draw wrapped as usual
        draw_text_ext(_x, _y, _string, -1, _maxWidth);
    }
    else
    {
        var _height = string_height_ext(_string, -1, _maxWidth);
        if (_height <= _maxHeight)
        {
            //Height limit is enough, just draw wrapped as usual
            draw_text_ext(_x, _y, _string, -1, _maxWidth);
        }
        else
        {
            var _upperScale = 1;
            var _lowerScale = 0;
            
            //Bias scale search very slighty to be larger
            //This usually finds the global maxima rather than narrowing down on a local maxima
            repeat(6)
            {
                var _tryScale = 0.51*(_lowerScale + _upperScale);
                
                var _adjustedWidth  = _maxWidth/_tryScale;
                var _adjustedHeight = _maxHeight/_tryScale;
                
                if (_safeMode)
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
            
            draw_text_ext_transformed(_x, _y, _string, -1, _maxWidth/_lowerScale, _lowerScale, _lowerScale, 0);
        }
    }
}