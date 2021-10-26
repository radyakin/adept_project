// Sergiy Radyakin, The World Bank, 2021

// Creates data structures for the database holding ADePT SP projects (2 tables)
// The main table is created in the default frame
// The subordinate programs table is created in the PROGS frame

program define adept_sp_projbase_create
    version 16.0
    syntax
    clear

    foreach v in hhid age gender educat status customind cinlbl urban hhweight region ethnic pline rpline plinetype numrpline pretradj wrquants rgnquant totcons adeq watype mv_grid recmiss usesvy fayvalue chkb_fay chkb_mse methodse svystrat cmbo_sngle filter f_path f_label f_level {
        quietly generate `v'=""
    }
    generate projid=.
    describe

    quietly pwf
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

// END OF FILE
