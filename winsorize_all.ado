capture program drop winsorize_all

program winsorize_all, rclass
	version 10
	syntax varlist [if] [in], [ nocompress force(varlist) debug ]

  if "`compress'" == "" compress

  local varlist: list uniq varlist

  if `"`force'"' != `""' {
    fvunab force: `force'
    local force: list uniq force
  }

  if `"`if'"' == `""' local if if 1

  if "`debug'" != "" {
    quietly count `if'
    display `"Winsorizing `varlist'"'
    display `"    Found `=r(N)' observations using if: `if'"'
  }

  foreach v of local varlist {
    if ("`: type `v''" == "float") | ("`: type `v''" == "double") | (`: list v in force'){
      _pctile `v' `if' `in', nq(1000)
      if (r(r9) == r(r991)) {
        display "{txt}`v' (`: type `v'') is NOT winsorized but .1% == 99.9% == " r(r9)
      }
      else if ((r(r999) != r(r991)) | (r(r1) != r(r9))) {
        display "{err}`v' not winsorized:", _continue
        if (r(r1) != r(r9)) {
          display "{err} (" r(r1) "!=" r(r9) ")", _continue
          quietly replace `v' = max(`v', r(r10)) `if' & !missing(`v')
        }
        if (r(r999) != r(r991)) {
          display "{err} (" r(r999) "!=" r(r991) ")", _continue
          quietly replace `v' = min(`v', r(r990)) `if' & !missing(`v')
        }
        display // end line from above
        /* winsor2 `v' `if' `in', replace cuts(1 99) */
      }
      else {
        display "{txt}`v' (`: type `v'') is winsorized"
      }
    }
    else {
      display "{res}Skipping `v' (`: type `v'')"
    }
  }

end
