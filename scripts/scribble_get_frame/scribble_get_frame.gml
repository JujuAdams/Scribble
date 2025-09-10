// Feather disable all

function scribble_get_frame()
{
    static _system = __scribble_system();
    return _system.__frames;
}