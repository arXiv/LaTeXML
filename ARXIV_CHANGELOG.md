# Velocity arXiv Changes

arXiv tries to maintain a "friendly fork" where we mostly aim for experimentation speed,
while regularly reintegrating the upstream changes of the official LaTeXML project.

- This log file tracks changes as they land in arXiv,
with dates roughly matching the update date of the live arXiv toolchain.
- Related changes specific to the configuration of the arXiv worker are labeled `[arXiv worker]`.
- Changes which are not yet in upstream LaTeXML, or are diverged from LaTeXML, are marked `[PRE]`.

To track the main upstream LaTeXML development, please see its [Changes](https://github.com/brucemiller/LaTeXML/blob/master/Changes) file.

## velocity-v0.9-preview-3 (2025-17-12)

[arXiv/latexml commit pending](#)
based on [brucemiller/latexml commit](https://github.com/brucemiller/LaTeXML/commit/3875cd64faeb5bdc275d595cb6af772958a51080)

### Toolchain
- `[arXiv worker]` New minimal bindings for savetrees.sty.ltxml

### Added
- new support for `page` option of `\includegraphics`

### Changes
-  `[PRE]` patch for argument order of \Description in acmart.cls.ltxml
-  `[PRE]` Robust on raw perl value instead of register value (PR #2693)
-  `[PRE]` add \overunderset to amsmath.sty (PR #2687)
-  `[PRE]` implement actualtext, artifact from recent graphicx (PR #2684)

- update refactor for text underscore (PR #2704)
- arXiv-style bibtex emulation (.bbl then .bib) (PR #2683)
- better kernel emulation of space tokens, as well as `\meaning` and `\string`
- extra robustness patches avoiding Fatal conditions found in arXiv
- internal API changes
  - readingFromMouth
- updates to grffile.sty.ltxml, orcidlink.sty.ltxml, aastex, marvosym.sty.ltxml

## velocity-v0.9-preview-2 (2025-17-09)

### Toolchain 

- `[arXiv worker]` Enabled raw interpretation of all `.sty` files
- `[arXiv worker]` Enabled pre-compiled kernel support in latexml
   - Note: `.cls` files are still NOT interpreted raw and need a `.cls.ltxml` binding.
- `[arXiv worker]` Enabled `intent=":literal"` accessible annotations on all MathML Core formulas.

[brucemiller/latexml commit 25ec2b0](https://github.com/brucemiller/LaTeXML/commit/25ec2b0e9070cc05cbb5e5e22bebf5ba98a0d86c)

### Added
- new approach to emulating TeX's modes
- Added ARIA support via an `aria:` namespace in the binding layer.
  - Enabled `\Description` macro in acmart.cls.ltxml
- New orcidlink.sty.ltxml binding
- Support for pre-compiling the plain.tex and latex.ltx kernels
- Introduce color variables for inline style attributes 
  - allows CSS theming of nearly all author-specified colors
- enabled support for archived JATS output

### Changes
 - better treatment of TeX delimiters as parameters (`\big` and friends)
 - ironed out edge cases when creating subfigure panels
 - more patches to pgf math parsing
 - improved timing for expanding frontmatter material such as `\title`
 - patch to `\PassOptionsToPackage`
 - patches to import.sty.ltxml, IEEEtran.cls.ltxml, ntheorem.sty.ltxml, authblk.sty.ltxml
 - neutralized "breakable" mode in tcolorbox.sty.ltxml
 - filled in missing binding stubs for pgfkeys.sty.ltxml, pgfmath.sty.ltxml, pgfrcs.sty.ltxml
 - patched dependencies of microtype.sty.ltxml
 - patch to search directories when using --whatsin=directory on input
 - better treatment for control space `\ `
 - patches to argument signatures in `elsart*` bindings
 - patches to subfloat.sty.ltxml, dexluetable.sty.ltxml, aastex.cls.ltxml, amssymb.sty.ltxml, txfonts.sty.ltxml ...
 - many robustness patches from mid-scale release testing against arXiv sandboxes.
 - better emulation of `\ifcase`, `\parshape`, `{filecontents}`
 - update eTeX definitions to match version 2.6 

### Removed
- `[arXiv worker]` disabled all experimental math formats such as Content MathML or math lexemes. Now only emitting MathML Core.

## velocity-v0.9-preview-1 (2025-24-07)

### Toolchain
  - `[arXiv worker]` New minimal bindings for arydshln.sty.ltxml, atableau.sty.ltxml, aliascnt.sty.ltxml

[brucemiller/latexml commit 5e47b3b](https://github.com/brucemiller/LaTeXML/commit/5e47b3b13a386826581a31464083086520ca2817)

### Changes

- arXiv-specific
  - support for 00README.json directives
  - support for directory input
  - new guard: too many Warnings terminate conversion

- improved fidelity to plain.tex primitives
- Large reorganization and upgrade of the TeX kernel/engine
  - improved handling of accents and font maps, font encodings
  - improved handling of preloading and redefining macros
  - more consistent naming convention for latexml-specific control sequences
  - improved Expansion abstractions
  - improved unicode targets for some characters
  - better treatment of TeX comments
  - more consistent treatment of kerns
  - safer register allocation, e.g. `\newcount`
  - better `\everymath`, `\everydisplay` support
  - more consistent treatment of `\MakeUppercase` and `\MakeLowercase`
  - better treatment for setting and unsetting TeX boxes
- use Unicode's properties for enhanced decoding of math characters 

- patches to color mixing in xcolor.sty.ltxml
- patches to mathtools.sty.ltxml - better unicode target
- patches to pgfmath emulation
- much improved PGF emulation for bounding boxes and sizing
- much improved PGF and XY generation to SVG, especially foreign object placement and sizing
- patch to hyperref.sty.ltxml to avoid leaking color set in `\href`
- update to amscd.sty.ltxml to allow its horizontal connectors to stretch horizontally in MathML Core.
- update to latest iftex.sty.ltxml
- better conversion stability for `\bibitem`, `\bibsep`
- better conversion stability for `\patchcmd`
- patches to todonotes.sty.ltxml

- schema: `ltx:rule` allowed in more contexts
- patch to enable the "magnify" option of latexml.sty
- stability improvements to image post-processing

- improvements to MathML Core output dialect 
  - use `em` units in `<mo>` minsize, maxsize attributes
  - better treatment and tests of the operator dictionary 

And many minor cleanup commits of fidelity buglets reported by arXiv readers.

## arXiv update to LaTeXML v0.8.8 (2024-26-02)

See the [official LaTeXML release notes](https://github.com/brucemiller/LaTeXML/releases/tag/v0.8.8)

This is the initial reference point for the arXiv/LaTeXML previews.
