// Feather disable all

/// Sets the time budget for compilation.
/// 
/// @param milliseconds

function ScribbleSetBudget(_milliseconds)
{
    static _system = __ScribbleFastSystem();
    _system.__budget = _milliseconds;
}