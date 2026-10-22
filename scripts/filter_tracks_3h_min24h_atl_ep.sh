#!/usr/bin/ksh

# This script is used to filter the atcf_gen output track files from the 
# genesis runs of the tracker.  The goal is to filter out disturbances 
# that either do not live long enough (the minimum cyclone life is defined
# in the BEGIN section in the variable named "minimum_storm_life") or do
# not have thermodynamic characteristics of a TC.  A primary check is done
# of the cyclone phase parameters:  Parameter B must be < 100 (it's actually
# a value of 10, but multiplied by 10 in the output that's read in), lower-
# level (600-900 mb) thermal wind, upper-level (300-600 mb) thermal wind.
# The threshold for the thermal wind values is that they must be > 0 to pass.
# An additional check can be done of the warm core flag.  This is simply a
# flag of either "Y" or "N", and it results from checking for a closed 
# contour in the mean 300-500 mb temperature field.  The closed contour has
# typically been set with a contour interval of 1 degK, but that doesn't 
# matter for this filtering (that's set in the tracker itself).
#
# Any of the tracks that are printed out by this script are for storms that
# have passed the various storm length and thermodynamic checks.  However,
# keep in mind that the script might not print out records for *all* times
# that were input to the script.  Per the logic below, it's going to print
# out times starting with the first one that satisfies the thermodynamic
# criteria.
#
# **************************************************************************
# IMPORTANT NOTE: This particular version of the script is designed to work
# with 3-hourly output.  This is integrated into the script with how it 
# looks at sets of the most recent *9* lead times, meant to cover the most
# recent 24 hours of time.  If used on 6-hourly or 12-hourly data, or if 
# used with a different time-length threshold (i.e., different than 24h),
# then the logic will need to be adjusted accordingly.
# **************************************************************************
#
#
# **************************************************************************
# IMPORTANT NOTE #2: This "atl_ep" version of the script is designed 
# so that it will allow storms from both the AL & EP basins.
# **************************************************************************

#
# Written by Tim Marchok, 8/11/2023
#

#set -x

