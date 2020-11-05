# dict.sh
Translate with style

# Demo

## dmenu selector

suggested solution, especially with preselect and center patches

![dmenu](https://user-images.githubusercontent.com/61080/98230730-71d0d900-1f96-11eb-99f2-6f846dd21986.gif)



## fzf selector

if you prefer fzf

![fzf](https://user-images.githubusercontent.com/61080/98230751-7b5a4100-1f96-11eb-904f-d3dbbfa6d787.gif)


## plain selector

fallback UI, good enough with no dependency requirement

![default](https://user-images.githubusercontent.com/61080/98230687-654c8080-1f96-11eb-9f12-414ce55d3a55.gif)


# Requirement:

  * curl
  * any nerdfont for display icons
  * afplay/ffplay for pronouncication


# Installation:

```sh
git clone --depth 1 https://github.com/klesh/dict.sh.git
cd dict.sh
./d hello
```


# fzf as default selector:

  * sh/bash/zsh: `export D_SELECTOR='fzf --reverse --height=30%%'`
  * fish: `set -gx D_SELECTOR 'fzf --reverse --height=30%%'`
