if (keyboard_check_pressed(vk_space) && scribble_is_text_element(textbox_element))
{
    if (typist.get_paused())
    {
        //If we're paused, unpause!
        typist.unpause();
    }
    else if (typist.get_state() >= 1)
    {
        if (textbox_element.get_page() < textbox_element.get_page_count() - 1)
        {
            //Otherwise move to the next page
            textbox_element.page(textbox_element.get_page() + 1);
        }
        else
        {
            //Increment our conversation index for the next piece of text
            textbox_conversation_index = (textbox_conversation_index + 1) mod array_length(textbox_conversation);
        }
    }
    else
    {
        typist.TypeSkip();
    }
}