/// @param styleStruct

function scribble_markdown_set_styles(_root_struct)
{
    static _scribble_state = __scribble_get_state();
    _scribble_state.__markdown_styles_struct = _root_struct;
}