// Feather disable all

function scribble_default_preprocessor_get()
{
    static _system = __scribble_initialize();
    
    return _system.__defaultPreprocessorFunc;
}