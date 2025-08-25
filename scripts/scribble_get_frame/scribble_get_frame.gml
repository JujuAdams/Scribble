// Feather disable all

function scribble_get_frame()
{
    static __scribble_state = __scribble_system().__state;
    return __scribble_state.__frames;
}