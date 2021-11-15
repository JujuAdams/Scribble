/// Adds an audio index that was created with either audio_create_buffer_sound or audio_create_stream to Scribbles External Sound Database.
///
/// @param soundName   Name, as a string, of the audio you'd like for Scribble to recognize as
/// @param soundID   Name, as a string, of the audio you'd like for Scribble to recognize as

function scribble_external_sound_add(_soundName, _soundID)
{
    //Ensure we're initialised
    __scribble_init();
    
    if (!ds_map_exists(global.__scribble_external_sound, _soundName)) 
    {
       if audio_exists(_soundID) 
	   {
           global.__scribble_external_sound[? _soundName] = _soundID;
	   }
	   else
	   {
           __scribble_error("Provided soundID " + string(_soundID) + ", with the soundName " + _soundName + ", has an invalid soundID or doesn't exist! \nPlease ensure that the sound index exists first!");
	   }
    }
    else
    {
        __scribble_error("External Sound " + _soundName + " already exists in Scribbles External Sound Database!");
    }
}