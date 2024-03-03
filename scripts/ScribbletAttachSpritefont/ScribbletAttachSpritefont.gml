// Feather disable all

/// @param font
/// @param proportional
/// @param separation

function ScribbletAttachSpritefont(_font, _proportional, _separation)
{
    static _system = __ScribbletSystem();
    _system.__spriteFontData[$ font_get_name(_font)] = {
        __proportional: _proportional,
        __separation:   _separation,
    };
}