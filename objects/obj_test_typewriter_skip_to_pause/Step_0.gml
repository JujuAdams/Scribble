if (keyboard_check_pressed(vk_space))
{
    if (element.get_paused())
    {
        element.unpause();    
    }
    else
    {
        element.skip_to_pause();    
    }
}