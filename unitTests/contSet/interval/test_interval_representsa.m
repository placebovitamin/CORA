function res = test_interval_representsa
% test_interval_representsa - unit_test_function of representsa
%
% Syntax:
%    res = test_interval_representsa
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

% Authors:       Dmitry Grebenyuk, Mark Wetzlinger
% Written:       16-January-2016
% Last update:   23-March-2021 (MW, rewrite syntax)
% Last revision: ---

% ------------------------------ BEGIN CODE -------------------------------

% 1. comparison to empty set
% empty interval
I = interval.empty(2);
assert(representsa(I,'emptySet'));

% non-empty intervals
I = interval(-5.0, 2);
assert(~representsa(I,'emptySet'));
I = interval([-5.0, -4.0, -3, 0, 0, 5], [-2, 0.0, 2.0, 0, 5, 8]);
assert(~representsa(I,'emptySet'));


% 2. comparison to origin
I = interval.empty(2);
assert(~representsa(I,'origin'));

% only origin
I = interval(zeros(3,1),zeros(3,1));
assert(representsa(I,'origin'));

% shifted center
I = interval([0.01;0.02],[0.03;0.025]);
assert(~representsa(I,'origin'));

% shifted center, contains origin within tolerance
I = interval([0.01;-0.01],[0.02;0.01]);
tol = 0.05;
assert(representsa(I,'origin',tol));


% 3. comparison to point
I = interval.empty(2);
assert(~representsa(I,'point'));

I = interval([-3;-2],[-3;-2]);
assert(representsa(I,'point'));
I = interval([-3;-2],[-3;-1]);
assert(~representsa(I,'point'));
assert(representsa(I,'point',1));


% 4. comparison to zonotope
I = interval.empty(2);
assert(representsa(I,'zonotope'));

I = interval([-4;2;5],[5;2;8]);
[res,Z] = representsa(I,'zonotope');
assert(res)
assert(isequal(Z,zonotope([0.5;2;6.5],[4.5 0 0; 0 0 0; 0 0 1.5])));


% combine results
res = true;

% ------------------------------ END OF CODE ------------------------------
