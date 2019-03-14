%% Analysis of responses per first stimulus
clearvars
load('DATA\SequenceLearningData.mat')
Orange = [0.85 0.33 0.10];
Yellow = [0.93 0.69 0.13];

%  Conversion vectors containing stim numbers
RAN_970 = [8 5  1  2]; CON_970 = [4 9 10 12]; 
RAN_972 = [6 3 11  7]; CON_972 = [8 5  1  2];
RAN_973 = [1 3  6  8]; CON_973 = [5 2 11 12];
RAN_974 = [9 4 10  7]; CON_974 = [1 3  6  8];
RAN_975 = [4 9 10 12]; CON_975 = [6 3 11  7];
RAN_976 = [5 2 11 12]; CON_976 = [9 4 10  7];
%% Conversion of condition 1-4 to stim number of first stimulus
stim1_CON = NaN([length(clu), max(nBlocks_CON)*24]);
stim1_RAN = NaN([length(clu), max(nBlocks_RAN)*24]);
avg_CON = NaN([length(clu), max(nBlocks_CON)*24]);
avg_RAN = NaN([length(clu), max(nBlocks_RAN)*24]);

for c = 1:length(clu)
    Lc = length(order_CON{c});
    Lr = length(order_RAN{c});
    if ID(c) == "#970"
            stim1_CON(c,1:Lc) = CON_970(order_CON{c}) ;
            stim1_RAN(c,1:Lr) = RAN_970(order_RAN{c}) ; 
    elseif ID(c) == "#972"
            stim1_CON(c,1:Lc) = CON_972(order_CON{c}) ;
            stim1_RAN(c,1:Lr) = RAN_972(order_RAN{c}) ; 
    elseif ID(c) == "#973"
            stim1_CON(c,1:Lc) = CON_973(order_CON{c}) ;
            stim1_RAN(c,1:Lr) = RAN_973(order_RAN{c}) ; 
    elseif ID(c) == "#974"
            stim1_CON(c,1:Lc) = CON_974(order_CON{c}) ;
            stim1_RAN(c,1:Lr) = RAN_974(order_RAN{c}) ; 
    elseif ID(c) == "#975"
            stim1_CON(c,1:Lc) = CON_975(order_CON{c}) ;
            stim1_RAN(c,1:Lr) = RAN_975(order_RAN{c}) ; 
    elseif ID(c) == "#976"
            stim1_CON(c,1:Lc) = CON_976(order_CON{c}) ;
            stim1_RAN(c,1:Lr) = RAN_976(order_RAN{c}) ; 
    end
    
    avg_CON(c,1:Lc) = mean(PSTH_CON{c}(:,15:30),2);
    avg_RAN(c,1:Lr) = mean(PSTH_RAN{c}(:,15:30),2);

end
stim1_RAN = categorical( stim1_RAN);
stim1_CON = categorical( stim1_CON);
% clear RAN_* CON_*
%%
% avg_stim(1) = avg_RAN(stim1_RAN == 1);
    avg_CON = reshape(avg_CON,1, []);
    avg_RAN = reshape(avg_RAN,1, []);
    stim1_RAN = reshape(stim1_RAN,1, []);
    stim1_CON = reshape(stim1_CON,1, []);
    %%
subplot(2,2,1)
    scatter(stim1_RAN, avg_RAN, 'o',  'MarkerEdgeColor' , 'none', 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 0.2)
%     summary(stim1_RAN)
subplot(2,2,2)
	scatter(stim1_CON, avg_CON, 'o',  'MarkerEdgeColor' , 'none', 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 0.2)
%     summary(stim1_CON)
%%
gplotmatrix(meanSEQ, meanRAN,ID,{'r','r','b','b','k','k'},['+', '.'] ,...
    [5,15],[],'grpbars',{'SEQ 1','SEQ 2','SEQ 3','SEQ 4','OFF'}, {'RAN 1','RAN 2','RAN 3','RAN 4','OFF'} )