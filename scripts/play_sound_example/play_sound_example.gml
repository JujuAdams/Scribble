/// @param json
/// @param data(array)
/// @param character

var _json = argument0; //Not used in this script
var _data = argument1;
var _char = argument2; //Not used in this script

var _sound = asset_get_index(_data[0]);
if (audio_exists(_sound)) audio_play_sound(_sound, 1, false);