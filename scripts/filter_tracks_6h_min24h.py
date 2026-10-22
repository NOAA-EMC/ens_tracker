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
# with 6-hourly output.  This is integrated into the script with how it 
# looks at sets of the most recent *5* lead times, meant to cover the most
# recent 24 hours of time.  If used on 3-hourly or 12-hourly data, or if 
# used with a different time-length threshold (i.e., different than 24h),
# then the logic will need to be adjusted accordingly.
# **************************************************************************
#
# This script has been converted from Tim Marchok aux to python - 20260903
#

#set -x


import sys

if len(sys.argv) < 2:
    print(" ")
    print(" +++ Usage: You need to enter 1 argument -- the name of the track file.")
    print(f" +++ Example: {sys.argv[0]} atcf_gen_track_file")
    print(" +++")
    print(" EXITING...")
    print(" ")
    sys.exit(8)

ifile = sys.argv[1]

print(" ")
print(f"ifile= {ifile}")
print(" ")

with open(ifile, "r") as f:
    lines = [line.rstrip("\n") for line in f]

lines = [
    line for line in lines
    if "50, NEQ" not in line
    and "64, NEQ" not in line
    and "_FOF" in line
]

lines.sort(key=lambda line: line.split()[2] if len(line.split()) >= 3 else "")

MINIMUM_STORM_LIFE = 24
CHECK_WCFLAG_AS_BACKUP = "n"
OUTPUT_FILE = "storms_filtered"


def awk_num(value):
    """Approximate AWK's numeric conversion behavior."""
    try:
        return float(value.strip())
    except (ValueError, AttributeError):
        return 0.0


