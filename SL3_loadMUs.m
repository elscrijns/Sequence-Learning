%% Load data files
clear all; clc
DIR = 'E:\Sequence Learning data\';
files = dir([DIR '#*.mat']);
n = length(files);
disp(['Number clusters = ' num2str(n)])

binWidth	= 10;                     % msec.
stimDur     = 150;
before      = 150;
after       = (4*150)+150;
edges       = -before:binWidth:after; % msec.
ON          = before / binWidth ;
OFF         = ON + 4*stimDur/binWidth;
load('C:\Users\u0105250\Documents\MATLAB\Sequence Learning\design\randomPerms.mat')
order_RAN = {};
order_CON = {};
%% Process each cluster
for c = 1:n
    fileName = files(c).name;
    load(fullfile(DIR,fileName) )
    
    % split file name to extract variables 
    name = split(fileName,{'_' '.'} );
    MU(c) = c;
    ID(c) = categorical(name(1));
    day(c) = categorical(name(3));
    phase(c) = categorical(name(4));
    pos(c) = categorical(name(5));
    clu(c) = categorical(name(end-1));
    
    clear name
    
% calculate average PSTHs per category
% if BL <30 
%     continue;
% end
    baseline(c) = BL;
    SD(c) = std(std(psths(:,1:15)));
    
    SEQ(c,:) = mean(psths(expType == 46, :)) - BL;
    RAN(c,:) = mean(psths(expType == 47, :)) - BL;
    CON(c,:) = mean(psths(expType == 48, :)) - BL;

    % Significant MU response
    % per MU a permutation test : Mean of each stim across presentations -> variance of the mean
    % -> 1000 permutations of bin order within one presentation -> variance
    % distribution
    meanFR(c) = mean(mean(psths(:,17:26))) - BL;
%     [responsiveMU(i), p1(i)] = ttest(mean(psths(:,18:24)), BL);
    [p1(c), responsiveMU(c)] = signrank(mean(psths(:,18:24))- BL);
    Threshold(c) = any(mean(psths(:,17:26)) > 2*SD(c) );
   
    % Mean responses per stim
    for s = 1:5
        win = [4:13] + s*15;
        meanSEQ(c,s) = mean(SEQ(c,win));
        meanRAN(c,s) = mean(RAN(c,win));
        meanCON(c,s) = mean(CON(c,win));        
    end
        clear win s
   
    % extract identifiers for first stim per trial
    % each condition no (1:24) is linked to a specific presentation order
    % as described in randomCond
        n1 = length(psths(expType == 47,:));
        nBlocks_RAN(c) = round(n1/24);
        order_RAN{c} = randomCond(conditions(expType == 47),1);
        n2 = length(psths(expType == 48,:));
        nBlocks_CON(c) = round(n2/24);
        order_CON{c} = randomCond(conditions(expType == 48),1);
    
        clear n1 n2 conditions
    
    % keep raw PSTHs per trial for processing of individual stims
    PSTH_SEQ{c} =  psths(expType == 46,:);
    PSTH_RAN{c} =  psths(expType == 47,:);
    PSTH_CON{c} =  psths(expType == 48,:);
end
 responsiveMU = logical(responsiveMU);
 disp(['Responsive clusters = ' num2str(sum(responsiveMU))])

%%  
 filenames = {files.name}; 
        save('DATA\SequenceLearningData.mat', 'filenames', 'baseline', 'SD', ...
            'meanFR', 'responsiveMU', 'Threshold', 'SEQ', 'RAN', 'CON',  ...
            'meanSEQ', 'meanRAN', 'meanCON', 'p1', 'ID','day','phase','pos', ...
            'PSTH_SEQ','PSTH_CON', 'PSTH_RAN', 'order_RAN', 'order_CON', ...
            'clu', 'MU', 'nBlocks_RAN', 'nBlocks_CON')
ID2 = findgroups(ID);
day2 = findgroups(day);
        save('DATA\SequenceLearningData_R.mat', ...
            'meanFR', 'responsiveMU','baseline', 'SEQ', 'RAN', 'CON',  ...
            'meanSEQ', 'meanRAN', 'meanCON', 'ID2','day2','phase', ...
            'clu', 'MU')
clearvars
