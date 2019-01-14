%% Data analysis
clear all
load('DATA\SequenceLearningData.mat')
Blue   = [0.00 0.45 0.74];
Orange = [0.85 0.33 0.10];
Yellow = [0.93 0.69 0.13];
folder = 'E:\Results\';
%% Daily average responses per stimulus
% mean responses per stimulus for significant MU clusters
D = unique(day);
lim = [];
figure;
for i = 1:3 % per day
    hAX(i) = subplot(2,3,i);    
    selection = responsiveMU & day == D(i) & phase == '1' ;
    barwitherr( [sem(meanSEQ(selection,:),1); sem(meanRAN(selection,:),1); sem(meanCON(selection,:),1)]', [mean(meanSEQ(selection,:)); mean(meanRAN(selection,:)); mean(meanCON(selection,:))]')
      title([char(D(i)) ', n=' num2str(sum(selection)) ])
      xlabel('Stimulus')
      box off
      if i == 1
          axis off
          legend('SEQ','RAN','CON')
          legend boxoff      
          title('')
          ylabel('pre-exposure');
      end
      lim(end+1,:) = ylim;
  
  hAX(i+3) = subplot(2,3,i+3);
  selection = responsiveMU & day == D(i) & phase == '2' ;
  barwitherr( [sem(meanSEQ(selection,:),1); sem(meanRAN(selection,:),1); sem(meanCON(selection,:),1)]', [mean(meanSEQ(selection,:)); mean(meanRAN(selection,:)); mean(meanCON(selection,:))]')
  title([char(D(i)) ', n=' num2str(sum(selection)) ])
      xlabel('Stimulus')
      box off
      if i==1
          ylabel('post-exposure');
      end
  lim(end+1,:) = ylim;
end
ylim(hAX, [min(lim(:,1)) max(lim(:,2))])

%%
SaveFig(30,20,'MeanRespPerPhase'); close