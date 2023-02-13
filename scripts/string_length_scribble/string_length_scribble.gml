/// Emulation of string_length(), but using Scribble for calculating the length of a string
/// 
/// **Please do not use this function in conjunction with string_copy()**
/// 
/// @param string    The string to draw

function string_length_scribble(_string)
{
    return scribble(_string).get_glyph_count();
}