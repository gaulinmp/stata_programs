# Stata Programs
By [Mac Gaulin](http://mgaulin.com)

Repo of convenient Stata programs.

## Overview

```winsorize_all.ado```: Program that winsorizes all continuous variables. Uses variable type as an indicator, and compares 999th percentile to max (same with min) to determine whether data are winsorized. Hardcoded to winsorize at top and bottom 1%. ***Note:** This program also compresses your dataset.* You should know what that does before running this and overwriting anything.

```wsum.ado```: Program summarizes variables (like `summarize *`), but allows the whole variable name to be shown (no truncating ~ nonsense), and allows sorting of variable list via `sort` option.


## Installation

Clone repo to some directory. Could be your PERSONAL directory. Could be not.

```sh
git clone https://github.com/gaulinmp/stata_programs.git
```

Optionall add to your profile.do:

```stata
sysdir set PERSONAL "C:\Users\thisguy\source\stata_programs"
```

which will set your PERSONAL ado-path to this repo.
