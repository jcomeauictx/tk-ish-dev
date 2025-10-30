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

# solution

the problem was, no fonts are installed by default, and the python3-tkinter
package doesn't have any as a prerequisite. so you must install one or more.
I used `apk add unifont` and, sure enough, running `python3 -m tkinter` worked
immediately.
