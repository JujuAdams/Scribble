// Feather disable all

/// @param pointSize
/// @param ascender
/// @param ascenderOffset

function __ScribbleCalculateStrikeY(_pointSize, _ascender, _ascenderOffset)
{
    //Fix dodgy ascender values
    if (_ascender <= 0)
    {
        _ascender = floor(_pointSize * (4/3));
    }
    
    return ceil(0.666*_ascender) - _ascenderOffset;
}