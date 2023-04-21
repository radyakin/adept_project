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
