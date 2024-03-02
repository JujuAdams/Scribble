// Feather disable all

/// Sets the time budget for compilation.
/// 
/// @param milliseconds

function ScribbletSetBudget(_milliseconds)
{
    static _system = __ScribbletSystem();
    _system.__budget = _milliseconds;
}