%% Data analysis
clear all
load('DATA\SequenceLearningData.mat')
Blue   = [0.00 0.45 0.74];
Orange = [0.85 0.33 0.10];
Yellow = [0.93 0.69 0.13];
folder = 'E:\Results\';
%% mean responses per stimulus for significant MU clusters
% figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
selection  = responsiveMU; %& phase == '2';

barwitherr( [sem(meanSEQ(selection,:),1); sem(meanRAN(selection,:),1); sem(meanCON(selection,:),1)]', [mean(meanSEQ(selection,:)); mean(meanRAN(selection,:)); mean(meanCON(selection,:))]');
  title('Average response')
  set(gca,'XTick', [1 2 3 4 5])
  xlabel('Stimulus')
  ylabel('mean +/- sem')
  legend('SEQ','RAN','CON')
  legend boxoff
  box off
%%
  SaveFig(15,10,[folder 'meanResp'])
  close
%% normalized responses
normSEQ = meanSEQ./meanSEQ(:,1);
normRAN = meanRAN./meanRAN(:,1);
normCON = meanCON./meanCON(:,1);

barwitherr( [sem(normSEQ(selection,:),1); sem(normRAN(selection,:),1); sem(normCON(selection,:),1)]', [mean(normSEQ(selection,:)); mean(normRAN(selection,:)); mean(normCON(selection,:))]')
  title('Normalized response')
  xlabel('Stimulus')
  ylabel('mean +/- sem')
  legend('SEQ','RAN','CON')
  legend boxoff
  box off
%%
  SaveFig(15,10,[folder 'normResp'])
  close