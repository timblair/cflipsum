# Introduction

CFLipsum is a simple component that uses the [lipsum.com](http://www.lipsum.com/) XML feed to generate placeholder Lorem Ipsum text.

# Basic Usage

    <cfset variables.generator = createobject("component", "LoremIpsum").init()>
    <cfset variables.lipsum = variables.generator.get_paragraphs(3)>

# Initialisation Parameters

There are two optional arguments that can be passed to the `init()` method of the LoremIpsum component (both are booleans):

* `start_with_lorem_ipsum` (default: `TRUE`) -- should the generated text start with the words 'Lorem ipsum'
* `use_local_cache` (default `FALSE`) -- should the local cache be used for same-type requests

# Lipsum Text Retrieval Functions

There are three methods for retrieving Lipsum text, depending on how much data you want returned.  All methods take a mandatory integer argument:

* `get_paragraphs(x)` -- returns `x` number of paragraphs
* `get_words(x)` -- returns `x` number of words
* `get_bytes(x)` -- returns `x` number of bytes (characters) of text

All functions return an `array` of paragraphs of text.  Note that `get_words` and `get_bytes` may also return multiple paragraphs, but the total content will be capped based on the function called and the provided limit.

# Caching

If you're going to be calling a given function a number of times, and you're not concerned with the text being different on each result, then setting the `use_local_cache` flag to `TRUE` when initialising the component.  This will cache the response of the specific combination of type (paragraphs, words or bytes) and amount of information to return.

As a brief example, here's some basic timings with and without caching turned on:

    100 requests of 1-3 paragraphs:
        Without caching: 6945ms (69.45ms/req)
	    With caching:     194ms ( 1.94ms/req)

# Download

You can [download the component](http://github.com/timblair/cflipsum/tree/master) from GitHub.  There is also a test file which gives other examples of basic usage, including caching.
