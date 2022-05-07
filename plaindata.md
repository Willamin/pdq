# PlainData

The PlainData (PD) format has a few goals:

* allow for storing data in plain text files
* minimal platform dependencies to read/write to the files
    * PDQ is a provided helper tool, but programs that are bundled with most OSes could be used to write your own helper tool in a pinch
* leverage existing syntax affordances when special syntax is needed
* expect data parsing and writing to be done with other programs

## Similarities

Essentially, PD can be thought of as a mix between a few other formats. 

It's much like the Mulitipart content type: PD joins what could be multiple files into a single file. PD's goals are such that they could similarly be met with a directory containing a text file and a few files formatted as CSV, JSON, TSV, or similar machine-parsable data files. There's a convenience that comes with bundling many files into a single file as evidenced by the tar and zip formats, inline-able scripts, styles, and base64-encoded images in HTML, and many markdown parsers' frontmatter for metedata.

## Format

A PD formatted file consists of a list of sections, each with a name. To denote the end of the current section and the beginning of a new section, a line containing two open brackets (`[[`), the name of the new section, and two close brackets (`]]`) is used. The name used can contain spaces. There may be spaces between either pair of brackets and the name, but when parsed by PDQ, these will be stripped.

There should be only one section with a given name. If two sections exist with the same name (after stripping leading and trailing whitespace), behavior of parsers is undefined. 

The first section is special. It does not have a name, nor does it begin with the bracketed line that all other sections do. This unnamed, first section is intended to be used as a description for the data contained in the file. If this is unnecessary, one could start the file with a bracketed line to immediately denote the start of the first named section. Due note: this isn't the same as a section with the name "description". 

The format contained in each section is free for the author to choose, though text-based formats and formats that are parsable with widely available command-line tools are strongly encouraged. 

## Sample

```
These are the purchase records of a small fictional bookshop. The sections should all be formatted with one record per line, with fields separated by a pipe character (|), intended to be filtered and queried with tools like cut.

The Books section has the columns: ISBN, Title, Author
The Purchases section has the columns: ISBN, Price, Date

[[ Books ]]
9789381529614 | Lord of the Flies | William Golding
9780141192451 | Treasure Island | Robert Louis Stevenson
9780486424538 | Oliver Twist | Charles Dickens
9780060934347 | Don Quixote | Miguel De Cervantes
9781411469389 | 1984 | George Orwell
9780486278070 | The Picture of Dorian Gray | Oscar Wilde

[[ Purchases ]]
9780486424538 | 6.00 | May 06, 2022
9781411469389 | 4.00 | May 08, 2022
9780141192451 | 7.00 | May 08, 2022
9780060934347 | 5.50 | May 13, 2022
9780141192451 | 7.00 | May 13, 2022
9780060934347 | 5.50 | May 15, 2022

```

## Inspiration

My inspiration in a very broad sense comes from [GNU Recutils](https://www.gnu.org/software/recutils/), which are a series of tools to make it easier to write and query plaintext databases called recfiles. The recfile format (and tools) felt a bit heavier than I ever needed, but seem incredibly useful in their own right. 

It's small, but I feel it's worth noting that the bracket syntax used to denote new sections is drawn from TOML's array of tables syntax.

