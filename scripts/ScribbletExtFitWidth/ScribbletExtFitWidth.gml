// Feather disable all

/// Returns the pixel width of a ScribbletDraw() draw call.
/// 
/// @param string
/// @param [hAlign=left]
/// @param [vAlign=top]
/// @param [font]
/// @param [fontScale=1]
/// @param [width]
/// @param [height]

function ScribbletExtFitWidth(_string, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1, _maxWidth = infinity, _maxHeight = infinity)
{
    if (_string == "") return 0;
    __SCRIBBLET_EXT_FIT_GET
    return _struct.__GetWidth();
}