+++
title = "Getting started with Julia"
+++

# Getting started with Julia

\toc

## How to install Julia

### Juliaup

Julia installation is becoming extremely simple. Whether you work in Windows, Linux, or MacOS, the first step is to install [juliaup](https://github.com/JuliaLang/juliaup) (the fine details change by OS).

For apples:
```sh
brew install juliaup
```

For Linux users, on Arch, with `paru`:
```sh
paru juliaup
```

For Windows:
```sh
winget install julia -s msstore
```

### Julia

Once we have Juliaup, the next step is the same for everyone:

```sh
juliaup add release
```

## Choose an IDE

There's a variety of good IDEs to work with Julia. You may have them already. Some don't even need a separate installation.

The choice depends on personal taste, fashion trends, whether you mostly work locally or on a server, your mood, and the weather.

Options include:

- Code ([Visual Studio](https://code.visualstudio.com/) or its open source alternative [Codium](https://vscodium.com/))
- Vim / Neovim / LunarVim / Neovide, ...
- Emacs, ...
- [Jupyter](https://jupyter.org/) / JupyterLab
- [Pluto](https://github.com/fonsp/Pluto.jl) (this one is actually a package within Julia)

In the tutorial I'm probably going to show you Code and Pluto.

There's also the options of working directly from the REPL, and the Julia Package [`OhMyREPL`](https://kristofferc.github.io/OhMyREPL.jl/latest/) makes that experience much nicer.

## using

Julia syntax is similar to that of `Matlab`, indexing of arrays (by default) starts at 1, to load libraries you call them as `using LibraryName`.

## Work in Environments

Always, always, always, work in a project-dedicated environment. Working in environments is

1. EASY
2. REPRODUCIBLE

EASY: all it takes is having the following three lines at the start of your scripts

```julia
using Pkg
Pkg.activate(".") # where . is the project directory
Pkg.instantiate() # installs required packages, at the right version
```

REPRODUCIBLE: that is given by Julia automagically creating two important files for every environment, `Manifest.toml` and `Project.toml`. They contain detailed information about every package you installed in certain environment, their version, their dependencies, ...

More details in the official [Pkg documentation](https://pkgdocs.julialang.org/v1/environments/).

(we are going to look at this together)

## SysImages

Loading libraries may take some time. This is due to the fact that the code in Julia is Just-In-Time compiled, and that requires some extra work. Similarly, the *Time-to-first-plot* can be perceveid as high: the first time you call a function, say `plot(x,y)`, that *method* (function applied to certain types) is going to be compiled: this ensure that the second time you call the same method, its execution is going to be much faster (like, really, much faster, C like fast). More details [here](https://julialang.org/blog/2021/01/precompile_tutorial/). This *can* be mitigated  (if you perceive that as a bottleneck in your workflow). The trick is to use the library [`PackageCompiler`](https://julialang.github.io/PackageCompiler.jl/stable/), and we are going to show you an example together.