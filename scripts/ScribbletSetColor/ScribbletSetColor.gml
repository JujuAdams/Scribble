// Feather disable all

/// @param name
/// @param color

function ScribbletSetColor(_name, _color)
{
    static _colourDict = __ScribbletSystem().__colourDict;
    _colourDict[$ _name] = _color;
}