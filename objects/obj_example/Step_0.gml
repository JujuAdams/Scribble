if (keyboard_check_pressed(vk_space))
{
    var _element = scribble(textbox_conversation[textbox_conversation_index]);
    
    if (_element.get_typewriter_paused())
    {
        //If we're paused, unpause!
        _element.typewriter_unpause(false);
    }
    else if (_element.get_typewriter_state() >= 1)
    {
        textbox_skip = false;
        
        if (_element.get_page() < _element.get_pages() - 1)
        {
            //Otherwise move to the next page
            _element.page(_element.get_page() + 1);
        }
        else
        {
            //Increment our conversation index for the next piece of text
            textbox_conversation_index = (textbox_conversation_index + 1) mod array_length(textbox_conversation);
            textbox_text = textbox_conversation[textbox_conversation_index];
            scribble(textbox_text).typewriter_reset();
        }
    }
    else
    {
        textbox_skip = true;
    }
}