## Magnetic Trolley Data Processing

### Introduction
The script `combined_data.m` is for combining the exported output of the Bartington Spectramag program, in which two input channels exist:
Input 1. The 3 components of the magnetic field as a function of time
Input 2. The potentiometer reading (related to distance) as a function of time

The script `process_single_file.m` works in almost an identical way to the above script, but is for when all 6 channels are output by the Bartington Spectramag program at once.

These scripts write out the magnetic field data as a function of distance into a single specified output file. There is also an option to include a set of 'background' measurements which are subtracted off the recorded magnetic field. This last mode of operation requires some interpolation between the two runs, and as such it is suggested that the trolley be run over the same distance for each set of measurements, and only be run in one direction per run.

### Example data provided

`back1.Dat` and `back2.Dat` - Background data to be used in `combined_data.m`
`data1.Dat` and `data2.Dat` - Data to be used in `combined_data.m`
`data_single.Dat` - Data to be used in `process_single_file.m`

### Input for a non-background run
The following files must exist and variables set:
`combined_data.m` - 
* Two unaltered (raw files include headers) '.Dat' files from each of the Bartington Spectramag inputs are required.
* `filename_mag=` - Input 1.
* `filename_dist=` - Input 2.
* `output_file=` - Output file.
* `track_dist=` - Distance of track in metres.

`process_single_file.m` - 
* One unaltered (raw file includes headers) '.Dat' files from the Bartington Spectramag input is required.
* `filename_mag=` - Input 1.
* `output_file=` - Output file.
* `track_dist=` - Distance of track in metres.

Note that input file names may be absolute paths rather than relative, e.g., `H:\Lindfield 2014_09_30\data1.Dat`

### Input for a background run
Everything as per above is required but additionally:
`combined_data.m` - 
* Two '.Dat' files which specify a background trolley run.
* `background_exist=1`
* `filename_mag_back=` - Background Input 1.
* `filename_dist_back=` - Background Input 2.

`process_single_file.m` - 
* One '.Dat' file which specifies a background trolley run.
* `background_exist=1`
* `filename_mag_back=` - Background Input 1.

### Output for a non-background run
The output file writes 4 columns, the distance in arbitrary units, and the X, Y, and Z magnetic components in nT (`dist xnT ynT znT`).
The 3 magnetic components are also plotted as a function of distance.

### Output for a background run
The output file writes 9 columns, the distance in arbitrary units, and the X, Y, and Z magnetic components with the background subtracted, the X, Y, and Z magnetic components, and the X, Y, and Z background components (`dist xnT_m_back ynT_m_back znT_m_back xnT ynT znT xnT_back ynT_back znT_back`).
The 3 components of the signal with the background subtracted and the background itself are also plotted as a function of distance.


