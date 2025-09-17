// Feather disable all

maxWidth  = 200;
maxHeight = 85;

text = "";

var _i = ord("a");
repeat(26)
{
    repeat(5)
    {
        text += chr(_i);
    }
    
    text += "\n";
    ++_i;
}

text = string_copy(text, 1, string_length(text)-1);

scrollY = 0;
serialY = 0;

mousePrevX = undefined;
mousePrevY = undefined;