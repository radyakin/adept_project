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

	local se=!missing("`suppressse'")
	if (`"`batchfile'"'=="") tempfile batchfile
	
	tempname fw
	file open `fw' using `"`batchfile'"', write text replace
	    file write `fw' `"[ADEPT_BATCH]"' _n
	    file write `fw' `"Project="`projectfile'""' _n
	    file write `fw' `"Output="`outputfile'""' _n
	    file write `fw' `"TablesList=`tableslist'"' _n
	    file write `fw' `"SuppressSE="`se'""' _n
	file close `fw'
	
	if !missing(`"`run'"') {
		
		capture confirm file `"`run'"'
		if _rc {
			display as error `"ADePT executable file not present: {result:`run'}"'
			exit 601
		}
		
		capture confirm file `"`projectfile'"'
		if _rc {
			display as error `"ADePT project file not present: {result:`run'}"'
			exit 601
		}
		
		capture confirm file `"`outputfile'"'
		if !_rc {
			display as text `"Output file already exists, deleting: {result:`outputfile'}"'
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
			display as error "Output file was not produced."
	    }
	    else {
			display as text `"Click {browse "`outputfile'" :here} to open the output file."'
	    }
	}

end

/* END OF FILE */
