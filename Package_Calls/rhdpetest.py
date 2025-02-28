# Imports.

import sys
import unittest
from diff_pdf_visually import pdf_similar

sys.path.insert( 0, "/Users/philsmith/Documents/Postdoc/rHDPE_Data_Analysis/rHDPE_Data_Analysis/" ) # Uncomment to ensure local version of package is used.

import rHDPE_Data_Analysis.DSC_Analysis as da
import rHDPE_Data_Analysis.SHM_Analysis as sa
import rHDPE_Data_Analysis.Rheology_Analysis as ra
import rHDPE_Data_Analysis.Colour_Analysis as ca
import rHDPE_Data_Analysis.TT_Analysis as tt
import rHDPE_Data_Analysis.TLS_Analysis as tls
import rHDPE_Data_Analysis.TGA_Analysis as ta
import rHDPE_Data_Analysis.FTIR_Analysis as fa
import rHDPE_Data_Analysis.ESCR_Analysis as ea
import rHDPE_Data_Analysis.Global_Analysis as ga

# Parameters.

ip = da.Input_Parameters_Class.Input_Parameters()

da.Input_Parameters_Class.read_parameters_from_numbers_file( "Input_Parameters/DSC_Test_Parameters.numbers", ip )

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

# Parameters.

ip = sa.Input_Parameters_Class.Input_Parameters()

sa.Input_Parameters_Class.read_parameters_from_numbers_file( "Input_Parameters/SHM_Test_Parameters.numbers", ip )

# Main function call.

sa.Analysis.SHM_Analysis_Main( ip )

class shmtest( unittest.TestCase ):

    def test_output( self ):

        base_outputs = ["Means_Features_Base.pdf", "Means_Distance_Matrix_Base.pdf", "Means_Dendrogram_Base.pdf", "Specimen_Features_Base.pdf", "Specimen_Distance_Matrix_Base.pdf", "Specimen_Dendrogram_Base.pdf"]
        new_outputs = ["Means_Features.pdf", "Means_Distance_Matrix.pdf", "Means_Dendrogram.pdf", "Specimen_Features.pdf", "Specimen_Distance_Matrix.pdf", "Specimen_Dendrogram.pdf"]

        root_directory = ip.output_directory + "SHM/Features/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

# Parameters.

ip = ra.Input_Parameters_Class.Input_Parameters()

ra.Input_Parameters_Class.read_parameters_from_numbers_file( "Input_Parameters/Rheology_Test_Parameters.numbers", ip )

# Main function call.

ra.Analysis.Rheology_Analysis_Main( ip )

class rheologytest( unittest.TestCase ):

    def test_output( self ):

        base_outputs = ["Means_Features_Base.pdf", "Means_Distance_Matrix_Base.pdf", "Means_Dendrogram_Base.pdf", "Specimen_Features_Base.pdf", "Specimen_Distance_Matrix_Base.pdf", "Specimen_Dendrogram_Base.pdf"]
        new_outputs = ["Means_Features.pdf", "Means_Distance_Matrix.pdf", "Means_Dendrogram.pdf", "Specimen_Features.pdf", "Specimen_Distance_Matrix.pdf", "Specimen_Dendrogram.pdf"]

        root_directory = ip.output_directory + "Rheology/Features/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

# Parameters.

ip = ca.Input_Parameters_Class.Input_Parameters()

ca.Input_Parameters_Class.read_parameters_from_numbers_file( "Input_Parameters/Colour_Test_Parameters.numbers", ip )

# Main function call.

ca.Analysis.Colour_Analysis_Main( ip )

class colourtest( unittest.TestCase ):

    def test_output( self ):

        base_outputs = ["Means_Features_Base.pdf", "Means_Distance_Matrix_Base.pdf", "Means_Dendrogram_Base.pdf", "Specimen_Features_Base.pdf", "Specimen_Distance_Matrix_Base.pdf", "Specimen_Dendrogram_Base.pdf"]
        new_outputs = ["Means_Features.pdf", "Means_Distance_Matrix.pdf", "Means_Dendrogram.pdf", "Specimen_Features.pdf", "Specimen_Distance_Matrix.pdf", "Specimen_Dendrogram.pdf"]

        root_directory = ip.output_directory + "Colour/Features/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

# Parameters.

ip = tt.Input_Parameters_Class.Input_Parameters()

tt.Input_Parameters_Class.read_parameters_from_numbers_file( "Input_Parameters/TT_Test_Parameters.numbers", ip )

# Main function call.

tt.Analysis.TT_Analysis_Main( ip )

