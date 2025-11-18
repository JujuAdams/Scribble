// Feather disable all

function __ScribbleGen1_ModelLimitsAndPaths()
{
    static _generatorState = __ScribbleSystem().__generatorState;
    
    var _modelMaxWidth = __layoutMaxWidth - (__paddingL + __paddingR);
    if (_modelMaxWidth < 0) _modelMaxWidth = infinity;
    
    var _modelMaxHeight = __layoutMaxHeight - (__paddingT + __paddingB);
    if (_modelMaxHeight < 0) _modelMaxHeight = infinity;
    
    //TODO - Calculate path length
    
    with(_generatorState)
    {
        __modelMaxWidth  = _modelMaxWidth;
        __modelMaxHeight = _modelMaxHeight;
    }
}
