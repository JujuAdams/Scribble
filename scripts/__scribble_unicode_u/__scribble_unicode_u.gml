/// @param unicode

function __scribble_unicode_u(_unicode)
{
    var _string = string(ptr(_unicode));
    return "U+" + string_delete(_string, 1, string_length(_string)-4);
}