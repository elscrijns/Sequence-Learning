clear all
load('DATA\SequenceLearningData_#974.mat')
folder = 'E:\Results\';
Blue   = [0.00 0.45 0.74];
Orange = [0.85 0.33 0.10];
Yellow = [0.93 0.69 0.13];
%% PSTH Overlay of SEQ, RAN & CON per animal
figure('Units', 'centimeters', 'InnerPosition', [-30,-5,20,20]);
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
        for i = 1:3
            h(i).edge(1).LineStyle = 'none';
            h(i).edge(2).LineStyle = 'none';
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
SaveFig(20,20,[ folder 'PSTHoverlay']), close

%% PSTH Overlay of SEQ, RAN & CON for all animals combined
figure('Units', 'centimeters', 'InnerPosition', [-30,-5,20,10]);
    hold on
    title(['Average response'])
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
%%  
    SaveFig(20,10,[ folder 'PSTHoverlay_all']), close