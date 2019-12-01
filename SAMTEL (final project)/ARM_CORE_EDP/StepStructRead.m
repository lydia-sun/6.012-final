function [stepStruct,headerLine] = StepStructRead(fName,varargin)
% function [stepStruct,headerLine] = StepStructRead(fName,varargin)
%
% convertEnv = getarg(varargin,'convertEnv',true); % convert environment variables

%%
if nargin < 1
%%
fName = 'InverterScriptTest.csv';
%%
end

%%
convertEnv = getarg(varargin,'convertEnv',true); % convert environment variables
headerExists = getarg(varargin,'headerExists',true);
loadmat = getarg(varargin,'loadmat',false);

%%
fName_loadmat = [fName,'.mat'];
if loadmat
    if exist(fName_loadmat,'file')
        d_tmp = load(fName_loadmat);
        stepStruct = d_tmp.stepStruct;
        headerLine = d_tmp.headerLine;
        return;
    end
end

%%
% fName
% unix(sprintf('cat %s',fName))
fid = fopen(fName,'r');
if headerExists
    headerLine = fgetl(fid);
else
    headerLine = [];
end
colHeaderLine = fgetl(fid);

%colHeaders = regexp(colHeaderLine,',','split');
%colHeaders = regexp(strtrim(colHeaderLine),',\s*','split');
colHeaders = regexp(strtrim(colHeaderLine),'\s*,\s*','split');
dummy = cell(size(colHeaders));
dummy2 = [colHeaders;dummy];

stepStruct1 = struct(dummy2{:});

stepStructAll = [];

nFields = length(colHeaders);

nSteps = 0;

% ptr = 0;

while 1
tline = fgetl(fid);
if ~ischar(tline)
    break;
end
%v = regexp(tline,',','split');
v = regexp(strtrim(tline),'\s*,\s*','split');


nSteps = nSteps + 1;



stepStructTmp = stepStruct1;
for i=1:nFields
    
    if 0
    valTmp = str2double(v{i});
    if isnan(valTmp)
        if convertEnv && any(v{i} == '$')
            pat = '(.*)\$([\d\w]+)(.*)';
            t = regexp(v{i},pat,'tokens');
            valTmp = [t{1}{1},getenv(t{1}{2}),t{1}{3}];
        else
            valTmp = v{i};
        end
    end
    
    else
        valTmp = str2num(v{i});
        if isempty(valTmp)
            if convertEnv && any(v{i} == '$')
                pat = '(.*)\$([\d\w]+)(.*)';
                t = regexp(v{i},pat,'tokens');
                valTmp = [t{1}{1},getenv(t{1}{2}),t{1}{3}];
            else
                valTmp = v{i};
            end
        end
    end
    stepStructTmp.(colHeaders{i}) = valTmp;
end

if nSteps == 1
    stepStructAll = stepStructTmp;
else
    
    if ~mod(nSteps,100)
        fprintf('step %d\n',nSteps)
    end
    
    if length(stepStructAll) < nSteps
        % double allocated space
        stepStructAll = [stepStructAll ; stepStructAll];
    end
    
    
    
    %disp(tline);
    
    %stepStructAll = [stepStructAll; stepStructTmp];
    stepStructAll(nSteps) = stepStructTmp;
    
end

end

stepStructAll = stepStructAll(1:nSteps);

fclose(fid);
    
stepStruct = stepStructAll;

%%
if loadmat
    myVars = {;
        'stepStruct';
        'headerLine';
        };
   save(fName_loadmat,myVars{:}); 
end
% stepStructAll.VDD
% stepStructAll.VBMin

%%
% data = importdata(fName);%,',',1);
% 
% M = importdata(fName,',',1)