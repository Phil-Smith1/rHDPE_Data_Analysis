# Imports.

import sys

sys.path.insert( 0, "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/rHDPE_Data_Analysis/" ) # Uncomment to ensure local version of package is used.

import rHDPE_Data_Analysis.GCMS_Analysis as ga

# Parameters.

read_parameters_from_numbers_file = False # True - parameters are read from Numbers file. False - parameters within code are used.
parameters_filename = "Experiment" # Options are Experiment, Test

ip = ga.Input_Parameters_Class.Input_Parameters() # Initialise input parameters class.

if read_parameters_from_numbers_file:

    ga.Input_Parameters_Class.read_parameters_from_numbers_file( ip.directory + "GCMS/Input_Parameters/GCMS_" + parameters_filename + "_Parameters.numbers", ip )

else:

    ip.directory = "" # Typically the directory that the file is run from, so an empty string to signify it's the working directory of the file.

    ip.data_directory = "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/Raw_Data/GCMS/" # Directory that contains the raw data.

    ip.output_directory = "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/Output/" # Directory where outputs are outputted.

    ip.read_files = False # Read the raw files.

    ip.merge_groups = False # Merge "different" resins that are really the same.

    ip.write_csv = False # Write the desired read data to a .csv file.

    ip.read_csv = True # Read the .csv file.

    ip.remove_files = True # Remove files of certain labels, e.g. those that are deemed erroneous.

    ip.remove_files_string = ""  # The string of descriptors to remove.

    ip.compute_mean = True # Compute means across specimens of a resin.

    ip.read_mean = True # Read the means from a file.

    ip.derivative = False # Computes the derivatives.

    ip.extract_features = False # Extract features from the data and save to a file.

    ip.read_and_analyse_features = False # Read features from a file and perform analysis.

    ip.plot_data = True # Run function that plots data.

    ip.sandbox = False # Run functions that are experimental.

# Main function call.

ga.Analysis.GCMS_Analysis_Main( ip )
