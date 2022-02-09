      module define_atcfunix_rec
        type atcfunix_card    ! Define a new type for an atcfunix card
          sequence
          character*2   atx_basin       ! Hurricane Center Acronym
          character*2   atx_storm_num   ! Storm number (03, etc)
          character*10  atx_ymdh        ! Fcst start date (yyyymmddhh)
          character*2   atx_technum     ! Always equal to 03 for models
          character*4   atx_model       ! Name of forecast model
          integer       atx_fcsthr      ! Fcst hour (i3.3)
          integer       atx_lat         ! Storm Lat (*10), always >0
          character*1   atx_latns       ! 'N' or 'S'
          integer       atx_lon         ! Storm Lon (*10), always >0
          character*1   atx_lonew       ! 'E' or 'W'
          integer       atx_vmax        ! max sfc wind speed (knots)
          integer       atx_pcen        ! Min central pressure (mb)
c          character*2   atx_stype       ! Storm type (= 'XX' for now)
c          integer       atx_wthresh     ! Wind threshold (34, 50, 64 kt)
c          character*3   atx_quad_id     ! NEQ = start with NE quadrant
c          integer       atx_ne_quad     ! Wind radius in NE quad (nm)
c          integer       atx_se_quad     ! Wind radius in SE quad (nm)
c          integer       atx_sw_quad     ! Wind radius in SW quad (nm)
c          integer       atx_nw_quad     ! Wind radius in NW quad (nm)
        end type atcfunix_card
      end module define_atcfunix_rec

      module maxparms
        integer, parameter :: ncmaxmem = 30 ! max # ncep ensemble perts
        integer, parameter :: nrmaxmem = 10 ! max # Tom ensemble perts
        integer, parameter :: n0maxmem = 20 ! max # ncep_bc ensemble perts
        integer, parameter :: h0maxmem = 20 ! max # hwrf ensemble
        integer, parameter :: y0maxmem = 10 ! max # COAMPS ensemble
        integer, parameter :: d0maxmem = 10 ! max # GFDL ensemble
        integer, parameter :: e0maxmem = 40 ! max # HWRF+GFDL+COAMPS  ensemble
        integer, parameter :: e1maxmem = 30 ! max # HWRF+GFDL
        integer, parameter :: e2maxmem = 30 ! max # HWRF+NAVY
        integer, parameter :: e3maxmem = 20 ! max # GFDL+NAVY

        integer, parameter :: ukmaxmem = 23 ! max # UKMET ensemble perts
        integer, parameter :: frmaxmem = 34 ! max # FRANCE ensemble perts

cJ.Peng-------2010-09-29--------------------------------------
        integer, parameter :: gcmaxmem = 20 ! max # gv ensemble perts
        integer, parameter :: g0maxmem = 20 ! max # FNMOC_bc ensemble perts

        integer, parameter :: ccmaxmem = 20 ! max # cmc ensemble perts
        integer, parameter :: c0maxmem = 20 ! max # cmc_bc ensemble perts

        integer, parameter :: ecmaxmem = 50 ! max # ecmwf ensemble perts
        integer, parameter :: ezmaxmem = 20 ! max # ecmwf ensemble perts

        integer, parameter :: srmaxmem = 21 ! max # sref ensemble perts
cJ.Peng-------2010-10-29------------2010-11-02-----------------
        integer, parameter :: c2maxmem = 40 ! max # NCEP+CMC ens pert
        integer, parameter :: f2maxmem = 40 ! max # NCEP+FNMOC ens pert

        integer, parameter :: c3maxmem = 90 ! max # NCEP+CMC+EC ens pert
        integer, parameter :: n2maxmem = 70 ! max # NCEP+EC ens pert
        integer, parameter :: m2maxmem = 70 ! max # NCEP+EC ens pert

        integer, parameter :: c4maxmem = 110 ! max # NCEP+CMC+EC+FNMOC
        integer, parameter :: c5maxmem = 133 ! max # NCEP+CMC+EC+FNMOC+UK

        integer, parameter :: c6maxmem = 153 ! max # NCEP+CMC+EC+FNMOC+UK+

        integer, parameter :: n3maxmem = 93 ! max # NCEP+EC+UK

        integer, parameter :: f3maxmem = 60 ! max # NCEP+CMC+FNMOC

        integer, parameter :: s3maxmem =  2 ! max # eemn+2emn ens pert
        integer, parameter :: p3maxmem =  3 ! max # ee/ae/ce+mn ens pert

        integer, parameter :: d3maxmem =  3 ! max # AVNO+CMC+EMX  pert
        integer, parameter :: d6maxmem =  6 ! max # AVNO+CMC+EMX+AEMN+..

        integer, parameter :: x6maxmem =  6 ! max # EEMN+AEMN+CEMN+FEMN+
        integer, parameter :: d4maxmem =  4 ! max # AVNO+CMC+EMX+3EMN
        integer, parameter :: d2maxmem =  2 ! max # 3EMN+3DET..

        integer, parameter :: ncminmem = 12 ! min # of ncep ensemble 
                         ! perts needed at a given fcst hr to get a mean
        integer, parameter :: nrminmem =  4 ! min # of Tom ensemble
        integer, parameter :: n0minmem =  8 ! min # of ncep_bc ensemble
        integer, parameter :: h0minmem =  8 ! min # of hwrf ensemble
        integer, parameter :: y0minmem =  4 ! min # of coamps ensemble
        integer, parameter :: d0minmem =  4 ! min # of GFDL ensemble
        integer, parameter :: e0minmem = 16 ! min # of GFDL+HWRF+COAMPS  ensemble
        integer, parameter :: e1minmem = 12 ! min # of GFDL+HWRF
        integer, parameter :: e2minmem = 12 ! min # of HWRF+NAVY
        integer, parameter :: e3minmem = 8 ! min # of GFDL+NAVY

        integer, parameter :: ukminmem =  9 ! min # of UKMET ensemble
        integer, parameter :: frminmem = 14 ! min # of FRANCE ensemble

cJ.Peng----2010-09-29---------------------------------------------
        integer, parameter :: gcminmem =  8 ! min # of gv ensemble
        integer, parameter :: g0minmem =  8 ! min # of gv ensemble

        integer, parameter :: ccminmem =  8 ! min # of cmc ensemble
        integer, parameter :: c0minmem =  8 ! min # of cmc ensemble

        integer, parameter :: ecminmem = 20 ! min # of ecmwf ensemble
                         ! perts needed at a given fcst hr to get a mean

        integer, parameter :: ezminmem =  8 ! min # of ecmwf ensemble

        integer, parameter :: srminmem =  8 ! min # of sref ensemble 
                         ! perts needed at a given fcst hr to get a mean
cJ.Peng-------2010-10-29-------------2010-11-02--------------------------
c        integer, parameter :: c2minmem = 20 ! min # of NCEP+CMC ensemble
c                         ! perts needed at a given fcst hr to get a mean
cJ.Peng------------2010-11-19--------------------------
        integer, parameter :: c2minmem = 22 ! min # of NCEP+CMC ensemble
                         ! perts needed at a given fcst hr to get a mean
        integer, parameter :: f2minmem = 22 ! min # of NCEP+FNMOC ensemble

        integer, parameter :: c3minmem = 50 ! min # of NCEP+CMC+EC ensemble
        integer, parameter :: n2minmem = 39 ! min # of NCEP+EC ensemble
        integer, parameter :: m2minmem = 39 ! min # of NCEP+EC ensemble

        integer, parameter :: c4minmem = 61 ! min # of NCEP+CMC+EC+FNMOC
        integer, parameter :: c5minmem = 74 ! min # of NCEP+CMC+EC+FNMOC+UK

        integer, parameter :: c6minmem = 85 ! min # of NCEP+CMC+EC+FNMOC+UK
        integer, parameter :: n3minmem = 52 ! min # of NCEP+EC+UK

        integer, parameter :: f3minmem = 33 ! min # of NCEP+CMC+FNMOC

        integer, parameter :: s3minmem =  2 ! min # of NCEP+CMC+EC ensemble
        integer, parameter :: p3minmem =  3 ! min # of NCEP+CMC+EC ensemble

        integer, parameter :: d3minmem =  3 ! min # of AVNO+CMC+EMX ensemble
        integer, parameter :: d6minmem =  6 ! min # of AVNO+CMC+EMX+AEMN+.. 

        integer, parameter :: x6minmem =  6 ! min # of
        integer, parameter :: d4minmem =  4 ! min # of AVNO+CMC+EMX+3EMN
        integer, parameter :: d2minmem =  2 ! min # of 3DET+3EMN..

        integer, parameter :: maxstorms  = 15 ! max # storms at a time
        integer, parameter :: maxtimes   = 65 ! max # fcst times (0-384
                                              ! every 6 hrs = 65).
c        integer, parameter :: max_accum_prob_hour = 384 ! Max hour to 
c        integer, parameter :: max_accum_prob_hour = 120 ! Max hour to 
c                              ! which we'll carry out the accum probs
        real, parameter :: grdspc = 1.00      ! grid spacing of our grid
      end module maxparms

      module ensinfo
        USE maxparms
        character*4 :: ncperts(ncmaxmem) = (/'AP01','AP02','AP03'
     &          ,'AP04','AP05','AP06','AP07','AP08','AP09','AP10'
     &          ,'AP11','AP12','AP13','AP14','AP15','AP16','AP17'
     &          ,'AP18','AP19','AP20','AP21','AP22','AP23','AP24'
     &          ,'AP25','AP26','AP27','AP28','AP29','AP30'/)

        character*4 :: nrperts(nrmaxmem) = (/'GR01','GR02','GR03'
     &          ,'GR04','GR05','GR06','GR07','GR08','GR09','GR10'
     &          /)

c        character*4 :: ncperts(ncmaxmem) = (/'GE01','GE02','GE03'
c     &          ,'GE04','GE05','GE06','GE07','GE08','GE09','GE10'
c     &          ,'GE11','GE12','GE13','GE14','GE15','GE16','GE17'
c     &          ,'GE18','GE19','GE20'/)

        character*4 :: n0perts(n0maxmem) = (/'AP01','AP02','AP03'
     &          ,'AP04','AP05','AP06','AP07','AP08','AP09','AP10'
     &          ,'AP11','AP12','AP13','AP14','AP15','AP16','AP17'
     &          ,'AP18','AP19','AP20'/)

        character*4 :: h0perts(h0maxmem) = (/'HW01','HW02','HW03'
     &          ,'HW04','HW05','HW06','HW07','HW08','HW09','HW10'
     &          ,'HW11','HW12','HW13','HW14','HW15','HW16','HW17'
     &          ,'HW18','HW19','HW20'/)

        character*4 :: y0perts(y0maxmem) = (/'C01C','C02C','C03C'
     &          ,'C04C','C05C','C06C','C07C','C08C','C09C','C10C'
     &          /)

        character*4 :: d0perts(d0maxmem) = (/'GP00','GP01','GP02'
     &          ,'GP03','GP04','GP05','GP06','GP07','GP08','GP09'
     &          /)

        character*4 :: e0perts(e0maxmem) = (/'GP00','GP01','GP02'
     &          ,'GP03','GP04','GP05','GP06','GP07','GP08','GP09'
     &          ,'C01C','C02C','C03C'
     &          ,'C04C','C05C','C06C','C07C','C08C','C09C','C10C'
     &          ,'HW01','HW02','HW03'
     &          ,'HW04','HW05','HW06','HW07','HW08','HW09','HW10'
     &          ,'HW11','HW12','HW13','HW14','HW15','HW16','HW17'
     &          ,'HW18','HW19','HW20'/)

        character*4 :: e1perts(e1maxmem) = (/'GP00','GP01','GP02'
     &          ,'GP03','GP04','GP05','GP06','GP07','GP08','GP09'
     &          ,'HW01','HW02','HW03'
     &          ,'HW04','HW05','HW06','HW07','HW08','HW09','HW10'
     &          ,'HW11','HW12','HW13','HW14','HW15','HW16','HW17'
     &          ,'HW18','HW19','HW20'/)

        character*4 :: e2perts(e2maxmem) = (/'C01C','C02C','C03C'
     &          ,'C04C','C05C','C06C','C07C','C08C','C09C','C10C'
     &          ,'HW01','HW02','HW03'
     &          ,'HW04','HW05','HW06','HW07','HW08','HW09','HW10'
     &          ,'HW11','HW12','HW13','HW14','HW15','HW16','HW17'
     &          ,'HW18','HW19','HW20'/)

        character*4 :: e3perts(e3maxmem) = (/'GP00','GP01','GP02'
     &          ,'GP03','GP04','GP05','GP06','GP07','GP08','GP09'
     &          ,'C01C','C02C','C03C'
     &          ,'C04C','C05C','C06C','C07C','C08C','C09C','C10C'
     &          /)

        character*4 :: ukperts(ukmaxmem) = (/'UK01','UK02'
     &   ,'UK03','UK04','UK05','UK06','UK07','UK08','UK09','UK10'
     &          ,'UK11','UK12','UK13','UK14','UK15','UK16','UK17'
     &          ,'UK18','UK19','UK20','UK21','UK22','UK23'/)

        character*4 :: frperts(frmaxmem) = (/'FR01','FR02','FR03'
     &          ,'FR04','FR05','FR06','FR07','FR08','FR09','FR10'
     &          ,'FR11','FR12','FR13','FR14','FR15','FR16','FR17'
     &          ,'FR18','FR19','FR20','FR21','FR22','FR23','FR24'
     &          ,'FR25','FR26','FR27','FR28','FR29','FR30','FR31'
     &          ,'FR32','FR33','FR34'/)

c#-------J.Peng----2010-09-29---------------------------------------------
        character*4 :: gcperts(gcmaxmem) = (/'NP01','NP02','NP03'
     &          ,'NP04','NP05','NP06','NP07','NP08','NP09','NP10'
     &          ,'NP11','NP12','NP13','NP14','NP15','NP16','NP17'
     &          ,'NP18','NP19','NP20'/)
        character*4 :: g0perts(g0maxmem) = (/'FP01','FP02','FP03'
     &          ,'FP04','FP05','FP06','FP07','FP08','FP09','FP10'
     &          ,'FP11','FP12','FP13','FP14','FP15','FP16','FP17'
     &          ,'FP18','FP19','FP20'/)


        character*4 :: ccperts(ccmaxmem) = (/'CP01','CP02','CP03'
     &          ,'CP04','CP05','CP06','CP07','CP08','CP09','CP10'
     &          ,'CP11','CP12','CP13','CP14','CP15','CP16','CP17'
     &          ,'CP18','CP19','CP20'/)
        character*4 :: c0perts(c0maxmem) = (/'CP01','CP02','CP03'
     &          ,'CP04','CP05','CP06','CP07','CP08','CP09','CP10'
     &          ,'CP11','CP12','CP13','CP14','CP15','CP16','CP17'
     &          ,'CP18','CP19','CP20'/)

cJ.Peng-------2010-10-29-------------------------------------
        character*4 :: c2perts(c2maxmem) = (/'AP01','AP02','AP03'
     &          ,'AP04','AP05','AP06','AP07','AP08','AP09','AP10'
     &          ,'AP11','AP12','AP13','AP14','AP15','AP16','AP17'
     &          ,'AP18','AP19','AP20'
     &          ,'CP01','CP02','CP03'
     &          ,'CP04','CP05','CP06','CP07','CP08','CP09','CP10'
     &          ,'CP11','CP12','CP13','CP14','CP15','CP16','CP17'
     &          ,'CP18','CP19','CP20'/)

cJ.Peng-------2012-04-27-------------------------------------
        character*4 :: f2perts(f2maxmem) = (/'AP01','AP02','AP03'
     &          ,'AP04','AP05','AP06','AP07','AP08','AP09','AP10'
     &          ,'AP11','AP12','AP13','AP14','AP15','AP16','AP17'
     &          ,'AP18','AP19','AP20'
     &          ,'FP01','FP02','FP03'
     &          ,'FP04','FP05','FP06','FP07','FP08','FP09','FP10'
     &          ,'FP11','FP12','FP13','FP14','FP15','FP16','FP17'
     &          ,'FP18','FP19','FP20'/)

