function StringDecompose(_string)
{
    var _glyphArray = [];
    global.__StringDecompose_glyphArray = _glyphArray;
    
    string_foreach(_string, function(_character, _index)
    {
        array_push(global.__StringDecompose_glyphArray, ord(_character));
    });
    
    return _glyphArray;
}