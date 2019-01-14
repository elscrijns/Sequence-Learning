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

%% Process each cluster
clear C
for i = 1:n
    fileName = files(i).name;
    load(fullfile(DIR,fileName) )
    
    % split file name to extract variables 
    C = split(fileName,{'_' '.'} );
     
     MU(i) = i;
     ID(i) = categorical(C(1));
     day(i) = categorical(C(3));
     phase(i) = categorical(C(4));
     pos(i) = categorical(C(5));
     clu(i) = categorical(C(8));
    
     clear C
    
     % calculate average PSTHs per category
    baseline(i) = BL;
    
    SEQ(i,:) = mean(psths(expType == 46, :)) - BL;
    RAN(i,:) = mean(psths(expType == 47, :)) - BL;
    CON(i,:) = mean(psths(expType == 48, :)) - BL;
    
    % selection criteria for responsive MUs
    SD(i) = std(std(psths(:,1:15)));
    
    % Significant MU response
    % per MU a permutation test : Mean of each stim across presentations -> variance of the mean
    % -> 1000 permutations of bin order within one presentation -> variance
    % distribution
    meanFR(i) = mean(mean(psths(:,18:24))) - BL;
%     [responsiveMU(i), p1(i)] = ttest(mean(psths(:,18:24)), BL);
    [p1(i), responsiveMU(i)] = signrank(mean(psths(:,18:24))- BL);
    Threshold(i) = any(mean(psths(:,15:30)) > 2*SD(i) );
   
    % Mean responses per stim
    for s = 1:4
        win = [1:15] + s*15;
        meanSEQ(i,s) = mean(SEQ(i,win));
        meanRAN(i,s) = mean(RAN(i,win));
        meanCON(i,s) = mean(CON(i,win));        
    end
end
 responsiveMU = logical(responsiveMU);
  
 filenames = {files.name};
        save('DATA\SequenceLearningData.mat', 'filenames', 'baseline', 'SD', ...
            'meanFR', 'responsiveMU', 'Threshold', 'SEQ', 'RAN', 'CON',  ...
            'meanSEQ', 'meanRAN', 'meanCON', 'p1', 'ID','day','phase','pos', 'clu')
%% responsive MU: Significant response to first stim
% p values from T-test comparing BL to mean response to stim 1
figure;
    hist(p1, 0:0.01:max(p1))
    line([0.05 0.05], [0 20], 'Color', 'red')
    title('p-val for responsive MU')
    box off
disp(['Number of responsive MU = ' num2str(sum(responsiveMU))])


%% Analysis of conditions
% p values from signrank comparing SEQ & RAN response pattern
% figure;
%     hSR = pSR < 0.05;
%     hist(pSR, 0:0.01:max(pSR))
%     line([0.05 0.05], [0 70], 'Color', 'red')
%     title('p-val for difference between conditions')
%     box off
% disp(['2-sided wilcoxon paired ranks test = ' num2str(sum(hSR))])

% FR per stimulus, average across presentations
% FR in 20ms bins -> comparing 2 conditions
% 2-sided wilcoxon paired ranks test per bin
% FDR correction Benjamini & Hochberg 1995

% avoid selectivity bias
% on half the data select l-m-h FR stimuli, compare conditions per group
%% preliminary results
  
  % https://nl.mathworks.com/help/stats/repeatedmeasuresmodel.ranova.html
% mean responses per stimulus for significant MU clusters
figure
% subplot(2,1,1)
  barwitherr( [sem(meanSEQ(responsiveMU,:),1); sem(meanRAN(responsiveMU,:),1); sem(meanCON(responsiveMU,:),1)]', [mean(meanSEQ(responsiveMU,:)); mean(meanRAN(responsiveMU,:)); mean(meanCON(responsiveMU,:))]')
  title('Average responses')
  legend('SEQ','RAN','CON')
  legend boxoff
  box off
     