cJ.Peng-------2010-11-02-------------------------------------------
        character*4 :: c3perts(c3maxmem) = (/'AP01','AP02','AP03'
     &          ,'AP04','AP05','AP06','AP07','AP08','AP09','AP10'
     &          ,'AP11','AP12','AP13','AP14','AP15','AP16','AP17'
     &          ,'AP18','AP19','AP20'
     &          ,'CP01','CP02','CP03'
     &          ,'CP04','CP05','CP06','CP07','CP08','CP09','CP10'
     &          ,'CP11','CP12','CP13','CP14','CP15','CP16','CP17'
     &          ,'CP18','CP19','CP20'
     &          ,'EN01','EN02','EN03'
     &          ,'EN04','EN05','EN06','EN07','EN08','EN09','EN10'
     &          ,'EN11','EN12','EN13','EN14','EN15','EN16','EN17'
     &          ,'EN18','EN19','EN20','EN21','EN22','EN23','EN24'
     &          ,'EN25','EP01','EP02','EP03','EP04','EP05','EP06'
     &          ,'EP07','EP08','EP09','EP10','EP11','EP12','EP13'
     &          ,'EP14','EP15','EP16','EP17','EP18','EP19','EP20'
     &          ,'EP21','EP22','EP23','EP24','EP25'/)

        character*4 :: n2perts(n2maxmem) = (/'AP01','AP02','AP03'
     &          ,'AP04','AP05','AP06','AP07','AP08','AP09','AP10'
     &          ,'AP11','AP12','AP13','AP14','AP15','AP16','AP17'
     &          ,'AP18','AP19','AP20'
     &          ,'EN01','EN02','EN03'
     &          ,'EN04','EN05','EN06','EN07','EN08','EN09','EN10'
     &          ,'EN11','EN12','EN13','EN14','EN15','EN16','EN17'
     &          ,'EN18','EN19','EN20','EN21','EN22','EN23','EN24'
     &          ,'EN25','EP01','EP02','EP03','EP04','EP05','EP06'
     &          ,'EP07','EP08','EP09','EP10','EP11','EP12','EP13'
     &          ,'EP14','EP15','EP16','EP17','EP18','EP19','EP20'
     &          ,'EP21','EP22','EP23','EP24','EP25'/)

        character*4 :: m2perts(m2maxmem) = (/'01AI','02AI','03AI'
     &          ,'04AI','05AI','06AI','07AI','08AI','09AI','10AI'
     &          ,'11AI','12AI','13AI','14AI','15AI','16AI','17AI'
     &          ,'18AI','19AI','20AI'
     &          ,'01N2','02N2','03N2'
     &          ,'04N2','05N2','06N2','07N2','08N2','09N2','10N2'
     &          ,'11N2','12N2','13N2','14N2','15N2','16N2','17N2'
     &          ,'18N2','19N2','20N2','21N2','22N2','23N2','24N2'
     &          ,'25N2'
     &          ,'01P2','02P2','03P2','04P2','05P2','06P2'
     &          ,'07P2','08P2','09P2','10P2','11P2','12P2','13P2'
     &          ,'14P2','15P2','16P2','17P2','18P2','19P2','20P2'
     &          ,'21P2','22P2','23P2','24P2','25P2'/)

        character*4 :: f3perts(f3maxmem) = (/'AP01','AP02','AP03'
     &          ,'AP04','AP05','AP06','AP07','AP08','AP09','AP10'
     &          ,'AP11','AP12','AP13','AP14','AP15','AP16','AP17'
     &          ,'AP18','AP19','AP20'
     &          ,'CP01','CP02','CP03'
     &          ,'CP04','CP05','CP06','CP07','CP08','CP09','CP10'
     &          ,'CP11','CP12','CP13','CP14','CP15','CP16','CP17'
     &          ,'CP18','CP19','CP20'
     &          ,'FP01','FP02','FP03'
     &          ,'FP04','FP05','FP06','FP07','FP08','FP09','FP10'
     &          ,'FP11','FP12','FP13','FP14','FP15','FP16','FP17'
     &          ,'FP18','FP19','FP20'/)


        character*4 :: c4perts(c4maxmem) = (/'AP01','AP02','AP03'
     &          ,'AP04','AP05','AP06','AP07','AP08','AP09','AP10'
     &          ,'AP11','AP12','AP13','AP14','AP15','AP16','AP17'
     &          ,'AP18','AP19','AP20'
     &          ,'CP01','CP02','CP03'
     &          ,'CP04','CP05','CP06','CP07','CP08','CP09','CP10'
     &          ,'CP11','CP12','CP13','CP14','CP15','CP16','CP17'
     &          ,'CP18','CP19','CP20'
     &          ,'EN01','EN02','EN03'
     &          ,'EN04','EN05','EN06','EN07','EN08','EN09','EN10'
     &          ,'EN11','EN12','EN13','EN14','EN15','EN16','EN17'
     &          ,'EN18','EN19','EN20','EN21','EN22','EN23','EN24'
     &          ,'EN25','EP01','EP02','EP03','EP04','EP05','EP06'
     &          ,'EP07','EP08','EP09','EP10','EP11','EP12','EP13'
     &          ,'EP14','EP15','EP16','EP17','EP18','EP19','EP20'
     &          ,'EP21','EP22','EP23','EP24','EP25'
     &          ,'FP01','FP02','FP03'
     &          ,'FP04','FP05','FP06','FP07','FP08','FP09','FP10'
     &          ,'FP11','FP12','FP13','FP14','FP15','FP16','FP17'
     &          ,'FP18','FP19','FP20'/)

        character*4 :: c5perts(c5maxmem) = (/'AP01','AP02','AP03'
     &          ,'AP04','AP05','AP06','AP07','AP08','AP09','AP10'
     &          ,'AP11','AP12','AP13','AP14','AP15','AP16','AP17'
     &          ,'AP18','AP19','AP20'
     &          ,'CP01','CP02','CP03'
     &          ,'CP04','CP05','CP06','CP07','CP08','CP09','CP10'
     &          ,'CP11','CP12','CP13','CP14','CP15','CP16','CP17'
     &          ,'CP18','CP19','CP20'
     &          ,'EN01','EN02','EN03'
     &          ,'EN04','EN05','EN06','EN07','EN08','EN09','EN10'
     &          ,'EN11','EN12','EN13','EN14','EN15','EN16','EN17'
     &          ,'EN18','EN19','EN20','EN21','EN22','EN23','EN24'
     &          ,'EN25','EP01','EP02','EP03','EP04','EP05','EP06'
     &          ,'EP07','EP08','EP09','EP10','EP11','EP12','EP13'
     &          ,'EP14','EP15','EP16','EP17','EP18','EP19','EP20'
     &          ,'EP21','EP22','EP23','EP24','EP25'
     &          ,'FP01','FP02','FP03'
     &          ,'FP04','FP05','FP06','FP07','FP08','FP09','FP10'
     &          ,'FP11','FP12','FP13','FP14','FP15','FP16','FP17'
     &          ,'FP18','FP19','FP20'
     &          ,'UK01','UK02','UK03'
     &          ,'UK04','UK05','UK06','UK07','UK08','UK09','UK10'
     &          ,'UK11','UK12','UK13','UK14','UK15','UK16','UK17'
     &          ,'UK18','UK19','UK20','UK21','UK22','UK23'/)

        character*4 :: c6perts(c6maxmem) = (/'AP01','AP02','AP03'
     &          ,'AP04','AP05','AP06','AP07','AP08','AP09','AP10'
     &          ,'AP11','AP12','AP13','AP14','AP15','AP16','AP17'
     &          ,'AP18','AP19','AP20'
     &          ,'CP01','CP02','CP03'
     &          ,'CP04','CP05','CP06','CP07','CP08','CP09','CP10'
     &          ,'CP11','CP12','CP13','CP14','CP15','CP16','CP17'
     &          ,'CP18','CP19','CP20'
     &          ,'EN01','EN02','EN03'
     &          ,'EN04','EN05','EN06','EN07','EN08','EN09','EN10'
     &          ,'EN11','EN12','EN13','EN14','EN15','EN16','EN17'
     &          ,'EN18','EN19','EN20','EN21','EN22','EN23','EN24'
     &          ,'EN25','EP01','EP02','EP03','EP04','EP05','EP06'
     &          ,'EP07','EP08','EP09','EP10','EP11','EP12','EP13'
     &          ,'EP14','EP15','EP16','EP17','EP18','EP19','EP20'
     &          ,'EP21','EP22','EP23','EP24','EP25'
     &          ,'FP01','FP02','FP03'
     &          ,'FP04','FP05','FP06','FP07','FP08','FP09','FP10'
     &          ,'FP11','FP12','FP13','FP14','FP15','FP16','FP17'
     &          ,'FP18','FP19','FP20'
     &          ,'UK01','UK02','UK03'
     &          ,'UK04','UK05','UK06','UK07','UK08','UK09','UK10'
     &          ,'UK11','UK12','UK13','UK14','UK15','UK16','UK17'
     &          ,'UK18','UK19','UK20','UK21','UK22','UK23'
     &          ,'GE01','GE02','GE03'
     &          ,'GE04','GE05','GE06','GE07','GE08','GE09','GE10'
     &          ,'GE11','GE12','GE13','GE14','GE15','GE16','GE17'
     &          ,'GE18','GE19','GE20'/)


        character*4 :: n3perts(n3maxmem) = (/'AP01','AP02','AP03'
     &          ,'AP04','AP05','AP06','AP07','AP08','AP09','AP10'
     &          ,'AP11','AP12','AP13','AP14','AP15','AP16','AP17'
     &          ,'AP18','AP19','AP20'
     &          ,'EN01','EN02','EN03'
     &          ,'EN04','EN05','EN06','EN07','EN08','EN09','EN10'
     &          ,'EN11','EN12','EN13','EN14','EN15','EN16','EN17'
     &          ,'EN18','EN19','EN20','EN21','EN22','EN23','EN24'
     &          ,'EN25','EP01','EP02','EP03','EP04','EP05','EP06'
     &          ,'EP07','EP08','EP09','EP10','EP11','EP12','EP13'
     &          ,'EP14','EP15','EP16','EP17','EP18','EP19','EP20'
     &          ,'EP21','EP22','EP23','EP24','EP25'
     &          ,'UK01','UK02','UK03'
     &          ,'UK04','UK05','UK06','UK07','UK08','UK09','UK10'
     &          ,'UK11','UK12','UK13','UK14','UK15','UK16','UK17'
     &          ,'UK18','UK19','UK20','UK21','UK22','UK23'/)

        character*4 :: s3perts(s3maxmem) = (/'EEMN','2EMN'/)
        character*4 :: p3perts(p3maxmem) = (/'EEMN','AEMN','CEMN'/)

        character*4 :: d3perts(d3maxmem) = (/'AVNO',' EMX',' CMC'/)

        character*4 :: d6perts(d6maxmem) = (/'AEMN','CEMN','EEMN'
     &                                      ,'AVNO',' CMC',' EMX'/)

        character*4 :: x6perts(x6maxmem) = (/'AEMN','CEMN','EEMN'
     &                                      ,'FEMN','UKMN','HPMN'/)

        character*4 :: d4perts(d4maxmem) = (/'AVNO',' EMX',' CMC'
     &                                      ,'3EMN'/)

        character*4 :: d2perts(d2maxmem) = (/'3EMN','3DET'/)


        character*4 :: ecperts(ecmaxmem) = (/'EN01','EN02','EN03'
     &          ,'EN04','EN05','EN06','EN07','EN08','EN09','EN10'
     &          ,'EN11','EN12','EN13','EN14','EN15','EN16','EN17'
     &          ,'EN18','EN19','EN20','EN21','EN22','EN23','EN24'
     &          ,'EN25','EP01','EP02','EP03','EP04','EP05','EP06'
     &          ,'EP07','EP08','EP09','EP10','EP11','EP12','EP13'
     &          ,'EP14','EP15','EP16','EP17','EP18','EP19','EP20'
     &          ,'EP21','EP22','EP23','EP24','EP25'/)

        character*4 :: ezperts(ezmaxmem) = (/'EN01','EN02','EN03'
     &          ,'EN04','EN05','EN06','EN07','EN08','EN09','EN10' 
     &          ,'EP01','EP02','EP03','EP04','EP05','EP06'
     &          ,'EP07','EP08','EP09','EP10'/)

        character*4 :: srperts(srmaxmem) = (/'EMC1','EMN1','EMN2'
     &          ,'EMN3','EMP1','EMP2','EMP3','NBC1','NBN1','NBN2'
     &          ,'NBN3','NBP1','NBP2','NBP3','NMC1','NMN1','NMN2'
     &          ,'NMN3','NMP1','NMP2','NMP3'/)

        integer  :: ncfcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: nrfcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: n0fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: h0fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: y0fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: d0fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: e0fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: e1fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: e2fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: e3fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: ukfcsthrs(maxtimes) = (/0,12,24,36,48,60,72,84,96
     &               ,108,120,132
     &               ,144,156,168,180,192,204,216,228,240,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: frfcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

c#-------J.Peng----2010-09-29---------------------------------------------
        integer  :: gcfcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)
        integer  :: g0fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: ccfcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)
        integer  :: c0fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)


cJ.Peng-------2010-10-29-------------------------------------
        integer  :: c2fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: f2fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

