// Feather disable all
function __ScribbleGen11_SetPaddingFlags()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    with(_generatorState)
    {
        var _usesHAlignLeft   = __usesHAlignLeft;
        var _usesHAlignCenter = __usesHAlignCenter;
        var _usesHAlignRight  = __usesHAlignRight;
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
    
    if (_usesHAlignCenter)
    {
        __padBboxL = true;
        __padBboxR = true;
    }
    else if (_usesHAlignLeft)
    {
        if (_usesHAlignRight)
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
    else if (_usesHAlignRight)
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
