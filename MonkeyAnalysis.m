   %% Significant MU response
% per MU a permutation test : Mean of each stim across presentations -> variance of the mean
% -> 1000 permutations of bin order within one presentation -> variance
% distribution

%% conditions analysis
% FR per stimulus, average across presentations
% FR in 20ms bins -> comparing 2 conditions
% 2-sided wilcoxon paired ranks test per bin
% FDR correction Benjamini & Hochberg 1995

% avoid selectivity bias
% on half the data select l-m-h FR stimuli, compare conditions per group
%% normalization: (FR-mean)/mean