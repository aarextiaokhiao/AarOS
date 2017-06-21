# AarOS

The AarOS program starts with cell 1 and upper-left corner. The program can be terminate by either moving to outside of the code or moving to @. Every cell starts with 0 each time AarOS program start.

# Commands

* \+ - Increase the current cell by 1.
* \- - Decrease the current cell by 1.
* \> - Turn the pointer to east.
* < - Turn the pointer to west.
* ^ - Turn the pointer to north.
* v - Turn the pointer to south.
* L - Move into previous cell.
* R - Move into next cell.
* " - String literal. When moving to next ", all characters are converted to ASCII values then putted to the cells, while first letter is in current cell.
* \\* - Start of string literal.
* *\\ - End of string literal. Same as " did.
* A - Pop the next cell and add with the current cell.
* M - Pop the next cell and subtract with the current cell.
* P - Pop the next cell and multiply with the current cell.
* D - Pop the next cell and divide by it from the current cell.
* / - Pop the next cell and modulus by it from the current cell.
* S - Skip a next command.
* I - If the current cell is not 0, then skip a next command.
* . - Input to the cell from a character.
* , - Output from the cell to a character.
* % - Output from the cell to a number.
* & - Remove the cell.
* @ - End program.
* Everything else - NO-OP.

# Changelog
* 1.0 - Release.
* 0.0 - Started this git.
* P1.1 - Added commands and first digraph commands
* P1.0 - Initial plan.
