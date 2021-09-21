<!--
%\VignetteEngine{tinymarkdown::mdweave_to_html}
%\VignetteIndexEntry{Using tinymarkdown as a vignette engine}
-->
---
title: Using tinymarkdown as a vignette engine
author: Jan van der Laan
css: "dark.min.css"
---



To use tinymarkdown as an engine for your package vignettes you will need to do the following:

### Specify tinymarkdown as your vignette builder in your `DESCRIPTION` file:

```
VignetteBuilder: tinymarkdown
```

### Add tinymarkdown as a dependency of your package. 

If your package doesn't use tinymarkdown otherwise
you can add it to your `Suggests` field in the `DESCRIPTION` file:

```
Suggests: 
    tinymarkdown
```

### Use the extension `.md` for your vignette.

Create the vignette in the `vignettes` directory in your 
package source.

### Specify the vignette engine in your vignette. 

You have to add the following line to your vignette:

```
%\VignetteEngine{tinymarkdown::mdweave_to_html}
```

Instead of `mdweave_to_html` you can also use `mdweave_to_pdf` to generate a vignette in PDF format. 
It is easiest to do this in a comment section in your markdown file. For example, start your 
markdown file with:

```
<!--
%\VignetteEngine{tinymarkdown::mdweave_to_html}
%\VignetteIndexEntry{The title of the vignette}
-->

---
title: [The title of the vignette]
---

[And the contents of your vignette]
```


## Custom styling

By default the default templates and styling of the pandoc installation on your machine 
will be used.  However, you can also specify custom styling in the header of your markdown
file. See the [documentation of Pandoc](https://pandoc.org/MANUAL.html) for more 
information. For example, if you generate HTML output and you want to use a curstom
CSS-stylesheet, you can place the stylesheet in the `vignettes` directory and 
refer to the stylesheet in the header:

```
<!--
%\VignetteEngine{tinymarkdown::mdweave_to_html}
%\VignetteIndexEntry{The title of the vignette}
-->

---
title: [The title of the vignette]
css: custom_styling.css
---
```


