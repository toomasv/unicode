# unicode

Needs`range.red` at https://gist.github.com/toomasv/0e3244375afbedce89b3719c8be7eac0
and also `dingbats` and `symbols` from this repo.

Uses some unicode-rich fonts - "Code2003" "EversonMono" "Lucida Sans Unicode" "Symbola" "Tahoma" "Unifont".

## usage

```
do %unicode.red
unicode 'all-symbols
```

Results in

```
List of symbols:
Adi shakti
Alembic
Alternate one-way left way traffic
Anchor
...
```

Then, e.g.

```
unicode "Adi shakti"
;== [#"☬"]
```

To see list of pages

```
unicode 'pages
```

Results in 

```
List of pages:
scripts
   latin
   ascii
   latin-1_supplement
...
symbols
   punctuation
   currency
   letterlike
...
collections
   weather
   pointing
   religion
...
```

To see list of sympbols of specific page

```
unicode 'weather
```

To open specific page

```
unicode/chart 'ascii
```

To open charts at start:

```
unicode 'show
```
