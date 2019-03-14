%% Convert raw data to .dat file
clearvars; clc;

session = '#973_gratings_pos2' ; outFile = [session '_MUA'];
    
% currentSession = uigetdir('E:\') ;
currentSession = generateNCS2Dat_32ch;
    % Opens a dialogbox that lets you select all CSC#.ncs files (1 per channel) 
    % you wish to include in your clustering
    % output: chunk.dat & chunk.dat.mat

% Selected recording session to cluster & analyze
disp(currentSession)
        % folder should contain:
        %   - chunk.dat         raw data used for clustering
        %   - chunk.dat.mat     contains the sample timestamps
        %   - events.nev        contains behavioral data

%%
disp('Initiate clustering')        
% Perform clustering of currentSession with KiloSort 
merge = 1; % perform post-hoc merging?
master_file_32ch
        % Assumes data is saved as chunk.dat in currentSession
        % If not fPath in master_file & ops.fbinary in config_file need to
        % be adjusted      
        % Takes several minutes to cluster the data. Progress in printed in command
        % window. (This can be supressed)
        % will generate multiple .npy files needed for Phy visualization
        % rez.mat contains all data needed for processing in Matlab
% clearvars -except currentSession trial
disp('clustering finished')
%% Load clusters and spike times
extractTimestamps;  % Timestamps (in usec) of each sample with sampling rate of 32556

% replaces loadKWIKfile from Klusta analysis
load([currentSession '\rez.mat' ])
    % rez: spikes x (timings, template N°, amplitude, ? , cluster N°)
    timings = rez.st3(:,1);     % timing in samples of each spike
    clusters = rez.st3(:,2);    % cluster assignment of each spike after auto-merge

% Extract the spike timestamps for all selected clusters  
    % Select the clusters you want to include in the analysis
    % the spike timestamps (in usec) are combined for all selected clusters
    % Unique cluster identifiers.
        clusterIdentifiers = unique(clusters);
    % Number of different clusters. 
        nClusters = length(clusterIdentifiers);
    % Include all clusters for MUA
        selectedClusters = [clusterIdentifiers];
    % Extract the spike timestampts for all selected clusters  
        [selectedSpikeTimestampsInUsec, selectedClusters]   = extractMUdata(clusters, timings, timeStamps, selectedClusters);
disp('MU data processed')
%% Extract all the required behavioral data

[trial] = extractBehaviouralData_SL2(currentSession,1);
        % in case of an error go to extractBehaviouralData.m and follow
        % instructions in section 1
    clear fileNEV filename

disp('loaded behavioral data')

%% The selected spike timestamps are linked to a specific trial, and stored
% in trial.spikes (in ms)
    before = 50; % ms time before trial start that should be included in analysis
    after  = 275*150;  % ms time after trial start (min. stim presentation time)
    [trial] = linkSpikesAndBehaviour(trial, selectedSpikeTimestampsInUsec, before, after);
%% plot PSTH
% one line condition
figure('OuterPosition', [-1500 0 500 400])
    fileName = fullfile(currentSession, [ outFile '.mat']) ;
    plotPSTHsPerCondition_gratings2;

%% Save the PSTH and datafile
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5,0.98, outFile,'HorizontalAlignment' ,'center','VerticalAlignment', 'top', 'FontSize', 14, 'Interpreter','none')
    figName = fullfile(currentSession, [outFile '.tif'] );
    saveas(gcf , figName, 'tif');

    save(fileName, 'trial' ); 
    close all
    disp('PSTH saved')
