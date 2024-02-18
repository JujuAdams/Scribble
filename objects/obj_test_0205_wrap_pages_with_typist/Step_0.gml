if (!SCRIBBLE_ALLOW_GLYPH_DATA_GETTER) return;

if (keyboard_check_pressed(vk_space))
{
    if (typist.GetTypePaused())
    {
        //If we're paused, unpause!
        element.TypeUnpause(false);
    }
    else if (typist.GetTypeState() >= 1)
    {
        if (element.get_page() >= element.get_page_count() - 1)
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
        typist.TypeSkip();
    }
}