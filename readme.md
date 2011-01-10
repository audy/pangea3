# 16S CLC Reference Assembly and Table Generation Pipeline

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

Then download ribopipe:

    $ git clone git@github.com:audy/ribopipe.git
    
This will create a `ribopipe/` directory
    
Invoke like this:

    cd ribopipe/
    ./ribopipe ../reads/ ../db.fasta
    
The reason you have to be in the ribopipe directory is because you have to be
in the same directory as CLC's License file (DRM kills science).

**TIP** - I like to run ribopipe and keep a log of what happened, but I also
like to see what's happening. So, I do this:

    ./ribopipe ../reads/ ../db.fasta > ../log.txt & tail -f ../log.txt
    
**TIP2** - The reads filenames are the headers in the megaclustable. So to make it legible, make them short. My preferred format is `L_1_B_002.txt` for Lane 1, barcode 2.