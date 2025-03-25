// Feather disable all

/// Sets a custom sprite lookup function for use within the Scribble parser. When parsing
/// formatting tags, this function will be executed to identify which GameMaker sprite asset should
/// be renderered. The sprite lookup function is executed with one argument - the name of the
/// sprite to find, as a string.
/// 
/// The sprite lookup function is, however, executed *after* searching for an external sprite with
/// a matching alias. If there is a naming conflict, the external sprite will be preferred.
/// 
/// N.B. This function should return `-1` if a matching sprite cannot be found. This function
///      should only return sprite asset handles otherwise.
/// 
/// @param function

function scribble_sprite_lookup_function(_function)
{
    static _system = __scribble_initialize();
    
    _system.__sprite_lookup_func = _function;
}