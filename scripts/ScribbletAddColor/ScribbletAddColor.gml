// Feather disable all

/// @param name
/// @param color

function ScribbletAddColor(_name, _color)
{
    static _colourDict = __ScribbletSystem().__colourDict;
    _colourDict[$ _name] = _color;
}