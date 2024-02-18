if (keyboard_check_pressed(vk_space))
{
    if (typist.get_paused())
    {
        typist.unpause();    
    }
    else
    {
        typist.TypeSkipToPause();    
    }
}