function res = test_fullspace_isIntersecting
% test_fullspace_isIntersecting - unit test function of isIntersecting
%
% Syntax:
%    res = test_fullspace_isIntersecting
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

% init zonotope
Z = zonotope(ones(n,1),[1 1; -1 0.5]);
assert(isIntersecting(fs,Z));

% init vector
p = [1;1];
assert(isIntersecting(fs,p));

% init empty set
O = emptySet(n);
assert(~isIntersecting(fs,O));

% combine results
res = true;

% ------------------------------ END OF CODE ------------------------------
