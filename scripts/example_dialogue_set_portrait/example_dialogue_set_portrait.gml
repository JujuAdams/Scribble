// Feather disable all
/// @param {Id.Scribble.element}   textElement
/// @param {Array}   eventData{array}
/// @param {Real.Int}   characterIndex

function example_dialogue_set_portrait(_text_element, _event_data, _char_index)
{
    textbox_portrait = asset_get_index(_event_data[0]);
}
