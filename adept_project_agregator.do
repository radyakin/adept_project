clear all

version 16.0

program define basecreate
    version 16.0
    syntax
    clear
    set obs 1
    foreach v in hhid age gender educat status customind cinlbl urban hhweight region ethnic pline rpline plinetype numrpline pretradj wrquants rgnquant totcons adeq watype mv_grid recmiss usesvy fayvalue chkb_fay chkb_mse methodse svystrat cmbo_sngle filter f_path f_label f_level {
        quietly generate `v'=""
    }
    generate projid=.
    describe

    pwf
    local cf=r(currentframe)
    frame create PROGS
    frame change PROGS
    foreach v in ptype pvar plabel {
        quietly generate `v'=""
    }
    generate projid=.
    order projid
    describe
    frame change `cf'
end

python

from sfi import Macro, Data, SFIToolkit
import base64
import configparser

def readproj(fn, n):
    config = configparser.ConfigParser()
    config.read(fn)

    Data.storeAt("projid",n,n+1)
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
    Data.storeAt("f_level",0, v.split()[0])
    Data.storeAt("f_label",0, str(base64.b64decode(v.split()[2]))[2:-1])
    Data.storeAt("f_path",0, str(base64.b64decode(v.split()[3]))[2:-1])

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
      Data.storeAt("projid",j,n+1)
    SFIToolkit.stata("frame change "+fc)

end

program define adept_readproj
    version 16.0
    syntax , projfile(string)
    python: import __main__; __main__.readproj("`projfile'", 0)
end


basecreate
adept_readproj , projfile("c:/Temp/adept_temp/example/sp3333.adept")

list
frame PROGS: list

// end of file