// Feather disable all

function scribble_default_preprocessor_get()
{
    static _system = __ScribbleSystem();
    
    return _system.__defaultPreprocessorFunc;
}