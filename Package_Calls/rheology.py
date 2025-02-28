# Imports.

import sys

sys.path.insert( 0, "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/rHDPE_Data_Analysis/" ) # Uncomment to ensure local version of package is used.

import rHDPE_Data_Analysis.Rheology_Analysis as ra

# Parameters.

read_parameters_from_numbers_file = False # True - parameters are read from Numbers file. False - parameters within code are used.
parameters_filename = "Paper_2" # Options are Experiment, Test, Paper_2

ip = ra.Input_Parameters_Class.Input_Parameters() # Initialise input parameters class.

if read_parameters_from_numbers_file:

    ra.Input_Parameters_Class.read_parameters_from_numbers_file( ip.directory + "Input_Parameters/Rheology_" + parameters_filename + "_Parameters.numbers", ip )

else:

    ip.directory = "" # Typically the directory that the file is run from, so an empty string to signify it's the working directory of the file.

    ip.data_directory = "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/Raw_Data/Rheology/" # Directory that contains the raw data.

    ip.output_directory = "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/Output/" # Directory where outputs are outputted.

    ip.read_files = False # Read the raw files.

    ip.merge_groups = False # Merge "different" resins that are really the same.

    ip.write_csv = False # Write the desired read data to a .csv file.

    ip.read_csv = True # Read the .csv file.

    ip.remove_files = True # Remove files of certain labels, e.g. those that are deemed erroneous.

    ip.remove_files_string = ""  # The string of descriptors to remove.

    ip.compute_mean = True # Compute means across specimens of a resin.

    ip.read_mean = True # Read the means from a file.

    ip.derivative = True # Computes the derivatives.

    ip.extract_features = True # Extract features from the data and save to a file.

    ip.read_and_analyse_features = True # Read features from a file and perform analysis.

    ip.plot_data = False # Run function that plots data.

    ip.sandbox = False # Run functions that are experimental.

# Main function call.

ra.Analysis.Rheology_Analysis_Main( ip )
