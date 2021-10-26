// Sergiy Radyakin, The World Bank, 2021

// Programmatically create an ADePT project from Stata, equivalent to the 
// example project that is shipped with the ADePT installation.

// Requires: adept_project_sp.ado

clear all

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