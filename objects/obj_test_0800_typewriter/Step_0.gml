if (keyboard_check_pressed(vk_space))
{
    if (typist.get_paused())
    {
        typist.unpause();
    }
    else
    {
        //if (typist.get_state() == 1)
        //{
            typist.out(0.3, 10, true);
            typist.ease(SCRIBBLE_EASE.BACK, 0, 30, 1, 1, 0, 0.3);
        //}
        //else if (typist.get_state() == 2)
        //{
        //    typist.in(0.3, 10);
        //    typist.ease(SCRIBBLE_EASE.BOUNCE, 0, -40, 1, 1, 0, 0.1);
        //}
        //else
        //{
        //    typist.skip();
        //}
    }
}