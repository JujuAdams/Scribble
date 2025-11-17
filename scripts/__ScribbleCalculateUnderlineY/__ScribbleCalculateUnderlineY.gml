// Feather disable all

/// @param pointSize
/// @param ascender
/// @param ascenderOffset

function __ScribbleCalculateUnderlineY(_pointSize, _ascender, _ascenderOffset)
{
    //Fix dodgy ascender values
    if (_ascender <= 0)
    {
        _ascender = floor(_pointSize * (4/3));
    }
    
    return _ascender - _ascenderOffset;
}