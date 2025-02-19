# Grep, Find, Sed and Awk

## Description

## Prerequisites

None

---

This tutorial looks at a few different tools which are useful for dealing with files in Linux environments. Here are the tools and their basic uses.

- **Grep** - A tool for finding text within a file (or other stream). It accepts regular expressions and so is very flexible.
- **Find** - A tool for finding files based on their name.
- **Sed** - **s**tream **ed**itor. A utility for finding and replacing strings.
- **AWK** - An extremely powerful, but tricky to use programming language for editing text data. AWK is actually turing complete so the possibilities are endless.

## Getting Text to Edit

In order to get the most out of text editing tools, we need some text to edit. I have put the first chapter of James Joyce's Finnegan's Wake into a txt file which can be downloaded using wget.

```bash
$ wget https://raw.githubusercontent.com/SCEBE-Technicians/enucc-tutorials/refs/heads/main/docs/assets/finnegans_wake.txt
```

## Finding text with grep

The first tool we'll look at is grep. It is a piece of software which lets you search for strings which match a regular expression. We use grep by piping the output of another command into grep or by redirecting a file's contents. Here are the two methods in action.

```bash
cat finnegans_wake.txt | grep the
grep the <finnegans_wake.txt
```

Those examples are quite simple, we're searching for the word "the" in the text. Unfortunately, since "the" is interpreted as a regular expression rather than as a word, words like "other" "theology" or ""there" will also be returned. However, "The" will not be matched since regex are case sensitive. We need to do some more work.

In regular expressions "\b" is used to signify the word boundary which will be either the space character, " ", the start of a line or the end of a line. We can also specify that we want to match either "t" or "T" by putting them in square brackets: "[Tt]". A better grep for the word "the" is:

```bash
grep "\b[Tt]he\b" <finnegans_wake.txt
```

We can also pass flags to grep to change its behaviour. Two useful flags are "-v" and "-c". "-v" will invert the result so that only lines that don't match the provided regex are shown. "-c" will suppress the normal output and return a count of the number of lines in which the pattern occurs. Here is a grep command to count the number of lines which don't contain the word "the".

```bash
grep -v "\b[Tt]he\b" <finnegans_wake.txt -c
```

```bash
grep another finnegans_wake.txt
```

```bash
grep -v "\b[Tt]he\b" <finnegans_wake.txt | grep another
```

## Finding files with find

```bash
find ./ -name "*.txt"
```

## Editing text with sed

```
grep Edenborough <finnegans_wake.txt | sed s/Edenborough/Edinburgh/
```

```bash
sed s/Edenborough/Edinburgh/g <finnegans_wake.txt >finnegans_new.txt
```

```bash
grep Edinburgh <finnegans_new.txt
```

```bash
head -n 1 <finnegans_wake.txt | sed s/e/a/
```

```bash
head -n 1 <finnegans_wake.txt | sed s/e/a/g
```

## Editing text with AWK
```bash
$ awk 'BEGIN { print "Hello world!" }'
```

```bash
$ awk 'NR < 10 {print $0}' <finnegans_wake.txt
```

```bash
$ awk 'NF < 10 {print $0}' <finnegans_wake.txt
```

```bash
$ awk 'NF < 10 {print NR ": " $0}' <finnegans_wake.txt
```

```bash
$ awk 'NF < 10 && NF > 0 {print NR ": " $0}' <finnegans_wake.txt
```

```bash
$ awk '\
BEGIN { count = 0 }
NF < 10 && NF > 0 { count += 1}
END { print count }
` < finnegans_wake.txt
```

```bash
$ grep place <finnegans_wake.txt -n | awk -F ':' '1 { print $1}'
```

