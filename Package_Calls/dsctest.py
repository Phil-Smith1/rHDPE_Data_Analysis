# Imports.

import sys
import unittest
from diff_pdf_visually import pdf_similar

sys.path.insert( 0, "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/rHDPE_Data_Analysis/" ) # Uncomment to ensure local version of package is used.

import rHDPE_Data_Analysis.DSC_Analysis as da

# Parameters.

ip = da.Input_Parameters_Class.Input_Parameters()

da.Input_Parameters_Class.read_parameters_from_numbers_file( ip.directory + "Input_Parameters/DSC_Test_Parameters.numbers", ip )

# Main function call.

da.Analysis.DSC_Analysis_Main( ip )

class dsctest( unittest.TestCase ):

    def test_output( self ):

        base_outputs = ["Means_Features_Base.pdf", "Means_Distance_Matrix_Base.pdf", "Means_Dendrogram_Base.pdf", "Specimen_Features_Base.pdf", "Specimen_Distance_Matrix_Base.pdf", "Specimen_Dendrogram_Base.pdf"]
        new_outputs = ["Means_Features.pdf", "Means_Distance_Matrix.pdf", "Means_Dendrogram.pdf", "Specimen_Features.pdf", "Specimen_Distance_Matrix.pdf", "Specimen_Dendrogram.pdf"]

        root_directory = ip.output_directory + "DSC/Features/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

if __name__ == "__main__":

    unittest.main()
