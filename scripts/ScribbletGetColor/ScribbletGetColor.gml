// Feather disable all

/// @param name

function ScribbletGetColor(_name)
{
    static _colourDict = __ScribbletSystem().__colourDict;
    return _colourDict[$ _name];
}