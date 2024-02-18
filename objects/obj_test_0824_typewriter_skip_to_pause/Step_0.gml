if (keyboard_check_pressed(vk_space))
{
    if (typist.GetTypePaused())
    {
        typist.TypeUnpause();    
    }
    else
    {
        typist.TypeSkipToPause();    
    }
}