function printTestOverview(varargin)
% printTestOverview - print information about the current state
%    of unit testing to the console
%
% Syntax:  
%    printTestOverview()
%    printTestOverview(format)
%
% Inputs:
%    format - (optional) results of which test suite should be displayed:
%               'short' (default), 'long', 'mp', 'mosek', 'sdpt3',
%               'intlab', 'nn'
%
% Outputs:
%    -
%
% Example: 
%    printTestOverview('long');

% Author:       Mark Wetzlinger
% Written:      22-January-2021
% Last update:  09-April-2023 (MW, remove 'classes', integrate other test suites)
% Last revision:---

%------------- BEGIN CODE --------------

% default format: last run
format = setDefaultValues({'short'},varargin);
% check if correct identifier provided
inputArgsCheck({{format,'str',{'short','long','intlab','mosek','mp','sdpt3','nn'}}});

% load data
unitTestsFile = [CORAROOT filesep 'unitTests' filesep 'unitTestsStatus.mat'];
if ~isfile(unitTestsFile)
    throw(CORAerror('CORA:specialError',...
        "No data provided. Run '''runTestSuite''' to acquire data."));
else
    % latest test results are stored in the variable 'testResults' in
    % unitTestsStatus.mat
    load(unitTestsFile,'testResults');
    % read out data from map
    if ~ismember(testResults.keys,format)
        disp("No results for test suite with identifier '" + format + "'");
        return
    else
        resultsTestSuite = testResults(format);
    end
end

% print header
fprintf('-*---------------------------------*-\n');
fprintf('--- Results of last full test run ---\n\n');

% print which test suite
fprintf(['  test suite: ',format,'\n']);

% print machine and Matlab version
fprintf(['  system:     ',resultsTestSuite.hostsystem,'\n']);
fprintf(['  Matlab:     ',resultsTestSuite.matlabversion,'\n']);

% print date and time
fprintf(['  date/time:  ',resultsTestSuite.date,'\n']);

% print test results
fprintf('  tests:\n');
fprintf(['  .. total:   ',num2str(resultsTestSuite.nrTotalTests),'\n']);
fprintf(['  .. failed:  ',num2str(resultsTestSuite.nrFailedTests),'\n']);

% print names of all failed tests
if resultsTestSuite.nrFailedTests > 0
    fprintf(['  .. .. ',resultsTestSuite.nameFailedTests{1},'\n']);
    for i=2:resultsTestSuite.nrFailedTests
    fprintf(['        ',resultsTestSuite.nameFailedTests{i},'\n']);
    end
end

% print footer
fprintf('-*---------------------------------*-\n');

%------------- END OF CODE --------------