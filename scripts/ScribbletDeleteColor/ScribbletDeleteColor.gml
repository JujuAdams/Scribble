// Feather disable all

/// @param name

function ScribbletDeleteColor(_name)
{
    static _colourDict = __ScribbletSystem().__colourDict;
    variable_struct_remove(_colourDict, _name);
}