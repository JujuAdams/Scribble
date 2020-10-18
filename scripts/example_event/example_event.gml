/// An example event called by Scribble's autotype feature
/// 
/// @param   textElement
/// @param   eventData{array}
/// @param   characterIndex
function example_event(argument0, argument1, argument2) {

    var _text_element = argument0;
    var _event_data   = argument1;
    var _char_index   = argument2;

    show_debug_message("Text element called event script \"example_event\" at character=" + string(_char_index) + ", data=" + string(_event_data));


}
