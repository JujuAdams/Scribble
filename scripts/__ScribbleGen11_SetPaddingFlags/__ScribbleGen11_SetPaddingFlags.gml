// Feather disable all
function __ScribbleGen11_SetPaddingFlags()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    with(_generatorState)
    {
        var _uses_halign_left   = __uses_halign_left;
        var _uses_halign_center = __uses_halign_center;
        var _uses_halign_right  = __uses_halign_right;
    }
    
    //Figure out how to pad the bounding box based on what alignments have been used
    __padBboxT = false;
    __padBboxB = true;
    
    if (__vAlign == fa_top)
    {
        __padBboxT = false;
    }
    
    if (__vAlign == fa_bottom)
    {
        __padBboxB = false;
    }
    
    if (_uses_halign_center)
    {
        __padBboxL = true;
        __padBboxR = true;
    }
    else if (_uses_halign_left)
    {
        if (_uses_halign_right)
        {
            __padBboxL = true;
            __padBboxR = true;
        }
        else
        {
            __padBboxL = false;
            __padBboxR = true;
        }
    }
    else if (_uses_halign_right)
    {
        __padBboxL = true;
        __padBboxR = false;
    }
    else
    {
        __padBboxL = false;
        __padBboxR = true;
    }
}
