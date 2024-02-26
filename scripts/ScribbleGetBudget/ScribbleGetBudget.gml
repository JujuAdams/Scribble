// Feather disable all

/// Returns the Scribble compilation time budget.

function ScribbleGetBudget()
{
    static _system = __ScribbleFastSystem();
    return _system.__budget;
}