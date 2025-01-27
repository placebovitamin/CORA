function pgon = empty(n)
% empty - instantiates an empty polygon
%
% Syntax:
%    pgon = polygon.empty(n)
%
% Inputs:
%    n - dimension
%
% Outputs:
%    pgon - empty polygon object
%
% Example: 
%    pgon = polygon.empty(2);
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Authors:       Mark Wetzlinger
% Written:       09-January-2024
% Last update:   15-January-2024 (TL, parse input)
% Last revision: ---

% ------------------------------ BEGIN CODE -------------------------------

% parse input
if nargin == 0
    n = 2;
end
inputArgsCheck({{n,'att','numeric',{'scalar','nonnegative'}}});

% call constructor (and check n there)
pgon = polygon(zeros(n,0));

% ------------------------------ END OF CODE ------------------------------
