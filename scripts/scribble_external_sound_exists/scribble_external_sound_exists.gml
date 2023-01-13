function scribble_external_sound_remove(_alias)
{
    //Ensure we're initialized
    __scribble_initialize();
    
    ds_map_delete(__scribble_get_external_sound_map(), _alias);
}