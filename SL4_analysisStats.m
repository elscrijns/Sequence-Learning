%% Data analysis
clearvars
load('DATA\SequenceLearningData.mat')
Blue   = [0.00 0.45 0.74];
Orange = [0.85 0.33 0.10];
Yellow = [0.93 0.69 0.13];
nMUs = sum(responsiveMU);
%% Overview of Nr responsive MUs
T = table(ID', day', phase', MU', responsiveMU', 'VariableNames', {'ID', 'day', 'phase','MU', 'responsiveMU' })
T = T(phase == '2',:);
    groupsummary(T, {'ID'}, 'nnz', 'responsiveMU')
    groupsummary(T, {'day', 'phase'}, 'nnz', {'responsiveMU'})
    groupsummary(T, {'day','ID'}, 'nnz', 'responsiveMU')

%% Repeated measures ANOVA
% To perform repeated measures with both stim and condition as a within
% subject factor. 
selection = responsiveMU & phase == '1';% & ismember(day, {'D10','D15','D20'});
DATA    = array2table([meanSEQ(selection,2:4), meanRAN(selection,2:4),meanCON(selection,2:4)], ...
    'VariableNames', {'S2','S3','S4','R2','R3','R4','C2','C3','C4'});
animal  = ID(selection);
MUs     = categorical(MU(selection));
D       = day(selection);
DATA    = addvars(DATA, animal', MUs', D', 'NewVariableNames', {'ID','MU', 'day'}); 
within = table({'S' 'S' 'S' 'R' 'R' 'R' 'C' 'C' 'C'}', { '2' '3' '4' '2' '3' '4' '2' '3' '4'}','VariableNames',{'condition','stimuli'});
%%
rm = fitrm( DATA , 'S2-C4 ~ 1', 'WithinDesign', within,'WithinModel','condition*stimuli');
    mauchly(rm) % spericity assumption is violated -> use corrected pval
result = ranova(rm, 'WithinModel','condition*stimuli')

%% multiple comparison
    multcompare(rm, 'condition'); % no effect of RAN vs SEQ?
    multcompare(rm, 'stimuli');
    multcompare(rm, 'condition', 'By', 'stimuli');
    subplot(1,2,1)
    plotprofile(rm, 'condition', 'Group','stimuli');
    subplot(1,2,2)
    plotprofile(rm, 'stimuli', 'Group','condition');
%% pairwise analysis
selection = responsiveMU & phase == '2' ;% & day == 'D20';
p(1) = signrank( reshape(meanSEQ(selection,2:4),[], 1 ), reshape(meanRAN(selection,2:4), [], 1) );
p(2) = signrank( reshape(meanSEQ(selection,2:4),[], 1 ), reshape(meanCON(selection,2:4), [], 1) );
p(3) = signrank( reshape(meanCON(selection,2:4),[], 1 ), reshape(meanRAN(selection,2:4), [], 1) );
p
%% Power?
mu0     = mean( reshape(meanSEQ(responsiveMU,2:4), [], 1) );
sigma0  = std( reshape(meanSEQ(responsiveMU,2:4), [], 1) );
p1      = mean( reshape(meanRAN(responsiveMU,2:4), [], 1) );
sampsizepwr('t2', [mu0,sigma0], p1, [], nMUs ) %   0.21704
%% Is there an effect of day on the outcome per stimulus?
[d1,p1] = manova1(meanSEQ, day,0.01)
% manovacluster(stats)
[d2,p2] = manova1(meanRAN, day,0.01)
[d3,p3] = manova1(meanCON, day,0.01)
%% 2way ANOVA for responsive MUs
DATA = [meanSEQ(responsiveMU,:); meanRAN(responsiveMU,:);meanCON(responsiveMU,:)];
[~,AOV,stats] = anova2(DATA, nMUs, 'off' );
    % Effect of stimulus and group, but no interaction
    disp(AOV)
figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
c1 = multcompare(stats, 'Display', 'on', 'Estimate', 'row');
    % Significant effect between SEQ & CON
figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
c2 = multcompare(stats, 'Display', 'on', 'Estimate', 'column');
    % stim2 is significantly larger than stim4
    % Off is significantly different from stimili

%% Random mixed effects model

responses   = reshape(DATA, [],1);
conditions  = repmat(condition, 5,1);
MU          = repmat(MUs, 5,1)  ;
stim        = categorical( cellstr( [ repmat('stim1', 3*nMUs,1); repmat('stim2', 3*nMUs,1); ...
    repmat('stim3', 3*nMUs,1); repmat('stim4', 3*nMUs,1); repmat(' OFF ', 3*nMUs,1) ] )) ;

Tbl = table(responses, conditions, stim, MU);
% lme = fitlme(Tbl, 'responses ~ conditions*stim + (conditions*stim|MU) ');
% anova(lme)

% lm = fitlm(Tbl, 'responses ~ -1 + condition*stim*MU' )

%% Power analysis
pwrStim = powerAOVII(AOV{2,5},AOV{2,3},stats.df,0.05) % F , df, error Df, alpha
pwrCond = powerAOVII(AOV{3,5},AOV{3,3},stats.df,0.05)
pwrInt = powerAOVII(AOV{4,5},AOV{4,3},stats.df,0.05)

for i = 1:4
    pwrCON(i) =  sampsizepwr('z', [mean(meanRAN(:,i)) std(meanRAN(:,i))], mean(meanCON(:,i)), [],82);
    pwrSEQ(i) =  sampsizepwr('z', [mean(meanRAN(:,i)) std(meanRAN(:,i))], mean(meanSEQ(:,i)), [],82);
    nSEQ(i) =  sampsizepwr('z', [mean(meanRAN(:,i)) std(meanRAN(:,i))], mean(meanSEQ(:,i)), 0.8);
end
disp('Power analysis (per stim) for comparison between:')
disp('- Random & control stimulus set: ')
    disp(pwrCON)
disp('- Random sequence & sequence stimulus set: ')
    disp(pwrSEQ)
disp('- required n for comparing random to sequence with 80% power: ')
    disp(nSEQ)