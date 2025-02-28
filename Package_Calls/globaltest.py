# Imports.

from pathlib import Path
import unittest
from diff_pdf_visually import pdf_similar

import sys

sys.path.insert( 0, "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/rHDPE_Data_Analysis/" ) # Uncomment to ensure local version of package is used.

import rHDPE_Data_Analysis.Global_Analysis as ga

# Parameters.

ip = ga.Input_Parameters_Class.Input_Parameters()

ga.Input_Parameters_Class.read_parameters_from_numbers_file( ip.directory + "Input_Parameters/Global_Test_Parameters.numbers", ip )

# Main function call.

ga.Analysis.Global_Analysis_Main( ip )

class globaltest( unittest.TestCase ):

    def test_output( self ):

        base_outputs = ["Feature_Dataset_Base.pdf"]
        new_outputs = ["Unnamed.pdf"]

        root_directory = ip.output_directory + "Global/Features/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

        base_outputs = ["Pearson_Base.pdf", "Spearman_Base.pdf"]
        new_outputs = ["Pearson.pdf", "Spearman.pdf"]

        root_directory = ip.output_directory + "Global/Correlations/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

        base_outputs = ["Vertical_Base.pdf"]
        new_outputs = ["Vertical.pdf"]

        root_directory = ip.output_directory + "Global/Distance_to_Virgin_Analysis/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

if __name__ == "__main__":

    unittest.main()
