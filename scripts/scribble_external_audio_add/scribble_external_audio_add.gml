/// Adds an audio index that was created with either audio_create_buffer_sound or audio_create_stream to Scribbles External Audio Database.
///
/// @param audioName   Name, as a string, of the audio you'd like for Scribble to recognize as
/// @param soundID   Name, as a string, of the audio you'd like for Scribble to recognize as

function scribble_external_audio_add(_audioName, _audioID)
{
    //Ensure we're initialised
    __scribble_init();
    
    if (!ds_map_exists(global.__scribble_external_audio, _audioName)) 
    {
        global.__scribble_external_audio[? _audioName] = _audioID;
    }
    else
    {
        __scribble_error("External Audio " + _audioName + " already exists in Scribbles External Audio Database!");
    }
}