if [ $# -lt 1 ]; then
  echo " "
  echo " +++ Usage: You need to enter 1 argument -- the name of the track file."
  echo " +++ Example: `basename $0` atcf_gen_track_file"
  echo " +++"
  echo " EXITING..."
  echo " "
  exit 8
fi

ifile=$1

echo " "
echo "ifile= $ifile"
echo " "

cat ${ifile} | grep -v "50, NEQ" | grep -v "64, NEQ" | grep "_FOF" | sort -k3 |\

awk -F, '

  BEGIN {
    c = 0
    h = 0
    check_wcflag_as_backup = "n"
    minimum_storm_life = 24
    numcases = 0
    oldstormid = "xxxx"
    for (ic=1; ic<=100; ic++) {
      gtx[ic] = 9999
      max_case_ix[ic]  = 0
      last_hour[ic] = -9999
    }
  }

  {
    c++
    h++
    numcases      = c
    inprec[c,h]   = $0
    tmpstormid    = $3
    stormid[c]    = tmpstormid
    fhour[c,h]    = $7
    first_hour[c] = $7
    last_hour[c]  = $7
    lat[c,h]      = substr($0,70,3)
    lon[c,h]      = substr($0,76,4)
    paramb[c,h]   = $22
    vtl[c,h]      = $23
    vtu[c,h]      = $24
    wcflag[c,h]   = $25
    oldstormid    = tmpstormid
    printf ("c= %2d, h= %2d, inprec= %s\n",c,h,inprec[c,h])

    while (getline > 0) {
      tmpstormid = $3
      if (tmpstormid == oldstormid) {
        h++
        max_case_ix[c] = h
        inprec[c,h]    = $0
        fhour[c,h]     = $7
        last_hour[c]   = $7
        lat[c,h]       = substr($0,70,3)
        lon[c,h]       = substr($0,76,4)
        paramb[c,h]    = $22
        vtl[c,h]       = $23
        vtu[c,h]       = $24
        wcflag[c,h]    = $25
        printf ("c= %2d, h= %2d, inprec= %s\n",c,h,inprec[c,h])
      }
      else {
        c++
        h = 1
        numcases       = c
        max_case_ix[c] = h
        stormid[c]     = tmpstormid
        oldstormid     = tmpstormid
        inprec[c,h]    = $0
        fhour[c,h]     = $7
        first_hour[c]  = $7
        last_hour[c]   = $7
        lat[c,h]       = substr($0,70,3)
        lon[c,h]       = substr($0,76,4)
        paramb[c,h]    = $22
        vtl[c,h]       = $23
        vtu[c,h]       = $24
        wcflag[c,h]    = $25
        printf ("c= %2d, h= %2d, inprec= %s\n",c,h,inprec[c,h])
      }
    }

    for (i=1; i<=numcases; i++) {

      total_cyclone_life = last_hour[i] - first_hour[i]

      printf (" Total cyclone life = %d\n",total_cyclone_life)

      metrics_pass = "n"

      printf ("max_case_ix[i]= %d\n",max_case_ix[i])
       
      if (total_cyclone_life >= minimum_storm_life) {

        # Cycle iteratively over sets of the most recent 9 lead times,
        # looking backwards to the first of the 9.  Because of this,
        # we start at time level 9 (looking back to the first time 
        # level).  Then we go to 10, looking back to 2, then 11 looking
        # back to 3, etc.  In each block, we need to have the first
        # time and the last time pass their checks, and then various
        # rules apply for the intervening 7 time levels.

        for (j=9; j<=max_case_ix[i]; j++) {

          first_paramb_good = "n"
          first_vtl_good    = "n"
          first_vtu_good    = "n"
          first_wcflag_good = "n"
          last_paramb_good  = "n"
          last_vtl_good     = "n"
          last_vtu_good     = "n"
          last_wcflag_good  = "n"
          is_epac_storm     = "n"

          goodct_paramb = 0
          goodct_vtl    = 0
          goodct_vtu    = 0
          goodct_wcflag = 0

          metrics_pass = "n"
          printf ("metrics_pass= %s\n",metrics_pass)

          # Check the first time in this current set of 9, i.e.,
          # the one that is 24h ago....

          printf ("j= %d\n",j)

          if (paramb[i,j-8] > -999 && paramb[i,j-8] <= 100) {
            goodct_paramb++
            first_paramb_good = "y"
          }
          if (vtl[i,j-8] >= 0) {
            goodct_vtl++
            first_vtl_good = "y"
          }
          if (vtu[i,j-8] >= 0) {
            goodct_vtu++
            first_vtu_good = "y"
          }
          if (wcflag[i,j-8] ~ "Y") {
            goodct_wcflag++
            first_wcflag_good = "y"
          }

          printf ("  ---> first_paramb_good= %s\n",first_paramb_good)
          printf ("  ---> first_vtl_good= %s\n",first_vtl_good)
          printf ("  ---> first_vtu_good= %s\n",first_vtu_good)
          printf ("  ---> first_wcflag_good= %s\n",first_wcflag_good)

          # Check the lat & lon at that first time level in 
          # order to check for EastPac storms.  But note that 
          # we are not filtering them out here, because we then
          # reset is_epac_storm to "pass" to create a workaround
          # to just get everything to pass.

          printf ("lon[i,j-8]= %d   lat[i,j-8]= %d\n",lon[i,j-8],lat[i,j-8])
          tmpval = lon[i,j-8] + 1000
          printf ("   +++ TEST  tmpval=  %d\n",tmpval)

          loncheck = lon[i,j-8] + 0
          latcheck = lat[i,j-8] + 0

          if (loncheck > 990) {
            is_epac_storm = "y"
          }
          if (loncheck > 900 && latcheck < 175) {
            is_epac_storm = "y"
          }
          if (loncheck > 841 && latcheck < 150) {
            is_epac_storm = "y"
          }
          if (loncheck > 830 && latcheck <  95) {
            is_epac_storm = "y"
          }
          if (loncheck > 800 && latcheck <  85) {
            is_epac_storm = "y"
          }
          if (loncheck > 780 && loncheck <= 800 && latcheck <  90) {
            is_epac_storm = "y"
          }
          if (loncheck > 768 && latcheck <  75) {
            is_epac_storm = "y"
          }

          if (is_epac_storm ~ "y") {
            printf (" xxx EPAC position detected at initial pt for this set of 5 times \n") 
          }

          if (is_epac_storm ~ "n") {
            printf (" +++ EPAC position NOT detected at initial pt for this set of 5 times \n") 
          }
        
          # Check the middle 7 time levels in this current 
          # set of 9...

          for (jj=j-7; jj<=j-1; jj++) {
            if (paramb[i,jj] > -999 && paramb[i,jj] <= 100) {
              goodct_paramb++
            }
            if (vtl[i,jj] >= 0) {
              goodct_vtl++
            }
            if (vtu[i,jj] >= 0) {
              goodct_vtu++
            }
            if (wcflag[i,jj] ~ "Y") {
              goodct_wcflag++
            }
          }

          # Check the current time in this set of 9...

          if (paramb[i,j] > -999 && paramb[i,j] <= 100) {
            goodct_paramb++
            last_paramb_good = "y"
          }
          if (vtl[i,j] >= 0) {
            goodct_vtl++
            last_vtl_good = "y"
          }
          if (vtu[i,j] >= 0) {
            goodct_vtu++
            last_vtu_good = "y"
          }
          if (wcflag[i,j] ~ "Y") {
            goodct_wcflag++
            last_wcflag_good = "y"
          }

          # This first check looks at the CPS parameters only, and is
          # a little more lenient than the 2nd check.  Here, the CPS
          # Parameter B must pass at all 9 times, but the two thermal
          # wind parameters must pass only 7 of the 9, and they need
          # not be the same ones.  However, the first and last times
          # must have at least one of the vtl or the vtu metrics 
          # pass.

#          if (is_epac_storm ~ "n") {

          is_epac_storm = "pass"

          if (is_epac_storm ~ "pass") {
            if (metrics_pass ~ "n") {
              if (goodct_paramb >= 9 && goodct_vtl >= 7 &&
                  goodct_vtu >= 7) {
                if (first_paramb_good ~ "y" &&
                    (first_vtl_good ~ "y" || first_vtu_good ~ "y") &&
                    last_paramb_good ~ "y" &&
                    (last_vtl_good ~ "y" || last_vtu_good ~ "y")) {
                  # If the 1st and last times are good for Parameter B,
                  # and either vtl or vtl is good at the *first* time and
                  # either vtl or vtl is good at the *last* time 
                  # *AND* given that 7/9 times in total have checks that
                  # pass for these vtl and vtu metrics (though not 
                  # necesssarily all at same lead times), then by process
                  # of elimination, the checks pass for this block of 
                  # 9 times.
                  printf (" +++ CPS ONLY PASS\n")
                  metrics_pass = "y"
                  gtx[i] = j-8  # This is the array index for the lead time
                                # at which genesis occurred.
                  printf ("i= %d,  gtx[i]= %d\n",i,gtx[i])
                  break
                }
                else {
                  printf (" !!! CPS ONLY FAIL due to first or last  \n")
                }
              }
              else {
                printf (" !!! CPS ONLY FAIL due to number of params gt 4 or 5  \n")
              }
            }
          }
          else {
            printf ("   --- Passing on this set of times due to EPAC location at time 1 \n")
          }

          # If the first check using all CPS parameters does not pass,
          # then try another one here, where we look at the CPS
          # Parameter B and also the wcflag for the 300-500 mb warm 
          # core.  Parameter B check must pass at all 5 lead times, 
          # while the wcflag must pass at least 4/5 times.
          # NOTE: This check is only done if the check_wcflag_as_backup
          # flag has been set to "y" in the BEGIN section.

#          if (is_epac_storm ~ "n") {
#            if (metrics_pass ~ "n" && is_epac_storm ~ "n") {

          is_epac_storm = "pass"

          if (is_epac_storm ~ "pass") {
            if (metrics_pass ~ "n" && is_epac_storm ~ "pass") {
              if (check_wcflag_as_backup ~ "y") {
                if (goodct_paramb >= 9 && goodct_wcflag >= 7) {
                  # All times must pass for Parameter B and 7/9 times pass
                  # for the 300-500 mb warm core flag.  Yes, this does open
                  # the possibility that either the first or the last time
                  # does not have a passing wcflag.
                  metrics_pass = "y"
                  gtx[i] = j-8  # This is the array index for the lead time
                                # at which genesis occurred.
                  printf (" +++ CPS wcflag PASS\n")
                  printf ("i= %d,  gtx[i]= %d\n",i,gtx[i])
                  break
                }
                else {
                  printf (" !!! CPS wcflag FAIL due to not having 5 \n")
                }
              }
            }
          }
          else {
            printf ("   --- Passing on this set of times due to EPAC location at time 1 \n")
          }

        }

      }
    }

  }

  END {

    printf ("\n\n")
    printf ("   --- Filtered genesis tracks ---\n\n")

    for (i=1; i<=numcases; i++) {

      printf ("In END, i= %d, gtx[i]= %d, max_case_ix[i]= %d\n",i,gtx[i],max_case_ix[i])

      if (gtx[i] < 9999) {
        # We have a genesis case!
        for (j=gtx[i]; j<=max_case_ix[i]; j++) {
          printf ("++++  %s\n",inprec[i,j])
          printf ("%s\n",inprec[i,j]) >"storms_filtered"
        }
      }
    }

    printf ("\n")

  }
  '
#  ' inpfile_name=${ifile}
