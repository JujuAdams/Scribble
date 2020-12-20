if (keyboard_check_pressed(vk_space))
{
    if (textbox_element.get_typewriter_paused())
    {
        //If we're paused, unpause!
        textbox_element.typewriter_unpause(false);
    }
    else if (textbox_element.get_typewriter_state() >= 1)
    {
        textbox_skip = false;
        
        if (textbox_element.get_page() < textbox_element.get_pages() - 1)
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
        textbox_skip = true;
    }
}