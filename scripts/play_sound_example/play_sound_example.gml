/// @param json
/// @param data(array)
/// @param changed
/// @param different_event

var _json      = argument0; //Not used in this script
var _data      = argument1;
var _changed   = argument2; //Not used in this script
var _different = argument3;

if ( _different )
{
    var _sound = asset_get_index( _data[0] );
    if ( audio_exists( _sound ) ) audio_play_sound( _sound, 1, false );
}