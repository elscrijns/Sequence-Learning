%% Data analysis
clearvars;
load('DATA\SequenceLearningData.mat')
Blue   = [0.00 0.45 0.74];
Orange = [0.85 0.33 0.10];
Yellow = [0.93 0.69 0.13];
folder = 'E:\Results\';
%% Daily average responses per stimulus
% mean responses per stimulus for significant MU clusters
% D = unique(day);
D = categorical({'D10' 'D11' 'D15' 'D20'});
lim = [];
figure;
for i = 1:length(D) % per day
    hAX(i) = subplot(2,4,i);    
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
      elseif i == 2
          ylabel('spikes/sec');
      end
      lim(end+1,:) = ylim;
%       ylim( [-4 8])
  
  hAX(i+5) = subplot(2,4,i+4);
  selection = responsiveMU & day == D(i) & phase == '2' ;
  barwitherr( [sem(meanSEQ(selection,:),1); sem(meanRAN(selection,:),1); sem(meanCON(selection,:),1)]', [mean(meanSEQ(selection,:)); mean(meanRAN(selection,:)); mean(meanCON(selection,:))]')
  title([char(D(i)) ', n=' num2str(sum(selection)) ])
      xlabel('Stimulus')
      box off
      if i==1
          ylabel('spikes/sec');
      end
  lim(end+1,:) = ylim;
%   ylim([-2 5])
end
% ylim(hAX, [min(lim(:,1)) max(lim(:,2))])
% ylim(hAX(6), [-1 20])
%%
SaveFig(40,20,'E:\Results\MeanRespPerPhase'); close