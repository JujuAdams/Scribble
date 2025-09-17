// Feather disable all

/// @param function

function scribble_default_preprocessor_set(_function)
{
    static _system = __ScribbleSystem();
    
    _system.__defaultPreprocessorFunc = _function;
}