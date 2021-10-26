clear all

program define base64string, sclass
    version 16.0
    syntax , string(string)
    python: from sfi import Macro; import base64; Macro.setLocal("b64",str(base64.b64encode(Macro.getLocal("string").encode("utf-8"))))
    // display `"`b64'"'
    local b64=substr(`"`b64'"',3,strlen(`"`b64'"')-3)
    sreturn local result=`"`b64'"'
end

// python: import base64; print(str(base64.b64decode("SU5EU0k=")))

program define adept_project_sp
    version 16.0
    local adept_version "5.0.4259.29002"
    local maxprogs=64 // can be made larger if needed, but total number of options may not be more than 256
    local s=""
    forval i=1/`maxprogs' {
    	local s=`"`s' PROGram`i'(string asis)"'
    }
    syntax using/ , ///
             [ head(string) age(string) gender(string) ///
             educat(string) status(string) ///
             customind(string) cinlbl(string) hhid(string) urban(string) ///
             hhweight(string) region(string) ethnic(string) ///
             pline(string) totcons(string) adeq(string) rpline(string) ///
             plinetype(string) numrpline(numlist >=0 <=100) ///
             wrquants(integer 0) watype(string) ///
             indfile(string) hhfile(string) filelbl(string) ///
             filter(string) `s']
             
             if missing(`"`rpline'"') local rpline="PRCNT"
             local rpline=strupper(`"`rpline'"')
             assert inlist(`"`rpline'"', "MEAN", "MEDIAN", "PRCNT")
             
             if missing(`"`plinetype'"') local plinetype="ABS"
             local plinetype=strupper(`"`plinetype'"')
             assert inlist(`"`plinetype'"', "ABS", "REL")
             
             if missing(`"`numrpline'"') local numrpline="10 20"
             
             if missing(`"`pretradj'"') local pretradj="ADJW0"
             local pretradj=strupper(`"`pretradj'"')
             assert inlist(`"`pretradj'"', "ADJW0", "ADJW1", "ADJW2", "ADJW3")
             
             assert inlist(`wrquants', 0, 1) // checkbox
             
             if missing(`"`rgnquant'"') local rgnquant="QUANT"
             local rgnquant=strupper(`"`rgnquant'"')
             assert inlist(`"`rgnquant'"', "QUANT", "DECIL")
             
             if missing(`"`watype'"') local watype="MONWA"
             local watype=strupper(`"`watype'"')
             assert inlist(`"`watype'"', "MONWA", "NMONWA")
             
             if !missing(`"`indfile'"') & !missing(`"`hhfile'"') {
             	display as error "Error! Either individual file must be specified or household file must be specified, but not both!"
                error 197
             }
             if missing(`"`indfile'"') & missing(`"`hhfile'"') {
             	display as error "Error! Individual file and household file may not be omitted at the same time! One of them must be specified!"
                error 197
             }
             
             if (!missing(`"`indfile'"')) {
             	local file=`"`indfile'"'
                local lev="IND"
             }
             else {
             	local file=`"`hhfile'"'
                local lev="HH"
             }
             
             if missing(`"`filelbl'"') local filelbl="Data1"
             base64string, string(`"`filelbl'"')
             local filelbl=s(result)
             
             base64string, string(`"`file'"')
             local file=s(result)
    
    local progstr=""
    local c=1
    while `"`program`c''"'!="" {
        local ptype=`"`:word 1 of `program`c'''"'
        
        local pvar= `"`:word 2 of `program`c'''"'
        if (`"`pvar'"'=="") {
        	display as error "Every program descriptor must contain a variable name"
            error 197
        }
        
        local plbl= `"`:word 3 of `program`c'''"'
        if (`"`plbl'"'=="") {
        	display as error "Every program descriptor must contain a descriptive label"
            error 197
        }
        
        local ptype=strupper(`"`ptype'"')
        
        assert inlist(`"`ptype'"', "HHDSA", "INDSA", "HHDLM", "INDLM", ///
                                   "HHDSI", "INDSI", "HHDRM", "INDRM")

        display as text `"`ptype'"' _col(10) `"`pvar'"'as result  _col(30) `"`plbl'"'
        
        base64string, string(`"`ptype'"')
        local ptype=s(result)
        base64string, string(`"`pvar'"')
        local pvar=s(result)
        base64string, string(`"`plbl'"')
        local plbl=s(result)
        
        local progstr=`"`progstr'%`ptype',`pvar',`plbl'"'
        local c=`c'+1
    }
    if (!missing(`"`progstr'"')) local progstr=subinstr(substr(`"`progstr'"',2,.),"%","`=char(92)'",.)
    tempname fh
    file open `fh' using `"`using'"', write text replace
      file write `fh' "[INPUTS]" _n
      if !missing(`"`head'"')      file write `fh' `"HEAD=`head'"' _n
      if !missing(`"`age'"')       file write `fh' `"AGE=`age'"' _n
      if !missing(`"`gender'"')    file write `fh' `"GENDER=`gender'"' _n
      if !missing(`"`educat'"')    file write `fh' `"EDUCAT=`educat'"' _n
      if !missing(`"`status'"')    file write `fh' `"STATUS=`status'"' _n
      if !missing(`"`customind'"') file write `fh' `"CUSTOMIND=`customind'"' _n
      if !missing(`"`cinlbl'"')    file write `fh' `"CINLBL=`cinlbl'"' _n
      if !missing(`"`hhid'"')      file write `fh' `"HHID=`hhid'"' _n
      if !missing(`"`urban'"')     file write `fh' `"URBAN=`urban'"' _n
      if !missing(`"`hhweight'"')  file write `fh' `"HHWEIGHT=`hhweight'"' _n
      if !missing(`"`region'"')    file write `fh' `"REGION=`region'"' _n
      if !missing(`"`ethnic'"')    file write `fh' `"ETHNIC=`ethnic'"' _n
      if !missing(`"`progstr'"')   file write `fh' `"LBFT=`progstr'"' _n
      if !missing(`"`pline'"')     file write `fh' `"PLINE=`pline'"' _n
                                   file write `fh' `"CMBO_RPLINE=`rpline'"' _n
                                   file write `fh' `"RG_PLINETYP=`plinetype'"' _n
                                   file write `fh' `"NUM_RPLINE=`numrpline'"' _n
                                   file write `fh' `"PRETRADJ=`pretradj'"' _n
                                   file write `fh' `"WRQUANTS=`wrquants'"' _n
                                   file write `fh' `"RG_NQUANT=`rgnquant'"' _n
      
      if !missing(`"`totcons'"')   file write `fh' `"TOTCONS=`totcons'"' _n
      if !missing(`"`adeq'"')      file write `fh' `"ADEQ=`adeq'"' _n      
                                   file write `fh' `"WATYPE=`watype'"' _n      
      // ----- EXTENDED SVY SETTINGS AND MISSING VALUES NOT IMPLEMENTED -------
      file write `fh' `"MV_GRID="' _n
      file write `fh' `"RECMISS=0"' _n
      file write `fh' `"UseSVY=0"' _n
      file write `fh' `"FAYVALUE=0"' _n
      file write `fh' `"CHKB_FAY=0"' _n
      file write `fh' `"CHKB_MSE=0"' _n
      file write `fh' `"METHODSE=LNR"' _n
      file write `fh' `"SVYSTRAT="' _n
      file write `fh' `"CMBO_SNGLE=MISS"' _n      
      // ----------------------------------------------------------------------
      if !missing(`"`filter'"') {
      	file write `fh' `"Filter=1"' _n
        file write `fh' `"FilterText=`filter'"' _n
      }
      else {
      	file write `fh' `"Filter=0"' _n
      }
      
      file write `fh' "[FILES]" _n
      file write `fh' `"value=`lev'`=char(09)'CHANGES()`=char(09)'`filelbl'`=char(09)'`file'"' _n

      file write `fh' "[HEADER]" _n
      file write `fh' "module=sp" _n
      file write `fh' "adept_version=5.0" _n
      file write `fh' "language3=ENG" _n
      file write `fh' "ado_version=`adept_version'" _n
      file write `fh' "exe_version=`adept_version'" _n
      
      file write `fh' "[OPTIONS]" _n
      file write `fh' "debug=0" _n
      
    file close `fh'    
end

adept_project_sp using "C:\temp\sp_proj1.adept", head("relation==1") ///
    age("age") gender("gender") educat("educ_completed") status("sector") ///
    customind("occupation") cinlbl("Occupation") hhid(" hhid") ///
    urban("location") hhweight("hhweight") region("region") ///
    ethnic("ethnicity_head") pline(" ae_lpovline ae_hpovline") ///
    totcons("hhexp") adeq("aesize") plinetype("abs") numrpline("10 20") ///
    filelbl("2007") indfile("T:\Tatiana\2011\ADePT_Projects\adept_blg.dta") ///
    filter("") ///
    program(INDSI retire_pension_amt "Old age pension") ///
    program(INDSA social_pension_amt "Social assistance") ///
    program(INDSI disability_pay_amt "Disability pension/allowance") ///
    program(INDSI legacy_pension_amt "Survivorship pension") ///
    program(INDLM unemploy_allow_amt "Unemployment benefit") ///
    program(INDSA mother_allow_amt   "Child allowance, up to 2 yo") ///
    program(INDSA other_allow_amt    "Other family allowances") ///
    program(INDSA child_allow_amt    "Monthly child allowance") ///
    program(INDSA heating_allow_amt  "Heating allowance") ///
    program(INDSA gmi_amt            "Guaranteed minimum income") ///
    program(INDSA other_benefit_amt  "Other sa benefits") ///
    program(HHDRM remit_inc          "Remittances")
	
// END OF FILE
    