def main():
    # ------------------------------------------------------------
    # Equivalent of:
    #
    # if [ $# -lt 1 ]; then
    #     ...
    #     exit 8
    # fi
    # ------------------------------------------------------------

    if len(sys.argv) < 2:
        prog = sys.argv[0]

        print()
        print(" +++ Usage: You need to enter 1 argument -- the name of the track file.")
        print(f" +++ Example: {prog} atcf_gen_track_file")
        print(" +++")
        print(" EXITING...")
        print()

        sys.exit(8)

    ifile = sys.argv[1]

    print()
    print(f"ifile= {ifile}")
    print()

    # ------------------------------------------------------------
    # Equivalent of:
    #
    # cat ${ifile} |
    # grep -v "50, NEQ" |
    # grep -v "64, NEQ" |
    # grep "_FOF" |
    # sort -k3
    #
    # IMPORTANT:
    # sort -k3 uses the THIRD WHITESPACE-SEPARATED FIELD.
    # ------------------------------------------------------------

    with open(ifile, "r") as f:
        lines = [line.rstrip("\n") for line in f]

    # grep -v "50, NEQ"
    # grep -v "64, NEQ"
    # grep "_FOF"
    lines = [
        line
        for line in lines
        if "50, NEQ" not in line
        and "64, NEQ" not in line
        and "_FOF" in line
    ]

    # Equivalent of:
    #
    # sort -k3
    #
    # Python split() without an argument uses whitespace.
    def sort_key(line):
        parts = line.split()

        if len(parts) >= 3:
            return parts[2]

        return ""

    lines.sort(key=sort_key)

    # ------------------------------------------------------------
    # Equivalent of AWK BEGIN block
    # ------------------------------------------------------------

    cases = []

    # ------------------------------------------------------------
    # Read records and group consecutive storm IDs.
    #
    # AWK itself uses:
    #
    # awk -F,
    #
    # so fields below are COMMA-separated.
    # ------------------------------------------------------------

    for line in lines:
        fields = line.split(",")

        # Original AWK accesses through $25.
        if len(fields) < 25:
            print(
                f"WARNING: skipping line with only "
                f"{len(fields)} comma-separated fields:",
                line,
                file=sys.stderr,
            )
            continue

        # AWK:
        #
        # $3  = storm ID
        # $7  = forecast hour
        # $22 = Parameter B
        # $23 = VTL
        # $24 = VTU
        # $25 = warm-core flag

        stormid = fields[2].strip()

        record = {
            "inprec": line,
            "fhour": awk_num(fields[6]),
            "paramb": awk_num(fields[21]),
            "vtl": awk_num(fields[22]),
            "vtu": awk_num(fields[23]),
            "wcflag": fields[24].strip(),
        }

        # --------------------------------------------------------
        # Start a new storm case if:
        #
        # 1. This is the first record, or
        # 2. The comma-separated $3 storm ID changed.
        # --------------------------------------------------------

        if not cases or stormid != cases[-1]["stormid"]:
            cases.append(
                {
                    "stormid": stormid,
                    "records": [],
                    "gtx": 9999,
                }
            )

        cases[-1]["records"].append(record)

        c = len(cases)
        h = len(cases[-1]["records"])

        print(f"c= {c:2d}, h= {h:2d}, inprec= {line}")

    numcases = len(cases)

    # ------------------------------------------------------------
    # Storm filtering logic
    # ------------------------------------------------------------

    for i, case in enumerate(cases, start=1):
        records = case["records"]

        if not records:
            continue

        # Equivalent of max_case_ix[i].
        max_case_ix = len(records)

        first_hour = records[0]["fhour"]
        last_hour = records[-1]["fhour"]

        total_cyclone_life = last_hour - first_hour

        print(f" Total cyclone life = {total_cyclone_life:g}")

        metrics_pass = "n"

        print(f"max_case_ix[i]= {max_case_ix}")

        # --------------------------------------------------------
        # Require storm life >= 24 hours.
        # --------------------------------------------------------

        if total_cyclone_life < MINIMUM_STORM_LIFE:
            continue

        # --------------------------------------------------------
        # Original AWK:
        #
        # for (j=5; j<=max_case_ix[i]; j++)
        #
        # We keep j logically 1-based here so it matches the AWK
        # output and gtx calculation.
        # --------------------------------------------------------

        for j in range(5, max_case_ix + 1):

            first_paramb_good = "n"
            first_vtl_good = "n"
            first_vtu_good = "n"
            first_wcflag_good = "n"

            last_paramb_good = "n"
            last_vtl_good = "n"
            last_vtu_good = "n"
            last_wcflag_good = "n"

            goodct_paramb = 0
            goodct_vtl = 0
            goodct_vtu = 0
            goodct_wcflag = 0

            metrics_pass = "n"

            print(f"metrics_pass= {metrics_pass}")
            print(f"j= {j}")

            # ----------------------------------------------------
            # First time in current group of 5.
            #
            # AWK index:
            #     j - 4
            #
            # Python index:
            #     j - 5
            # ----------------------------------------------------

            first = records[j - 5]

            if first["paramb"] > -999 and first["paramb"] <= 100:
                goodct_paramb += 1
                first_paramb_good = "y"

            if first["vtl"] >= 0:
                goodct_vtl += 1
                first_vtl_good = "y"

            if first["vtu"] >= 0:
                goodct_vtu += 1
                first_vtu_good = "y"

            if "Y" in first["wcflag"]:
                goodct_wcflag += 1
                first_wcflag_good = "y"

            print(f"  ---> first_paramb_good= {first_paramb_good}")
            print(f"  ---> first_vtl_good= {first_vtl_good}")
            print(f"  ---> first_vtu_good= {first_vtu_good}")
            print(f"  ---> first_wcflag_good= {first_wcflag_good}")

            # ----------------------------------------------------
            # Middle 3 times in current group of 5.
            #
            # AWK:
            #
            # for (jj=j-3; jj<=j-1; jj++)
            # ----------------------------------------------------

            for jj in range(j - 3, j):
                rec = records[jj - 1]

                if rec["paramb"] > -999 and rec["paramb"] <= 100:
                    goodct_paramb += 1

                if rec["vtl"] >= 0:
                    goodct_vtl += 1

                if rec["vtu"] >= 0:
                    goodct_vtu += 1

                if "Y" in rec["wcflag"]:
                    goodct_wcflag += 1

            # ----------------------------------------------------
            # Last/current time in current group of 5.
            #
            # AWK index:
            #     j
            #
            # Python index:
            #     j - 1
            # ----------------------------------------------------

            last = records[j - 1]

            if last["paramb"] > -999 and last["paramb"] <= 100:
                goodct_paramb += 1
                last_paramb_good = "y"

            if last["vtl"] >= 0:
                goodct_vtl += 1
                last_vtl_good = "y"

            if last["vtu"] >= 0:
                goodct_vtu += 1
                last_vtu_good = "y"

            if "Y" in last["wcflag"]:
                goodct_wcflag += 1
                last_wcflag_good = "y"

            # ----------------------------------------------------
            # CPS-only check
            # ----------------------------------------------------

            if metrics_pass == "n":

                if (
                    goodct_paramb >= 5
                    and goodct_vtl >= 4
                    and goodct_vtu >= 4
                ):

                    if (
                        first_paramb_good == "y"
                        and (
                            first_vtl_good == "y"
                            or first_vtu_good == "y"
                        )
                        and last_paramb_good == "y"
                        and (
                            last_vtl_good == "y"
                            or last_vtu_good == "y"
                        )
                    ):

                        print(" +++ CPS ONLY PASS")

                        metrics_pass = "y"

                        # First record in the first successful
                        # five-time block.
                        #
                        # Keep gtx 1-based, like AWK.
                        case["gtx"] = j - 4

                        print(f"i= {i},  gtx[i]= {case['gtx']}")

                        break

                    else:
                        print(
                            " !!! CPS ONLY FAIL due to first or last  "
                        )

                else:
                    print(
                        " !!! CPS ONLY FAIL due to "
                        "number of params gt 4 or 5  "
                    )

            # ----------------------------------------------------
            # Optional Parameter B + warm-core flag backup
            # ----------------------------------------------------

            if metrics_pass == "n":

                if CHECK_WCFLAG_AS_BACKUP == "y":

                    if (
                        goodct_paramb >= 5
                        and goodct_wcflag >= 4
                    ):

                        metrics_pass = "y"
                        case["gtx"] = j - 4

                        print(" +++ CPS wcflag PASS")
                        print(
                            f"i= {i},  gtx[i]= {case['gtx']}"
                        )

                        break

                    else:
                        print(
                            " !!! CPS wcflag FAIL "
                            "due to not having 5 "
                        )

    # ------------------------------------------------------------
    # Equivalent of AWK END block
    # ------------------------------------------------------------

    print()
    print()
    print("   --- Filtered genesis tracks ---")
    print()

    with open(OUTPUT_FILE, "w") as fout:

        for i, case in enumerate(cases, start=1):

            gtx = case["gtx"]
            max_case_ix = len(case["records"])

            print(
                f"In END, i= {i}, "
                f"gtx[i]= {gtx}, "
                f"max_case_ix[i]= {max_case_ix}"
            )

            if gtx < 9999:

                # ------------------------------------------------
                # Genesis case.
                #
                # Original AWK:
                #
                # for (j=gtx[i]; j<=max_case_ix[i]; j++)
                #
                # Since gtx is 1-based, convert to Python's
                # zero-based list index using gtx - 1.
                # ------------------------------------------------

                for j in range(gtx - 1, max_case_ix):

                    line = case["records"][j]["inprec"]

                    print(f"++++  {line}")

                    fout.write(line + "\n")

    print()


if __name__ == "__main__":
    main()


