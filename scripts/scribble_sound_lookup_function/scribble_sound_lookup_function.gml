// Feather disable all

/// Sets a custom sound lookup function for use within Scribble. When parsing formatting tags and
/// playing back audio from a typist, this function will be executed to identify which GameMaker
/// sound asset should be played. The sound lookup function is executed with one argument - the
/// name of the sound to find, as a string.
/// 
/// N.B. This function should return `-1` if a matching sound cannot be found. This function
///      should only return sound asset handles otherwise.
/// 
/// @param function

function scribble_sound_lookup_function(_function)
{
    static _system = __scribble_initialize();
    
    _system.__sound_lookup_func = _function;
}