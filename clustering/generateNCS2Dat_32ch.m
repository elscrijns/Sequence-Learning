% Select 1 or multiple *.ncs files to combine into one *.dat file. One file
% is created for each recording session and per cluster of channels in case
% of a multichannel electrode
% The signal, timeStamps, samplingFreq and headers are exported to the .dat file

function [Directory] = generateNCS2Dat_32ch;
    
    % Combines all the CSC 
    signal       = [];              % AD units.
    timeStamps   = [];              % usec.
    samplingFreq = [];              % Hz.
    headers      = {};

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Directory = uigetdir('E:\');
%    FileNames = {"csc1.ncs" "csc2.ncs" "csc3.ncs" "csc4.ncs" "csc5.ncs" ...
%       "csc6.ncs" "csc7.ncs" "csc8.ncs" "csc9.ncs" "csc10.ncs" "csc11.ncs" ...
%       "csc12.ncs" "csc13.ncs" "csc14.ncs" "csc15.ncs" "csc16.ncs" "csc17.ncs" ...
%       "csc18.ncs" "csc19.ncs" "csc20.ncs" "csc21.ncs" "csc22.ncs""csc23.ncs" ...
%       "csc24.ncs" "csc25.ncs" "csc26.ncs" "csc27.ncs" "csc28.ncs" "csc29.ncs" ...
%       "csc30.ncs" "csc31.ncs" "csc32.ncs" }
%    FileNames = {FileNames.name};
    [FileNames, Directory] = uigetfile('*.ncs', 'Select file(s) with continuously sampled signal (*.ncs)','E:\csc*' , 'MultiSelect', 'on');
    if isnumeric(FileNames)
        disp('No file with continuously sampled signal has been selected!');
        return;     
    end
%    [destFileName, destDirectory] = uiputfile('*.dat', 'Save your data', [srcDirectory '\chunk']);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ischar(FileNames)         % Single file selected.
        FileNames = {FileNames};
    end

    for counter = 1:length(FileNames)
        disp(fullfile(Directory , FileNames{counter}));
        [signal(end+1, :), timeStamps(end+1, :), samplingFreq(end+1), headers{end+1}] = processEachChannel(fullfile(Directory, FileNames{counter}));
        if size(timeStamps, 1) > 1 && any(max(timeStamps) - min(timeStamps))
           disp('Time stamps vary across different channels of the same recordings session!');
           % return;
        end
           timeStamps = timeStamps(1,:);
    end
    
    clear counter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    signal = signal(:,  1:end-512);

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
    
    clear minSignalValue maxSignalValue
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dt = timeStamps(2:end) - timeStamps(1:end - 1);    
    disp(['Min(dt)     = ' num2str(min(dt)) ' usec']);
    disp(['Mean(dt)    = ' num2str(mean(dt)) ' usec']);
    disp(['Median(dt)  = ' num2str(median(dt)) ' usec']);
    disp(['Max(dt)     = ' num2str(max(dt)) ' usec']);
    disp(['Desired(dt) = ' num2str(10.0 ^ 6 / samplingFreq) ' usec']);
    if max(dt) > 35
        n =find(dt == max(dt))
%         n =find(dt == min(dt));
%         l = length(dt)
%         l-n;
        dt(n) = [];
        timeStamps(n) = [];
    end

clear dt n l
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
destFileName = fullfile(Directory, 'chunk.dat');
    fid = fopen(destFileName, 'w');
    fwrite(fid, signal, 'int16');
    fclose(fid);
    save([destFileName '.mat'], 'timeStamps', 'samplingFreq', 'headers', 'FileNames', 'Directory');
        
    
 clear fid
 end

