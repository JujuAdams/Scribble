/// An example event called by Scribble's autotype feature
/// 
/// @param   textElement
/// @param   eventData{array}
/// @param   characterIndex

function example_event(_text_element, _event_data, _char_index)
{
    show_debug_message("Text element called event script \"example_event\" at character=" + string(_char_index) + ", data=" + string(_event_data));
}