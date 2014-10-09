## Magnetic Trolley Data Processing

### Introduction
This script is for combining the exported output of the Bartington Spectramag program, in which two input channels exist:
Input 1. The 3 components of the magnetic field as a function of time
Input 2. The potentiometer reading (related to distance) as a function of time

This script writes out the magnetic field data as a function of distance into a single specified output file. There is also an option to include a set of 'background' measurements which are subtracted off the recorded magnetic field

### Input for a non-background run
The following files must exist and variables set:
-Two unaltered (raw files include headers) '.Dat' files from each of the Bartington Spectramag inputs are required.
-`filename_mag=` - Input 1.
-`filename_dist=` - Input 2.
-`output_file=` - Output file.

Note that input file names may be absolute paths rather than relative, e.g., `H:\Lindfield 2014_09_30\data1.Dat`

### Input for a background run
Everything as per above is required but additionally:
-Two '.Dat' files which specify a background trolley run.
-`background_exist=1`
-`filename_mag_back=` - Background Input 1.
-`filename_dist_back=` - Background Input 2.

### Output for a non-background run

