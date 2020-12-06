/// @param spriteIndex        Sprite index to whitelist
/// @param [spriteIndex...]   Any additional sprite indexes to whitelist

function scribble_whitelist_sprite()
{
	var _i = 0;
	repeat(argument_count)
	{
		var _sprite = argument[_i];
    
		if (is_string(_sprite))
		{
		    show_error("Scribble:\nSprite index was a string but should be an asset index\n ", false);
		}
		else
		{
		    global.__scribble_sprite_whitelist_map[? _sprite] = true;
		}
    
		++_i;
	}

	global.__scribble_sprite_whitelist = true;
}