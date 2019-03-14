capture program drop winsorize_all

program winsorize_all, rclass
	version 10
	syntax varlist [if] [in], [ nocompress ]

  if "`compress'" == "" compress

  foreach v of local varlist {
    if ("`: type `v''" == "float") | ("`: type `v''" == "double"){
      local if
      _pctile `v' `if' `in', nq(1000)
      if (r(r9) == r(r991)) {
        display "{txt}`v' (`: type `v'') is NOT winsorized but .1% == 99.9% == " r(r9)
      }
      else if ((r(r999) != r(r991)) | (r(r1) != r(r9))) {
        display "{err}`v' not winsorized:", _continue
        if (r(r999) != r(r991)) {
          display "{err} (" r(r999) "!=" r(r991) ")", _continue
        }
        if (r(r1) != r(r9)) {
          display "{err} (" r(r1) "!=" r(r9) ")", _continue
        }
        display // end line from above
        winsor2 `v' `if' `in', replace cuts(1 99)
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
