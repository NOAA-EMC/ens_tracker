import datetime
import logging

import numpy as np

from genesis_guidance import forecast_models
from genesis_guidance.tracker_utils import search_for_object, dist_match
import genesis_guidance.io_utils as io


#def tctracker(model     , rundate                   , topdir     , basins      ):
def tctracker(model, rundate, topdir, basins, fname_template):

    basin = basins[0]
    model_definition = forecast_models.READERS[model](model_name=model,
                                                      basin=basin,
                                                      rundate=rundate,
                                                      fname_template=fname_template)
    logging.info(model_definition.basin_bbox())

    dist_output_path = io.cases_output_path(topdir, model, basin, rundate, 'dist')
    if dist_output_path.exists():
        logging.info('Output file already exists : {dist_output_path}'.format(
            dist_output_path=dist_output_path))
        return None

    # check that necessary model output files exist.
    # Exit if not all data are available.
    model_definition.check_for_input_files()

    outputs = {}
    for basin in basins:
        # Initialize arrays
        outputs[basin] = {
            'finalinfo': None,
            'finaltcinfo': None,
        }
    # Loop through each forecast hour file.
    for fh in model_definition.f_hours:
        vtime = rundate + datetime.timedelta(hours=fh)
        for basin in basins:
            model_definition.basin = basin
            allpinfo, alltcinfo = search_for_object(fh, model_definition, vtime, rundate)

            if allpinfo is not None:
                if outputs[basin]['finalinfo'] is None:
                    outputs[basin]['finalinfo'] = allpinfo
                else:
                    outputs[basin]['finalinfo'] = np.vstack(
                        (outputs[basin]['finalinfo'], allpinfo))

            if alltcinfo is not None:
                if outputs[basin]['finaltcinfo'] is None:
                    outputs[basin]['finaltcinfo'] = alltcinfo
                else:
                    outputs[basin]['finaltcinfo'] = np.vstack(
                        (outputs[basin]['finaltcinfo'], alltcinfo))

    # TODO: Make this relative to the Model definition tau array so it's more dynamic
    if model == 'ukm':
        tdiff_crit = 12  # hours between forecast points for matching.
    else:
        tdiff_crit = 6
    logging.info('Tracks complete -- Writing out data')
    for basin, data in outputs.items():
        # write out info for all disturbances tracked per basin
        dist_output_path = io.cases_output_path(topdir, model, basin, rundate, 'dist')
        io.save_output_text(data=data['finalinfo'], filepath=dist_output_path)

        # write out info for all TC matching points tracked per basin
        tc_output_path = io.cases_output_path(topdir, model, basin, rundate, 'tc')
        io.save_output_text(data=data['finaltcinfo'], filepath=tc_output_path)

        # match up disturbance track points and write out storm relative files
        for storm_id, match_data in dist_match(data['finalinfo'], tdiff_crit=tdiff_crit):
            output_path = io.tracker_output_path(topdir, model, basin, rundate, storm_id,
                                                 'dist')
            io.save_output_text(data=match_data, filepath=output_path)

        # match up TC track points and write out storm relative files
        for storm_id, match_data in dist_match(data['finaltcinfo'], tdiff_crit=tdiff_crit):
            output_path = io.tracker_output_path(topdir, model, basin, rundate, storm_id, 'tc')
            io.save_output_text(data=match_data, filepath=output_path)

    return outputs


def main():
    import argparse

    logging.getLogger().setLevel(logging.INFO)
    logging.basicConfig(format=('%(asctime)s | %(filename)-19s:%(lineno)-3d |'
                                ' %(levelname)-8s | %(message)s'), )
    parser = argparse.ArgumentParser(description='Run NHCs Genesis Guidance algorithm')
    parser.add_argument('--date', type=str, required=True)
    parser.add_argument('--fname_template', type=str, required=True)
    parser.add_argument('--model', type=str, default='gfs')
    parser.add_argument('--basin', type=str, nargs='*', default=['natl', 'epac'])
    parser.add_argument('--odir', type=str, default='./')
    parser.add_argument('--debug', type=bool, default=False)

    args = parser.parse_args()
    rundate = datetime.datetime.strptime(args.date, "%Y%m%d%H")
    if args.debug:
        logging.getLogger().setLevel(logging.DEBUG)

    basins = args.basin
    if isinstance(basins, str):  # if only 1 basin passed, make it a list
        basins = [
            basins,
        ]

    if "{" not in args.fname_template:
        logging.error('fname_template should include formatting notation e.g.\n'
                      '"/model2/grib/gfs0p5deg/gfs.{date:%Y%m%dt%Hz}.pgrb2f{fhr:03}"')
        raise ValueError

    logging.debug('Running Tracker on {basin}'.format(basin=basins))
    tctracker(model=args.model,
              rundate=rundate,
              topdir=args.odir,
              basins=basins,
              fname_template=args.fname_template)

    logging.info('TCLOGG Complete for {basin} {date} {model}'.format(
        model=args.model,
        date=rundate,
        basin=basins,
    ))


if __name__ == '__main__':
    main()
