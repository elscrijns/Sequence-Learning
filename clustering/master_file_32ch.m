% default options are in parenthesis after the comment

fpath    = currentSession; 
% fpath = 'C:\Users\u0105250\Documents\MATLAB\KiloSort\TEST_data\'; % where on disk do you want the simulation? ideally and SSD...
if ~exist(fpath, 'dir'); mkdir(fpath); end
 
% Add directories to your MATLAB paths. should not be necessary when paths
% have been saved. 
addpath(genpath('C:\Users\u0105250\Documents\GitHub\KiloSort')) % path to kilosort folder
addpath(genpath('C:\Users\u0105250\Documents\GitHub\npy-matlab')) % path to npy-matlab scripts

% adjust for each clustering session
pathToYourConfigFile = 'C:\Users\u0105250\Documents\MATLAB\Sequence Learning\clustering'; % take from Github folder and put it somewhere else (together with the master_file)
run(fullfile(pathToYourConfigFile, 'config_file_32ch.m')) 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You should not need to edit from here
% KiloSort will perform clustering
% Automerge can be activated if required (L32)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic; % start timer
%
if ops.GPU     
    gpuDevice(1); % initialize GPU (will erase any existing GPU arrays)
end

if strcmp(ops.datatype , 'openEphys')
   ops = convertOpenEphysToRawBInary(ops);  % convert data, only for OpenEphys
end
%
[rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes for initialization
rez                = fitTemplates(rez, DATA, uproj);  % fit templates iteratively
rez                = fullMPMU(rez, DATA);% extract final spike times (overlapping extraction)

% OPTIONAL AutoMerge. rez2Phy will use for clusters the new 5th column of st3 if you run this)
if merge == 1
    rez = merge_posthoc2(rez);
end

% save matlab results file
save(fullfile(ops.root,  'rez.mat'), 'rez', '-v7.3');

% save python results file for Phy
rezToPhy(rez, ops.root);

% remove temporary file
delete(ops.fproc);
%%