cJ.Peng-------2010-11-02------------------------------------------
c        integer  :: c3fcsthrs(maxtimes) = (/0,12,24,36,48,60,72,84,96
c     &               ,108,120,132,144,156,168,180,192,204,216,228,240
c     &               ,999,999,999,999,999,999,999,999,999,999,999,999
c     &               ,999,999,999,999,999,999,999,999,999,999,999,999
c     &               ,999,999,999,999,999,999,999,999,999,999,999,999
c     &               ,999,999,999,999,999,999,999,999/)

        integer  :: c3fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: n2fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: m2fcsthrs(maxtimes) = (/0,12,24,36,48,60,72,84,96
     &               ,108,120,132
     &               ,144,156,168,180,192,204,216,228,240,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: f3fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: c4fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: c5fcsthrs(maxtimes) = (/0,12,24,36,48,60,72,84,96
     &               ,108,120,132
     &               ,144,156,168,180,192,204,216,228,240,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: c6fcsthrs(maxtimes) = (/0,12,24,36,48,60,72,84,96
     &               ,108,120,132
     &               ,144,156,168,180,192,204,216,228,240,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: n3fcsthrs(maxtimes) = (/0,12,24,36,48,60,72,84,96
     &               ,108,120,132
     &               ,144,156,168,180,192,204,216,228,240,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: s3fcsthrs(maxtimes) = (/0,12,24,36,48,60,72,84,96
     &               ,108,120,132,144,156,168,180,192,204,216,228,240
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999/)
        integer  :: p3fcsthrs(maxtimes) = (/0,12,24,36,48,60,72,84,96
     &               ,108,120,132,144,156,168,180,192,204,216,228,240
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999/)

        integer  :: d3fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: d6fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: x6fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: d4fcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/) 

        integer  :: d2fcsthrs(maxtimes) = (/0,12,24,36,48,60,72,84,96
     &               ,108,120,132,144,156,168,180,192,204,216,228,240
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999/)

c------J.Peng------2011-01-03----------------------------------------
c        integer  :: ecfcsthrs(maxtimes) = (/0,12,24,36,48,60,72,84,96
c     &               ,108,120,132,144,156,168,180,192,204,216,228,240
c     &               ,999,999,999,999,999,999,999,999,999,999,999,999
c     &               ,999,999,999,999,999,999,999,999,999,999,999,999
c     &               ,999,999,999,999,999,999,999,999,999,999,999,999
c     &               ,999,999,999,999,999,999,999,999/)

        integer  :: ecfcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)

        integer  :: ezfcsthrs(maxtimes) = (/0,6,12,18,24,30,36,42,48,54
     &               ,60,66,72,78,84,90,96,102,108,114,120,126,132,138
     &               ,144,150,156,162,168,174,180,186,192,198,204,210
     &               ,216,222,228,234,240,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)


        integer  :: srfcsthrs(maxtimes) = (/0,3,6,9,12,15,18,21,24,27
     &               ,30,33,36,39,42,45,48,51,54,57,60,63,66,69
     &               ,72,75,78,81,84,87,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999,999,999,999,999,999,999,999
     &               ,999,999,999,999,999/)
        character*2, save :: run_basin
      end module ensinfo

      module grid_bounds
        integer, parameter :: maxbasins = 11
c---J.Peng-----2015-01-09---------------------------------------------
        character*2 :: basin(maxbasins) = (/'AL','EP','WP','CP'
     &                 ,'AA','BB','SI','SP','SC','EC','AU'/)
        real :: xmaxlat(maxbasins) = (/ 60.0, 60.0, 60.0, 60.0, 60.0
     &                        , 60.0, -1.0, -1.0,999.0,999.0,999.0/)

        real :: xminlat(maxbasins) = (/  1.0,  1.0,  1.0,  1.0,  1.0
     &                        ,  1.0,-60.0,-60.0,999.0,999.0,999.0/)

        real :: xmaxlon(maxbasins) = (/345.0,285.0,185.0,255.0,125.0
     &                        ,145.0,125.0,185.0,999.0,999.0,999.0/)

        real :: xminlon(maxbasins) = (/250.0,190.0, 90.0,160.0, 30.0
     &                        , 50.0, 30.0, 90.0,999.0,999.0,999.0/)
      end module grid_bounds

      module trig_vals
        real, save :: pi, dtr
        real, save :: dtk = 111.1949     ! Dist (km) over 1 deg lat
                                         ! using erad=6371.0e+3
        real, save :: erad = 6371.0e+3   ! Earth's radius (m)
        real, save :: ecircum = 40030.2  ! Earth's circumference
                                         ! (km) using erad=6371.e3
        real, save :: omega = 7.292e-5
      end module trig_vals

c
c--------------------------------------------------------------------
c
      program trakave
c
c$$$  MAIN PROGRAM DOCUMENTATION BLOCK
c
c Main Program: TRAKAVE      Get average of ensemble tracks
C   PRGMMR: MARCHOK          ORG: NP22        DATE: 2005-08-01
c
c ABSTRACT: This program reads in the tropical cyclone track files 
c   (in "atcfunix" format) from the various ensemble perturbation
c   members and produces an ensemble mean track.  Currently, the
c   program can handle members from the NCEP, ECMWF and CANADIAN
c   ensembles.
c
c Program history log:
c   2005-08-01  Marchok - Original operational version.
c   2006-08-02  Marchok - Changed pertubation IDs for Canadian ens
c                         (they no longer have "negative" perts).
c   2007-08-08  Marchok - Added code for averaging SREF ensemble tracks.
c
c Input files:
c   unit   11    Text file containing the concatenated atcfunix tracks
c                with all storms for all ensemble members at all 
c                forecast hours.
c
c Output files:
c   unit   52    Opened and closed internally, 1 file for each storm,
c                this series of output files contains the gridded 
c                strike probabilities, both for the individual forecast
c                hours as well as the accumulated probabilities.
c                pt (1,1) is the far NW point on this output grid, 
c                pt (imax,jmax) is the far SE point on this output grid.
c   unit   53    Output atcfunix file with mean ensemble track forecast
c                positions for each storm at each forecast hour.
c   unit   54    Output atcf file with mean ensemble track forecast
c                positions for each storm forecast hours 12-72.
c   unit   55    Output track file with mean ensemble track forecast
c                positions for each storm forecast hours 0-72.
c   unit   56    Output text file with ensemble track forecast spread
c                values for each storm at each forecast hour.
c   unit   57    Output text file with ensemble track forecast mode
c                values for each storm at each forecast hour.
c
c Subprograms called:
c   read_nlists  Read input namelists for input date & storm number info
c
c Attributes:
c   Language: Fortran90
c
c Notes:   
c   maxmem     This is the max number of members expected for a 
c              given Center's ensemble forecast
c   minmem     This is the minimum number of member tracks that need to 
c              exist at a given forecast hour in order to produce a mean
c              
c
c$$$
c
c-------
c
      USE define_atcfunix_rec; USE maxparms; USE trig_vals
      USE ensinfo

      type (atcfunix_card) saverec

      real,allocatable :: traklat(:,:,:)
      real,allocatable :: traklon(:,:,:)
cJ.Peng-04-15-2013
      real,allocatable :: tcvmx(:,:,:)
      real,allocatable :: tcpce(:,:,:)

      real    xmeanlat(maxstorms,maxtimes)
      real    xmeanlon(maxstorms,maxtimes)
cJ.Peng-04-15-2013
      real    xmeanvmx(maxstorms,maxtimes)
      real    xmeanpce(maxstorms,maxtimes)

      real    xspread(maxstorms,maxtimes)
      real    dthresh
      integer  :: fcsthrs(maxtimes)
      integer minmem,maxmem,fcst_interval
      character*4,allocatable :: perts(:)
      character*1 :: do_probs = 'y'
      character*1 :: modeflag = 'y'
      character*4 :: stormarr(maxstorms)
      character*4 :: catcf,catcf_lc
      character*5 :: cmodel
c
      pi = 4. * atan(1.)   ! Both pi and dtr were declared in module
      dtr = pi/180.0       ! trig_vals, but were not yet defined.

      xmeanlat = -9999.0; xmeanlon = -9999.0
cJ.Peng-04-15-2013
      xmeanvmx = -9999.0; xmeanpce = -9999.0

      xspread = -999.0

      call read_nlists (dthresh,cmodel)

      select case (cmodel)
        case ('ens');  maxmem = ncmaxmem; fcsthrs(:) = ncfcsthrs(:)
        case ('ref');  maxmem = nrmaxmem; fcsthrs(:) = nrfcsthrs(:)

        case ('ensb');  maxmem = n0maxmem; fcsthrs(:) = n0fcsthrs(:)
        case ('hf21');  maxmem = h0maxmem; fcsthrs(:) = h0fcsthrs(:)
        case ('ny10');  maxmem = y0maxmem; fcsthrs(:) = y0fcsthrs(:)
        case ('gd10');  maxmem = d0maxmem; fcsthrs(:) = d0fcsthrs(:)
        case ('egn3');  maxmem = e0maxmem; fcsthrs(:) = e0fcsthrs(:)
        case ('egt2');  maxmem = e1maxmem; fcsthrs(:) = e1fcsthrs(:)
        case ('ent2');  maxmem = e2maxmem; fcsthrs(:) = e2fcsthrs(:)
        case ('gnt2');  maxmem = e3maxmem; fcsthrs(:) = e3fcsthrs(:)

        case ('ukes');  maxmem = ukmaxmem; fcsthrs(:) = ukfcsthrs(:)

        case ('fres');  maxmem = frmaxmem; fcsthrs(:) = frfcsthrs(:)

c----------J.Peng----------2010-09-29-------------------------------
c        case ('gve');  maxmem = gcmaxmem; fcsthrs(:) = gcfcsthrs(:)
        case ('fens');  maxmem = gcmaxmem; fcsthrs(:) = gcfcsthrs(:)
        case ('fenb');  maxmem = g0maxmem; fcsthrs(:) = g0fcsthrs(:)

        case ('cens'); maxmem = ccmaxmem; fcsthrs(:) = ccfcsthrs(:)
        case ('cenb'); maxmem = c0maxmem; fcsthrs(:) = c0fcsthrs(:)


cJ.Peng-------2010-10-29--------------2010-11-02---------------
        case ('g2c'); maxmem = c2maxmem; fcsthrs(:) = c2fcsthrs(:)

        case ('naf2'); maxmem = f2maxmem; fcsthrs(:) = f2fcsthrs(:)

        case ('gce3'); maxmem = c3maxmem; fcsthrs(:) = c3fcsthrs(:)
        case ('nae2'); maxmem = n2maxmem; fcsthrs(:) = n2fcsthrs(:)
        case ('inae'); maxmem = m2maxmem; fcsthrs(:) = m2fcsthrs(:)

        case ('ncf3'); maxmem = f3maxmem; fcsthrs(:) = f3fcsthrs(:)

        case ('gce4'); maxmem = c4maxmem; fcsthrs(:) = c4fcsthrs(:)
        case ('gce5'); maxmem = c5maxmem; fcsthrs(:) = c5fcsthrs(:)

        case ('gce6'); maxmem = c6maxmem; fcsthrs(:) = c6fcsthrs(:)
        case ('neu3'); maxmem = n3maxmem; fcsthrs(:) = n3fcsthrs(:)


        case ('gce3a'); maxmem = s3maxmem; fcsthrs(:) = s3fcsthrs(:)
        case ('gce3b'); maxmem = p3maxmem; fcsthrs(:) = p3fcsthrs(:)

        case ('sing'); maxmem = d3maxmem; fcsthrs(:) = d3fcsthrs(:)
        case ('tot6'); maxmem = d6maxmem; fcsthrs(:) = d6fcsthrs(:)

        case ('six6'); maxmem = x6maxmem; fcsthrs(:) = x6fcsthrs(:)
        case ('tot4'); maxmem = d4maxmem; fcsthrs(:) = d4fcsthrs(:)

        case ('tot2'); maxmem = d2maxmem; fcsthrs(:) = d2fcsthrs(:)

        case ('eens');  maxmem = ecmaxmem; fcsthrs(:) = ecfcsthrs(:)
        case ('eefs');  maxmem = ezmaxmem; fcsthrs(:) = ezfcsthrs(:)

        case ('sref'); maxmem = srmaxmem; fcsthrs(:) = srfcsthrs(:)
      end select
         
      allocate (traklat(maxstorms,maxmem,maxtimes),stat=itla)
      allocate (traklon(maxstorms,maxmem,maxtimes),stat=itlo)
cJ.Peng-04-15-2013
      allocate (tcvmx(maxstorms,maxmem,maxtimes),stat=itlp)
      allocate (tcpce(maxstorms,maxmem,maxtimes),stat=itlq)

      allocate (perts(maxmem),stat=ipa)
      if (itla/=0.or.itlo/=0.or.ipa/=0.or.itlp/=0.or.itlq/=0) then
        print *,' '
        print *,'!!! ERROR in trakave allocating arrays.'
        print *,'!!! itla = ',itla,' itlo= ',itlo,' ipa= ',ipa
        stop 94
      endif

      traklat = -9999.0;  traklon = -9999.0
cJ.Peng-04-15-2013
      tcvmx = -9999.0
      tcpce = -9999.0

      select case (cmodel)
        case ('ens');  perts(:) = ncperts(:)
                       minmem   = ncminmem  
                       catcf    = 'AEMN'  
                       catcf_lc = 'aemn'  

        case ('ref');  perts(:) = nrperts(:)
                       minmem   = nrminmem
                       catcf    = 'GRMN'
                       catcf_lc = 'grmn'

        case ('ensb');  perts(:) = n0perts(:)
                       minmem   = n0minmem
                       catcf    = 'AEMB'
                       catcf_lc = 'aemb'

        case ('hf21');  perts(:) = h0perts(:)
                       minmem   = h0minmem
                       catcf    = 'HEMN'
                       catcf_lc = 'hemn'

        case ('ny10');  perts(:) = y0perts(:)
                       minmem   = y0minmem
                       catcf    = 'YEMN'
                       catcf_lc = 'yemn'

        case ('gd10');  perts(:) = d0perts(:)
                       minmem   = d0minmem
                       catcf    = 'GEMN'
                       catcf_lc = 'gemn'

        case ('egn3');  perts(:) = e0perts(:)
                       minmem   = e0minmem
                       catcf    = 'MEMN'
                       catcf_lc = 'memn'

        case ('egt2');  perts(:) = e1perts(:)
                       minmem   = e1minmem
                       catcf    = 'GHMN'
                       catcf_lc = 'ghmn'

        case ('ent2');  perts(:) = e2perts(:)
                       minmem   = e2minmem
                       catcf    = 'HYMN'
                       catcf_lc = 'hymn'

        case ('gnt2');  perts(:) = e3perts(:)
                       minmem   = e3minmem
                       catcf    = 'GYMN'
                       catcf_lc = 'gymn'

        case ('ukes');  perts(:) = ukperts(:)
                       minmem   = ukminmem
                       catcf    = 'UKMN'
                       catcf_lc = 'ukmn'

        case ('fres');  perts(:) = frperts(:)
                       minmem   = frminmem
                       catcf    = 'FRMN'
                       catcf_lc = 'frmn'

c        case ('gve');  perts(:) = gcperts(:)
c                       minmem   = gcminmem  
c                       catcf    = 'GVMN'  
c                       catcf_lc = 'gvmn'  
c-------J.Peng---------2010-09-29--------------------------
        case ('fens');  perts(:) = gcperts(:)
                       minmem   = gcminmem
c                       catcf    = 'FEMN'
c                       catcf_lc = 'femn'
                       catcf    = 'NEMN'
                       catcf_lc = 'nemn'


        case ('fenb');  perts(:) = g0perts(:)
                       minmem   = g0minmem
                       catcf    = 'FEMB'
                       catcf_lc = 'femb'


        case ('cens'); perts(:) = ccperts(:)
                       minmem   = ccminmem  
                       catcf    = 'CEMN'  
                       catcf_lc = 'cemn'  

        case ('cenb'); perts(:) = c0perts(:)
                       minmem   = c0minmem
                       catcf    = 'CEMB'
                       catcf_lc = 'cemb'

cJ.Peng-------2010-10-29-------------------------------------
        case ('g2c'); perts(:) = c2perts(:)
                       minmem   = c2minmem 
                       catcf    = '2EMN' 
                       catcf_lc = '2emn'

        case ('naf2'); perts(:) = f2perts(:)
                       minmem   = f2minmem
                       catcf    = '2NAF'
                       catcf_lc = '2naf'

cJ.Peng-------2010-11-02-----------------------------
        case ('gce3'); perts(:) = c3perts(:)
                       minmem   = c3minmem
                       catcf    = '3EMN'
                       catcf_lc = '3emn'

        case ('nae2'); perts(:) = n2perts(:)
                       minmem   = n2minmem
                       catcf    = '2NAE'
                       catcf_lc = '2nae'

        case ('inae'); perts(:) = m2perts(:)
                       minmem   = m2minmem
                       catcf    = 'NAEI'
                       catcf_lc = 'naei'

        case ('ncf3'); perts(:) = f3perts(:)
                       minmem   = f3minmem
                       catcf    = '3NCF'
                       catcf_lc = '3ncf'

        case ('gce4'); perts(:) = c4perts(:)
                       minmem   = c4minmem
                       catcf    = '4EMN'
                       catcf_lc = '4emn'

        case ('gce5'); perts(:) = c5perts(:)
                       minmem   = c5minmem
                       catcf    = '5EMN'
                       catcf_lc = '5emn'

        case ('gce6'); perts(:) = c6perts(:)
	               minmem   = c6minmem
		       catcf    = 'MIX6'
		       catcf_lc = 'mix6'

        case ('neu3'); perts(:) = n3perts(:)
                       minmem   = n3minmem
                       catcf    = '3NEU'
                       catcf_lc = '3neu'

        case ('gce3a'); perts(:) = s3perts(:)
                       minmem   = s3minmem
                       catcf    = 'SEMN'
                       catcf_lc = 'semn'
        case ('gce3b'); perts(:) = p3perts(:)
                       minmem   = p3minmem
                       catcf    = 'PEMN'
                       catcf_lc = 'pemn'

        case ('sing'); perts(:) = d3perts(:)
                       minmem   = d3minmem
                       catcf    = '3DET'
                       catcf_lc = '3det'
        case ('tot6'); perts(:) = d6perts(:)
                       minmem   = d6minmem
                       catcf    = '6EMN'
                       catcf_lc = '6emn'

        case ('six6'); perts(:) = x6perts(:)
                       minmem   = x6minmem
                       catcf    = 'SIXM'
                       catcf_lc = 'sixm'

        case ('tot4'); perts(:) = d4perts(:)
                       minmem   = d4minmem
                       catcf    = 'T4MN'
                       catcf_lc = 't4mn'

        case ('tot2'); perts(:) = d2perts(:)
                       minmem   = d2minmem
                       catcf    = 'S6MN'
                       catcf_lc = 's6mn'


        case ('eens');  perts(:) = ecperts(:)
                       minmem   = ecminmem  
                       catcf    = 'EEMN'  
                       catcf_lc = 'eemn'  

        case ('eefs');  perts(:) = ezperts(:)
                       minmem   = ezminmem
                       catcf    = 'TEMN'
                       catcf_lc = 'temn'

        case ('sref'); perts(:) = srperts(:)
                       minmem   = srminmem  
                       catcf    = 'SFMN'  
                       catcf_lc = 'sfmn'  
      end select
 
      fcst_interval = fcsthrs(2) - fcsthrs(1)

cJ.Peng-04-15-2013
      call read_atcfunix (traklat,traklon,tcvmx,tcpce,
     & saverec,stormarr,maxmem,fcst_interval,perts)

      do i = 1,maxstorms
        print *,'i= ',i,'  stormarr(i)= ',stormarr(i)
      enddo

cJ.Peng-04-15-2013
      call get_mean_track (traklat,traklon,xmeanlat,xmeanlon
     &            ,tcvmx,tcpce,xmeanvmx,xmeanpce
     &            ,stormarr,saverec,maxmem,minmem,catcf,fcsthrs)

      call get_spread (traklat,traklon,xmeanlat,xmeanlon,xspread
     &                ,stormarr,saverec,maxmem,minmem,fcsthrs)

      if (do_probs == 'y') then
        call get_probs (traklat,traklon,xmeanlat,xmeanlon
     &             ,stormarr,saverec%atx_ymdh,dthresh,'indiv'
     &             ,modeflag,catcf,maxmem,fcsthrs,catcf_lc)
        call get_probs (traklat,traklon,xmeanlat,xmeanlon
     &             ,stormarr,saverec%atx_ymdh,dthresh,'accum'
     &             ,modeflag,catcf,maxmem,fcsthrs,catcf_lc)
      endif

      print *,' '
      print *,'NORMAL END TO TRAKAVE....'
      print *,' '

      deallocate (traklat,stat=ictla)
      deallocate (traklon,stat=ictlo)

cJ.Peng-04-15-2013
      deallocate (tcvmx,stat=ictlp)
      deallocate (tcpce,stat=ictlq)

      deallocate (perts,stat=icpa)

      if (ictla/=0.or.ictlo/=0.or.icpa/=0.or.ictlp/=0.or.ictlq/=0) then
        print *,' '
        print *,'!!! ERROR in trakave deallocating arrays.'
        print *,'!!! ictla = ',ictla,' ictlo= ',ictlo,' icpa= ',icpa
        stop 94
      endif

      stop 
      end

c
c----------------------------------------------------------------------
c
c----------------------------------------------------------------------
      subroutine get_probs (traklat,traklon,xmeanlat,xmeanlon
     &                     ,stormarr,cymdh,dthresh,prob_type
     &                     ,modeflag,catcf,maxmem,fcsthrs,catcf_lc)
c
c     ABSTRACT: This subroutine calculates the probability of a
c     given location (gridpoint) being within a specified distance
c     of an ensemble member trackpoint.  For the domain, we'll sort
c     through all the track points and get the most extreme
c     N, E, S and W points, then add a certain amount onto that on
c     each side.  Then, for all the gridpoints that are included,
c     we'll go one by one to each gridpoint and calculate the 
c     distances from each forecast track point at that hour to 
c     each gridpoint.  If that distance is less than the specified
c     distance threshold, we add it to the total, and then divide
c     that total count by the total number of members to get the 
c     probability at that gridopoint for that forecast hour.
c     
c     NOTE: This particular subroutine can calculate the 
c     probabilities individually for each forecast hour or for
c     the total accumulated probability over the forecast, 
c     depending on the value of the input variable prob_type.
c     If we are doing this for individual cases, then we will
c     also call  get_prob_mode in order to get the ensemble 
c     probability mode and print it out in a separate atcfunix
c     record.


      USE maxparms; USE grid_bounds; USE trig_vals; USE ensinfo

      real  traklat(maxstorms,maxmem,maxtimes)
      real  traklon(maxstorms,maxmem,maxtimes)
      real  xmeanlat(maxstorms,maxtimes)
      real  xmeanlon(maxstorms,maxtimes)
      real, allocatable :: xprob(:,:)
      real  :: xnm_per_degree = 60.0    
      real  xdist,dthresh,xlondiff,xlatdiff,xinterplon,xinterplat
      character*1 :: modeflag,hold_input_modeflag
      character*2 :: cbasin
      character*4 :: stormarr(maxstorms),cstorm,catcf,catcf_lc
      character*5 :: prob_type
      character*10   cymdh
      character*12   cacc
      character*46   outgrfile
      character*33   outtxtfile
      character      cthresh1*1,cthresh2*2,cthresh3*3,cthresh4*4
      integer :: fcsthrs(maxtimes)
      integer  basinix,ifh_interval,ibct
      integer, allocatable :: accum_ct(:,:)
      integer  max_accum_prob_hour
      logical(1),allocatable :: gridpoint_already_hit(:,:,:)
c
c      outtxtfile = 'enstrkprob.'//cymdh//'.ctlinfo.txt'
c      open (unit=51,file=outtxtfile,status='unknown')

      if (catcf_lc == 'sfmn') then
        max_accum_prob_hour = 87   ! SREF max fcst hour = 87 in Aug 2007
      else
c--------J.Peng----2011-01-11---------------------------------------
        max_accum_prob_hour = 168  ! For all others, go out to 120h
      endif

      hold_input_modeflag = modeflag

      stormloop: do ist = 1,maxstorms

        modeflag = hold_input_modeflag

        ! As of June, 2002, we will only compute these probabilities
        ! for storms in the AL, EP and WP basins.  This next code
        ! checks for those basin ID's and will cycle the stormloop
        ! if it's not one of those basins....

        cbasin = stormarr(ist)(1:2)
c--------J.Peng----2015-01-09---------------------------------
        if (cbasin == 'AL' .or. cbasin == 'EP' .or. cbasin == 'WP' 
     & .or. cbasin == 'CP' .or. cbasin == 'AA' .or. cbasin == 'BB'
     & .or. cbasin == 'SI' .or. cbasin == 'SP' )then

          continue
        else
          print *,' '
          print *,'+++ NOTE: In get_probs, we are NOT calculating'
          print *,'+++       the probabilities for storm '
     &                      ,stormarr(ist)
          print *,'+++       It is not in a basin we do probs for.'
          print *,' '
          cycle stormloop
        endif

        ! Get the index for the basin we're in.

        basinix = -99
        ibct = 1
        basinloop: do while (ibct <= maxbasins)
          if (cbasin == basin(ibct)) then
            basinix = ibct
            exit basinloop
          endif
          ibct = ibct + 1
        enddo basinloop
        if (basinix == -99) then
          print *,' '
          print *,'!!! ERROR IN GET_PROBS.  BASIN IS NOT '
          print *,'!!! RECOGNIZED.  BASIN = ',cbasin
          print *,'!!! EXITING....'
          stop 99
        endif

        ! In an older version of this program, we narrowed the area 
        ! over which we computed the probabilities to keep the file 
        ! size smaller, but that meant that each output file had 
        ! different starting and ending points.  In this new version
        ! we just calculate it over the whole basin.

        maxlat = int(xmaxlat(basinix))
        maxlon = int(xmaxlon(basinix))
        minlat = int(xminlat(basinix))
        minlon = int(xminlon(basinix))

        numlat = abs(maxlat-minlat) + 1
        numlon = abs(maxlon-minlon) + 1

        itemp = int(dthresh)
        if (itemp < 10) then
          write (cthresh1,'(i1)') itemp
          outgrfile = catcf_lc//'.trkprob.'//stormarr(ist)//'.'//
     &              cthresh1//'nm.'//cymdh//'.'//prob_type//'.ieee'
        else if (itemp >= 10 .and. itemp < 100) then
          write (cthresh2,'(i2)') itemp
          outgrfile = catcf_lc//'.trkprob.'//stormarr(ist)//'.'//
     &              cthresh2//'nm.'//cymdh//'.'//prob_type//'.ieee'
        else if (itemp >= 100 .and. itemp < 1000) then
          write (cthresh3,'(i3)') itemp
          outgrfile = catcf_lc//'.trkprob.'//stormarr(ist)//'.'//
     &              cthresh3//'nm.'//cymdh//'.'//prob_type//'.ieee'
        else if (itemp >= 1000) then
          write (cthresh4,'(i4)') itemp
          outgrfile = catcf_lc//'.trkprob.'//stormarr(ist)//'.'//
     &              cthresh4//'nm.'//cymdh//'.'//prob_type//'.ieee'
        endif

        print *,' '
        print *,'Before open 52, stormarr(ist) = ',stormarr(ist)
        print *,' '

        if (xmeanlon(ist,1) > 0.0) then
          print *,' '
          print *,'!!! OPEN:  '
          print *,'   open for prob_type = ',prob_type
          print *,'   ist = ',ist,'  xmeanlon = ',xmeanlon(ist,1)
          print *,'   file name = ',outgrfile
          print *,'   dthresh = ',dthresh
          inquire (52,access=cacc) 
          print *,'   cacc 1 = ',cacc
          open (unit=52,file=outgrfile,access='direct'
     &         ,form='unformatted',iostat=ios
     &         ,status='unknown',recl=numlat*numlon*4)
          print *,'   ios = ',ios
          inquire (52,access=cacc) 
          print *,'   cacc 2 = ',cacc
        else
          cycle stormloop
        endif

        cstorm = stormarr(ist)

        if (prob_type == 'indiv') then
          write (51,82) stormarr(ist),cymdh,numlon,minlon,numlat,minlat
        endif

   82   format (a4,1x,a10,' nx= ',i4,' beglon= ',i3
     &                   ,' ny= ',i4,' beglat= ',i3)

        ! Allocate the xprob array.  Pt (1,1) is in the far NW part 
        ! of the subgrid.

        if (.not.allocated(xprob)) then
          allocate (xprob(numlon,numlat),stat=ipa)
          if (ipa /= 0) then
            print *,' '
            print *,'!!! ERROR in sub get_probs allocating xprob array.'
            print *,'!!! ipa = ',ipa
            igpret = 94
            return
          endif
        endif

        if (.not.allocated(gridpoint_already_hit)) then
          allocate (gridpoint_already_hit(numlon,numlat,maxmem)
     &             ,stat=iga)
          if (iga /= 0) then
            print *,' '
            print *,'!!! ERROR in sub get_probs allocating '
            print *,'!!! gridpoint_already_hit array.'
            print *,'!!! iga = ',iga
            igpret = 94
            return
          endif
        endif

        if (.not.allocated(accum_ct)) then
          allocate (accum_ct(numlon,numlat),stat=iaa)
          if (iaa /= 0) then
            print *,' '
            print *,'!!! ERROR in sub get_probs allocating '
            print *,'!!! accum_ct array.'
            print *,'!!! iaa = ',iaa
            igpret = 94
            return
          endif
        endif

        ! Now go through each forecast time and get the
        ! probabilities at each grid point.  We check the xmeanlon
        ! at each forecast time to make sure that we still have a
        ! mean track (i.e., that the forecast isn't over or that
        ! the storm didn't dissipate).
        !
        ! Note below that the indexing of the xprob array will go
        ! so that pt (1,1) is in the upper left (most NW) corner
        ! of the subgrid, and point (maxlon,maxlat) is in the 
        ! lower right (most SE) corner of the subgrid.

        print *,' '
        print *,' '
        print *,'++++++++++++++++++++++++ '
        print *,' +++ NEW STORM +++'
        print *,'++++++++++++++++++++++++ '
        print *,'ist= ',ist,' maxlat= ',maxlat,' minlat= ',minlat
        print *,' '

c--------J.Peng-----2010-10-26---------------------
        gridpoint_already_hit = .false.
        accum_ct = 0

        ifhloop: do ifh = 1,maxtimes

          ifhour = fcsthrs(ifh) 
          print *,' '
          print *,'++++++++++++++++++++++++ '
          print *,' +++ NEW TIME +++'
          print *,'++++++++++++++++++++++++ '
          print *,'ifh= ',ifh,' ist= ',ist,'  forecast hour = ',ifhour

          if (ifhour > max_accum_prob_hour .and. prob_type == 'accum')
     &    then
            print *,' '
            print *,'!!! NOT CALCULATING ACCUM PROBS PAST '
     &             ,max_accum_prob_hour,'hours'
            exit ifhloop
          endif

          if (xmeanlon(ist,ifh) > 0.0) then    ! valid mean fcst at ifh

            xprob = 0.0
            latloop: do jlat = maxlat,minlat,-1

c              print *,'jlat= ',jlat

              jix = maxlat - jlat + 1
              ylat = float(jlat)

              lonloop: do ilon = minlon,maxlon

c                print *,'ilon= ',ilon

                iix = ilon - minlon + 1
                xlon = float(ilon)

                ict = 0
                ipt = 0
                memberloop: do im = 1,maxmem

                  ict = ict + 1
                  if (traklon(ist,im,ifh) > 0.0) then
                    call calcdist (xlon,ylat,traklon(ist,im,ifh)
     &                            ,traklat(ist,im,ifh),dtr,xdist)
                    if (xdist <= dthresh) then
                      if (prob_type == 'accum') then
c--------J.Peng-----2010-10-26---------------------
                        if (gridpoint_already_hit(iix,jix,im)) then
                          continue
                        else
                          accum_ct(iix,jix) = accum_ct(iix,jix) + 1
                          gridpoint_already_hit(iix,jix,im) = .true.
                        endif
c                          accum_ct(iix,jix) = accum_ct(iix,jix) + 1
                      else
                        ipt = ipt + 1
c                        print *,'++YES, dist= ',xdist,' ipt= ',ipt
                      endif
                    endif 
                  endif

                  ! * * * * * * * * * * * * * * * * * * * * * * * * * *
                  ! INTERPOLATE TRACKS FOR "ACCUMULATED" PROBABILITIES:
                  ! For accum probs, interpolate the tracks in between
                  ! time periods to get a smooth track and not miss 
                  ! any "in-between" points.  Don't need to do this for
                  ! the individual, instantaneous track probs at each
                  ! forecast hour.  Currently, since TPC only does their
                  ! accumulated probabilities out to 120h, we will only
                  ! do ours to 120h as well, so don't interpolate if the
                  ! the next forecast hour would be > 120.
                  ! * * * * * * * * * * * * * * * * * * * * * * * * * *

                  if (prob_type == 'accum' .and. ifh < maxtimes .and.
     &                fcsthrs(ifh+1) <= max_accum_prob_hour) then
                    if (traklon(ist,im,ifh)   > 0.0 .and. 
     &                  traklon(ist,im,ifh+1) > 0.0) then
                      ifh_interval = fcsthrs(ifh+1) - fcsthrs(ifh)
                      xlondiff = traklon(ist,im,ifh+1) - 
     &                           traklon(ist,im,ifh)
                      xlatdiff = traklat(ist,im,ifh+1) - 
     &                           traklat(ist,im,ifh)
                      interploop: do iint = 1,ifh_interval-1
                        xinterplon = traklon(ist,im,ifh) + 
     &                               (float(iint)/float(ifh_interval) *
     &                                xlondiff)
                        xinterplat = traklat(ist,im,ifh) + 
     &                               (float(iint)/float(ifh_interval) *
     &                                xlatdiff)
                        call calcdist (xlon,ylat,xinterplon
     &                                ,xinterplat,dtr,xdist)
                        if (xdist <= dthresh) then
c--------J.Peng-----2010-10-26---------------------
                          if (gridpoint_already_hit(iix,jix,im)) then
                            continue
                          else
                            accum_ct(iix,jix) = accum_ct(iix,jix) + 1
                            gridpoint_already_hit(iix,jix,im) = .true.
                          endif
c                            accum_ct(iix,jix) = accum_ct(iix,jix) + 1
                        endif
                      enddo interploop
                    endif
                  endif

                enddo memberloop

                if (maxmem > 0) then
c                  print *,'xprob: ipt= ',ipt,' ict= ',ict,' prob= '
c     &                     ,float(ipt)/float(maxmem)
                  xprob(iix,jix) = float(ipt)/float(maxmem)
                endif

              enddo lonloop

            enddo latloop

c           If the probability type is for an individual forecast hour,
c           then write out the data right now for this hour, and then
c           if the modeflag is set to find the probability mode, call
c           the subroutine  get_prob_mode.

            if (prob_type == 'indiv') then
c              do iii = 1,numlon
c                do jjj = 1,numlat
c                  if (xprob(iii,jjj) > 0.0) then
c                    print *,'HEY, iii= ',iii,' jjj= ',jjj,' xprob= '
c     &                     ,xprob(iii,jjj)
c                  endif
c                enddo
c              enddo 
cccccc-------J.Peng.------2010-09-30--------------------------------
              print *,'JPENG_ifh=',ifh 
              write (52,rec=ifh) ((xprob(i,j),i=1,numlon),j=1,numlat)
              if (modeflag == 'y') then
                call get_prob_mode (numlon,numlat,minlon,maxlon,minlat
     &               ,maxlat,xprob,xmodelon,xmodelat,xmodeval,ifhour
     &               ,cstorm,cymdh,ifh,dthresh,xmeanlon,xmeanlat,ist
     &               ,basinix,catcf,fcsthrs,modeflag)
              endif
            endif

          else

            cycle ifhloop

          endif
              
        enddo ifhloop

        if (prob_type == 'accum') then
          jloop: do jlat = maxlat,minlat,-1
            jix = maxlat - jlat + 1
            ylat = float(jlat)
            iloop: do ilon = minlon,maxlon
              iix = ilon - minlon + 1
              xlon = float(ilon)
              xprob(iix,jix) = float(accum_ct(iix,jix)) /
     &                         float(maxmem)
c              print *,'jix= ',jix,' iix= ',iix,' xprob= ',xprob(iix,jix)
c              write (61,120) jix,iix,float(jlat),float(ilon)
c     &                       ,xprob(iix,jix)
            enddo iloop
          enddo jloop
          irec=1
          write (52,rec=irec) ((xprob(i,j),i=1,numlon),j=1,numlat)
        endif

        deallocate (xprob,stat=icxa)
        if (icxa /= 0) then
          print *,' '
          print *,'!!! ERROR in trakave deallocating xprob array.'
          print *,'!!! icxa = ',icxa
          stop 94
        endif

        close (52)

      enddo stormloop

 120  format (1x,'jix= ',i3,' iix= ',i3,' jlat= ',f6.1,' ilon= '
     &          ,f6.1,' xprob= ',f6.2)

      icgaha = 0
      icaca  = 0

      if (allocated(gridpoint_already_hit)) then
        deallocate (gridpoint_already_hit,stat=icgaha)
      endif

      if (allocated(accum_ct)) then
        deallocate (accum_ct,stat=icaca)
      endif

      if (icgaha /= 0 .or. icaca /= 0) then
        print *,' '
        print *,'!!! ERROR in trakave deallocating gridpoint'
        print *,'!!! or accum_ct arrays.'
        print *,'!!! icgaha = ',icgaha,' icaca= ',icaca
        stop 94
      endif
c
      return
      end
       
c
c----------------------------------------------------------------
c
c----------------------------------------------------------------
      subroutine get_mean_track (traklat,traklon,xmeanlat,xmeanlon
     &            ,tcvmx,tcpce,xmeanvmx,xmeanpce
     &              ,stormarr,saverec,maxmem,minmem,catcf,fcsthrs)

c     ABSTRACT: This subroutine calculates the mean lat and lon 
c     positions for each storm at each forecast hour.  maxmem is
c     the maximum number of members for a given Center's forecast,
c     while minmem is the minimum number of member tracks that must
c     exist at a given forecast hour in order to produce a forecast
c     track.  Currently, I have this set at ~40% of maxmem, so for
c     NCEP (maxmem=10,minmem=4), CMC (maxmem=16,minmem=6),
c     ECMWF (maxmem=50,minmem=20)

      USE define_atcfunix_rec; USE maxparms
      USE trig_vals

      type (atcfunix_card) saverec

      real  traklat(maxstorms,maxmem,maxtimes)
      real  traklon(maxstorms,maxmem,maxtimes)
      real  xmeanlat(maxstorms,maxtimes)
      real  xmeanlon(maxstorms,maxtimes) 
cJ.Peng-04-15-2013----
      real  tcvmx(maxstorms,maxmem,maxtimes)
      real  tcpce(maxstorms,maxmem,maxtimes)
      real  xmeanvmx(maxstorms,maxtimes)
      real  xmeanpce(maxstorms,maxtimes)
      real  stdvmx(maxstorms,maxtimes)
      real  stdpce(maxstorms,maxtimes)
      real  yspread(maxstorms,maxtimes)

      integer :: fcsthrs(maxtimes)
      integer pairct
      character*4 :: stormarr(maxstorms)
      character*4 :: catcf
      yspread =-999.0 
c
      print *,' '
      print *,'************************** '
      print *,'*** In get_mean_track.... '
      print *,'************************** '
      print *,' '

      stormloop: do ist = 1,maxstorms

        print *,' '
        print *,'-------------------'
        print *,'storm number = ',ist
        print *,'storm name   = ',stormarr(ist)
        print *,' '

        timeloop: do ifh = 1,maxtimes

          ict = 0
          xlatsum = 0.0
          xlonsum = 0.0

cJ.Peng-04-15-2013-----
	  xvmxsum = 0.0
	  xpcesum = 0.0 

          print *,' '
          print *,' time index (ifh) = ',ifh
          print *,' '

          do imem = 1,maxmem
            if (traklon(ist,imem,ifh) > 0.0) then
              ict = ict + 1
              xlatsum = xlatsum + traklat(ist,imem,ifh)
cJ.Peng------03/27/2015-----------------------------------
c              xlonsum = xlonsum + traklon(ist,imem,ifh)
c              if(traklon(ist,imem,ifh) < 30.0) then
cJ.Peng------03262019--bug fix for SI storms -----------
              if(traklon(ist,imem,ifh) < 30.0
     &            .and. traklat(ist,imem,ifh) > 0.0) then
                xlonsum = xlonsum + traklon(ist,imem,ifh)+360.0
              else
                xlonsum = xlonsum + traklon(ist,imem,ifh)
              endif
cJ.Peng------03/27/2015-----------------------------------

cJ.Peng-04-15-2013-----
              xvmxsum = xvmxsum + tcvmx(ist,imem,ifh)
   	      xpcesum = xpcesum + tcpce(ist,imem,ifh)

              print *,'mem= ',imem,' lat= ',traklat(ist,imem,ifh)
     &                            ,' lon= ',traklon(ist,imem,ifh)
            else
              print *,'mem= ',imem,' lat= ',traklat(ist,imem,ifh)
     &                            ,' lon= ',traklon(ist,imem,ifh)
            endif
          enddo


c          pairct = 0
c          if (traklon(ist,1,ifh) > 0.0 .and. traklon(ist,6,ifh) > 0.0)
c     &    then
c            pairct = pairct + 1
c          endif
c          if (traklon(ist,2,ifh) > 0.0 .and. traklon(ist,7,ifh) > 0.0)
c     &    then
c            pairct = pairct + 1
c          endif
c          if (traklon(ist,3,ifh) > 0.0 .and. traklon(ist,8,ifh) > 0.0)
c     &    then
c            pairct = pairct + 1
c          endif
c          if (traklon(ist,4,ifh) > 0.0 .and. traklon(ist,9,ifh) > 0.0)
c     &    then
c            pairct = pairct + 1
c          endif
c          if (traklon(ist,5,ifh) > 0.0 .and. traklon(ist,10,ifh) > 0.0)
c     &    then
c            pairct = pairct + 1
c          endif
c          if (ict > 2 .and. pairct >= 2) then


          if (ict >= minmem) then
            xmeanlat(ist,ifh) = xlatsum / ict
            xmeanlon(ist,ifh) = xlonsum / ict
            print *,'MEAN:  LAT= ',xmeanlat(ist,ifh)
     &                   ,' LON= ',xmeanlon(ist,ifh)

cJ.Peng-04-15-2013-----------
	    xmeanvmx(ist,ifh) = xvmxsum / ict
	    xmeanpce(ist,ifh) = xpcesum / ict
cJ.Peng-04-15-2013---spread for intensity----wind and SLP
            jct = 0
            svmxsum = 0.0
            spcesum = 0.0
            do imem = 1,maxmem
              if (traklon(ist,imem,ifh) > 0.0) then
		jct = jct + 1
		svmxsum = svmxsum +
     &               (tcvmx(ist,imem,ifh)-xmeanvmx(ist,ifh))**2
                spcesum = spcesum + 
     &               (tcpce(ist,imem,ifh)-xmeanpce(ist,ifh))**2
	      endif 
            enddo 
            if (jct >= minmem) then
	      stdvmx(ist,ifh) = sqrt(svmxsum/jct)
	      stdpce(ist,ifh) = sqrt(spcesum/jct)
            endif
cJ.Peng-04-15-2013---spread for track------------------
            xdistsum = 0.0
	    imemct   =   0
	    do imem = 1,maxmem
              if (traklon(ist,imem,ifh) > 0.0) then
		call calcdist (xmeanlon(ist,ifh),xmeanlat(ist,ifh)
     &              ,traklon(ist,imem,ifh),traklat(ist,imem,ifh)
     &              ,dtr,xdist)
		xdistsum = xdistsum + xdist
		imemct   = imemct + 1
              endif
            enddo
	    if (imemct >= minmem) then
	      yspread(ist,ifh) = xdistsum / float(imemct)
            endif
c---------------------------------------------------------------
c            call output_atcfunix (stormarr(ist),saverec%atx_ymdh
c     &           ,xmeanlat(ist,ifh),xmeanlon(ist,ifh),ifh,'mean'
c     &           ,-99.0,-99.0,catcf,fcsthrs)
cJ.Peng-04-15-2013---------
            call output_atcfunix1 (stormarr(ist),saverec%atx_ymdh
     &           ,xmeanlat(ist,ifh),xmeanlon(ist,ifh)
     &           ,stdvmx(ist,ifh),stdpce(ist,ifh),yspread(ist,ifh)
     &           ,xmeanvmx(ist,ifh),xmeanpce(ist,ifh),ifh,'mean'
     &           ,-99.0,-99.0,catcf,fcsthrs)

c          else if (ict > 0 .and. ict <= 2) then
          else if (ict > 0 .and. ict < minmem) then
            xmlat = xlatsum / ict
            xmlon = xlonsum / ict
            print *,' '
            print *,'!!! NOT ENOUGH MEMBERS FOR MEAN FOR STORM #',ist
            print *,'!!! STORM NAME = ',stormarr(ist)
            print *,'!!! MODEL NAME = ',catcf
            print *,'!!! NUMBER OF MEMBERS = ',ict,'  TIME INDEX = ',ifh
            print *,'!!! MINIMUM NUMBER OF MEMBERS NEEDED= ',minmem
            print *,'!!! MEAN POSITION WOULD HAVE BEEN: '
            print *,'!!! LAT: ',xmlat,'  LON: ',xmlon
          else
            print *,'!!! UNDEFINED MEAN POSITION !!!'
          endif

        enddo timeloop
c------J.Peng---------2010-09-29------------------------------------
c        if (xmeanlon(ist,1) > 0.0) then
c          call output_atcf (stormarr(ist),xmeanlon,xmeanlat
c     &                      ,saverec%atx_ymdh,ist,catcf)
c          call output_all (stormarr(ist),xmeanlon,xmeanlat
c     &                      ,saverec%atx_ymdh,ist,catcf)
c     &                    
c        endif

      enddo stormloop

      return
      end

c
c------------------------------------------------------------------
c
c------------------------------------------------------------------
      subroutine get_spread (traklat,traklon,xmeanlat,xmeanlon
     &          ,xspread,stormarr,saverec,maxmem,minmem,fcsthrs)
c
c     ABSTRACT: This subroutine calculates the spread of the 
c     ensemble track forecasts, defined as the average distance
c     of the ensemble members to the mean track.

      USE trig_vals; USE maxparms; USE define_atcfunix_rec
      USE ensinfo

      type (atcfunix_card) saverec

      real      traklat(maxstorms,maxmem,maxtimes)
      real      traklon(maxstorms,maxmem,maxtimes)
      real      xmeanlat(maxstorms,maxtimes)
      real      xmeanlon(maxstorms,maxtimes)
      real      xspread(maxstorms,maxtimes)
      real      xdistsum,xdist
      integer :: fcsthrs(maxtimes)
      integer   imemct,ict,ifh_interval,ifhour
      character*4 :: stormarr(maxstorms)
c
      print *,' '
      print *,'************************** '
      print *,'*** In get_spread.... '
      print *,'************************** '
      print *,' '

      ifh_interval = fcsthrs(2) - fcsthrs(1)

      stormloop: do ist = 1,maxstorms

        print *,' '
        print *,'-------------------'
        print *,'Spread calculation '
        print *,'storm number = ',ist
        print *,'storm name   = ',stormarr(ist)
        print *,' '

        timeloop: do ifh = 1,maxtimes

          ifhour = (ifh - 1) * ifh_interval

          print *,' '
          print *,' time index (ifh) = ',ifh,' fhour= '
     &           ,ifhour
          print *,' '

          if (xmeanlat(ist,ifh) > -999.0) then

            ! We have a valid mean for this storm and tau

            xdistsum = 0.0
            imemct   =   0

            write (*,81) 'MEAN:  LAT= ',xmeanlat(ist,ifh)
     &                        ,' LON= ',xmeanlon(ist,ifh)

            do imem = 1,maxmem
              if (traklon(ist,imem,ifh) > 0.0) then
                call calcdist (xmeanlon(ist,ifh),xmeanlat(ist,ifh)
     &              ,traklon(ist,imem,ifh),traklat(ist,imem,ifh)
     &              ,dtr,xdist)
                write (*,83) 'pert:  LAT= ',traklat(ist,imem,ifh)
     &              ,' LON= ',traklon(ist,imem,ifh),'  pert= ',imem
     &              ,'  xdist= ',xdist,' nm'
                xdistsum = xdistsum + xdist
                imemct   = imemct + 1
              endif
            enddo

            if (imemct >= minmem) then
              xspread(ist,ifh) = xdistsum / float(imemct)
              write (*,85) 'SPREAD: ',xspread(ist,ifh),'  nmem= '
     &                    ,imemct,'  ifh= ',ifh
              write (56,95) stormarr(ist),saverec%atx_ymdh,ifhour
     &             ,'SPREAD: ',xspread(ist,ifh),'  nmem= ',imemct
     &             ,'  ifh= ',ifh
            else
              xspread(ist,ifh) = -999.0
              write (*,87) 'SPREAD: NOT ENOUGH MEMBERS, nmem= ',imemct
              write (56,95) stormarr(ist),saverec%atx_ymdh,ifhour
     &                     ,'SPREAD: ',-999.0,'  nmem= ',imemct
     &                     ,'  ifh= ',ifh
            endif
       
          else
 
            write (*,89) 'SPREAD: No mean track for this time'
            write (56,95) stormarr(ist),saverec%atx_ymdh,ifhour
     &                   ,'SPREAD: ',-999.0,'  nmem= ',0
     &                   ,'  ifh= ',ifh
 
          endif

        enddo timeloop

        if (xmeanlat(ist,1) > -999.0) then
          ! We have at least a valid initial time for this storm, so we
          ! should print out the spread array....
          write (65,91) saverec%atx_ymdh,stormarr(ist)
     &                 ,(xspread(ist,ifh),ifh=1,8)
        endif

      enddo stormloop

  81  format (1x,a12,f7.2,2x,a6,f7.2)
  83  format (1x,a12,f7.2,2x,a6,f7.2,2x,a8,i2,2x,a9,f7.2,a3)
  85  format (1x,a8,f7.2,2x,a8,i2,a7,i2)
  87  format (1x,a34,i2)
  89  format (1x,a35)
  91  format (1x,a10,3x,a4,8(3x,f7.2))
  95  format (1x,a4,2x,a10,2x,'fhour= ',i3,3x,a8,f8.2,2x,a8,i2,a7,i2)
      
      return
      end
c
c------------------------------------------------------------------
c
c------------------------------------------------------------------
      subroutine get_prob_mode (numlon,numlat,minlon,maxlon,minlat
     &        ,maxlat,xprob,xmodelon,xmodelat,xmodeval,ifhour
     &        ,cstorm,cymdh,ifh,dthresh,xmeanlon,xmeanlat,ist
     &        ,basinix,catcf,fcsthrs,modeflag)
c
c     ABSTRACT: This subroutine will scan the array of probabilities
c     in order to find the highest probability, or mode.  Since there
c     is a very good chance that you may have bimodal or multimodal
c     cases in which there is more than one probability mode, we need
c     a way to select only one mode.  A barnes analysis, used for 
c     conducting the search, effectively applies a gaussian filter
c     to provide a sort of area-averaged value.  This will help to
c     highlight one area among any other similar areas.
c
c     re      input e-folding radius for barnes analysis
c     ri      input influence radius for searching for min/max

      USE maxparms; USE trig_vals; USE grid_bounds

      real        xprob(numlon,numlat)
      real        rlon(numlon),rlat(numlat)
      real        xmeanlon(maxstorms,maxtimes)
      real        xmeanlat(maxstorms,maxtimes)
      real        re,ri,blat,blon,bval,ctlon,ctlat,dell
      real        tlat,tlon,fixlon,fixlat,dthresh
      real        xmodelon,xmodelat,xmodeval
      integer     fcsthrs(maxtimes)
      integer     numlon,numlat,minlon,minlat,maxlon,maxlat,basinix
     
      character*1 modeflag
      character*4 cstorm,catcf
      character(*) cymdh

c      re   = 150.0
c      ri   = 300.0
      re   = 120.0
      ri   = 240.0
      fmax = -1.0e+10
      dell = grdspc
      nhalf = 3

c     First and foremost we need to check to see if our storm is out
c     of our grid bounds that we have prescribed for this probability
c     mode analysis.  If in fact it is outside those bounds, then
c     quit this analysis and return (this should only happen on very
c     rare occasions, such as if TPC keeps a storm under their control
c     that passes into the central Pacific instead of handing it off
c     to CPHC).

      if (xmeanlon(ist,ifh) > 0.0                 .and.
     &    xmeanlon(ist,ifh) >= xminlon(basinix)   .and.
     &    xmeanlon(ist,ifh) <= xmaxlon(basinix)   .and.
     &    xmeanlat(ist,ifh) >= xminlat(basinix)   .and.
     &    xmeanlat(ist,ifh) <= xmaxlat(basinix)) then
        continue
      else
        print *,' '
        print *,'!!! WARNING: in get_prob_mode, the current storm'
        print *,'!!! mean position is outside the bounds for this'
        print *,'!!! specified ocean domain.  Therefore, we cannot'
        print *,'!!! calculate the mode at this hour.'
        print *,'!!! RETURNING.....'
        print *,' '
        print *,'    Storm info:'
        print *,'       Storm index=         ',ist
        print *,'       Forecast hour index= ',ifh
        print *,'       Mean longitude=      ',xmeanlon(ist,ifh)
        print *,'       Mean latitude=       ',xmeanlat(ist,ifh)
        print *,' '
        print *,'    Grid info:'
        print *,'       basinix= ',basinix
        print *,'       min longitude= ',xminlon(basinix)
        print *,'       max longitude= ',xmaxlon(basinix)
        print *,'       min latitude= ',xminlat(basinix)
        print *,'       max latitude= ',xmaxlat(basinix)
        print *,' '
        return
      endif


c     First we need to be able to narrow our scan.  We will do this
c     by first scanning the array to find the northernmost, southern-
c     most, easternmost and westernmost extent of the probabilities
c     which are > 0.

      mini =  9999
      minj =  9999
      maxi = -9999
      maxj = -9999

      dmax = -1.0e+10
      do i = 1,numlon
        do j = 1,numlat
          if (xprob(i,j) > dmax) then
            dmax = xprob(i,j)
            id   = i
            jd   = j
          endif
          if (xprob(i,j) > 0.0) then
            if (i < mini) mini = i
            if (i > maxi) maxi = i
            if (j < minj) minj = j
            if (j > maxj) maxj = j
          endif
        enddo
      enddo

      print *,' '
      print *,'dmax:  at beg of get_prob_mode, dmax= ',dmax 
      print *,'i= ',id,' j= ',jd
      print *,'mini= ',mini
      print *,'maxi= ',maxi
      print *,'minj= ',minj
      print *,'maxj= ',maxj

      if (mini ==  9999 .or. minj ==  9999 .or. 
     &    maxi == -9999 .or. maxj == -9999) then
        print *,' '
        print *,'!!! ERROR in get_prob_mode, one or more of the max or'
        print *,'!!! min indeces for the xprob array could not '
        print *,'!!! be found.  The xprob array must = 0.'
        print *,'!!! EXITING.... '
        print *,' '
        STOP 99
      endif

c     Load all the lat and lon values into arrays.  Remember that
c     the xprob array goes from upper left (NW) to lower right (SE).

      do i = 1,numlon
        rlon(i) = float(minlon + i - 1)
      enddo

      do j = numlat,1,-1
        jix = numlat - j + 1
        rlat(jix) = float(maxlat - jix + 1)
      enddo

c     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c              First pass through barnes analysis....
c                   
c     For the first round through the  barnes analysis, we use the 
c     full grid resolution, and at each grid point, we look at an
c     area roughly 2x(ri).

      npts = ceiling(ri/(dtk*grdspc)) * 2

      ibct=0
      ibarnes_loopct = 0

c      print *,' '
c      print *,'before first barnes, mini= ',mini,' maxi= ',maxi
c      print *,'before first barnes, minj= ',minj,' maxj= ',maxj
c      print *,'npts= ',npts

      do i = mini,maxi
        do j = minj,maxj

          blon = rlon(i)        
          blat = rlat(j)        

c          write (*,*) ' '
c          write (*,*) ' - - - - - - - - - - - -'
c          write (*,*) ' '
c          write (*,59) cstorm,ifhour
c          write (*,61) 'before 1st barnes, i= ',i,j,blon,360.-blon
c     &                 ,blat,-99.0

          jjbeg = j - npts
          if (jjbeg < 1) jjbeg = 1
          jjend = j + npts
          if (jjend > numlat) jjend = numlat
          iibeg = i - npts
          if (iibeg < 1) iibeg = 1
          iiend = i + npts
          if (iiend > numlon) iiend = numlon

          ibct = ibct + 1
          call barnes (blon,blat,rlon,rlat,numlon,numlat,iibeg,jjbeg
     &                ,iiend,jjend,xprob,re,ri,bval,icount)

c          write (*,61) 'after  1st barnes, i= ',i,j,blon,360.-blon
c     &                 ,blat,bval

          ibarnes_loopct = ibarnes_loopct + icount

          if (bval > fmax) then
            fmax  = bval
            ctlon = blon
            ctlat = blat
          endif

        enddo
      enddo

  59  format (1x,'Storm= ',a4,'  forecast hour= ',i4)
  61  format (1x,a22,i3,' j= ',i3,' blon= ',f7.2,'E (',f7.2,'W) blat= '
     &       ,f7.2,' bval= ',f10.6)

      print *,' '
      print *,'++++ FIRST BARNES LOOP COMPLETED ++++'
      print *,' '
      print *,'After first loop, # calls to barnes = ',ibct
      print *,'Total # of internal barnes loop iterations = '
     &       ,ibarnes_loopct

      write (*,59) cstorm,ifhour
      write (6,63) ctlon,360.-ctlon,ctlat,fmax
  63  format (' After first run, ctlon= ',f8.3,'E (',f8.3,'W) ctlat= '
     &       ,f8.3,' barnval = ',f10.6)
      print *,' '

      if (ctlon <= xminlon(basinix) .or. ctlon >= xmaxlon(basinix) .or.
     &    ctlat <= xminlat(basinix) .or. ctlat >= xmaxlat(basinix)) then
        print *,' '
        print *,'!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
        print *,'!!! EXIT: In get_prob_mode, the mode position that '
        print *,'!!! was found after 1 iteration of the barnes loop is'
        print *,'!!! equal to or greater than 1 of the boundaries, '
        print *,'!!! meaning that we are pushing up against the'
        print *,'!!! boundary with our search and it is possible that'
        print *,'!!! we are not finding the true mode.'
        print *,'!!! '
        print *,'!!! ctlon= ',ctlon,'  ctlat= ',ctlat
        print *,'!!! grid minlon = ',xminlon(basinix)
        print *,'!!! grid maxlon = ',xmaxlon(basinix)
        print *,'!!! grid minlat = ',xminlat(basinix)
        print *,'!!! grid maxlat = ',xmaxlat(basinix)
        print *,'!!! '
        print *,'!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
        modeflag = 'n'
        return
      endif

c     - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
c              Second pass through barnes analysis....
c                   
c     Now that we've gotten a first estimate of the position, we 
c     go through this 3 more times, cutting the grid resolution
c     in half each time through in order to sharpen the estimate.
c     Cut the number of points (npts) in half from what we looked
c     at in the first barnes iteration so that our first position 
c     estimate is restricted from moving too much.

      npts = ceiling(ri/(dtk*grdspc))

      ibct = 0
      ibarnes_loopct = 0
      kloop: do k = 1,nhalf

        dell = 0.5*dell
        tlon = ctlon
        tlat = ctlat
        fmax = -1.0e+15

        print *,' '
        write (*,67) k,ctlon,360.-ctlon,ctlat
 67     format (1x,'In second barnes loop, k= ',i3,' ctlon= ',f8.3
     &         ,'E (',f8.3,'W) ctlat= ',f8.3)
        print *,' '

        jloop: do j = -npts,npts

          blat = tlat + dell*float(j)
         
          if (blat > float(maxlat) .or. blat < float(minlat)) then
            print *,' '
            print *,'!!! WARNING: In get_prob_mode 2nd barnes loop for'
            print *,'!!! nhalf = ',nhalf,', blat is outside of the '
            print *,'!!! grid lat bounds.  blat= ',blat
            print *,'!!! maxlat= ',maxlat,' minlat= ',minlat
            cycle jloop
          endif

          iloop: do i = -npts,npts

            blon = tlon + dell*float(i)

            if (blon > float(maxlon) .or. blon < float(minlon)) then
              print *,' '
              print *,'!!! WARNING: In get_prob_mode 2nd barnes loop' 
              print *,'!!! for nhalf = ',nhalf,', blon is outside of'
              print *,'!!! the grid lon bounds.  blon= ',blon
              print *,'!!! maxlon= ',maxlon,' minlon= ',minlon
              cycle iloop
            endif
      
            ifix = int(blon - float(minlon)) + 1
            jfix = int(float(maxlat) - blat) + 1

c            write (*,*) ' '
c            write (*,*) ' - - - - - - - - - - - -'
c            write (*,*) ' '
c            write (*,59) cstorm,ifhour
c            write (*,71) 'before 2nd barnes, ifix= ',ifix,jfix,k,blon
c     &                   ,360.-blon,blat,-99.0

            ! We cut npts in half so that the center position is
            ! restricted from moving too much in this refinement,
            ! but we need to double it here to make sure we 
            ! include enough points in the  barnes analysis.

            jjbeg = jfix - (npts*2)
            if (jjbeg < 1) jjbeg = 1
            jjend = jfix + (npts*2)
            if (jjend > numlat) jjend = numlat
            iibeg = ifix - (npts*2)
            if (iibeg < 1) iibeg = 1
            iiend = ifix + (npts*2)
            if (iiend > numlon) iiend = numlon

            ibct = ibct + 1
            call barnes (blon,blat,rlon,rlat,numlon,numlat,iibeg,jjbeg
     &                  ,iiend,jjend,xprob,re,ri,bval,icount)

c            write (*,71) 'after  2nd barnes, ifix= ',ifix,jfix,k,blon
c     &                   ,360.-blon,blat,bval

            ibarnes_loopct = ibarnes_loopct + icount

            if (bval > fmax) then
              fmax  = bval
              ctlon = blon
              ctlat = blat
            endif

          enddo iloop

        enddo jloop

        write (6,73) k,ctlon,360.-ctlon,ctlat,fmax

        if (ctlon <= xminlon(basinix) .or. ctlon >= xmaxlon(basinix) 
     &      .or. ctlat <= xminlat(basinix) 
     &      .or. ctlat >= xmaxlat(basinix)) then
          print *,' '
          print *,'!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          print *,'!!! EXIT: In get_prob_mode, the mode position that '
          print *,'!!! was found after iteration nhalf= ',k,' of the '
          print *,'!!! barnes loop is equal to or greater than 1 of the'
          print *,'!!! boundaries, meaning that we are pushing up '
          print *,'!!! against the boundary with our search and it is'
          print *,'!!! possible that we are not finding the true mode.'
          print *,'!!! '
          print *,'!!! ctlon= ',ctlon,'  ctlat= ',ctlat
          print *,'!!! grid minlon = ',xminlon(basinix)
          print *,'!!! grid maxlon = ',xmaxlon(basinix)
          print *,'!!! grid minlat = ',xminlat(basinix)
          print *,'!!! grid maxlat = ',xmaxlat(basinix)
          print *,'!!! '
          print *,'!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
          modeflag = 'n'
          return
        endif

      enddo kloop

 71   format (1x,a25,i3,' jfix= ',i3,' k= ',i2,' blon= ',f7.2,'E ('
     &       ,f7.2,'W) blat= ',f7.2,' bval= ',f10.6)

 73   format (' nhalf barnes, k= ',i2,' ctlon= ',f8.3,'E (',f8.3
     &       ,'W)  ctlat= ',f8.3,' barnval = ',f10.6)

      print *,' '
      print *,'++++ SECOND BARNES LOOP COMPLETED ++++'
      print *,' '
      print *,'After second loop, # calls to barnes = ',ibct
      print *,'Total # of internal barnes loop iterations = '
     &       ,ibarnes_loopct

      write (*,59) cstorm,ifhour
      write (6,77) ctlon,360.-ctlon,ctlat,fmax
 77   format (' After second run, ctlon= ',f8.3,'E (',f8.3,'W) ctlat= '
     &       ,f8.3,' barnval = ',f10.6)
      print *,' '
      print *,'+ + + + + + + + + + + + + + + + + + + '

      xmodelon = ctlon
      xmodelat = ctlat
      bmaxval  = fmax


c     We have now gotten the position of the max probability, or
c     the mode, using the  barnes analysis.  This barnes analysis,
c     however, gives us essentially an area-averaged value.  But
c     what we really need is the actual raw probability value 
c     calculated previously in this program.  So we will look at
c     the eight gridpoints surrounding the lat/lon value obtained
c     by the  barnes analysis and pick out the max raw value.
c     For the  output atcfunix mode record, however, we will use
c     the lat/lon position obtained through the barnes analysis.

      print *,' '
      print *,' Getting (i,j) location of max prob mode....'
      print *,' numlon= ',numlon,'  numlat= ',numlat
      print *,' ifix= ',ifix,' jfix= ',jfix
      print *,' '

      ifix = int(ctlon - float(minlon)) + 1
      jfix = int(float(maxlat) - ctlat) + 1

      fmax = -1.0e+15

      if (xprob(ifix,jfix) > fmax) then
        ihold = ifix
        jhold = jfix
        fmax  = xprob(ifix,jfix)
      endif

      if (ifix < numlon) then
        ! Check the point just *east* of our 
        ! found mode position....
        if (xprob(ifix+1,jfix) > fmax) then
          ihold = ifix+1
          jhold = jfix
          fmax  = xprob(ifix+1,jfix)
        endif
      endif

      if (ifix > 1) then
        ! Check the point just *west* of our
        ! found mode position....
        if (xprob(ifix-1,jfix) > fmax) then
          ihold = ifix-1        
          jhold = jfix 
          fmax  = xprob(ifix-1,jfix)
        endif
      endif

      if (jfix < numlat) then
        ! Check the point just *south* of our 
        ! found mode position (remember: j=1 is
        ! the northernmost point....)
        if (xprob(ifix,jfix+1) > fmax) then
          ihold = ifix
          jhold = jfix+1
          fmax  = xprob(ifix,jfix+1)
        endif
      endif

      if (jfix > 1) then
        ! Check the point just *north* of our
        ! found mode position (remember: j=1 is
        ! the northernmost point....)
        if (xprob(ifix,jfix-1) > fmax) then
          ihold = ifix
          jhold = jfix-1
          fmax  = xprob(ifix,jfix-1)
        endif
      endif

      if (ifix < numlon .and. jfix > 1) then
        ! Check the point just *northeast* of our
        ! found mode position (remember: j=1 is
        ! the northernmost point....)
        if (xprob(ifix+1,jfix-1) > fmax) then
          ihold = ifix+1
          jhold = jfix-1
          fmax  = xprob(ifix+1,jfix-1)
        endif
      endif

      if (ifix < numlon .and. jfix < numlat) then
        ! Check the point just *southeast* of our
        ! found mode position (remember: j=1 is
        ! the northernmost point....)   
        if (xprob(ifix+1,jfix+1) > fmax) then
          ihold = ifix+1   
          jhold = jfix+1
          fmax  = xprob(ifix+1,jfix+1)
        endif
      endif

      if (ifix > 1 .and. jfix < numlat) then
        ! Check the point just *southwest* of our
        ! found mode position (remember: j=1 is
        ! the northernmost point....)   
        if (xprob(ifix-1,jfix+1) > fmax) then
          ihold = ifix-1   
          jhold = jfix+1
          fmax  = xprob(ifix-1,jfix+1)
        endif
      endif
        
      if (ifix > 1 .and. jfix > 1) then
        ! Check the point just *northwest* of our
        ! found mode position (remember: j=1 is
        ! the northernmost point....)
        if (xprob(ifix-1,jfix-1) > fmax) then
          ihold = ifix-1
          jhold = jfix-1
          fmax  = xprob(ifix-1,jfix-1)
        endif
      endif

      fixlon   = float(minlon + ihold - 1)
      fixlat   = float(maxlat - jhold + 1)
      xmodeval = fmax

      print *,' '
      print *,' Location (i,j) of max mode: '
      print *,'   i-location: ',ihold,'  fixlon: ',fixlon
      print *,'   j-location: ',jhold,'  fixlat: ',fixlat
      print *,'   fmax = xmodeval = ',xmodeval
      print *,' '

      print *,' '
      print *,'At end of get_prob_mode, '
      write (*,59) cstorm,ifhour
      write (*,81) ctlat,xmodelat
      write (*,83) ctlon,360.-ctlon,xmodelon,360.-xmodelon
      write (*,85) bmaxval,xmodeval
 81   format (1x,'Barnes lat: ',f7.2,'              fixlat: ',f7.2)
 83   format (1x,'Barnes lon: ',f7.2,'E (',f7.2,'W)  fixlon: '
     &       ,f7.2,'E (',f7.2,'W)')
 85   format (1x,'Barnes val: ',f10.6,'  fixval: ',f10.6)
      print *,'ifix= ',ihold,' jfix= ',jhold


c     Now make a call to output_atcfunix to create an output
c     atcfunix record for this mode value....

      call output_atcfunix (cstorm,cymdh,xmodelat,xmodelon
     &               ,ifh,'mode',xmodeval,dthresh,catcf,fcsthrs)

c
      return
      end

c
c----------------------------------------------------------------
c
c----------------------------------------------------------------
      subroutine barnes(flon,flat,rlon,rlat,imax,jmax,iibeg,jjbeg
     &                 ,iiend,jjend,fxy,re,ri,favg,icount)
c
c     ABSTRACT: This routine performs a single-pass barnes anaylsis
c     of fxy at the point (flon,flat). The e-folding radius (km)
c     and influence radius (km) are re and ri, respectively.
c
c     NOTE:  The input grid that is searched in this subroutine is most
c     likely NOT the model's full, original grid.  Instead, a smaller
c     subgrid of the original grid is searched, which is determined by
c     the npts value passed into this subroutine. 
c
c     INPUT:
c     flon    Lon value for center point about which barnes anl is done
c     flat    Lat value for center point about which barnes anl is done
c     rlon    Array of lon values for each grid point
c     rlat    Array of lat values for each grid point
c     imax    Max number of pts in x-direction on input grid
c     jmax    Max number of pts in y-direction on input grid
c     iibeg   i index for grid point to start barnes anlysis (upp left)
c     jjbeg   j index for grid point to start barnes anlysis (upp left)
c     iiend   i index for last grid point in barnes anlysis (low right)
c     jjend   j index for last grid point in barnes anlysis (low right)
c     fxy     Real array of data on which to perform barnes analysis
c     re      input e-folding radius for barnes analysis
c     ri      input influence radius for searching for min/max
c
c     OUTPUT:
c     favg    Average value about the point (flon,flat)
c
      real      fxy(imax,jmax), rlon(imax), rlat(jmax)
      real      flon,flat,favg,res,re,ri,wts,dist,wt

c     --------------------------

      res = re*re
      wts = 0.0
      favg = 0.0

      icount = 0

c      write (*,62) iibeg,iiend,jjbeg,jjend
c 62   format (1x,'in barnes, iibeg= ',i3,' iiend= ',i3,' jjbeg= ',i3
c     &       ,' jjend= ',i3)

      do j=jjbeg,jjend
        do i=iibeg,iiend

          icount = icount + 1

          ! Call a different version of calcdist in order to
          ! get the distance in km....

          call calcdistkm(flon,flat,rlon(i),rlat(j),dist)

c          write (*,65) i,j,flon,flat,rlon(i),rlat(j),dist

          if (dist .gt. ri) cycle

c          write (*,66) i,j,flon,flat,rlon(i),rlat(j),dist,fxy(i,j)
c          print *,'+++ dist= ',dist,' fxy= ',fxy(i,j)

          wt   = exp(-1.0*dist*dist/res)
          wts  = wts + wt
          favg = favg + wt*fxy(i,j)

        enddo
      enddo

c 65   format (1x,'i= ',i3,' j= ',i3,' flon= ',f6.2,' flat= ',f5.2
c     &       ,' rlon(i)= ',f6.2,' rlat(j)= ',f5.2,' dist= ',f7.2)
c 66   format (1x,'i= ',i3,' j= ',i3,' flon= ',f6.2,' flat= ',f5.2
c     &       ,' rlon(i)= ',f6.2,' rlat(j)= ',f5.2,' dist= ',f7.2
c     &       ,' fxy= ',f5.2)
cJ.Peng_04-22-2013  F4.2 to f5.2 the above line
c      write (*,75) 'in barnes before averaging, wts = ',wts,'  favg= '
c     &             ,favg

      if (wts .gt. 1.0E-5) then
         favg = favg/wts
      else
         favg = 0.0
      endif
      iret = 0

c      write (*,75) 'in barnes after  averaging, wts = ',wts,'  favg= '
c     &             ,favg

c 75   format (1x,a34,f9.4,a8,f10.6)

c
      return
      end

c
c-----------------------------------------------------------------------
c
c-----------------------------------------------------------------------
      subroutine calcdistkm(rlonb,rlatb,rlonc,rlatc,xdist)
c
c     ABSTRACT: This subroutine computes the distance between two
c               lat/lon points by using spherical coordinates to
c               calculate the great circle distance between the points.
c                       Figure out the angle (a) between pt.B and pt.C,
c             N. Pole   then figure out how much of a % of a great
c               x       circle distance that angle represents.
c              / \
c            b/   \     cos(a) = (cos b)(cos c) + (sin b)(sin c)(cos A)
c            /     \
c        pt./<--A-->\c     NOTE: The latitude arguments passed to the
c        B /         \           subr are the actual lat vals, but in
c                     \          the calculation we use 90-lat.
c               a      \
c                       \pt.  NOTE: You may get strange results if you:
c                         C    (1) use positive values for SH lats AND
c                              you try computing distances across the
c                              equator, or (2) use lon values of 0 to
c                              -180 for WH lons AND you try computing
c                              distances across the 180E meridian.
c
c     NOTE: In the diagram above, (a) is the angle between pt. B and
c     pt. C (with pt. x as the vertex), and (A) is the difference in
c     longitude (in degrees, absolute value) between pt. B and pt. C.
c
c     !!! NOTE !!! -- THE PARAMETER ecircum IS DEFINED (AS OF THE
c     ORIGINAL WRITING OF THIS SYSTEM) IN KM, NOT M, SO BE AWARE THAT
c     THE DISTANCE RETURNED FROM THIS SUBROUTINE IS ALSO IN KM.
c
      USE trig_vals
c
      if (rlatb < 0.0 .or. rlatc < 0.0) then
        pole = -90.
      else
        pole = 90.
      endif
c
      distlatb = (pole - rlatb) * dtr
      distlatc = (pole - rlatc) * dtr
      difflon  = abs( (rlonb - rlonc)*dtr )
c
      cosanga = ( cos(distlatb) * cos(distlatc) +
     &            sin(distlatb) * sin(distlatc) * cos(difflon))

c     This next check of cosanga is needed since I have had ACOS crash
c     when calculating the distance between 2 identical points (should
c     = 0), but the input for ACOS was just slightly over 1
c     (e.g., 1.00000000007), due to (I'm guessing) rounding errors.

      if (cosanga > 1.0) then
        cosanga = 1.0
      endif
c added on 04/28/2016--------------------------
      if (cosanga < -1.0) then
        cosanga = -1.0
      endif
c added on 04/28/2016--------------------------

      degrees    = acos(cosanga) / dtr
      circ_fract = degrees / 360.
      xdist      = circ_fract * ecircum

c     NOTE: whether this subroutine returns the value of the distance
c           in km or m depends on the scale of the parameter ecircum.
c           At the original writing of this subroutine (7/97), ecircum
c           was given in km.

      return
      end

c
c-----------------------------------------------------------------------
c
cJ.Peng-04-15-2013  --------------------------------------------
      subroutine read_atcfunix (traklat,traklon,tcvmx,tcpce,
     &  saverec,stormarr,maxmem,fcst_interval,perts)

c
c     ABSTRACT: This subroutine reads in the atcfunix records from
c     the concatenated file that contains all these records for all 
c     storms, all forecast hours and all ensemble members.

      USE define_atcfunix_rec; USE maxparms; USE ensinfo
      USE grid_bounds
c
      type (atcfunix_card) inprec,saverec

      real    traklat(maxstorms,maxmem,maxtimes)
      real    traklon(maxstorms,maxmem,maxtimes)

cJ.Peng-04-15-2013
      real tcvmx(maxstorms,maxmem,maxtimes)
      real tcpce(maxstorms,maxmem,maxtimes)

      integer maxmem,fcst_interval
      character*4   perts(maxmem)
      character*4   atcfid,stormarr(maxstorms)
      character*1   foundstorm,foundmember,foundmodel
c
      stormarr = 'XXXX'

      ict = 0
      istot = 0
      readloop: do while (.true.)

        read (11,85,end=870) inprec

        if (ict == 0) then
          saverec = inprec
          ict = ict + 1
        endif

        atcfid(1:2) = inprec%atx_basin
        atcfid(3:4) = inprec%atx_storm_num

c       Find the array index for the storm that is being read in.  As 
c       we encounter a new storm in the atcfunix file, we add that 
c       storm to the array and increment the index (istix) by 1.

        foundstorm = 'n'
        stormloop: do istorm = 1,maxstorms
          if (atcfid == stormarr(istorm)) then
            foundstorm = 'y'
            istix = istorm
            exit stormloop
          endif
        enddo stormloop
        if (foundstorm == 'n') then
          istot = istot + 1
          istix = istot
          stormarr(istix) = atcfid
        endif

c       Similarly, find the lat/lon array index for the ensemble member
c       that is being read in.  The members are specified in a module.
c       If the program cannot find the member, chances are the ensemble
c       suite has been updated and new members have been added.

        foundmember = 'n'
        memberloop: do imem = 1,maxmem
          if (inprec%atx_model == perts(imem)) then
            foundmodel = 'y'
            imix = imem
            exit memberloop
          endif
        enddo memberloop
        if (foundmodel == 'n') then
          print *,' '
          print *,'!!! ERROR: IN PROGRAM TRAKAVE, A MODEL/MEMBER NAME'
          print *,'!!!        IS NOT RECOGNIZED.'
          print *,'!!!       '
          print *,'!!!        MODEL/MEMBER NAME = --->'
     &                              ,inprec%atx_model,'<----'
          print *,'!!!       '
          print *,'!!! STOPPING PROGRAM....      '
          print *,'!!!       '
          stop 990
        endif 

c       Calculate the index (ifix) for the forecast hour in lat and
c       lon arrays.

        ifix = (inprec%atx_fcsthr / fcst_interval) + 1

c       Check the lat/lon arrays to see if we've already read in the
c       lat/lon positions for this storm/member/forecast_time (traklat
c       and traklon are initialized to -9999.0).  Yes, it is possible
c       to have more than 1 record for a given storm/member/time, 
c       since there are up to 3 different records written out for each
c       forecast time, each containing the 34-, 50- and 64-kt wind 
c       radii.  Note that if the values read in are zeroes, that means
c       that the tracker could not find the storm; consider these 
c       missing values and ignore them. 

        if (traklat(istix,imix,ifix) < -9998.0 .and. 
     &      traklon(istix,imix,ifix) < -9998.0) then

          if (inprec%atx_lat > 0 .and. inprec%atx_lon > 0) then

            ! Float the integer latitudes and convert any positive 
            ! southern latitudes to be negative.

            if (inprec%atx_latns == 'N') then
              traklat(istix,imix,ifix) = float(inprec%atx_lat)/10.0
            else
              traklat(istix,imix,ifix) = float(inprec%atx_lat)/(-10.0)
            endif

            ! Float the integer longitudes and convert any "western" 
            ! longitudes to be "eastern", 0-360.

            if (inprec%atx_lonew == 'E') then
              traklon(istix,imix,ifix) = float(inprec%atx_lon)/10.0
            else
              traklon(istix,imix,ifix) = float(3600 - inprec%atx_lon)
     &                                        / 10.0
            endif

cJ.Peng-04-15-2013
	    tcvmx(istix,imix,ifix) = float(inprec%atx_vmax)
	    tcpce(istix,imix,ifix) = float(inprec%atx_pcen)

          endif
  
        endif

      enddo readloop

C      close (11)

   85 format (a2,2x,a2,2x,a10,2x,a2,2x,a4,2x,i3,2x,i3,a1,2x,i4,a1,2x
     &       ,i3,2x,i4)
c     &       ,i3,2x,i4,2x,a2,2x,i2,2x,a3,4(2x,i3))
cPENG bug fixed on 04/18/2018
c 85   format (a2,2x,a2,2x,a10,2x,a2,2x,a4,2x,i3,2x,i3,a1,2x,i4,a1,2x
c     &       ,i3,2x,i4,2x,a2,3x,i2,2x,a3,4(2x,i4))

  870 goto 1090

 1010 print *,' '
      print *,'!!! ERROR opening input file.  ERROR = ',ios
      print *,' '

 1090 continue

      return
      end

c
c-----------------------------------------------------------------------
c
c-----------------------------------------------------------------------
      subroutine calcdist(rlonb,rlatb,rlonc,rlatc,dtr,xdist)
c
c     ABSTRACT: This subroutine computes the distance between two
c               lat/lon points by using spherical coordinates to
c               calculate the great circle distance between the points.
c                       Figure out the angle (a) between pt.B and pt.C,
c             N. Pole   then figure out how much of a % of a great
c               x       circle distance that angle represents.
c              / \
c            b/   \     cos(a) = (cos b)(cos c) + (sin b)(sin c)(cos A)
c            /     \
c        pt./<--A-->\c     NOTE: The latitude arguments passed to the
c        B /         \           subr are the actual lat vals, but in
c                     \          the calculation we use 90-lat.
c               a      \
c                       \pt.  NOTE: You may get strange results if you:
c                         C    (1) use positive values for SH lats AND
c                              you try computing distances across the
c                              equator, or (2) use lon values of 0 to
c                              -180 for WH lons AND you try computing
c                              distances across the 180E meridian.
c
c     NOTE: In the diagram above, (a) is the angle between pt. B and
c     pt. C (with pt. x as the vertex), and (A) is the difference in
c     longitude (in degrees, absolute value) between pt. B and pt. C.
c
c     !!! NOTE !!! -- THE PARAMETER ecircum IS DEFINED (AS OF THE
c     WRITING OF THIS SYSTEM) IN NM, NOT M or KM, SO BE AWARE THAT
c     THE DISTANCE RETURNED FROM THIS SUBROUTINE IS ALSO IN NM.
c
      real :: dtk = 60.005       ! Dist (nm) over 1 deg lat
                                 ! using erad=6371.0e+3 km
      real :: erad = 6371.0e+3   ! Earth's radius (m)
      real :: ecircum = 21601.8  ! Earth's circumference
                                 ! (nm) using erad=6371.e3
      real    dtr
c
      if (rlatb < 0.0 .or. rlatc < 0.0) then
        pole = -90.
      else
        pole = 90.
      endif
c
      distlatb = (pole - rlatb) * dtr
      distlatc = (pole - rlatc) * dtr
      difflon  = abs( (rlonb - rlonc)*dtr )
c
      cosanga = ( cos(distlatb) * cos(distlatc) +
     &            sin(distlatb) * sin(distlatc) * cos(difflon))

c     This next check of cosanga is needed since I have had ACOS crash
c     when calculating the distance between 2 identical points (should
c     = 0), but the input for ACOS was just slightly over 1
c     (e.g., 1.00000000007), due to (I'm guessing) rounding errors.

      if (cosanga > 1.0) then
        cosanga = 1.0
      endif
c added on 04/28/2016--------------------------
      if (cosanga < -1.0) then
        cosanga = -1.0
      endif
c added on 04/28/2016--------------------------

      degrees    = acos(cosanga) / dtr
      circ_fract = degrees / 360.
      xdist      = circ_fract * ecircum

c     NOTE: whether this subroutine returns the value of the distance in
c           km, m or nm depends on the scale of the parameter ecircum.
c           At the original writing of this subroutine (2/01), ecircum
c           was given in nm.

      return
      end

c
c---------------------------------------------------------------------
c
c---------------------------------------------------------------------
      subroutine output_atcfunix (stormid,cymdh,outlat,outlon,ifh
     &                           ,ctype,xprob,dthresh,catcf,fcsthrs)
c
c     ABSTRACT: This subroutine  outputs a 1-line message for a given
c     storm at an input forecast hour in the new ATCF UNIX format.
c     Unlike the old atcf DOS format in which you waited until the
c     whole tracking was over to write the  output for all forecast
c     hours, with this atcfunix format, each time we are calling this
c     subroutine, it is to only write out 1 record, which will be the
c     fix info for a particular storm at a given time.  
c
c     While this new atcfunix format contains much more information than
c     the old 1-line atcf dos message, for the purposes of the ensemble
c     mean track, we will only use the slots for storm location and NOT
c     worry about the intensity parameters.  An example is shown below:
c
c     AL, 13, 2000092500, 03, AEMN, 036, 243N, 675W
c
c     NOTE: The longitudes that are passed into this subroutine are
c     given in 0 - 360, increasing eastward.  The format for the
c     atcfunix system requires that the  output be 0-180E or
c     0-180W, so we must adjust the values, if needed.  Also, the
c     values for southern latitudes must be positive (use 'N' and
c     'S' to distinguish Northern/Southern Hemispheres).
c
c     INPUT:
c     stormid   Storm ID (EP02, AL13, etc...)
c     cymdh     initial date/time of forecast (yyyymmddhh)
c     outlat    latitude fix position for this storm at this time
c               which is to be written out to the  output file
c     outlon    longitude fix position for this storm at this time
c               which is to be written out to the  output file
c     ifh       the index for the current forecast hour being output
c     ctype     'mean' for ens mean, 'mode' for ens prob mode
c     xprob     prob mode value for ctype = 'mode'. Not used for mean
c     dthresh   distance threshold used for prob mode value, to be 
c               used in model output name for 'mode' case.
c
c     LOCAL:
c     intlon    integer that holds the value of outlon*10
c     intlat    integer that holds the value of outlat*10
c
      USE ensinfo; USE maxparms

      real    outlon,outlat,xprob
      integer fcsthrs(maxtimes)
      integer intlon,intlat
      character*1  clatns,clonew
      character*2  basinid,stormnum
      character*4  stormid,ctype,cmode,catcf
      character*10 cymdh
      character*37 outatxfile

c     First convert all of the lat/lon values from reals into integers.
c     These integer values must be 10x their real value (eg. 125.4 will
c     be written out as 1254).  Convert the lon values so that they go
c     from 0-180E or 0-180W, and convert the lat values so that they are
c     positive and use 'N' or 'S' to differentiate hemispheres.

C      outatxfile = 'aemn.'//cymdh//'.cyclone.trackatcfunix'
C      open (unit=53,file=outatxfile,status='unknown',position='append')

      if (outlon < -998.0 .or. outlat < -998.0) then
        intlon = 0
        intlat = 0
        clonew = ' '
        clatns = ' '
      else
        if (outlon >= 180.0) then
c          intlon = 3600 - int(outlon * 10. + 0.5)
c          clonew = 'W'
cJ.Peng-----03/27/2015------------------------------------
          if (outlon < 360.0) then
            intlon = 3600 - int(outlon * 10. + 0.5)
            clonew = 'W'
          else
            intlon =int(outlon * 10. + 0.5) - 3600
            clonew = 'E'
          endif
cJ.Peng-----03/27/2015------------------------------------

        else
          intlon = int(outlon * 10. + 0.5)
          clonew = 'E'
        endif
        intlat = int(abs(outlat) * 10. + 0.5)
        if (outlat < 0.0) then
          clatns = 'S'
        else
          clatns = 'N'
        endif
      endif

      basinid = stormid(1:2)
      stormnum = stormid(3:4)

      if (ctype == 'mean') then
        write (53,81) basinid,stormnum,cymdh,catcf,fcsthrs(ifh)
     &        ,intlat,clatns,intlon,clonew
      else
        itemp = int(dthresh)
        cmode(1:1) = catcf(1:1)
        write (cmode(2:4),'(i3.3)') itemp
c        print *,'atcfunix, cmode= ',cmode,' itemp= ',itemp
c        write (*,79) cmode,itemp
   79   format (1x,' cmode= ....',a4,'....  itemp= ',i3.3)
        write (57,83) basinid,stormnum,cymdh,cmode,fcsthrs(ifh)
     &        ,intlat,clatns,intlon,clonew,int(xprob*100.0)
      endif

   81 format (a2,', ',a2,', ',a10,', 03, ',a4,', ',i3.3,', ',i3,a1
     &       ,', ',i4,a1)
   83 format (a2,', ',a2,', ',a10,', 03, ',a4,', ',i3.3,', ',i3,a1
     &       ,', ',i4,a1,', ',i3)
c
C      close (53)
      return
      end

c
c-----------------------------------------------------------------------
      subroutine output_atcf (stormid,xmeanlon,xmeanlat,cymdh,ist,catcf)
c
c     ABSTRACT: This subroutine  outputs a 1-line message for each storm
c     in ATCF format.  This message contains the model identifier, the
c     forecast initial date, and the positions for 12, 24, 36, 48 and
c     72 hours.  This message also contains the intensity
c     estimates (in knots) for those same hours.  The  conversion for
c     m/s to knots is to multiply m/s by 1.9427 (3.281 ft/m,
c     1 naut mile/6080 ft, 3600s/h).
c
c     NOTE: Intensity estimates are NOT included for the ensemble 
c     mean tracks.
c
c     NOTE: The longitudes that are passed into this subroutine are
c     given in 0 - 360, increasing eastward.  The  output of this
c     subroutine is used by the atcf system at TPC for plotting
c     purposes, and the atcf plotting routines need the longitudes in
c     0 - 360, increasing westward.  Thus, a necessary adjustment is
c     made.

      USE maxparms

      character*4  stormid,catcf
      character*10 cymdh
      character*8  yymmddhh
      character*33 outatcffile

      real    xmeanlat(maxstorms,maxtimes)
      real    xmeanlon(maxstorms,maxtimes)
      integer intlon(maxtimes),intlat(maxtimes)
c
C      outatcffile = 'aemn.'//cymdh//'.cyclone.trackatcf'
C      open (unit=54,file=outatcffile,status='unknown',position='append')

      yymmddhh = cymdh(3:10)

      ifhloop: do ifh = 1,maxtimes

        if (xmeanlon(ist,ifh) < -998.0 .or. xmeanlat(ist,ifh) < -998.0)
     &  then

          intlon(ifh) = 0
          intlat(ifh) = 0

        else
          intlon(ifh) = 3600 - int(xmeanlon(ist,ifh) * 10. + 0.5)
          intlat(ifh) = int(abs(xmeanlat(ist,ifh)) * 10. + 0.5)
          if (xmeanlat(ist,ifh) < 0.0) then
            intlat(ifh) = intlat(ifh) * (-1)
          endif

        endif

      enddo ifhloop

      write (54,82) '99',catcf,yymmddhh,intlat(3),intlon(3)
     &           ,intlat(5),intlon(5),intlat(7),intlon(7)
     &           ,intlat(9),intlon(9),intlat(13),intlon(13)
     &           ,0,0,0,0,0,stormid,cymdh(9:10)

   82 format (a2,a4,a8,10i4,5i3,1x,a4,a2)
c

C      close (54)
      return
      end

c
c-----------------------------------------------------------------------
c
c-----------------------------------------------------------------------
      subroutine output_all (stormid,xmeanlon,xmeanlat,cymdh,ist,catcf)
c
c     ABSTRACT: This subroutine  outputs a 1-line message for each
c     storm.  This message contains the model identifier, the forecast
c     initial date, and the positions for 0, 12, 24, 36, 48, 60 and 72
c     hours.  In the case of the regional models (NGM, Eta), which
c     only go out to 48h, zeroes are included for forecast hours
c     60 and 72.
c
c     NOTE: The longitudes that are passed into this subroutine are
c     given in 0 - 360, increasing eastward.  The  output of this
c     subroutine is used by Steve Lord for plotting purposes, and his
c     plotting routines need the longitudes in 0 - 360, increasing
c     westward.  Thus, a necessary adjustment is made.
c
      USE maxparms

      character*4  stormid,catcf
      character*10 cymdh
      character*8  yymmddhh
      character*2  stormnum
      character*3  basinid
      character*32 outallfile

      real    xmeanlat(maxstorms,maxtimes)
      real    xmeanlon(maxstorms,maxtimes)
      integer intlon(maxtimes),intlat(maxtimes)
c
C      outallfile = 'aemn.'//cymdh//'.cyclone.trackall'
C      open (unit=55,file=outallfile,status='unknown',position='append')

      yymmddhh = cymdh(3:10)
      stormnum = stormid(3:4)
c
      ifhloop: do ifh = 1,maxtimes

        if (xmeanlon(ist,ifh) < -998.0 .or. xmeanlat(ist,ifh) < -998.0)
     &  then
          intlon(ifh) = 0
          intlat(ifh) = 0
        else
          intlon(ifh) = 3600 - int(xmeanlon(ist,ifh) * 10. + 0.5)
          intlat(ifh) = int(abs(xmeanlat(ist,ifh)) * 10. + 0.5)
          if (xmeanlat(ist,ifh) < 0.0) then
            intlat(ifh) = intlat(ifh) * (-1)
          endif
        endif

      enddo ifhloop

      select case (stormid(1:2))
        case ('AL');  basinid(3:3) = 'L'
        case ('CP');  basinid(3:3) = 'C'
        case ('EP');  basinid(3:3) = 'E'
        case ('WP');  basinid(3:3) = 'W'
        case ('SC');  basinid(3:3) = 'O'
        case ('EC');  basinid(3:3) = 'T'
        case ('AU');  basinid(3:3) = 'U'
        case ('SP');  basinid(3:3) = 'P'
        case ('SI');  basinid(3:3) = 'S'
        case ('BB');  basinid(3:3) = 'B'
        case ('AA');  basinid(3:3) = 'A'
        case default; basinid(3:3) = '*'
      end select

      basinid(1:2) = stormid(3:4)

      write (55,83) '99',catcf,yymmddhh,intlat(1),intlon(1)
     &           ,intlat(3),intlon(3),intlat(5),intlon(5)
     &           ,intlat(7),intlon(7),intlat(9),intlon(9)
     &           ,intlat(11),intlon(11),intlat(13),intlon(13)
     &           ,basinid

   83 format (a2,a4,a8,14i4,1x,a3)
c
C      close (55)
      return
      end

c---------------------------------------------------------------------
c
c---------------------------------------------------------------------
      subroutine read_nlists (dthresh,cmodel)
c
c     ABSTRACT: This subroutine simply reads in the namelists that are
c     created in the shell script.  Namelist datain currently contains
c     just the value of the dthresh parameter.
c
      real      dthresh
      character*5 :: cmodel
c
      namelist/datain/dthresh,cmodel
c
      read (5,NML=datain,END=801)
  801 continue

      print *,' '
      print *,'After datain namelist read in trakave.f, '
      print *,'namelist parms follow: ' 
      print *,' '
      print *,'Distance threshold (dthresh) = ',dthresh
      print *,'cmodel = ',cmodel
c
      return
      end
c---------------------------------------------------------------------
cJ.Peng-04-15-2013--------------------------
      subroutine output_atcfunix1 (stormid,cymdh,outlat,outlon
     &                           ,stdvmx,stdpce,yspread
     &                           ,outvmx,outpce,ifh
     &                           ,ctype,xprob,dthresh,catcf,fcsthrs)
c
c     ABSTRACT: This subroutine  outputs a 1-line message for a given
c     storm at an input forecast hour in the new ATCF UNIX format.
c     Unlike the old atcf DOS format in which you waited until the
c     whole tracking was over to write the  output for all forecast
c     hours, with this atcfunix format, each time we are calling this
c     subroutine, it is to only write out 1 record, which will be the
c     fix info for a particular storm at a given time.  
c
c     While this new atcfunix format contains much more information than
c     the old 1-line atcf dos message, for the purposes of the ensemble
c     mean track, we will only use the slots for storm location and NOT
c     worry about the intensity parameters.  An example is shown below:
c
c     AL, 13, 2000092500, 03, AEMN, 036, 243N, 675W
c
c     NOTE: The longitudes that are passed into this subroutine are
c     given in 0 - 360, increasing eastward.  The format for the
c     atcfunix system requires that the  output be 0-180E or
c     0-180W, so we must adjust the values, if needed.  Also, the
c     values for southern latitudes must be positive (use 'N' and
c     'S' to distinguish Northern/Southern Hemispheres).
c
c     INPUT:
c     stormid   Storm ID (EP02, AL13, etc...)
c     cymdh     initial date/time of forecast (yyyymmddhh)
c     outlat    latitude fix position for this storm at this time
c               which is to be written out to the  output file
c     outlon    longitude fix position for this storm at this time
c               which is to be written out to the  output file
c     ifh       the index for the current forecast hour being output
c     ctype     'mean' for ens mean, 'mode' for ens prob mode
c     xprob     prob mode value for ctype = 'mode'. Not used for mean
c     dthresh   distance threshold used for prob mode value, to be 
c               used in model output name for 'mode' case.
c
c     LOCAL:
c     intlon    integer that holds the value of outlon*10
c     intlat    integer that holds the value of outlat*10
c
      USE ensinfo; USE maxparms

      real    outlon,outlat,xprob
      real    outvmx,outpce,stdvmx,stdpce,yspread 
      integer fcsthrs(maxtimes)
      integer intlon,intlat
      character*1  clatns,clonew
      character*2  basinid,stormnum
      character*4  stormid,ctype,cmode,catcf
      character*10 cymdh
      character*37 outatxfile

c     First convert all of the lat/lon values from reals into integers.
c     These integer values must be 10x their real value (eg. 125.4 will
c     be written out as 1254).  Convert the lon values so that they go
c     from 0-180E or 0-180W, and convert the lat values so that they are
c     positive and use 'N' or 'S' to differentiate hemispheres.

C      outatxfile = 'aemn.'//cymdh//'.cyclone.trackatcfunix'
C      open (unit=53,file=outatxfile,status='unknown',position='append')

      if (outlon < -998.0 .or. outlat < -998.0) then
        intlon = 0
        intlat = 0
        clonew = ' '
        clatns = ' '
      else
        if (outlon >= 180.0) then
c          intlon = 3600 - int(outlon * 10. + 0.5)
c          clonew = 'W'
cJ.Peng-----03/27/2015------------------------------------
          if (outlon < 360.0) then
            intlon = 3600 - int(outlon * 10. + 0.5)
            clonew = 'W'
          else
            intlon =int(outlon * 10. + 0.5) - 3600
            clonew = 'E'
          endif
cJ.Peng-----03/27/2015------------------------------------

        else
          intlon = int(outlon * 10. + 0.5)
          clonew = 'E'
        endif
        intlat = int(abs(outlat) * 10. + 0.5)
        if (outlat < 0.0) then
          clatns = 'S'
        else
          clatns = 'N'
        endif
      endif

      basinid = stormid(1:2)
      stormnum = stormid(3:4)

      if (ctype == 'mean') then
c        write (53,81) basinid,stormnum,cymdh,catcf,fcsthrs(ifh)
c     &        ,intlat,clatns,intlon,clonew
c     &        ,int(outvmx+0.5),int(outpce+0.5),stdvmx,stdpce
c     &        ,yspread

        write (53,81) basinid,stormnum,cymdh,catcf,fcsthrs(ifh)
     &        ,intlat,clatns,intlon,clonew
     &        ,int(outvmx+0.5),int(outpce+0.5)
     &        ,int(yspread+0.5),int(stdpce+0.5)
     &        ,int(stdvmx+0.5)
      else
        itemp = int(dthresh)
        cmode(1:1) = catcf(1:1)
        write (cmode(2:4),'(i3.3)') itemp
c        print *,'atcfunix, cmode= ',cmode,' itemp= ',itemp
c        write (*,79) cmode,itemp
   79   format (1x,' cmode= ....',a4,'....  itemp= ',i3.3)
        write (57,83) basinid,stormnum,cymdh,cmode,fcsthrs(ifh)
     &        ,intlat,clatns,intlon,clonew,int(xprob*100.0)
      endif

c   81 format (a2,', ',a2,', ',a10,', 03, ',a4,', ',i3.3,', ',i3,a1
c     &       ,', ',i4,a1,', ',i3,', ',i4,', ',f5.1,', ',f5.1
c     &       ,', ',f7.2)

   81 format (a2,', ',a2,', ',a10,', 03, ',a4,', ',i3.3,', ',i3,a1
     &       ,', ',i4,a1,', ',i3,', ',i4,
     &       ', XX,  34, NEQ, 0000, 0000, 0000, 0000',
     &       ', ',i4,', ',i4,', ',i3)

   83 format (a2,', ',a2,', ',a10,', 03, ',a4,', ',i3.3,', ',i3,a1
     &       ,', ',i4,a1,', ',i3)
c
C      close (53)
      return
      end

c
c-----------------------------------------------------------------------
