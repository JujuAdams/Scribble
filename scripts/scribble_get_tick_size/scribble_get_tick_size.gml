// Feather disable all

/// Returns the tick size as set by `scribble_set_tick_size()`. If you set the tick size to
/// `undefined` then this function will return `undefined`.

function scribble_get_tick_size()
{
    static _system = __scribble_system();
    return _system.__userTickSize;
}