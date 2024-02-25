// Feather disable all

/// @param state

function ScribbleSetCompile(_state)
{
    static _system = __ScribbleFastSystem();
    _system.__compile = _state;
}