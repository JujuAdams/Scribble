enum SCRIBBLE_FONT_GROUP
{
    FALLBACK,
    BASIC_LATIN,
    EXTENDED_LATIN,
    GREEK,
    CYRILLIC,
    CHINESE_SIMPLIFIED,
    CHINESE_TRADITIONAL,
    KOREAN,
    JAPANESE,
    HEBREW,
    ARABIC,
    THAI_C90,
    KRUTIDEV,
    //...
    __SIZE, //Do not delete! Insert new groups before __SIZE
}

function __scribble_config_glyph_index_to_font_group(_glyph_index)
{
    if ((_glyph_index >= 32) && (_glyph_index <= 127)) //ASCII Latin
    {
        return SCRIBBLE_FONT_GROUP.BASIC_LATIN;
    }
    
    if ((_glyph_index >= 128) && (_glyph_index <= 591)) //Extended Latin, including punctuation
    {
        return SCRIBBLE_FONT_GROUP.EXTENDED_LATIN;
    }
    
    if ((_glyph_index >= 880) && (_glyph_index <= 1023)) //Greek
    {
        return SCRIBBLE_FONT_GROUP.GREEK;
    }
    
    if ((_glyph_index >= 1024) && (_glyph_index <= 1279)) //Cyrillic
    {
        return SCRIBBLE_FONT_GROUP.CYRILLIC;
    }
    
    if ((_glyph_index >= 1424) && (_glyph_index <= 1535)) //Hebrew
    {
        return SCRIBBLE_FONT_GROUP.HEBREW;
    }
    
    if (((_glyph_index >=  1536) && (_glyph_index <=  1791))  //Arabic
    ||  ((_glyph_index >=  8216) && (_glyph_index <=  8217))  //Arabic quotation marks
    ||  ((_glyph_index >= 65136) && (_glyph_index <= 65279))) //Arabic Presentation Forms B
    {
        return SCRIBBLE_FONT_GROUP.ARABIC;
    }
    
    if (((_glyph_index >=  3584) && (_glyph_index <=  3711))
    ||  ((_glyph_index >= 63232) && (_glyph_index <= 63258))) //Thai C90
    {
        return SCRIBBLE_FONT_GROUP.THAI_C90;
    }
    
    var _krutidev_index = _glyph_index - SCRIBBLE_DEVANAGARI_OFFSET;
    if (_krutidev_index >= 0)
    {
        if (((_krutidev_index >= 32) && (_krutidev_index <= 255))
        ||  (_krutidev_index ==  338)
        ||  (_krutidev_index ==  362)
        ||  (_krutidev_index ==  402)
        ||  (_krutidev_index ==  710)
        ||  (_krutidev_index == 8211)
        ||  (_krutidev_index == 8212)
        ||  (_krutidev_index == 8218)
        ||  (_krutidev_index == 8222)
        ||  (_krutidev_index == 8224)
        ||  (_krutidev_index == 8225)
        ||  (_krutidev_index == 8230)
        ||  (_krutidev_index == 8240)
        ||  (_krutidev_index == 8249))
        {
            return SCRIBBLE_FONT_GROUP.KRUTIDEV;
        }
    }
    
    return SCRIBBLE_FONT_GROUP.FALLBACK;
}

function __scribble_config_font_group_to_glyph_range(_fontGroup)
{
    switch(_fontGroup)
    {
        case SCRIBBLE_FONT_GROUP.BASIC_LATIN:         return [  32,  127]; break;
        case SCRIBBLE_FONT_GROUP.EXTENDED_LATIN:      return [ 128,  591]; break;
        case SCRIBBLE_FONT_GROUP.GREEK:               return [ 880, 1023]; break;
        case SCRIBBLE_FONT_GROUP.CYRILLIC:            return [1024, 1279]; break;
        case SCRIBBLE_FONT_GROUP.HEBREW:              return [1424, 1535]; break;
        case SCRIBBLE_FONT_GROUP.CHINESE_SIMPLIFIED:  break;
        case SCRIBBLE_FONT_GROUP.CHINESE_TRADITIONAL: break;
        case SCRIBBLE_FONT_GROUP.KOREAN:              break;
        case SCRIBBLE_FONT_GROUP.JAPANESE:            break;
        case SCRIBBLE_FONT_GROUP.ARABIC:              return [[1536, 1791], [8216, 8217], [65136, 65279]]; break;
        case SCRIBBLE_FONT_GROUP.THAI_C90:            return [[3584, 3711], [63232, 63258]]; break;
        case SCRIBBLE_FONT_GROUP.KRUTIDEV:            return [[32, 255], 338, 362, 402, 710, 8211, 8212, 8218, 8222, 8224, 8225, 8230, 8240, 8249]; break;
    }
    
    return [];
}