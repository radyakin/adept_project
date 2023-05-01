// Run ADePT project in batch mode
// 2023 Sergiy Radyakin, The World Bank

program define adept_batch

	version 13.0
	
	syntax, ///
	    [batchfile(string)] ///
	    projectfile(string) ///
	    outputfile(string) ///
	    tableslist(string) ///
	    [suppressse] ///
	    [run(string)]

	display as text "{break}"
	
	if (`"`batchfile'"'=="") & (`"`run'"'=="") {
		display as error "Error! Options {it:batchfile()} and {it:run()} cannot be both missing at the same time!"
		display as text "Specify the option {it:run()} pointing to the ADePT executable to run the batch task immediately, or specify the option {it:batchfile()} pointing to a new {it:*.ini} file somewhere to create an ADePT batch task file to be used later on."
		exit 199
	}	
	
	local se=!missing("`suppressse'")
	if (`"`batchfile'"'=="") tempfile batchfile
	
	tempname fw
	quietly file open `fw' using `"`batchfile'"', write text replace
	    file write `fw' `"[ADEPT_BATCH]"' _n
	    file write `fw' `"Project="`projectfile'""' _n
	    file write `fw' `"Output="`outputfile'""' _n
	    file write `fw' `"TablesList=`tableslist'"' _n
	    file write `fw' `"SuppressSE="`se'""' _n
	file close `fw'
	
	if !missing(`"`run'"') {
		
		capture confirm file `"`run'"'
		if _rc {
			display as error `"Error! ADePT executable file not present: {result:`run'}"'
			exit 601
		}
		
		capture confirm file `"`projectfile'"'
		if _rc {
			display as error `"Error! ADePT project file not present: {result:`run'}"'
			display as text `"An ADePT project file can be created with a command {cmd:adept_project_sp} (or equivalent for a different ADePT module)."'
			exit 601
		}
		
		capture confirm file `"`outputfile'"'
		if !_rc {
			display as result `"Warning! Output file already exists, deleting: {result:`outputfile'}"'
			erase `"`outputfile'"'
		}
		
		// Test if output can be created at the specified path:
		tempname fh
		file open `fh' using `"`outputfile'"', write text replace
			file write `fh' "TEST" _n
		file close `fh'
		
		confirm file `"`outputfile'"'
		erase `"`outputfile'"'		
		
	    shell "`run'" "`batchfile'"
		
	    capture confirm file `"`outputfile'"'
	    if _rc {
			display as error "Error! Output file was not produced."
	    }
	    else {
			display as text `"Success! Click {browse "`outputfile'" :here} to open the output file."'
	    }
	}

end

/* END OF FILE */
