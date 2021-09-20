/// Tries to add all fonts in your project to Scribble

function scribble_font_add_all()
{
    //Ensure we're initialised
    __scribble_init();
    
    global.__scribble_autoscanning = true;
    
    var _i = 0;
    repeat(9999)
    {
        if (!font_exists(_i)) break;
        var _name = font_get_name(_i);
        if (string_copy(_name, 1, 9) != "__newfont") //Don't scan fonts created at runtime (e.g. by font_add_sprite())
        {
            scribble_font_add(_name);
        }
        
        ++_i;
    }
    
    global.__scribble_autoscanning = false;
}