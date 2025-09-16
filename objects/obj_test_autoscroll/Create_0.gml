// Feather disable all

maxWidth  = 216;
maxHeight = 266;

text = "";

var _i = ord("a");
repeat(26)
{
    repeat(10)
    {
        text += chr(_i);
    }
    
    text += "\n";
    ++_i;
}

text = string_copy(text, 1, string_length(text)-1);