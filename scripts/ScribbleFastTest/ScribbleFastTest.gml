// Feather disable all

/// @param x
/// @param y
/// @param string
/// @param [colour=white]
/// @param [alpha=1]
/// @param [hAlign=left]
/// @param [vAlign=top]
/// @param [font]
/// @param [fontScale=1]
/// @param [width]
/// @param [height]
/// @param [scaleToBox=false]

function ScribbleFastTest(_x, _y, _string, _colour = c_white, _alpha = 1, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1, _maxWidth = infinity, _maxHeight = infinity, _scaleToBox = false)
{
    static _system = __ScribbleFastSystem();
    static _cache  = _system.__cache;
    
    if (_font == undefined) _font = _system.__defaultFont;
    draw_set_font(_font);
    draw_set_colour(_colour);
    draw_set_alpha(_alpha);
    draw_set_halign(_hAlign);
    draw_set_valign(_vAlign);
    
    if (is_infinity(_maxWidth) || ((not _scaleToBox) && is_infinity(_maxHeight)))
    {
        draw_text_transformed(_x, _y, _string, _fontScale, _fontScale, 0);
    }
    else
    {
        _maxWidth  = max(0, _maxWidth);
        _maxHeight = max(0, _maxHeight);
        
        var _key = _string + ":" + string(_font) + ":" + string(_fontScale) + (_scaleToBox? "s" : "f") + string(_maxWidth) + ":" + string(_maxHeight);
        var _struct = _cache[$ _key];
        if (_struct == undefined)
        {
            _struct = new __ScribbleClassFast(_string, _font, _fontScale, _maxWidth, _maxHeight, _scaleToBox);
            _cache[$ _key] = _struct;
        }
        
        _struct.__drawMethod(_x, _y);
    }
}