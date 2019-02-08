%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adjusted from retrieveBehavioralData.m by Dzmitry Kaliukhovic ( from Github)
% Source: https://github.com/departutto/laminar/tree/master/position-clutter-tolerance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [trial, time0] = extractBehaviouralData_SL(filename)
% 
% if ~filename
%     return;
% else
%     fprintf('Events file: %s%s\n', filename);
% end

[timeStamps, ttls] = Nlx2MatEV([filename], [1 0 1 0 0], 0, 1, 1);
time0              = 0; % timeStamps(1);
timeStamps         = (timeStamps - time0) / 10 ^ 6; % sec
photoCellEvents    = bitand(ttls, 3);
events             = bitshift(ttls, -2);
consolidated       = [timeStamps' events' photoCellEvents'];

clear timeStamps ttls photoCellEvents events;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find indices of the events corresponding to the beginning of trials.
headerStart = find(consolidated(:, 2) == 254);

% All must be 0.
if any(consolidated(headerStart + 1, 2)) || ...
   any(consolidated(headerStart + 3, 2)) || ...
   any(consolidated(headerStart + 5, 2)) 
    error('Corrupted header structure (1)!');
end

% Extract header ends.
headerEnds = unique(consolidated(headerStart + 6, 2));
if length(headerEnds) > 1 || headerEnds ~= 253
    error('Corrupted header structure (1)!');
end

% Extract the experiment type.
experimentType = unique(consolidated(headerStart + 2, 2));
if length(experimentType) > 3
    error('Multiple experiment identifiers!');
end
fprintf('Experiment type: %d\n', experimentType);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trial = struct([]);

for i = 1:length(headerStart)
    if i == length(headerStart) % photocell (3rd column in consolidated) must be 0.
            lastPhotocell  = size(consolidated, 1) - 1;
    else
            lastPhotocell  = headerStart(i + 1) - 2;
    end
    trial(i).expType   = consolidated(headerStart(i) + 2, 2);
    trial(i).onset     = consolidated(headerStart(i) + 8, 1);    
    trial(i).offset    = consolidated(lastPhotocell, 1) ;     
end

fprintf('Total number of detected blocks: %d\n', length(headerStart));
clear i experimentType conditions;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Detect photocells per trial.
firstIndex    = headerStart + 8;
lastIndex     = [headerStart(2:end) - 1; size(consolidated, 1)];

for i = 1:length(headerStart)
    photoEvents = consolidated(firstIndex(i):lastIndex(i), 1);
    if length(photoEvents) < 1
        error('No photoevents!');
    end
    
    trial(i).photoevents = photoEvents(1);
    for j = 2:length(photoEvents)
        range = photoEvents(j) - trial(i).photoevents(end);
        if range < 0.3 && range > 0.1
            trial(i).photoevents(end + 1) = photoEvents(j);
        end
    end
    clear photoEvents;
end

clear i j timeThreshold firstIndex lastIndex consolidated;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    for i = 1:length(trial)
        duration = [];
        duration = diff(trial(i).photoevents);
        statistics = [min(duration) mean(duration) median(duration) std(duration) max(duration)];
        fprintf('Stimulus offset - Stimulus onset (desired 150 msec):\n');    
        fprintf('Min - Mean - Median - Std - Max: %.4f - %.4f - %.4f - %.4f - %.4f\n', statistics);
    end
       
    delay = [];
    for i = 1:length(trial)
        delay(end + 1) = trial(i).photoevents(1) - trial(i).onset;
    end
    statistics = [min(delay) mean(delay) median(delay) std(delay) max(delay)];
    fprintf('Delay = Stimulus onset - Trial onset:\n');
    fprintf('Min: %.4f - Mean:  %.4f - Median:  %.4f - Std: %.4f - Max: %.4f \n', statistics);

clear statistics i j

clear trialStart duration delay;
