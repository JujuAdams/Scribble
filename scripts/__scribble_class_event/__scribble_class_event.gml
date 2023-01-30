function __scribble_class_event(_name, _data) constructor
{
    //These are publicly exposed via .get_events()
    name            = _name;
    data            = _data;
    position        = undefined; //Legacy
    character_index = undefined;
    line_index      = undefined;
}