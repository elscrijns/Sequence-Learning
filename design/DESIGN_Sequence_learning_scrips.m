%% PVTimerFcn
% line 82
           
%       elseif ismember(expType,[26 40]) % second order edge experiment                
                if handles.trialNr==1 % create order on first trial
                    trialOrder=[];
                    nStimuli= handles.nCond; %18
                    for iBlock=1:handles.nBlocks
                        startNum=(iBlock-1)*nStimuli+1;
                        endNum=iBlock*nStimuli;
                        trialOrder=cat(1,trialOrder,Shuffle(startNum:endNum)');
                    end
                    %handles.trialOrder=repmat(trialOrder,4,1);
                    handles.trialOrder = trialOrder ;
                    disp('Trial order created')
                end
                if handles.trialNr<=length(handles.trialOrder)
                    condition=handles.trialOrder(handles.trialNr);
                else
                    stop(object)
                    disp('Experiment finished...')
                end
                
                

 %% create SP_sequenceLearning(condN, sequence, random, sframes, itiframes)
 % elseif exptype == 40
 command=['SP_sequenceLearning(' num2str(condition) ', [' num2str(handles.sequence) '] , [' ...
            num2str(handles.random) '] , ' num2str(handles.sframes) ',' num2str(handles.itiframes) ')'];
    disp([padZeros(handles.trialNr) ') Condition ' num2str(condition) ' : ' command])
    fprintf(handles.s1,command)
    
%% PVloadStimuli
if expType == 40
    handles.itiDuration     = 1.5 ;     % in seconds
    handles.stimDuration    = 0.3 ;     % in seconds
       
    % change for each rat
    handles.sequence        = [1,2,3,4] ;
    handles.random          = [5,6,7,8] ;
    handles.animalID        = '123' ;
    handles.date            = '18_07_15'; % YY MM DD
    
    handles.conditions      = 1:48 ;    % 24*sequence + 24 random permutations
    handles.nCond           = length(handles.conditions);
    handles.nBlocks         = 100 ;     % amount of repeats per stimulus
    %handles.stimulusConditionVector=1:length(handles.stims);

    imDir                   = 'passiveViewing\stimuli\images\SequenceLearning\';    
    stimCreationMethod      = 4; % load predefined stim
    files                   = scandir(['C:\Ben\' imDir],'tif');
    SP_struct.imDir         = imDir;
    SP_struct.stimNames     = files;
    gamma = 1.0;
        
    PVupdate_expParameters('subDir',imDir,'stimCreationMethod',stimCreationMethod,'SP_struct',SP_struct,'gammaVal',gamma)
