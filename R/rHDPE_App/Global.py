# Imports.

import Global_Analysis_2 as ga

# Directory.

directory = "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/R/rHDPE_App/"

# Parameters.

ip = ga.Input_Parameters_Class.Input_Parameters() # Initialise input parameters class.

ip.datasets_to_read = [1, 2, 3, 4, 5, 6] # 1: FTIR; 2: DSC; 3: TGA; 4: Rhe; 5: TT; 6: Colour; 7: TLS; 8: FTIR2; 9: FTIR3; 10: TGA_SB; 11: SHM; 12: ESCR.

ip.sample_mask = [11, 14, 10, 4, 13, 21, 23, 18, 22, 20, 2, 3, 17, 16, 19, 1, 15, 12, 6, 5, 7, 9, 8, 24]

ip.read_files = True # Read the files.

ip.pca = True

# Main function call.

ga.Analysis.Global_Analysis_Main( directory, ip )
