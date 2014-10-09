## Magnetic Trolley Data Processing

### Introduction
This script is for combining the exported output of the Bartington Spectramag program, in which two input channels exist:
Input 1. The 3 components of the magnetic field as a function of time
Input 2. The potentiometer reading (related to distance) as a function of time

This script writes out the magnetic field data as a function of distance into a single specified output file. There is also an option to include a set of 'background' measurements which are subtracted off the recorded magnetic field. This last mode of operation requires some interpolation between the two runs, and as such it is suggested that the trolley be run over the same distance for each set of measurements, and only be run in one direction per run.

### Input for a non-background run
The following files must exist and variables set:

*Two unaltered (raw files include headers) '.Dat' files from each of the Bartington Spectramag inputs are required.
*`filename_mag=` - Input 1.
*`filename_dist=` - Input 2.
*`output_file=` - Output file.

Note that input file names may be absolute paths rather than relative, e.g., `H:\Lindfield 2014_09_30\data1.Dat`

### Input for a background run
Everything as per above is required but additionally:

*Two '.Dat' files which specify a background trolley run.
*`background_exist=1`
*`filename_mag_back=` - Background Input 1.
*`filename_dist_back=` - Background Input 2.

### Output for a non-background run
The output file writes 4 columns, the distance in arbitrary units, and the X, Y, and Z magnetic components in nT (`dist xnT ynT znT`).
The 3 magnetic components are also plotted as a function of distance.

### Output for a background run
The output file writes 9 columns, the distance in arbitrary units, and the X, Y, and Z magnetic components with the background subtracted, the X, Y, and Z magnetic components, and the X, Y, and Z background components (`dist xnT_m_back ynT_m_back znT_m_back xnT ynT znT xnT_back ynT_back znT_back`).
The 3 components of the signal with the background subtracted and the background itself are also plotted as a function of distance.