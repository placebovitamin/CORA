function res = test_fullspace_contains
% test_fullspace_contains - unit test function of contains
%
% Syntax:
%    res = test_fullspace_contains
%
% Inputs:
%    -
%
% Outputs:
%    res - true/false
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: -

% Authors:       Mark Wetzlinger
% Written:       05-April-2023
% Last update:   ---
% Last revision: ---

% ------------------------------ BEGIN CODE -------------------------------

% init fullspace
n = 2;
fs = fullspace(n);

% init point
p = [2;1];
assert(contains(fs,p));

% init zonotope
Z = zonotope([2;1],eye(n));
assert(contains(fs,Z));

% init ellipsoid
E = ellipsoid(eye(n),ones(n,1));
assert(contains(fs,E));

% empty set
O = emptySet(n);
assert(contains(fs,O));

% combine results
res = true;

% ------------------------------ END OF CODE ------------------------------
