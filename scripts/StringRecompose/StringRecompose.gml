function StringRecompose(_glyphArray, _copy = true)
{
    if (_copy) _glyphArray = variable_clone(_glyphArray);
    
    global.__StringRecompose_glyphArray = _glyphArray;
    
    array_foreach(_glyphArray, function(_element, _index)
    {
        global.__StringRecompose_glyphArray[@ _index] = chr(_element);
    });
    
    return string_concat_ext(_glyphArray);
}