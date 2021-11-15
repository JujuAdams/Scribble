/// Adds an audio index that was created with either audio_create_buffer_sound or audio_create_stream to Scribbles External Sound Database.
///
/// @param soundName   Name, as a string, of the audio that you previously assigned to Scribbles External Sound Database.

function scribble_external_sound_exists(_soundName)
{
    //Ensure we're initialised
    __scribble_init();
    
	// Get from database and return result
    return ds_map_exists(global.__scribble_external_sound, _soundName);
}