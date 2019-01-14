% Select 1 or multiple *.ncs files to combine into one *.dat file. One file
% is created for each recording session and per cluster of channels in case
% of a multichannel electrode
% The signal, timeStamps, samplingFreq and headers are exported to the .dat file

 function [destDirectory] = generateNCS2Dat;
    
    % Combines all the CSC 
    signal       = [];              % AD units.
    timeStamps   = [];              % usec.
    samplingFreq = [];              % Hz.
    headers      = {};

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   
   [srcFileNames, srcDirectory] = uigetfile('*.ncs', 'Select file(s) with continuously sampled signal (*.ncs)','E:\' , 'MultiSelect', 'on');
    if isnumeric(srcFileNames)
        disp('No file with continuously sampled signal has been selected!');
        return;     
    end
    
    [destFileName, destDirectory] = uiputfile('*.dat', 'Save your data', [srcDirectory '\chunk']);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ischar(srcFileNames)         % Single file selected.
        srcFileNames = {srcFileNames};
    end

    for counter = 1:length(srcFileNames)
        disp([srcDirectory srcFileNames{counter}]);
        [signal(end + 1, :), timeStamps(end + 1, :), samplingFreq(end + 1), headers{end + 1}] = processEachChannel([srcDirectory srcFileNames{counter}]);
        if size(timeStamps, 1) > 1 && any(max(timeStamps) - min(timeStamps))
            disp('Time stamps vary across different channels of the same recordings session!');
            % return;
        end
        timeStamps = timeStamps(1,:);
    end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    samplingFreq = unique(samplingFreq);
    if length(samplingFreq) ~= 1
        disp('Sampling frequency varies across different channels of the same recordings session!');
        return;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    disp(['Signal duration (given a sampling frequency of 32556 Hz) = ' num2str(size(signal, 2) / 32556) ' sec']);
    
    minSignalValue = min(min(signal));
    maxSignalValue = max(max(signal));
    
    if minSignalValue < -32768 || maxSignalValue > 32767
        disp('The data type int16 cannot properly represent the retrieved signal(s)!');
        return;
    else
        disp(['Min(signal) = ' num2str(minSignalValue) ' AD units (>= -32768)']);
        disp(['Max(signal) = ' num2str(maxSignalValue) ' AD units (<= 32767)']);
    end
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dt = timeStamps(2:end) - timeStamps(1:end - 1);    
    disp(['Min(dt)     = ' num2str(min(dt)) ' usec']);
    disp(['Mean(dt)    = ' num2str(mean(dt)) ' usec']);
    disp(['Median(dt)  = ' num2str(median(dt)) ' usec']);
    disp(['Max(dt)     = ' num2str(max(dt)) ' usec']);
    disp(['Desired(dt) = ' num2str(10.0 ^ 6 / samplingFreq) ' usec']);
    if max(dt) > 35
        n =find(dt == max(dt));
        n =find(dt == min(dt));
        l = length(dt)
        l-n;
        %dt(n) = [];
        %timeStamps(n) = [];
    end
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isnumeric(destFileName)
        fid = fopen([destDirectory destFileName], 'w');
        fwrite(fid, signal, 'int16');
        fclose(fid);
        save([destDirectory destFileName '.mat'], 'timeStamps', 'samplingFreq', 'headers', 'srcFileNames', 'srcDirectory');
    end    
    
 end

