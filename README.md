# huffman

This METAPOST package allows to draw binary Huffman trees from two
arrays : a string one, and a value one. It is based on METAOBJ package which
provides many tools to build trees in general.

_This package is in beta version, do not hesitate to report bugs, as well as
requests for improvement_.

## Github

To allow for easier feedback and bug reporting, this repository has a mirror
repository on github:
[https://github.com/chupinmaxime/huffman](https://github.com/chupinmaxime/huffman) 

## Installation

huffman is on the [ctan](ctan.org) and can be installed via the package manager of your
distribution [https://www.ctan.org/pkg/mpchess](https://www.ctan.org/pkg/huffman).

### With TeX live under Linux or MacOS

To install huffman with TeX live, you will have to create the directory texmf
directory in your home. 
```bash
user $> mkdir ~/texmf
```

Then, you will have to place the .mp files in the
`~/texmf/tex/metapost/huffman/`.

Once this is done, huffman will be loaded with the classic
```metapost
input huffman
```

### With MikTEX and Windows

These two systems are unknown to the author of MPchess, so we refer to their
documentation to add local packages:
[http://docs.miktex.org/manual/localadditions.html](http://docs.miktex.org/manual/localadditions.html)

## Dependencies

huffman depends on the packages METAPOST: `metaobj` and, if MPchess is not
used with LuaLaTeX and luamplib, `latexmp`.

## Documentation

* [English documentation](doc/huffman-doc-en.pdf)

## Contact

Maxime Chupin, `notezik(at)gmail.com`

## Licenses

This projet is under LATEX Project Public License 1.3c. 