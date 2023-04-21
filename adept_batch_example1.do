// Produce ADePT tables table21 and table41 without standard errors using the project saved in povineq_1.adept and saving the output to povineq1.xls in the temp folder. 

// The module will be determined in accordance with the project file.

// ADePT will be run from C:\ADEPT\ folder, which is the default installation folder.

clear all

adept_batch , ///
  projectfile("c:\temp\povineq_1.adept") ///
  outputfile("c:\temp\povineq1.xls") ///
  tableslist("table21 table41") ///
  suppressse ///
  run("C:\ADEPT\adept.exe")

/* END OF FILE */