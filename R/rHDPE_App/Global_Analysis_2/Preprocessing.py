# Imports

import numpy as np
import pandas as pd
from rpy2.robjects import pandas2ri
from rpy2.robjects.conversion import localconverter
import rpy2.robjects as robjects

from . import Utilities as util

from . import Global_Utilities as gu

# Function definitions.

def source_R_functions( directory ):

    r = robjects.r
    r['source'](directory + 'rHDPE_R_Functions.R')

def authorise_googledrive( directory ):

    robjects.globalenv['authorise_googledrive']( directory )

def read_googlesheet_via_R( filename ):

    read_googlesheet = robjects.globalenv['read_googlesheet']

    rdf = read_googlesheet( filename )

    with localconverter( robjects.default_converter + pandas2ri.converter ):

        pydf = robjects.conversion.rpy2py( rdf )

    return pydf

def read_files_and_preprocess( directory, datasets_to_read, sample_mask ):

    source_R_functions( directory )

    authorise_googledrive( directory )

    dataset_names = ["FTIR", "DSC", "TGA", "Rheology", "TT", "Colour", "SHM", "TLS", "ESCR"]

    dataset_names = [dataset_names[i - 1] for i in datasets_to_read]

    dataset = []

    for n in dataset_names:

        if n == "FTIR2":

            df = pd.read_csv( directory + "FTIR" + "/Output/Integral_Analysis/Mean_Features.csv" )

        elif n == "FTIR3":

            df = pd.read_csv( directory + "FTIR" + "/Output/Component_Analysis/Features/Mean_Features.csv" )

        elif n == "TGA_SB":

            df = pd.read_csv( directory + "TGA" + "/Output/Sandbox/Mean_Features.csv" )

        else:

            try:

                df = pd.read_csv( directory + "Input/" + n + "/Mean_Features.csv" )

                df.drop( columns = [df.columns[0]], inplace = True )

            except FileNotFoundError:

                print( "File not found on server, getting it from Google Drive." )

                df = read_googlesheet_via_R( "~/Input/Sheets/" + n + "/Mean_Features" )

        dataset.append( df )

    for i in range( len( dataset ) ):

        samples_present = dataset[i].iloc[:, 0].tolist()

        sample_mask = gu.remove_redundant_samples( sample_mask, samples_present )

    features, feature_names = util.produce_full_dataset_of_features( directory, dataset, sample_mask )

    rank_features = util.rank_features( features )

    features_df = gu.array_with_column_titles_and_label_titles_to_df( features, feature_names, sample_mask )

    rank_features_df = gu.array_with_column_titles_and_label_titles_to_df( rank_features, feature_names, sample_mask )

    dataset = []

    for n in dataset_names:

        if n == "FTIR2":

            df = pd.read_csv( directory + "FTIR" + "/Output/Integral_Analysis/Std_of_Features.csv" )

        elif n == "FTIR3":

            df = pd.read_csv( directory + "FTIR" + "/Output/Component_Analysis/Features/Std_of_Features.csv" )

        elif n == "TGA_SB":

            df = pd.read_csv( directory + "TGA" + "/Output/Sandbox/Std_of_Features.csv" )

        else:

            try:

                df = pd.read_csv( directory + "Input/" + n + "/Std_of_Features.csv" )

                df.drop( columns = [df.columns[0]], inplace = True )

            except FileNotFoundError:

                print( "File not found on server, getting it from Google Drive." )

                df = read_googlesheet_via_R( "~/Input/Sheets/" + n + "/Std_of_Features" )

        dataset.append( df )

    std_of_features, _ = util.produce_full_dataset_of_features( directory, dataset, sample_mask )

    std_of_features_df = gu.array_with_column_titles_and_label_titles_to_df( std_of_features, feature_names, sample_mask )

    return features_df, std_of_features_df, rank_features_df
