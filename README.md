# adept_project
ADePT project tools


## adept_batch

Runs an ADePT project file with optional request of tables to be built or suppressing standard errors (SEs) calculation.

NB: adept_batch will fail in the following situations:
- ADePT in not installed, or not configured; (run ADePT manually at least once before using the batch tools).
- ADePT is already running as a parallel process for this user; (close all other ADePT sessions).
- An output file from an earlier interactive execution is open in MS Excel or another viewer that blocks file access when it is running; (close MS Excel or its equivalent used for viewing the output files).
- A project file refers to a dataset that is missing or not accessible; (use a correct project file or generate a new one).
- other situations; (check interactively if the project file works and results in a meaningful output. If it doesn't work interactively, it will not work in the batch mode either).

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


