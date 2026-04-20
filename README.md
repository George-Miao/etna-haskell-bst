# etna-haskell-bst

Binary search tree workload for [Etna](https://github.com/alpaylan/etna-cli),
implemented in Haskell with QuickCheck, SmallCheck, and LeanCheck
strategies.

## Usage

```bash
etna workload add https://github.com/alpaylan/etna-haskell-bst
```

The shared `etna-lib` support library is included as a git submodule at
`./etna-lib`. When cloning outside the `etna` CLI, remember to
`git clone --recurse-submodules`.
