function scribble_external_sound_exists(_alias)
{
    //Ensure we're initialized
    __scribble_initialize();
    
    return ds_map_exists(__scribble_get_external_sound_map(), _alias);
}