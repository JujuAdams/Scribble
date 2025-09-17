// Feather disable all

function __scribble_get_font_data(_name)
{
    static _fontDataMap = __scribble_system().__fontDataMap;
    var _data = _fontDataMap[? _name];
    if (_data == undefined)
    {
        var _string = "Font \"" + string(_name) + "\" not recognised";
        
        if (__scribble_system().__gmMightRemoveUnusedAssets)
        {
            _string += "\nThis may mean GameMaker has stripped assets during compile.\n \nThere are two solutions available:\n1. Add the \"scribble\" tag to every asset (font, sprite, sound, etc.) you want to use in Scribble\n    then set `SCRIBBLE_DETECT_MISSING_ASSETS` to `false` to turn off this warning;\n \n2. or untick \"Automatically remove unused assets when compiling\" in Game Options";
        }
        
        __scribble_error(_string);
    }
    
    return _data;
}