# dict.sh
Translate with style


# Demo

## plain selector

default UI: recommended for CLI user

![plainsel](https://user-images.githubusercontent.com/61080/98447662-988f3b00-2161-11eb-8600-18eef9cfed29.gif)

## dmenu selector

suggested solution for GUI user

![dmenu](https://user-images.githubusercontent.com/61080/98230730-71d0d900-1f96-11eb-99f2-6f846dd21986.gif)


## fzf selector

if you prefer fzf

![fzf](https://user-images.githubusercontent.com/61080/98230751-7b5a4100-1f96-11eb-904f-d3dbbfa6d787.gif)



# Requirement:

  * curl
  * any nerdfont for display icons
  * afplay/ffplay for pronouncication


# Installation:

```sh
git clone --depth 1 https://github.com/klesh/dict.sh.git
cd dict.sh
sudo make install
```

# Usage

## Terminal

```sh
d hello world
```

fzf selector:
```sh
export D_SELECTOR='fzf --reverse --height=30%%'
d hello world
```

plainsel selector:
```sh
export D_SELECTOR='plainsel'
d hello world
```

## Translate selected with dwm 

make sure `dmenu` and `xsel` are installed and add following configuration to your dwm `config.h`

```c
static const char *dictcmd[]  = { "d", "$(xsel -o)", NULL };

static Key keys[] = {
	....
	{ MODKEY,                       XK_d,                       spawn,          {.v = dictcmd} },
	...
```


