%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Created on January-8th by Els.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psths      = [];
conditions = [];
expType    = [];
BL         = [];
spikeTimings = [];

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%s%%%%%%%%%%%%%%%%%%%%%%%%

binWidth	= 10;                     % msec.
stimDur     = 150;
before      = 150;
after       = (4*150)+150;
edges       = -before:binWidth:after; % msec.
onsetIndex  = before  / binWidth ;
off         = onsetIndex + 4*stimDur/binWidth;

for i = 1:length(trial)
    spikeTimings             = (trial(i).spikes - trial(i).onset) / 10.0 ^ 3; % msec.
    psths(end + 1, :)        = 10.0 ^ 3 / binWidth * histc(spikeTimings, edges); % Hz. (spikes per sec) 
    % each row will contain the bin counts per trial
    % the counts are converted to firig rate by 10^3/bninwidts
    conditions(end + 1) = trial(i).condition;
    expType(end + 1) = trial(i).expType;
    trial(i).psth = psths(i, :);            
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load all stimulus presentation data
files = dir([currentSession '\permutations*']);
    % files are sorted by name not by order of recording
    filenames = split({files.name}, '_');
    filenames = squeeze(filenames);
    [~,idx] = sortrows(filenames, 4); % last column contains recording time in m:ss
    
    n = length(filenames);
        if n>4
            disp('There are more than 4 permutation tests')
            return;
        end
permutations = [];
permType = [];
for i = 1:n
    
    load(fullfile(currentSession, files(idx(i)).name) )
    disp(fullfile(currentSession, files(idx(i)).name) )
    permType(:,i) = repmat(perm, numel(permOrder),1);
    permutations(:,i) = reshape(permOrder', [] ,1);
    
end
permutations = reshape(permutations, 1, []);
permutations = permutations(1:end-1);
permType = reshape(permType, 1, []);
permType = permType(1:end-1);

%% sequence stimuli with blanc permutation
hAx(1) =  subplot(2,2,1);

title('Sequence stimuli with blanc permutation')
% create index for 
blanc1 = expType == 49 & permutations == 1 & permType == 0;
blanc2 = expType == 49 & permutations == 2 & permType == 0;
control = expType == 49 & permutations > 2 & permType == 0;

BL = mean(mean(psths(:,1:onsetIndex))); %150 ms
y(1,:) = mean(psths(blanc1, :)) - BL;
y(2,:) = mean(psths(blanc2, :)) - BL;
y(3,:) = mean(psths(control, :)) - BL;

permutationPlot(y, psths, before, after)

% ylim(hAx,[min(lim(:,1))-10 , max(lim(:,2))+10 ]);
%% sequence stimuli with deviant permutation
hAx(2) =  subplot(2,2,2);
hold on
title('Sequence stimuli with deviant permutation')
% create index for 
blanc1 = expType == 49 & permutations == 1 & permType == 13;
blanc2 = expType == 49 & permutations == 2 & permType == 13;
control = expType == 49 & permutations > 2 & permType == 13;

BL = mean(mean(psths(:,1:onsetIndex))); %150 ms
y(1,:) = mean(psths(blanc1, :)) - BL;
y(2,:) = mean(psths(blanc2, :)) - BL;
y(3,:) = mean(psths(control, :)) - BL;

permutationPlot(y, psths, before, after)
%% Random stimuli with blanc permutation
hAx(3) =  subplot(2,2,3);
title('Random stimuli with blanc permutation')
% create index for 
blanc1 = expType == 50 & permutations == 1 & permType == 0;
blanc2 = expType == 50 & permutations == 2 & permType == 0;
control = expType == 50 & permutations > 2 & permType == 0;

BL = mean(mean(psths(:,1:onsetIndex))); %150 ms
y(1,:) = mean(psths(blanc1, :)) - BL;
y(2,:) = mean(psths(blanc2, :)) - BL;
y(3,:) = mean(psths(control, :)) - BL;

permutationPlot(y, psths, before, after)
%% Random stimuli with deviant permutation
hAx(4) =  subplot(2,2,4);
title('Random stimuli with deviant permutation')
% create index for 
blanc1 = expType == 50 & permutations == 1 & permType == 13;
blanc2 = expType == 50 & permutations == 2 & permType == 13;
control = expType == 50 & permutations > 2 & permType == 13;

BL = mean(mean(psths(:,1:onsetIndex))); %150 ms
y(1,:) = mean(psths(blanc1, :)) - BL;
y(2,:) = mean(psths(blanc2, :)) - BL;
y(3,:) = mean(psths(control, :)) - BL;

permutationPlot(y, psths, before, after)
%%
function permutationPlot(y, psths, before, after)
    hold on, box off
    plot(y(:,1:end-1)');
 
    % Normalizing the firing rate by calculating the mean of each bin
    % equivalent to dividing each bin by amount of trials
    xlim([1 size(psths, 2)]);
%         lim(i,:) = [ min(min(y)) , max(max(y)) ] ; 
        % indicate mean per stimulus
        stim1 = mean(y(:,18:24),2);
        stim2 = mean(y(:,35:41),2);
        stim3 = mean(y(:,50:56),2);
        stim4 = mean(y(:,65:71),2);
        plot([18 24], [stim1 stim1], '-');
%             p1 = ttest2(y(i,18:24),y(i,1:15));
%             if p1 == 1
%                 text(27, stim4+5, '*', 'Fontsize', 20)
%             end
        plot([35 41], [stim2 stim2], '-');
%             p2 = ttest2(y(i,35:41),y(i,1:15));
%             if p2 == 1
%                 text(42, stim2+5, '*', 'Fontsize', 20)
%             end
        plot([50 56], [stim3 stim3], '-');
%             p3 = ttest2(y(i,50:56),y(i,1:15));
%             if p3 == 1
%                 text(57, stim3+5 , '*', 'Fontsize', 20)
%             end
        plot([65 71], [stim4 stim4], '-');
%             p4 = ttest2(y(i,65:71),y(i,1:15));
%             if p4 == 1
%                 text(72, stim4+5, '*', 'Fontsize', 20)
%             end
        
        % Figure annotation
        plot([1 120], [0 0], '-k');
%         plot([onsetIndex onsetIndex],  [-50 100],  ':r')
%         plot([off off],  [-50 100],  ':r')
        set(gca, 'XTick',      [1 15 30 45 60 75 90] );
        set(gca, 'XTickLabel', [-before 0 150 300 450 600 after]);
        xlabel('time, msec'), ylabel('spikes/sec');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear stim* p
   
end