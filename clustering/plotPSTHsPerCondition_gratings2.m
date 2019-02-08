%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Last modified on February 4th 2019 by Els.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psths      = [];
conditions = [];
expType    = [];
BL         = [];
spikeTimings = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%s%%%%%%%%%%%%%%%%%%%%%%%%

binWidth	= 10;                       % msec.
stimDur     = 150;
after       = stimDur + 50;
% edges       = -before:binWidth:after; % msec.
onsetIndex  = 6 ;                       % 50 ms
off         = onsetIndex + stimDur/binWidth; % 

for i = 1:length(trial)
    spikeTimings    = (trial(i).spikes - trial(i).onset) / 10.0^3 ; % msec.
    photoEvents     = (trial(i).photoevents - trial(i).onset) / 10.0^3 ;
    for j = 1:length(trial(i).photoevents)-1
        before      = photoEvents(j) - 50 ;
        edges       = before:binWidth:(photoEvents(j)+after);
        psths(end + 1, :)   = 10.0 ^ 3 / binWidth * histc(spikeTimings, edges); % Hz. (spikes per sec) 
        expType(end + 1, 1)    = trial(i).expType;
%         trial(i).psth       = psths(i, :);
%         trial(i).duration   = diff(trial.photoevents);
    end
    % each row will contain the bin counts per trial
    % the counts are converted to firig rate by 10^3/bninwidts
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create PSTH per condition
BL = mean(mean(psths(:,1:onsetIndex))); %50 ms
y(1,:) = mean(psths(expType == 53, 1:end-1)) - BL; % random
y(2,:) = mean(psths(expType == 52, 1:end-1)) - BL; % small 10°
y(3,:) = mean(psths(expType == 54, 1:end-1)) - BL; % large 30°

COL   = [0.00 0.45 0.74; 0.85 0.33 0.10; 0.93 0.69 0.13];

% plot PSTHs for each expType
plot(y');
    hold on, box off
    xlim([1 size(psths, 2)]);
    lim = [ min(min(y)) , max(max(y)) ] ; 
        % indicate mean per stimulus
Average = mean(y(:,8:18)');
    plot([8 18], [Average(1) Average(1)], '-', 'Color', COL(1,:));
    plot([8 18], [Average(2) Average(2)], '-', 'Color', COL(2,:));
    plot([8 18], [Average(3) Average(3)], '-', 'Color', COL(3,:));
        
        % Figure annotation
        plot([1 25], [0 0], '-k');
        plot([onsetIndex onsetIndex],  [-500 1000],  ':r')
        plot([off off],  [-500 1000],  ':r')
        set(gca, 'XTick',      [0:5:25]+1 );
        set(gca, 'XTickLabel', [-50 0 50 100 150 200]);
        xlabel('time, msec'), ylabel('spikes/sec');
          
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear stim* p
   
 ylim([min(lim(:,1))*1.1 , max(lim(:,2))*1.1 ]);
 legend('random','small','large')
 legend boxoff
clear lim i onsetIndex edges p1 p2 p3 p4 hAx off 
clear binWidth uniqueConditions spikeTimings nConditions