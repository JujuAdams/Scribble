if (keyboard_check_pressed(vk_space))
{
    if (typist.GetTypePaused())
    {
        typist.TypeUnpause();
    }
    else
    {
        if (typist.GetTypeState() == 1)
        {
            typist.TypeOut(0.3, 10, true);
            typist.TypeEase(SCRIBBLE_EASE.BACK, 0, 30, 1, 1, 0, 0.3);
        }
        else if (typist.GetTypeState() == 2)
        {
            typist.TypeIn(0.3, 10);
            typist.TypeEase(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);
        }
    }
}