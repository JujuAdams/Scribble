// Feather disable all

/// Returns the Scribble compilation time budget.

function ScribbletGetBudgetUsed()
{
    static _system = __ScribbletSystem();
    return _system.__budgetUsedPrev;
}