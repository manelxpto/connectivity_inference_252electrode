% Loads an HDF5 file (with spike timestamps) from MCS MEA2100
% makes the data available and produces a raster plot
% Paulo de Castro Aguiar
% Neuroengineering and Computational Neuroscience Lab
% i3S, July 2021
% pauloaguiar@i3s.up.pt
% -----------------------------------------------------------------------


%% GET FILENAME
[fname, path] = uigetfile('*.h5', 'Please select the HDF5 file to load' );
filename = [path, fname];        

% load data and check file content
options = [];
options.dataType = 'double';
Data = McsHDF5.McsData(filename, options);
N_SpikeTStreams = numel( Data.Recording{1,1}.TimeStampStream );        
if N_SpikeTStreams ~= 1
    errordlg({'The selected file is not valid for NCNMEA analysis!', '', 'Please choose an HDF5 file with spike times data only', '', '(HDF5 files with multiple data streams are not valid!)'}, 'ERROR', 'modal');
    status = -1;
    error('Invalid HDF5 file');
end

% sampling_freq_Hz is needed
if N_SpikeTStreams == 1
    answer = inputdlg('Choose time resolution for spike analysis [ms]: (do not use <1.0 unless really needed)', 'Metadata needed', [1 48], {'1.0'});
    sampling_freq_Hz = 1.0e3 / str2double( answer );
end        



%% LOAD SPIKE TIMES
electrode_labels = Data.Recording{1,1}.TimeStampStream{1,1}.Info.SourceChannelLabels;
channel_ids = str2double( Data.Recording{1,1}.TimeStampStream{1,1}.Info.SourceChannelIDs );
total_electrodes = numel( channel_ids );

total_recording_time_secs = 1.0e-6 * double( Data.Recording{1,1}.Duration );

dt_ms = 1.0e3/sampling_freq_Hz;
time_stamps_ms = 0:dt_ms:(1.0e3 * total_recording_time_secs + dt_ms);

spike_times_elec_ms = Data.Recording{1,1}.TimeStampStream{1,1}.TimeStamps';
spike_times_elec_ms = cellfun( @(x) double(x) * 1.0e-3, spike_times_elec_ms, 'UniformOutput', 0 ); % timestamps in ms

total_spikes_elec = cellfun( @numel, spike_times_elec_ms );



%% REORDER ELECTRODES
R = cell2mat( regexp( electrode_labels ,'(?<Name>\D+)(?<Nums>\d+)','names') );
[tmp, sorted_elec_ind] = sortrows([ {R.Name}', num2cell(cellfun(@(x)str2double(x),{R.Nums}')) ]);
sorted_elec_labels = strcat(tmp(:,1) ,cellfun(@(x) num2str(x), tmp(:,2),'unif',0));

% dummy test
test = strcmp( sorted_elec_labels, electrode_labels( sorted_elec_ind ) );
if prod( test ) == 0
    errordlg('Something is wrong with the labels! Abort', 'ERROR');
    return;
end

% proceed
electrode_labels = electrode_labels( sorted_elec_ind ); 
channel_ids      = channel_ids( sorted_elec_ind );
total_spikes_elec  = total_spikes_elec( sorted_elec_ind, : );
spike_times_elec_ms  = spike_times_elec_ms( sorted_elec_ind, : );



%% CREATE RASTER PLOT
electrodes_mask     = true( total_electrodes, 1 );
time_mask.Tstart_ms = time_stamps_ms(1);
time_mask.Tstop_ms  = time_stamps_ms(end);        

electrodes_selected = find( electrodes_mask == true );
N = numel( electrodes_selected );

figure
hold on
for k = 1 : N        
    elec_ind = electrodes_selected(k);
    t = 1.0e-3 * spike_times_elec_ms{ elec_ind, 1 };
    y = k * ones( size(t) );
    plot( t, y, 'b.', 'MarkerSize',4 );        
end
hold off
xlabel( 'Spike Times [s]' )

if N < 33
    ylabel( 'Electrode Label [1]' )    
    yticks(1:N)    
    yticklabels( electrode_labels( electrodes_selected ) );    
else
    ylabel( 'Electrode ID [1]' )            
end
ylim( [0.5, N+0.5] );
set(gca, 'YDir', 'Reverse');

xlim( 1.0e-3*[time_mask.Tstart_ms - 1.0/5.0e4, time_mask.Tstop_ms + 1.0/5.0e4 ] ); %1/5e4 gives an extra corresponting to the interval in a 50kHz recording


%%
% -----------------------------------------------------------------------
% Paulo de Castro Aguiar
% Neuroengineering and Computational Neuroscience Lab
% i3S, July 2021
% pauloaguiar@ineb.up.pt
% -----------------------------------------------------------------------








