function scribble_external_sound_exists(_alias)
{
    //Ensure we're initialized
    __scribble_system();
    
    return ds_map_exists(global.__scribble_external_sound_map, _alias);
}