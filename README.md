<h1 align="center">
CC-LCI
</h1>
<h2 align="center">
A LOLCODE interpreter for CCLua
</h2>

**NOTE:** The interpreter as is stands at the current moment in time is non-functional, and as such the features discussed below are purely theoretical and are subject to changes at any time.

## About
*CC-LCI* stands for Computercraft LOLCODE Interpreter. It is designed as a comprehensive LOLCODE interpreter for CC 1.79 using the specification for LOLCODE version 1.3. Please note that as there is no official specification for LOLCODE 1.3 this may differ from official intentions for the direction of LOLCODE 1.3.

## Usage
To use *CC-LCI* for CC 1.79 all you (should) have to do is run the following code
```
pastebin get {NO CODE YET} lci
```
This will download and create a file named `lci` which nicely bundles all of the source files together into a single easy to use file.

### CLI
Just running `lci` from your shell will bring up an interactive LOLCODE interpreter from where you can experiment with LOLCODE.
There are also several other ways to use *CC-LCI* from the commandline.

**Syntax**
```
lci [-hqd] [-l <logfile>] [--help|--quiet|--debug|--log <logfile>] [sourcefile]
```
 Option | Alias | Description
--------| ----- | -----------
`sourcefile` | | Relative path to the *LOLCODE* file the interpreter will read from
`--help` | `-h` | Prints out a help page 
`--quiet` | `-q` | Silences the interpreter from printing `VISIBLE` statements
`--debug` | `-d` | Provides detailed information about what the interpreter is doing
`--log` | `-l` | Exports whatever is printed to the console to the specified `logfile`