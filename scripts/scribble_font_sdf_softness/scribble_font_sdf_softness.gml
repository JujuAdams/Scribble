/// @param fontName
/// @param softness

function scribble_font_sdf_softness(_name, _softness)
{
    __scribble_get_font_data(_name).__material.__sdf_softness = _softness;
}