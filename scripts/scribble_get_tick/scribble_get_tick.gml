// Feather disable all

function scribble_get_tick()
{
    static _system = __ScribbleSystem();
    return _system.__ticks;
}