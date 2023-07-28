// Feather disable all
/// @param   textElement
/// @param   eventData{array}
/// @param   characterIndex

function example_dialogue_set_portrait(_text_element, _event_data, _char_index)
{
    textbox_portrait = asset_get_index(_event_data[0]);
}