class tttest( unittest.TestCase ):

    def test_output( self ):

        base_outputs = ["Means_Features_Base.pdf", "Means_Distance_Matrix_Base.pdf", "Means_Dendrogram_Base.pdf", "Specimen_Features_Base.pdf", "Specimen_Distance_Matrix_Base.pdf", "Specimen_Dendrogram_Base.pdf"]
        new_outputs = ["Means_Features.pdf", "Means_Distance_Matrix.pdf", "Means_Dendrogram.pdf", "Specimen_Features.pdf", "Specimen_Distance_Matrix.pdf", "Specimen_Dendrogram.pdf"]

        root_directory = ip.output_directory + "TT/Features/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

# Parameters.

ip = tls.Input_Parameters_Class.Input_Parameters()

tls.Input_Parameters_Class.read_parameters_from_numbers_file( "Input_Parameters/TLS_Test_Parameters.numbers", ip )

# Main function call.

tls.Analysis.TLS_Analysis_Main( ip )

class tlstest( unittest.TestCase ):

    def test_output( self ):

        base_outputs = ["Means_Features_Base.pdf", "Means_Distance_Matrix_Base.pdf", "Means_Dendrogram_Base.pdf", "Specimen_Features_Base.pdf", "Specimen_Distance_Matrix_Base.pdf", "Specimen_Dendrogram_Base.pdf"]
        new_outputs = ["Means_Features.pdf", "Means_Distance_Matrix.pdf", "Means_Dendrogram.pdf", "Specimen_Features.pdf", "Specimen_Distance_Matrix.pdf", "Specimen_Dendrogram.pdf"]

        root_directory = ip.output_directory + "TLS/Features/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

# Parameters.

ip = ta.Input_Parameters_Class.Input_Parameters()

ta.Input_Parameters_Class.read_parameters_from_numbers_file( "Input_Parameters/TGA_Test_Parameters.numbers", ip )

# Main function call.

ta.Analysis.TGA_Analysis_Main( ip )

class tgatest( unittest.TestCase ):

    def test_output( self ):

        base_outputs = ["Means_Features_Base.pdf", "Means_Distance_Matrix_Base.pdf", "Means_Dendrogram_Base.pdf", "Specimen_Features_Base.pdf", "Specimen_Distance_Matrix_Base.pdf", "Specimen_Dendrogram_Base.pdf"]
        new_outputs = ["Means_Features.pdf", "Means_Distance_Matrix.pdf", "Means_Dendrogram.pdf", "Specimen_Features.pdf", "Specimen_Distance_Matrix.pdf", "Specimen_Dendrogram.pdf"]

        root_directory = ip.output_directory + "TGA/Features/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

# Parameters.

ip = fa.Input_Parameters_Class.Input_Parameters()

fa.Input_Parameters_Class.read_parameters_from_numbers_file( "Input_Parameters/FTIR_Test_Parameters.numbers", ip )

# Main function call.

fa.Analysis.FTIR_Analysis_Main( ip )

class ftirtest( unittest.TestCase ):

    def test_output( self ):

        base_outputs = ["Means_Features_Base.pdf", "Means_Distance_Matrix_Base.pdf", "Means_Dendrogram_Base.pdf", "Specimen_Features_Base.pdf", "Specimen_Distance_Matrix_Base.pdf", "Specimen_Dendrogram_Base.pdf"]
        new_outputs = ["Means_Features.pdf", "Means_Distance_Matrix.pdf", "Means_Dendrogram.pdf", "Specimen_Features.pdf", "Specimen_Distance_Matrix.pdf", "Specimen_Dendrogram.pdf"]

        root_directory = ip.output_directory + "FTIR/Features/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

# Parameters.

ip = ea.Input_Parameters_Class.Input_Parameters()

ea.Input_Parameters_Class.read_parameters_from_numbers_file( "Input_Parameters/ESCR_Test_Parameters.numbers", ip )

# Main function call.

ea.Analysis.ESCR_Analysis_Main( ip )

class escrtest( unittest.TestCase ):

    def test_output( self ):

        base_outputs = ["Means_Features_Base.pdf", "Means_Distance_Matrix_Base.pdf", "Means_Dendrogram_Base.pdf", "Specimen_Features_Base.pdf", "Specimen_Distance_Matrix_Base.pdf", "Specimen_Dendrogram_Base.pdf"]
        new_outputs = ["Means_Features.pdf", "Means_Distance_Matrix.pdf", "Means_Dendrogram.pdf", "Specimen_Features.pdf", "Specimen_Distance_Matrix.pdf", "Specimen_Dendrogram.pdf"]

        root_directory = ip.output_directory + "ESCR/Features/"

        for i in range( len( base_outputs ) ):

            f1 = root_directory + "Base/" + base_outputs[i]
            f2 = root_directory + new_outputs[i]

            if not pdf_similar( f1, f2 ):

                raise AssertionError

# Parameters.

ip = ga.Input_Parameters_Class.Input_Parameters()

ga.Input_Parameters_Class.read_parameters_from_numbers_file( "Input_Parameters/Global_Test_Parameters.numbers", ip )

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
