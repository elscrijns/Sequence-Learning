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

for f = 1:length(trial)
    spikeTimings             = (trial(f).spikes - trial(f).onset) / 10.0 ^ 3; % msec.
    psths(end + 1, :)        = 10.0 ^ 3 / binWidth * histc(spikeTimings, edges); % Hz. (spikes per sec) 
    % each row will contain the bin counts per trial
    % the counts are converted to firig rate by 10^3/bninwidts
    conditions(end + 1) = trial(f).condition;
    expType(end + 1) = trial(f).expType;
    trial(f).psth = psths(f, :);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create PSTH per condition
BL = mean(mean(psths(:,1:onsetIndex))); %200 ms
y(1,:) = mean(psths(expType == 46, :)) - BL;
y(2,:) = mean(psths(expType == 47, :)) - BL;
y(3,:) = mean(psths(expType == 48, :)) - BL;

figure('Units', 'centimeters' , 'OuterPosition', [0 0 16 18])
for f = 1:3  
    hAx(f) = subplot(3,1,f);
    hold on, box off,
    
    plot(y(f,1:end-1));
 
    % Normalizing the firing rate by calculating the mean of each bin
    % equivalent to dividing each bin by amount of trials
    xlim([1 size(psths, 2)]);
        lim(f,:) = [ min(min(y)) , max(max(y)) ] ; 
        % indicate mean per stimulus
        stim1 = mean(y(f,17:26));
        stim2 = mean(y(f,34:43));
        stim3 = mean(y(f,49:58));
        stim4 = mean(y(f,64:73));
        plot([17 26], [stim1 stim1], '-');
            p1 = ttest2(y(f,19:26),y(f,1:15));
            if p1 == 1
                text(26, stim4+20, '*', 'Fontsize', 20)
            end
        plot([34 43], [stim2 stim2], '-');
            p2 = ttest2(y(f,34:41),y(f,1:15));
            if p2 == 1
                text(41, stim2+20, '*', 'Fontsize', 20)
            end
        plot([49 58], [stim3 stim3], '-');
            p3 = ttest2(y(f,49:56),y(f,1:15));
            if p3 == 1
                text(56, stim3+20 , '*', 'Fontsize', 20)
            end
        plot([64 73], [stim4 stim4], '-');
            p4 = ttest2(y(f,64:71),y(f,1:15));
            if p4 == 1
                text(71, stim4+20, '*', 'Fontsize', 20)
            end
        
        % Figure annotation
        plot([1 120], [0 0], '-k');
        plot([onsetIndex onsetIndex],  [-500 1000],  ':r')
        plot([off off],  [-500 1000],  ':r')
        set(gca, 'XTick',      [1 15 30 45 60 75 90] );
        set(gca, 'XTickLabel', [-before 0 150 300 450 600 after]);
        xlabel('time, msec'), ylabel('spikes/sec');
    
        if f == 1
            title('Sequence')
        elseif f==2
            title('Random')
        else
            title('Control')
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear stim* p
   
end
 ylim(hAx,[min(lim(:,1))-10 , max(lim(:,2))+10 ]);
clear lim onsetIndex edges p1 p2 p3 p4 hAx off 
clear binWidth uniqueConditions spikeTimings nConditions