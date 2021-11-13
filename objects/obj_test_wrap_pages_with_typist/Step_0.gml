if (keyboard_check_pressed(vk_space))
{
    if (typist.get_paused())
    {
        //If we're paused, unpause!
        element.unpause(false);
    }
    else if (typist.get_state() >= 1)
    {
        if (element.get_page() >= element.get_pages() - 1)
        {
            //Wrap back round to the first page
            element.page(0);
        }
        else
        {
            //Otherwise move to the next page
            element.page(element.get_page() + 1);
        }
    }
    else
    {
        typist.skip();
    }
}