// Feather disable all

function scribble_get_time()
{
    static _system = __ScribbleSystem();
    return _system.__milliseconds;
}