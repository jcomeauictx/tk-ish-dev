# tk-ish-dev

libtk, whether called from python3-tkinter or from wish, segfaults on the
iSH app, and as later verified, on the alpine:3.14.3 Docker image.

this repo is for tracking down the bug and fixing it.

steps to reproduce on Alpine 3.14.3:
```
c2c75a9a29fc:~$ echo 'label .dash -text "-"' | wish
Cannot find a usable font
Aborted (core dumped)
```
([sample wish code](opensource.com/article/23/4/learn-tcltk-wish-simple-game))

you can also `xtrace` it, but you have to build the
[package](https://github.com/jcomeauictx/xtrace)
first on the target system. and I didn't find it to be of any real help
with the problem.

## solution

the problem was, no fonts are installed by default, and the python3-tkinter
package doesn't have any as a prerequisite. so you must install one or more.
I used `apk add unifont` and, sure enough, running `python3 -m tkinter` worked
immediately.

## followup

I just (2025-10-30-18:16:13 PDT) checked https://github.com/tcltk/tk and
found the latest version of tkUnixRFont.c has a check for
`if (!set || set->nfont == 0)`, so there's no need for me to submit a patch.
I'm not sure that will work as well as my `Tcl_Panic` call at getting across
to the user the need to install a font&mdash;it may just silently refuse to
add the Label, Button, or whatever&mdash; but I'll consider it out of my
hands now.
