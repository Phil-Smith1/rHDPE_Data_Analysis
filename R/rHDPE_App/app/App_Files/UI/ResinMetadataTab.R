# Tab for displaying resin metadata.

resinMetadataTab <- tabPanel( "Resin Metadata",
  
  verbatimTextOutput( "metadata_dataset_version_to" ),
  reactableOutput( "metadata_table_ro" )
  
)
