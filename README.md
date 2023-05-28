# connectivity_inference_252electrode
Scripts to import h5 files containing timestamps of spikes of neuronal popoulations captured in 252 micrelectrode arrays

Using electrophysiology data from arrays with 252 electrodes, the goal is to estimate the connectivity matrix and draw the underlying circuit (connectivity inference) from laboratory induced nervous tissue.

- Load_HDF5_RasterPlot.m
Imports  h5 files containing timestamps of spikes 

- connprob.
Cross-correlation function

- neuro.m
Applies cross-correlation function through all electrodes of the .h5 file. Plots the connectivity matrix afterwards

- timehistrogram.m
Plots the histogram between two electrodes chosen by the user, for a specified time window.
