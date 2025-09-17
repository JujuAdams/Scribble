// Feather disable all
/// @param newFontName

function scribble_super_create(_name)
{
    var _fontData = new __ScribbleClassFont(_name, 1, undefined, false, false, 0, 0);
    _fontData.__runtime   = true;
    _fontData.__superfont = true;
}
