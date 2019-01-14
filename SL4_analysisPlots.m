%% Data analysis
clear all
load('DATA\SequenceLearningData.mat')
Blue   = [0.00 0.45 0.74];
Orange = [0.85 0.33 0.10];
Yellow = [0.93 0.69 0.13];
%% responsive MU: Significant response to first stim
% p values from T-test comparing BL to mean response to stim 1
figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
    hist(p1, 0:0.01:max(p1))
    line([0.05 0.05], [0 40], 'Color', 'red')
    title('p-val for responsive MU')
    box off
    nMUs = sum(responsiveMU); %replications

disp(['Number of collected MU  = ' num2str(length(responsiveMU))])
disp(['Number of responsive MU = ' num2str(nMUs)])

    %% Histogram of average responses per stimulus
figure('Units', 'centimeters', 'InnerPosition', [-30,0,20,15]);
    
for i = 1:4
subplot(3,4,i) 
    histogram(meanSEQ(responsiveMU,i), 'Normalization', 'probability', 'FaceColor', Blue, 'EdgeColor', 'none')
    xlim([-20 20])
    ylim([0 0.8])
    box off, axis square
end

for i = 1:4
subplot(3,4,4+i), hold on
    histogram(meanRAN(responsiveMU,i), 'Normalization', 'probability','FaceColor', Orange, 'EdgeColor', 'none')
    xlim([-20 20])
    ylim([0 0.8])
    box off, axis square
end

for i = 1:4
subplot(3,4,8+i), hold on
    histogram(meanCON(responsiveMU,i), 'Normalization', 'probability','FaceColor', Yellow, 'EdgeColor', 'none')
    xlim([-20 20])
    ylim([0 0.8])
    box off, axis square
end
supertitle('Average responses per stimulus')
%% Scatterplot and histogram for first stimulus
figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
title('meanSEQ vs meanRAN stim1')
h = scatterhist(meanSEQ(responsiveMU,1), meanRAN(responsiveMU,1), 'Direction', 'out', 'Marker', '.');
    line(h(1), [-10 15], [-10 15], 'Color', 'k', 'LineWidth', 1)
    
%% Scatterplot and histogram for second stimulus
figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
h = scatterhist(meanSEQ(responsiveMU,2), meanRAN(responsiveMU,2), 'Direction', 'out', 'Marker', '.');
    line(h(1), [-10 15], [-10 15], 'Color', 'k', 'LineWidth', 1)
title('meanSEQ vs meanRAN stim2')

%% NORMALIZED Daily average responses per stimulus
% mean responses per stimulus for significant MU clusters
normSEQ = meanSEQ./meanSEQ(:,1);
normRAN = meanRAN./meanRAN(:,1);
normCON = meanCON./meanCON(:,1);
D = unique(day);
lim = [];
figure;
for i = 1:3
    hAX(i) = subplot(2,3,i);    
    selection = responsiveMU & day == D(i) & phase == '1' ;
    barwitherr( [sem(normSEQ(selection,:),1); sem(normRAN(selection,:),1); sem(normCON(selection,:),1)]', [mean(normSEQ(selection,:)); mean(normRAN(selection,:)); mean(normCON(selection,:))]')
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
  barwitherr( [sem(normSEQ(selection,:),1); sem(normRAN(selection,:),1); sem(normCON(selection,:),1)]', [mean(normSEQ(selection,:)); mean(normRAN(selection,:)); mean(normCON(selection,:))]')
  title([char(D(i)) ', n=' num2str(sum(selection)) ])
      xlabel('Stimulus')
      box off
      if i==1
          ylabel('post-exposure');
      end
  lim(end+1,:) = ylim;
end
% ylim(hAX, [min(lim(:,1)) max(lim(:,2))])
%%
SaveFig(30,20,'NormRespPerPhase_rat970'); close

%%
% close all