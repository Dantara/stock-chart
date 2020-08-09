# Stock Chart

This application draws a ascii chart in a terminal of specified stock.

*NOTE*: This application is created for education purpose.

### Prerequisites

This project relies on the [Haskell Stack tool](https://docs.haskellstack.org/en/stable/README/).

It is recommended to get Stack with batteries included by
installing [Haskell Platform](https://www.haskell.org/platform/).

## Build

To build this project simply run

```sh
stack build
```

This will install all dependencies, including a proper version of GHC
(which should be there already if you have Haskell Platform 8.6.5).

## Run

This project has one executable that you can run with

```
stack exec stock-chart
```

During development it is recommended a combination of `build` and `exec`:

```
stack build && stack exec stock-chart-exe
```

