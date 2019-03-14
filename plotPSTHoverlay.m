clearvars
load('DATA\SequenceLearningData.mat')
folder = 'E:\Results\';
Blue   = [0.00 0.45 0.74];
Orange = [0.85 0.33 0.10];
Yellow = [0.93 0.69 0.13];
%% Normalization
% SEQ = (SEQ - meanFR') ./meanFR';
% RAN = (RAN - meanFR') ./meanFR';
% CON = (CON - meanFR') ./meanFR';
%% PSTH Overlay of SEQ, RAN & CON for all animals combined
figure('Units', 'centimeters', 'InnerPosition', [-30,-5,20,15]);
    hold on
    title('Average response')
 subplot(2,1,1), hold on
% plot PSTH of average + sem response per condition
    h(3) = shadedErrorBar(1:91 , mean(CON(responsiveMU ,:),1), sem(CON(responsiveMU,:),1), 'lineProps', {'color', Yellow} );
    h(2) = shadedErrorBar(1:91 , mean(RAN(responsiveMU,:),1), sem(RAN(responsiveMU,:),1), 'lineProps', {'color', Orange} );
    h(1) = shadedErrorBar(1:91 , mean(SEQ(responsiveMU,:),1), sem(SEQ(responsiveMU,:),1), 'lineProps', {'color', Blue} );
        for i = 1:3
            h(i).edge(1).LineStyle = 'none';
            h(i).edge(2).LineStyle = 'none';
        end

% Figure annotation
sd = mean(SD);
    xlim([0 90]), box off
    plot([0 90], [0 0], '-k', 'LineWidth', 0.5);
    plot([0 90], [sd sd], ':k', 'LineWidth', 0.5);
    plot([15 15],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([30 30],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([45 45],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([60 60],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([75 75],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    set(gca, 'XTick',      [ 1  15  30  45  60  75  90] );
    set(gca, 'XTickLabel', [-150 0 150 300 450 600 750]);
    xlabel('time, msec'), ylabel('spikes/sec');
    clear h
%% statistics
for bin = 15:90
    [p1(bin),h1(bin),stats1(bin)] = signrank( SEQ(responsiveMU,bin), RAN(responsiveMU,bin), 'method', 'approximate');
    [p2(bin),h2(bin),stats2(bin)] = signrank( SEQ(responsiveMU,bin), CON(responsiveMU,bin), 'method', 'approximate');
    [p3(bin),h3(bin),stats3(bin)] = signrank( CON(responsiveMU,bin), RAN(responsiveMU,bin), 'method', 'approximate');
    pS(bin) = signrank( SEQ(responsiveMU,bin) );
    
    if p1(bin) < 0.05
        scatter(bin ,-4,'*k')
%     else 
%         scatter(bin ,-4,'.k')
    end
%     if pS(bin) < 0.05
%         scatter(bin ,-3,'*r')
%     end
end
[FDR, q] = mafdr(p1);
%%
   subplot(3,1,[2 3]), hold on
% rho = corr(SEQ);
%     image(rho,'CDataMapping','scaled')
%     colorbar
[rho, p] = corr(SEQ, RAN);
    image(rho,'CDataMapping','scaled')
    set(gca, 'XTick',      [ 1  15  30  45  60  75  90] );
    set(gca, 'XTickLabel', [-150 0 150 300 450 600 750]);
    set(gca, 'YTick',      [ 1  15  30  45  60  75  90] );
    set(gca, 'YTickLabel', [-150 0 150 300 450 600 750]);
     xlim([0 90]), ylim([0 90]), box off
%% Save figure
    SaveFig(20,15,[ folder 'PSTHoverlay_corr']), close
%% PSTH Overlay of SEQ, RAN & CON per animal
figure('Units', 'centimeters', 'InnerPosition', [-30,-5,25,20]);
Rats = unique(ID);
n = length(Rats);

for i = 1:n

 % 1 subplot per rat
    subplot(3,2,i), hold on
    title(['rat ' char(Rats(i)) ])

 % Select all responsive MUs for each rat   
    selection =  responsiveMU & ID == Rats(i) ; 
% plot PSTH of average + sem response per condition
    h(3) = shadedErrorBar(1:91 , mean(CON(selection ,:),1), sem(CON(selection,:),1), 'lineProps', {'color', Yellow} );
    h(2) = shadedErrorBar(1:91 , mean(RAN(selection,:),1), sem(RAN(selection,:),1), 'lineProps', {'color', Orange} );
    h(1) = shadedErrorBar(1:91 , mean(SEQ(selection,:),1), sem(SEQ(selection,:),1), 'lineProps', {'color', Blue} );
        for p = 1:3
            h(p).edge(1).LineStyle = 'none';
            h(p).edge(2).LineStyle = 'none';
        end

% Figure annotation
    xlim([0 90]), box off
    plot([0 90], [0 0], '-k', 'LineWidth', 0.5);
    plot([15 15],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([30 30],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([45 45],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([60 60],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([75 75],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    set(gca, 'XTick',      [ 1  15  30  45  60  75  90] );
    set(gca, 'XTickLabel', [-150 0 150 300 450 600 750]);
    xlabel('time, msec'), ylabel('spikes/sec');

    clear h
end
%%
SaveFig(25,20,[ folder 'PSTHoverlay_perAnimal']), close
%% PSTH Overlay per day of SEQ, RAN & CON for all animals combined
figure('Units', 'centimeters', 'InnerPosition', [-30,-5,25,20]);
D = unique(day);
n = length(D);

% SEQ
    subplot(3,1,1), hold on   
for i = 1:n
 % Select all responsive MUs for each day   
    selection =  responsiveMU & day == D(i) ; 
 % plot PSTH of average + sem response per condition
    plot(1:91 , mean(SEQ(selection,:),1) );
end
title('SEQ responses by day')
hold off

% RAN
    subplot(3,1,2), hold on   
for i = 1:n
 % Select all responsive MUs for each day   
    selection =  responsiveMU & day == D(i) ; 
 % plot PSTH of average + sem response per condition
    plot(1:91 , mean(RAN(selection,:),1) );
end
title('RAN responses by day')
hold off

% CON
    subplot(3,1,3), hold on   
for i = 1:n
 % Select all responsive MUs for each day   
    selection =  responsiveMU & day == D(i) ; 
 % plot PSTH of average + sem response per condition
    plot(1:91 , mean(CON(selection,:),1) );
end
title('CON responses by day')
hold off

% Figure annotation
for p = 1:3
    subplot(3,1,p), hold on

    xlim([0 90]), box off
    plot([0 90], [0 0], '-k', 'LineWidth', 0.5);
    plot([15 15],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([30 30],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([45 45],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([60 60],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    plot([75 75],  [-5 max(ylim)],  '-r', 'LineWidth', 0.5)
    set(gca, 'XTick',      [ 1  15  30  45  60  75  90] );
    set(gca, 'XTickLabel', [-150 0 150 300 450 600 750]);
    xlabel('time, msec'), ylabel('spikes/sec');
    legend('D10','D11', 'D12','D13', 'D15', 'D20', 'Location','NorthWest');
    legend boxoff
end
%%  
    SaveFig(20,15,[ folder 'PSTHoverlay_perDay']), close all
%%
