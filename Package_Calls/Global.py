# Imports.

import sys

sys.path.insert( 0, "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/rHDPE_Data_Analysis/" ) # Uncomment to ensure local version of package is used.

import rHDPE_Data_Analysis.Global_Analysis as ga

# Parameters.

read_parameters_from_numbers_file = False # True - parameters are read from Numbers file. False - parameters within code are used.

ip = ga.Input_Parameters_Class.Input_Parameters() # Initialise input parameters class.

if read_parameters_from_numbers_file:

    ga.Input_Parameters_Class.read_parameters_from_numbers_file( ip.directory + "Input_Parameters/Global_Experiment_Parameters.numbers", ip )

else:

    ip.directory = "" # Typically the directory that the file is run from, so an empty string to signify it's the working directory of the file.

    ip.output_directory = "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/Output/" # Directory where outputs are outputted.

    ip.datasets_to_read = [1, 2, 3, 4, 5, 6] # 1: FTIR; 2: DSC; 3: TGA; 4: Rhe; 5: TT; 6: Colour; 7: SHM; 8: TLS; 9: ESCR; 10: FTIR2; 11: FTIR3; 12: TGA_SB; 13: SAXS; 14: GPC; 15: TM.

    # ip.sample_mask = [11, 14, 10, 4, 13, 21, 23, 18, 22, 20, 2, 3, 17, 16, 19, 1, 15, 12, 6, 5, 7, 9, 8, 24, 25]
    # ip.sample_mask = [11, 14, 10, 4, 13, 2, 3, 1, 15, 12, 6, 5, 7, 9, 8] # No PP and no virgin.
    ip.sample_mask = [11, 14, 10, 4, 13, 18, 21, 23, 22, 20, 2, 3, 17, 16, 19, 1, 15, 12, 6, 5, 7, 9, 8, 24]

    ip.rerun_compute_features = False
    ip.name = "Test"

    ip.read_files = True # Read the files.

    ip.plot_global_features = False

    ip.scatterplot = False
    ip.scatterplot_x = "SAXS_la"
    ip.scatterplot_y = "SAXS_lc"

    ip.correlation_heatmaps = False

    ip.pca = True

    ip.distance_to_virgin_analysis_based_on_pcas = False

    ip.huang_brown_model = False

    ip.manual_ml = False

    ip.pca_ml = False

    ip.sandbox = False # Run functions that are experimental.

# Main function call.

ga.Analysis.Global_Analysis_Main( ip )
