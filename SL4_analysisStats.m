%% Prepare data table for ANOVA/mixed effects
DATA = [meanSEQ(responsiveMU,:); meanRAN(responsiveMU,:);meanCON(responsiveMU,:)];
responses = reshape(DATA, [],1);
    % Each column represents 1 stimulus of the set, Each row is 1 MU that has shown a
    % significant response to the first stimulus (ttest)
groups  = categorical(cellstr([repmat('SEQ', nMUs,1); repmat('RAN', nMUs,1);repmat('CON', nMUs,1)]));
stim    = categorical( cellstr( [ repmat('stim1', 3*nMUs,1); repmat('stim2', 3*nMUs,1); ...
    repmat('stim3', 3*nMUs,1); repmat('stim4', 3*nMUs,1) ] )) ;
MU      = repmat(MUidx.MU(responsiveMU) , 3*4,1);

%% 2way ANOVA for responsive MUs

[~,AOV,stats] = anova2(DATA, nMUs, 'off' );
    % Effect of stimulus, but not of group, also no interaction
    disp(AOV)
figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
c1 = multcompare(stats, 'Display', 'on', 'Estimate', 'row');
figure('Units', 'centimeters', 'InnerPosition', [-30,10,10,6]);
c2 = multcompare(stats, 'Display', 'on', 'Estimate', 'column');
    % stim1 is significantly larger than stim2-4
    
%% Repeated measure ANOVA across days

%% Random mixed effects model
groups = repmat(groups,4,1);
Tbl = table(groups, stim, responses, MU);

lme = fitlme(Tbl, 'responses ~ -1 + groups*stim + (-1 + groups*stim|MU) ');
anova(lme)

% lm = fitlm(Tbl, 'responses ~ -1 + groups*stim*MU' )

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