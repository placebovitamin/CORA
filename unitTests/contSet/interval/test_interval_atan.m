function res = test_interval_atan
% test_interval_atan - unit test function of sine for intervals,
%    overloaded 'atan()' function for intervals
%
% Syntax:
%    res = test_interval_atan
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
% See also: mtimes

% Authors:       Mark Wetzlinger
% Written:       08-August-2020
% Last update:   03-December-2023 (MW, add unbounded cases)
% Last revision: ---

% ------------------------------ BEGIN CODE -------------------------------

tol = 1e-9;

% Check special values:
% x                         atan(x)     ..in deg
% 0                         0           0
% sqrt(3)/3                 pi/6        30
% 1                         pi/4        45
% sqrt(3)                   pi/3        60
% 2 - sqrt(3)               pi/12       15
% 2 + sqrt(3)               5pi/12      75
% sqrt(5-2*sqrt(5))         pi/5        36
% sqrt(5+2*sqrt(5))         2pi/5       72

I = interval([0,sqrt(3)/3],[1,sqrt(3)]);
I_atan = atan(I);
I_true = interval([0,pi/6],[pi/4,pi/3]);
assert(isequal(I_atan,I_true,tol));

I = interval([2-sqrt(3);sqrt(5-2*sqrt(5))],[2+sqrt(3);sqrt(5+2*sqrt(5))]);
I_atan = atan(I);
I_true = interval([pi/12;pi/5],[5*pi/12;2*pi/5]);
assert(isequal(I_atan,I_true,tol));

% unbounded cases
I = interval([-Inf,1],[0,Inf]);
I_atan = atan(I);
I_true = interval([-pi/2,pi/4],[0,pi/2]);
assert(isequal(I_atan,I_true,tol));

% n-d arrays
lb = reshape([ 1.000 3.000 2.000 5.000 -3.000 0.000 2.000 1.000 0.000 -2.000 -1.000 3.000 0.000 0.000 0.000 0.000 1.000 -1.000 1.000 0.000 0.000 0.000 0.000 0.000 ], [2,2,2,3]);
ub = reshape([ 1.500 4.000 4.000 10.000 -1.000 0.000 3.000 2.000 1.000 0.000 2.000 4.000 0.000 0.000 0.000 0.000 2.000 -0.500 3.000 2.000 0.000 0.000 0.000 0.000 ], [2,2,2,3]);
I = interval(lb,ub);
Iatan = atan(I);
assert(isequal(Iatan.inf,atan(lb)))
assert(isequal(Iatan.sup,atan(ub)))

% combine results
res = true;

% ------------------------------ END OF CODE ------------------------------
