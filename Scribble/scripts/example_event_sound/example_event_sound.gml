/// An example event called by Scribble's autotype feature
/// 
/// @param   textElement
/// @param   eventData{array}
/// @param   characterIndex

var _text_element = argument0;
var _event_data   = argument1;
var _char_index   = argument2;

var _sound = asset_get_index(_event_data[0]);
if (audio_exists(_sound))
{
    audio_play_sound(_sound, 1, false);
}
else
{
    show_debug_message("Sound \"" + string(_event_data[0]) + "\" doesn't exist!");
}