// Feather disable all

/// Returns the pixel height of a ScribbletDraw() draw call.
/// 
/// @param string
/// @param [hAlign=left]
/// @param [vAlign=top]
/// @param [font]
/// @param [fontScale=1]

function ScribbletExtHeight(_string, _hAlign = fa_left, _vAlign = fa_top, _font = undefined, _fontScale = 1)
{
    if (_string == "") return 0;
    __SCRIBBLET_EXT_GET
    return _struct.__GetHeight();
}