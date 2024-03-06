# Hound

---

## What is Hound?

The idea came from quicklinks feature in Raycast & Alfred where you have some predefined urls and you just enter a query and it'll send you to that url with the query appended. Hound is that ability but just in neovim. The nice-ness/difference here is that you have the option to create a query simply by highlighting text (vs higlight then yank).

## Installation

#### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```
{
    "adxmantium/hound",
    config = function()
		local hound = require("hound")

		hound.setup({
			sources = {
				{
					name = "go",
					url = "https://google.com/search",
				},
				{
					name = "so",
					url = "https://stackoverflow.com/search",
				},
                ...
			},
		})
    end
}
```

## Usage

There are currently 2 ways to query a source

1. Manually using the `:Hound` command

```
-- pseudo sample
:Hound [source name] [remaining text becomes part of query]

-- usage example
:Hound go how to get started with neovim
```

2. Query based on last yanked text

```
-- pseudo sample
(yank some text)
:Hound [source name]

-- usage example
(yank some text)
:Hound so
(stackoverflow open with yanked text as qsp
```

## Roadmap

1. Create query based on highlighted to cut out the step of yanking
