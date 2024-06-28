function StringHebrewParse(_string)
{
    var _glyphArray = StringDecompose(_string);
    array_push(_glyphArray, 0x00);
    GlyphArrayBiDiReorder(_glyphArray, true, false);
    return StringRecompose(_glyphArray, false);
}