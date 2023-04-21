# adept_project
ADePT project tools


## adept_batch

#### Syntax

`adept_batch`  is followed by these options:

- `batchfile(string)` optional name of the batch file to be created, if not specified a temporary file name will be used;
- `projectfile(string)` name of the project file to use (must exist);
- `outputfile(string)` name of the output file for ADePT to generate (in *.xls format), note that the output file is always overwritten if already exists;
- `tableslist(string)` optional space-delimited list of the tables to produce:
  - if not specified - all feasible tables will be attempted,
  - if specified: only the specified feasible table will be attempted;
- `suppressse` - optional flag to suppress calculation of standard errors (SEs) by ADePT;
- `run(string)` - optional path to ADePT, if specified, the ADePT executable will be immediately used for running the generated batch job.
