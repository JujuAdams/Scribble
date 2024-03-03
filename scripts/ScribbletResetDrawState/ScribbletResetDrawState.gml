// Feather disable all

/// Convenience function to reset GameMaker's native draw state.

function ScribbletResetDrawState()
{
    draw_set_font(-1);
    draw_set_colour(c_white);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}