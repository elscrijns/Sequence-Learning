%% Extract all the required behavioral data
Dir = 'E:\' ;
currentSession = uigetdir(Dir, 'Select the recording session to analyze');
session = '#970_test_D10_1_Ch01-16_clu' ;

% Load behavioral data
    load([currentSession '\trial.mat'])
% Load clusters and spike times
    extractTimestamps;  % Timestamps (in usec) of each sample with sampling rate of 32556
% Load clustered data
    load([currentSession '\rez.mat' ])
        % rez: spikes x (timings, template N�, amplitude, ? , cluster N�)
        timings = rez.st3(:,1);     % timing in samples of each spike
        clusters = rez.st3(:,2);    % cluster assignment of each spike after auto-merge

clear fullpathMAT
%% Cluster analysis
% Extract the spike timestamps for all selected clusters  
    % Select the clusters you want to include in the analysis
    % the spike timestamps (in usec) are combined for all selected clusters
CLU = unique(clusters);
nClusters = length(CLU);

for i = 1:nClusters
    selectedCluster = CLU(i);
    % Extract the spike timestampts for all selected clusters  
    [selectedSpikeTimestampsInUsec, selectedClusters]   = extractMUdata(clusters, timings, timeStamps, selectedCluster);

% The selected spike timestamps are linked to a specific trial, and stored
% in trial.spikes (in ms)
    
    [trial] = linkSpikesAndBehaviour(trial, selectedSpikeTimestampsInUsec, before, after);

disp( ['Data processed for cluster #' num2str(selectedClusters) ] )
%% plot PSTH with prespecified Y-axis limits
% one subplot per condition
   
plotPSTHsPerCondition_SL;

%% Save the PSTH and datafile
outFile = [session num2str(selectedClusters)];
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5,0.98, outFile,'HorizontalAlignment' ,'center','VerticalAlignment', 'top', 'FontSize', 14, 'Interpreter','none')
    figName = ['E:\Sequence Learning plots\' outFile '.tif'] ;
     saveas(gcf , figName, 'tif');

fileName = [ 'E:\Sequence Learning data\' outFile '.mat']; save(fileName, 'trial', 'y' );

close all
disp('PSTH saved')
clear selectedSpikeTimestampsInUsec selectedClusters outFile fileName
end

%% when selecting a new cluster from the same session
 clearvars -except currentSession trial clusters timings timeStamps