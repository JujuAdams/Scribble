// Feather disable all

/// @param function

function scribble_default_preprocessor_set(_function)
{
    static _system = __scribble_initialize();
    
    _system.__defaultPreprocessorFunc = _function;
}