// Sergiy Radyakin, The World Bank, 2021

// Add a particular project to the database holding multiple projects.
// Main table should be in the current frame.
// Programs table should be in the PROGS frame.

// ProjectID is determined automatically as: 
// (largest_used_projid)+1, or 1 if no projects exist in the base

// Requires: python, configparser

python

from sfi import Macro, Data, SFIToolkit
import base64
import configparser

def readproj(fn, projid):
    config = configparser.ConfigParser()
    config.read(fn)
    Data.addObs(1)
    n=Data.getObsTotal()-1 # // Index of the last observation
    Data.storeAt("projid",n,projid)
    Data.storeAt("hhid",n, config.get('INPUTS', 'HHID'))
    Data.storeAt("age",n, config.get('INPUTS', 'AGE'))
    Data.storeAt("gender",n, config.get('INPUTS', 'GENDER'))
    Data.storeAt("educat",n, config.get('INPUTS', 'EDUCAT'))
    Data.storeAt("status",n, config.get('INPUTS', 'STATUS'))
    Data.storeAt("customind",n, config.get('INPUTS', 'CUSTOMIND'))
    Data.storeAt("cinlbl",n, config.get('INPUTS', 'CINLBL'))
    Data.storeAt("urban",n, config.get('INPUTS', 'URBAN'))
    Data.storeAt("hhweight",n, config.get('INPUTS', 'HHWEIGHT'))
    Data.storeAt("region",n, config.get('INPUTS', 'REGION'))
    Data.storeAt("ethnic",n, config.get('INPUTS', 'ETHNIC'))
    lbft=config.get('INPUTS', 'LBFT')
    Data.storeAt("pline",n, config.get('INPUTS', 'PLINE'))
    Data.storeAt("rpline",n, config.get('INPUTS', 'CMBO_RPLINE')) #????
    Data.storeAt("plinetype",n, config.get('INPUTS', 'RG_PLINETYP'))
    Data.storeAt("numrpline",n, config.get('INPUTS', 'NUM_RPLINE'))
    Data.storeAt("pretradj",n, config.get('INPUTS', 'PRETRADJ')) #??
    Data.storeAt("wrquants",n, config.get('INPUTS', 'WRQUANTS'))
    Data.storeAt("rgnquant",n, config.get('INPUTS', 'RG_NQUANT'))
    Data.storeAt("totcons",n, config.get('INPUTS', 'TOTCONS'))
    Data.storeAt("adeq",n, config.get('INPUTS', 'ADEQ'))
    Data.storeAt("watype",n, config.get('INPUTS', 'WATYPE'))
    Data.storeAt("mv_grid",n, config.get('INPUTS', 'MV_GRID'))
    Data.storeAt("recmiss",n, config.get('INPUTS', 'RECMISS'))
    Data.storeAt("usesvy",n, config.get('INPUTS', 'UseSVY'))
    Data.storeAt("fayvalue",n, config.get('INPUTS', 'FAYVALUE'))
    Data.storeAt("chkb_fay",n, config.get('INPUTS', 'CHKB_FAY'))
    Data.storeAt("chkb_mse",n, config.get('INPUTS', 'CHKB_MSE'))
    Data.storeAt("methodse",n, config.get('INPUTS', 'METHODSE'))
    Data.storeAt("svystrat",n, config.get('INPUTS', 'SVYSTRAT'))
    Data.storeAt("cmbo_sngle",n, config.get('INPUTS', 'CMBO_SNGLE'))
    Data.storeAt("filter",n, config.get('INPUTS','Filter'))

    v=config.get('FILES', 'value')
    Data.storeAt("f_level",n, v.split()[0])
    Data.storeAt("f_label",n, str(base64.b64decode(v.split()[2]))[2:-1])
    Data.storeAt("f_path",n, str(base64.b64decode(v.split()[3]))[2:-1])

    fc="default"
    fm="PROGS"
    SFIToolkit.stata("frame change "+fm)
    progs=lbft.split("\\")
    for p in progs:
      Data.addObs(1)
      j=Data.getObsTotal()-1
      prog1=p.split(",")
      Data.storeAt("ptype",j,str(base64.b64decode(prog1[0]))[2:-1])
      Data.storeAt("pvar",j,str(base64.b64decode(prog1[1]))[2:-1])
      Data.storeAt("plabel",j,str(base64.b64decode(prog1[2]))[2:-1])
      Data.storeAt("projid",j,projid)
    SFIToolkit.stata("frame change "+fc)

end

program define adept_sp_projbase_add
    version 16.0
    syntax , projfile(string)
    //python: import __main__; __main__.readproj("`projfile'", 0)
    
    summarize projid
    if (r(max)!=.) local newprojid=r(max)+1
    else local newprojid=1
    
    python: readproj("`projfile'", `newprojid')
end

// END OF FILE
