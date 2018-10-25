%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Last modified on October 20th by Els.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psths      = [];
conditions = [];
expType    = [];
BL         = [];
spikeTimings = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%s%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create PSTH per condition
BL = mean(mean(psths(:,1:onsetIndex))); %200 ms
y(1,:) = mean(psths(expType == 46, :)) - BL;
y(2,:) = mean(psths(expType == 47, :)) - BL;
y(3,:) = mean(psths(expType == 48, :)) - BL;

figure('Units', 'centimeters' , 'OuterPosition', [0 0 16 18])
for i = 1:3  
    hAx(i) = subplot(3,1,i);
    hold on, box off,
    
    plot(y(i,1:end-1));
 
    % Normalizing the firing rate by calculating the mean of each bin
    % equivalent to dividing each bin by amount of trials
    xlim([1 size(psths, 2)]);
        lim(i,:) = [ min(min(y)) , max(max(y)) ] ; 
        % indicate mean per stimulus
        stim1 = mean(y(i,17:27));
        stim2 = mean(y(i,32:42));
        stim3 = mean(y(i,47:57));
        stim4 = mean(y(i,62:72));
        plot([17 27], [stim1 stim1], '-');
            p1 = ttest2(y(i,17:27),y(i,1:15));
            if p1 == 1
                text(27, stim4+20, '*', 'Fontsize', 20)
            end
        plot([32 42], [stim2 stim2], '-');
            p2 = ttest2(y(i,32:42),y(i,1:15));
            if p2 == 1
                text(42, stim2+20, '*', 'Fontsize', 20)
            end
        plot([47 57], [stim3 stim3], '-');
            p3 = ttest2(y(i,47:57),y(i,1:15));
            if p3 == 1
                text(57, stim3+20 , '*', 'Fontsize', 20)
            end
        plot([62 72], [stim4 stim4], '-');
            p4 = ttest2(y(i,62:72),y(i,1:15));
            if p4 == 1
                text(72, stim4+20, '*', 'Fontsize', 20)
            end
        
        % Figure annotation
        plot([1 120], [0 0], '-k');
        plot([onsetIndex onsetIndex],  [-500 1000],  ':r')
        plot([off off],  [-500 1000],  ':r')
        set(gca, 'XTick',      [1 15 30 45 60 75 90] );
        set(gca, 'XTickLabel', [-before 0 150 300 450 600 after]);
        xlabel('time, msec'), ylabel('spikes/sec');
    
        if i == 1
            title('Sequence')
        elseif i==2
            title('Random')
        else
            title('Control')
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear stim* p
   
end
 ylim(hAx,[min(lim(:,1))-50 , max(lim(:,2))+100 ]);
clear BL lim psths i onsetIndex edges p*
clear binWidth uniqueConditions conditions spikeTimings nConditions