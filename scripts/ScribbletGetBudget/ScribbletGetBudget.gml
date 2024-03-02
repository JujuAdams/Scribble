// Feather disable all

/// Returns the Scribble compilation time budget.

function ScribbletGetBudget()
{
    static _system = __ScribbletSystem();
    return _system.__budget;
}