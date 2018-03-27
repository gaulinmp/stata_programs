/* -*- coding: utf-8 -*- */

// wsum program
capture program drop wsum
program wsum, rclass
	version 12
    syntax varlist(min=1 fv ts) [if] [in], ///
            [ sort ///
            stat_format(string asis) ///
            count_format(string asis) ///
            * ]
	
    *** This formats the inputs and sets up local variables.
    tokenize `varlist'
	
	if "`sort'" != "" local varlist: list sort varlist

	local max_str_len = 1
	foreach v in `varlist' {
		local i_str_len = strlen("`v'")
		if `i_str_len' > `max_str_len' local max_str_len `i_str_len'
	}

	quietly ///
	estpost summarize `varlist' `if' `in', detail

	if "`stat_format'"=="" local stat_format "(fmt(%12.3gc))"
	else local stat_format "(fmt(`stat_format'))"
	if "`count_format'"=="" local count_format "(fmt(%12.0gc))"
	else local count_format "(fmt(`count_format'))"

	esttab ., varwidth(`max_str_len') ///
		noobs nomtitles nonote nonumber ///
		collabels("Obs"            "Mean"            "Median"         "Std. Dev"      "Min"            "Max",) ///
		cells("count`count_format' mean`stat_format' p50`stat_format' sd`stat_format' min`stat_format' max`stat_format' ") ///
		`options'
	
end
// end wsum program
