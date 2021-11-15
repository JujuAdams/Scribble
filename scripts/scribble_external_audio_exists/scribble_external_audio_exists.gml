/// Adds an audio index that was created with either audio_create_buffer_sound or audio_create_stream to Scribbles External Audio Database.
///
/// @param audioName   Name, as a string, of the audio that you previously assigned to Scribbles External Audio Database.

function scribble_external_audio_exists(_audioName)
{
    //Ensure we're initialised
    __scribble_init();
    
	// Get from database and return result
    return ds_map_exists(global.__scribble_external_audio, _audioName);
}