%% Data analysis
clear all
load('DATA\SequenceLearningData.mat')
Blue   = [0.00 0.45 0.74];
Orange = [0.85 0.33 0.10];
Yellow = [0.93 0.69 0.13];
nMUs = sum(responsiveMU);
DATA = [meanSEQ(responsiveMU,:); meanRAN(responsiveMU,:);meanCON(responsiveMU,:)];

%% 2way ANOVA for responsive MUs

[~,AOV,stats] = anova2(DATA, nMUs, 'off' );
    % Effect of stimulus, but not of group, also no interaction
    disp(AOV)
figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
c1 = multcompare(stats, 'Display', 'on', 'Estimate', 'row');
figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
c2 = multcompare(stats, 'Display', 'on', 'Estimate', 'column');
    % stim1 is significantly larger than stim2-4
    
%% Prepare data table for rm/mixed effects
DATA = array2table(DATA, 'VariableNames', {'stim1','stim2','stim3','stim4'});
% responses = reshape(DATA, [],1); 
    % Each column represents 1 stimulus of the set, Each row is 1 MU that has shown a
    % significant response to the first stimulus (ttest)
condition  = categorical(cellstr([repmat('SEQ', nMUs,1); repmat('RAN', nMUs,1);repmat('CON', nMUs,1)]));
animal     = repmat(ID(responsiveMU), 1, 3)';
MUs        = categorical(repmat(MU(responsiveMU), 1, 3))';
D          = repmat(day(responsiveMU), 1, 3)';


% To perform repeated measures with both stim and condition as a within
% subject factor. Does not work for rm model
% DATA    = array2table([meanSEQ(responsiveMU,2:end), meanRAN(responsiveMU,2:end),meanCON(responsiveMU,2:end)], ...
%     'VariableNames', {'stim2','stim3','stim4','stim2','stim3', ...
%     'stim4','stim2','stim3','stim4'});
% animal  = ID(responsiveMU);
% MUs     = categorical(MU(responsiveMU));
% within = table(['S' 'S' 'S' 'R' 'R' 'R' 'C' 'C' 'C']', [ 2 3 4 2 3 4 2 3 4]','VariableNames',{'condition','stimuli'});

Tbl = addvars(DATA, animal, MUs, condition, D, 'NewVariableNames', {'animal', 'MU', 'condition', 'day'});
stim = table([2 3 4 ]','VariableNames',{'stimuli'});%% Repeated measure ANOVA across days
rm = fitrm( Tbl , 'stim2-stim4 ~ day + condition', 'WithinDesign', stim)
    mauchly(rm) % spericity assumption is rejected -> use corrected pval
    ranova(rm)
    rm.Coefficients
    manova(rm)
%% Random mixed effects model
responses   = reshape(DATA, [],1); 
conditions  =   ;
MU          =   ;
stim        = categorical( cellstr( [ repmat('stim1', 3*nMUs,1); repmat('stim2', 3*nMUs,1); ...
    repmat('stim3', 3*nMUs,1); repmat('stim4', 3*nMUs,1) ] )) ;

Tbl = table(responses, conditions, stim, MU);
lme = fitlme(Tbl, 'responses ~ condition*stim + (condition*stim|MU) ');
anova(lme)

% lm = fitlm(Tbl, 'responses ~ -1 + condition*stim*MU' )

%% Power analysis
pwrCol = powerAOVII(AOV{2,5},AOV{2,3},stats.df,0.05)
pwrRow = powerAOVII(AOV{3,5},AOV{3,3},stats.df,0.05)
pwrInt = powerAOVII(AOV{4,5},AOV{4,3},stats.df,0.05)

for i = 1:4
    pwrCON(i) =  sampsizepwr('z', [mean(meanRAN(:,i)) std(meanRAN(:,i))], mean(meanCON(:,i)), [],82);
    pwrSEQ(i) =  sampsizepwr('z', [mean(meanRAN(:,i)) std(meanRAN(:,i))], mean(meanSEQ(:,i)), [],82);
    nSEQ(i) =  sampsizepwr('z', [mean(meanRAN(:,i)) std(meanRAN(:,i))], mean(meanSEQ(:,i)), 0.8);
end
disp('Power analysis for comparison between:')
disp('-Random & control stimulus set: ')
    pwrCON
disp('-Random sequence & sequence stimulus set: ')
    pwrSEQ
disp('-required n for comparing random to sequence with 80% power: ')
    nSEQ