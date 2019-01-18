%% Load data files
clear all; clc
DIR = 'E:\Grating Sequence\';
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
for i = 1:n
    fileName = files(i).name;
    load(fullfile(DIR,fileName) )
    
    % split file name to extract variables 
    C = split(fileName,{'_' '.'} );
     
     MU(i) = i;
     ID(i) = categorical(C(1));
     pos(i) = categorical(C(3));
     clu(i) = categorical(C(end-1));
    
     clear C
    
     % calculate average PSTHs per category
    baseline(i) = BL;
    
    NONE(i,:)  = y(1,:);
    SMALL(i,:) = y(2,:);
    LARGE(i,:) = y(3,:);
   
    % selection criteria for responsive MUs
    SD(i) = std(std(psths(:,1:15)));
    
    % Significant MU response
    meanFR(i) = mean(mean(psths(:,18:24))) - BL;
    [p1(i), responsiveMU(i)] = signrank(mean(psths(:,18:24))- BL);
    Threshold(i) = any(mean(psths(:,15:30)) > 2*SD(i) );
   
    % Mean responses per stim
    for s = 1:5
        win = [1:15] + s*15;
        meanNONE(i,s) = mean(NONE(i,win));
        meanSMALL(i,s) = mean(SMALL(i,win));
        meanLARGE(i,s) = mean(LARGE(i,win));
    end
end
 responsiveMU = logical(responsiveMU);
%% Save data  
 filenames = {files.name};
%         save('DATA\SequenceLearningData.mat', 'filenames', 'baseline', 'SD', ...
%             'meanFR', 'responsiveMU', 'Threshold', 'SEQ', 'RAN', 'CON',  ...
%             'meanSEQ', 'meanRAN', 'meanCON', 'p1', 'ID','day','phase','pos', 'clu', 'MU')
save('DATA\GratingSequenceData.mat', 'filenames', 'baseline', 'SD', 'clu', 'MU', ...
            'meanFR', 'responsiveMU', 'Threshold', 'NONE', 'SMALL', 'LARGE',  ...
            'meanNONE', 'meanSMALL', 'meanLARGE', 'p1', 'ID','pos')

%% Barplot with mean and sem
figure('Units', 'centimeters', 'InnerPosition', [-30,0,15,10]);
  barwitherr( [sem(meanNONE(responsiveMU,:),1) ; sem(meanSMALL(responsiveMU,:),1); sem(meanLARGE(responsiveMU,:),1)]', [mean(meanNONE(responsiveMU,:)); mean(meanSMALL(responsiveMU,:)); mean(meanLARGE(responsiveMU,:))]')
  title('Average responses')
  xlabel('Stimulus')
  ylabel('mean +/- sem')
  legend('NONE','SMALL','LARGE', 'Location', 'NorthEast')
  legend boxoff
  box off
  %%
  SaveFig(15,10,'E:\Results\meanResp_gratings')
  close
%% PSTH overlay  
figure('Units', 'centimeters', 'InnerPosition', [-30,0,20,10]);
hold on, box off
Blue   = [0.00 0.45 0.74];
Orange = [0.85 0.33 0.10];
Yellow = [0.93 0.69 0.13];
% Select all responsive MUs for each rat   
    selection =  responsiveMU; 
% plot PSTH of average + sem response per condition
    h(3) = shadedErrorBar(1:91 , mean(LARGE(selection ,:),1), sem(LARGE(selection,:),1), 'lineProps', {'color', Yellow} );
    h(2) = shadedErrorBar(1:91 , mean(SMALL(selection,:),1), sem(SMALL(selection,:),1), 'lineProps', {'color', Orange} );
    h(1) = shadedErrorBar(1:91 , mean(NONE(selection,:),1), sem(NONE(selection,:),1), 'lineProps', {'color', Blue} );
        for i = 1:3
            h(i).edge(1).LineStyle = 'none';
            h(i).edge(2).LineStyle = 'none';
        end

% Figure annotation
    xlim([0 90]), box off
    plot([0 90], [0 0], '-k', 'LineWidth', 0.5);
    plot([15 15],  ylim,  '-r', 'LineWidth', 0.5)
    plot([30 30],  ylim,  '-r', 'LineWidth', 0.5)
    plot([45 45],  ylim,  '-r', 'LineWidth', 0.5)
    plot([60 60],  ylim,  '-r', 'LineWidth', 0.5)
    plot([75 75],  ylim,  '-r', 'LineWidth', 0.5)
    set(gca, 'XTick',      [ 1  15  30  45  60  75  90] );
    set(gca, 'XTickLabel', [-150 0 150 300 450 600 750]);
    xlabel('time, msec'), ylabel('spikes/sec');

%%
SaveFig(20,10, 'E:\Results\PSTHoverlay_gratings'), close
%% Statistical analysis
nMUs = sum(responsiveMU);
DATA = [meanNONE(responsiveMU,:); meanSMALL(responsiveMU,:);meanLARGE(responsiveMU,:)];

%% 2-way ANOVA for responsive MUs

[~,AOV,stats] = anova2(DATA, nMUs, 'off' );
    % Effect of stimulus, but not of group, also no interaction
    disp(AOV)
figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
c1 = multcompare(stats, 'Display', 'on', 'Estimate', 'row');
figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
c2 = multcompare(stats, 'Display', 'on', 'Estimate', 'column');
    % stim1 is significantly larger than stim2-4
