%% Matab 2018 Markov Chain rule
P = ones(8)/8;
P(1:2, :) = 1/6;
P(1:2,1:2) = 0;

mc = dtmc(P);
graphplot(mc, 'ColorNodes', true)

X = simulate(mc,8*60);
simplot(mc,X)
simplot(mc,X,'FrameRate',1,'Type','graph')

simplot(mc,X,'Type','transitions');

%% Matlab 2009 Hidden Markov Models
P = [0.65 0.35 ; 1 0 ]; % different transition states: 1 is permutation, 2 is control.
E = [1 0 0; 0 1/2 1/2 ]; % possible outcomes: 1 is control condition, 2 and 3 are possible permutations
[seq,states] = hmmgenerate(10000,P,E);
sum(seq==1)
%[seq,states] = hmmgenerate(10,P,[1;1;1;1;1;1;1;1])

%% Alias method
    n = 100
    x = rand(n,1);
    
for i = 1:n
    if x(i)>0.25
        con(i) = 1
    else 
        con(i) = 2
    end
end
%% manual permutations
nBlocks = 10;
conditions = [];
k = 1;

while k < nBlocks
    x = randperm(8) % 8 conditions, 1&2 are permutations, 3:8 are control sequence
    loc = find(x<3)
    if k>1 && x(1)<3 && conditions(end)<3
        continue;
    elseif diff(loc) > 1
        conditions = [conditions, x];
        k = k+1
    end
end
conditions