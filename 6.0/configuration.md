Scribble has two scripts that are used to configure the library. **You should edit these scripts to customise Scribble for your own purposes.**

1. [`__scribble_macros()`](__scribble_macros)

2. [`scribble_reset()`](scribble_reset)

[`__scribble_macros()`](__scribble_macros) contains static properties that control various internal behaviours. It is not necessary to call [`__scribble_macros()`](__scribble_macros) in your code at any point ([macros](https://manual.yoyogames.com/GameMaker_Language/GML_Overview/Variables/Constants.htm) are handled at compile time by GameMaker).

[`scribble_reset()`](scribble_reset) resets Scribble's state to whatever values are held inside this script. This function is called once by [`scribble_init()`](scribble_init) to initialise the library, and you can (and should!) use it yourself whenever resetting the draw state.