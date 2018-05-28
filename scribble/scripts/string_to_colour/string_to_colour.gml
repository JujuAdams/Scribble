/// @description string_to_colour( name )
/// @param name

switch( string( argument0 ) ) {
    
    case "c_test": return make_colour_rgb( 100, 150, 200 ); break;
    
    case "c_aqua":    return c_aqua;    break;
    case "c_black":   return c_black;   break;
    case "c_blue":    return c_blue;    break;
    case "c_dkgray":  return c_dkgray;  break;
    case "c_fuchsia": return c_fuchsia; break;
    case "c_green":   return c_green;   break;
    case "c_lime":    return c_lime;    break;
    case "c_ltgray":  return c_ltgray;  break;
    case "c_maroon":  return c_maroon;  break;
    case "c_navy":    return c_navy;    break;
    case "c_olive":   return c_olive;   break;
    case "c_orange":  return c_orange;  break;
    case "c_purple":  return c_purple;  break;
    case "c_red":     return c_red;     break;
    case "c_silver":  return c_silver;  break;
    case "c_teal":    return c_teal;    break;
    case "c_white":   return c_white;   break;
    case "c_yellow":  return c_yellow;  break;
    
    default: return noone; break;
    
}

