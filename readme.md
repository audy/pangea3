# Pang3a

Austin G. Davis-Richardson,  
Chris T. Brown,  
David B. Crabb,  

## Description

This is a simple pipeline for running reference assemblies against the Tax-Collected 16S RDP database using CLC Reference Assemble, and generating (megaclust) tables that can be easily imported into Excel.

The entire process from assembly to splitting up into Phylum..Species is automated.

## Running

Your directory structure should look like this:

    /.
    /..
    /reads/
    /database/

Then download pang3a:

    $ git clone git@github.com:audy/pang3a.git
    
This will create a `pang3a/` directory
    
Invoke like this:

    cd pang3a/
    ./pang3a ../reads/ ../db.fasta #shannon "run"
    
The reason you have to be in the pang3a directory is because you have to be
in the same directory as CLC's License file (DRM kills science).

    
**TIP2** - The reads filenames are the headers in the megaclustable. So to make it legible, make them short. My preferred format is `L_1_B_002.txt` for Lane 1, barcode 2.