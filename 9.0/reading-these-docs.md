# Reading These Docs

&nbsp;

Scribble's documentation is written in a "feature first" style. The sidebar contains a number of topics that relate to the implementation of features. Each page is separated into a number of subheadings, each describing part of Scribble's API that relate to that feature.

Features can be interacted with in three ways:

1. **Global functions** are standard GameMaker functions that modifies Scribble's state everywhere.

2. **Text element methods** are called by executing the named function on a struct returned by `scribble()`.

3. **Command tags** are instructions that are passed to Scribble by inserting them into a string that's being drawn.