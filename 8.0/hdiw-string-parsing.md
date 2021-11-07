# String Parsing

&nbsp;

Parsing is the process by which a string is broken down into its component parts. At its core, Scribble breaks down strings into glyphs. However, each glyph has a lot of additional data associated with it, data that is determined by the use of [formatting tags](text-formatting). Scribble also supports [typewriter events](hdiw-typewriter-and-events) and these need to be parsed too.

Writing a parser in GameMaker using the `string_*()` functions is straight-forward (with the exception of 1-indexed strings 🙄). However, these functions are _horrifically_ slow. When we call a function like `string_delete()`, GameMaker returns a string. This string is a block of data that GameMaker has to allocate, and allocating memory is, unfortunately, a slow operation. This doesn't sound like too big of an issue until you consider that this may need to happen hundreds of times per string!

Additionally, [characters in a string might be encoded using a different number of bytes](hdiw-what-even-is-a-string-anyway). GameMaker's string operations all work with the raw binary data. When we refer to e.g. the 4th character in a string, GameMaker doesn't know whether the 4th character starts at byte 4 or at byte 13. If we want to split a string at a specific point, GameMaker has to iterate over at least part of the string, figuring out exactly where to split the binary data. For one-off functions this is fine, but it's incredibly inefficient when working with large strings that need to be chopped up a lot.

Scribble needs to be _fast_ and the `string_*()` functions don't cut the mustard. We do, however, have an alternative - handle the binary ourselves. We can write our string into a buffer and then iterate over the binary in that buffer in a single, elegant pass. It saves on GameMaker's string reallocation and it saves on repeatedly iterating over the same data, figuring out where each character starts and ends. And, in a gentle stoke of mercy, [UTF-8](hdiw-what-even-is-a-string-anyway) is actually really easy to decode.

?> If you're unfamiliar with buffers, take a look at [GameMaker's documentation](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Buffers/Buffers.htm) on the matter. Additionally, DragoniteSpam has a [good video](https://www.youtube.com/watch?v=xfUcVqEtYz4) on the topic.

Scribble's parser is built like so:

- Create a buffer, and write the UTF-8-encoded string into it
- Create a data structure to store per-glyph data. Scribble uses a ds_grid for this
- Create an array for event data to go into
- Set our parser state to "not in a command tag"
- Start a loop that iterates over the buffer
  - Read a character from the buffer, following UTF-8 decoding rules
  - If the character is a null (`0x00`) then we've found the end of the string. Break out of the loop
  - If we're not in a command tag:
    - If we've seen a `[` symbol (and the previous character wasn't a `[`) then we've entered into a command tag
	  - Reset our tag parameter count to 1
	  - Record the byte position of the start of the command tag's content
	  - Set our state to "inside a command tag". Do another iteration of the loop
	- If we've seen a whitespace character (newline `\n`, tab `\t`, or space) then write that character into the grid. Do another iteration of the loop
	- If we've seen any other Unicode character, write that character into the grid. Do another iteration of the loop
  - If we _are_ in a command tag:
    - If the character is a comma `,`, replace the comma with a null (`0x00`) and increment our parameter count for this command tag. Do another iteration of the loop
	- If the character is anything _but_ a `]` symbol then ignore it. Do another iteration of the loop
	- If the is a `]` symbol then we've found the end of the command tag
	  - Jump back to the start of the command tag. For each parameter that we've found (number of commas plus 1), read a substring using `buffer_string`, and add it into an array
	  - Look up what kind of command is inside the tag, and execute behaviour code accordingly. If the command is an event, add the event to an array and record the where in the string the event should be executed
	  - Do another iteration of the loop

