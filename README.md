# General info

The data comes from two different sources.

The folder ``data`` has the logs that are used for this work:

- ``Oar:`` has a csv file that is extracted from the database. It contains general job information. (number of nodes used, running time, the request sent by the user)
- ``Colmet:`` has a list of HDF5 files. Each HDF5 file has the value of different measurments.
The energy measurement are contained within the entry: Job_0 -> RAPLSTATS_default
The other entries: has job specific information (like the number of CPU Cycles…). For this analysis we do not use it, but feel free to analyse it.


I also provide a jupyter notebook (``data_preprocessing.ipynb``) that contains an R script to access and do basic prepossessing of both data sources. 
Take a look at it and send me your questions directly (in french or english) 


