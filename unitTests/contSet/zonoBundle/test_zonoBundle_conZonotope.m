function res = test_zonoBundle_conZonotope
% test_zonoBundle_conZonotope - unit test function of conZonotope
%
% Syntax:
%    res = test_zonoBundle_conZonotope
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
% See also: none

% Authors:       Mark Wetzlinger
% Written:       24-April-2023
% Last update:   ---
% Last revision: ---

% ------------------------------ BEGIN CODE -------------------------------

tol = 1e-8;

% fully-empty zonoBundle
n = 2;
zB = zonoBundle.empty(n);
cZ = conZonotope(zB);
assert(representsa(cZ,'emptySet') && dim(cZ) == n);

% non-empty intersection
Z1 = zonotope([1;1], [3 0; 0 2]);
Z2 = zonotope([0;0], [2 2; 2 -2]);
zB = zonoBundle({Z1,Z2});
% convert to constrained zonotope
cZ = conZonotope(zB);
% vertices
V = vertices(zB);
V_ = vertices(cZ);
% compare results
assert(compareMatrices(V,V_,tol));

% empty intersection
Z2 = zonotope([-4;1],[0.5 1; 1 -1]);
zB = zonoBundle({Z1,Z2});
% convert to constrained zonotope
cZ = conZonotope(zB);
% vertices
V = vertices(zB);
V_ = vertices(cZ);
% compare results
assert(compareMatrices(V,V_,tol));

% combine results
res = true;

% ------------------------------ END OF CODE ------------------------------
