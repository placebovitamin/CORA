function res = test_linearSys_reach_12_adaptive_2()
% test_linearSys_reach_12_adaptive_2 - unit test function of linear
%    reachability analysis; checks if the adaptive tuning of time step
%    sizes no longer prohibits itself from using a previously used time
%    step size in case it was the largest time-step tried so far.
%
% Syntax:
%    res = test_linearSys_reach_12_adaptive_2
%
% Inputs:
%    -
%
% Outputs:
%    res - true/false

% Authors:       Maximilian Perschl
% Written:       05-November-2024
% Last update:   ---
% Last revision: ---

% ------------------------------ BEGIN CODE -------------------------------

% dynamics
[A,B] = aux_loadMatrices();
linsys = linearSys(A,B);

% model parameters
params.tStart = 0;
params.tFinal = 60;
params.U = zonotope(zeros(50,1),[zeros(49,1);1]);
params.R0 = zonotope(zeros(50,1));

% options (to reproduce error)
options.linAlg = 'adaptive';
options.error = 1493.48;

% reachability analysis should perform with no errors
R = reach(linsys,params,options);

% test completed
res = true;

end


% Auxiliary functions -----------------------------------------------------

function [A,B] = aux_loadMatrices()
    A = sparse([ 1 25 1 2 27 2 3 28 3 4 29 4 5 30 5 6 31 6 7 32 7 8 33 8 9 34 9 10 35 10 11 36 11 12 37 12 13 38 13 14 39 14 15 40 15 16 41 16 17 42 17 18 43 18 19 44 19 20 45 20 21 46 21 22 47 22 23 48 23 24 49 24 25 49 50 25 26 2 26 27 3 27 28 4 28 29 5 29 30 6 30 31 7 31 32 8 32 33 9 33 34 10 34 35 11 35 36 12 36 37 13 37 38 14 38 39 15 39 40 16 40 41 17 41 42 18 42 43 19 43 44 20 44 45 21 45 46 22 46 47 23 47 48 24 48 49 25 ], [ 1 1 2 2 2 3 3 3 4 4 4 5 5 5 6 6 6 7 7 7 8 8 8 9 9 9 10 10 10 11 11 11 12 12 12 13 13 13 14 14 14 15 15 15 16 16 16 17 17 17 18 18 18 19 19 19 20 20 20 21 21 21 22 22 22 23 23 23 24 24 24 25 25 25 25 26 26 27 27 27 28 28 28 29 29 29 30 30 30 31 31 31 32 32 32 33 33 33 34 34 34 35 35 35 36 36 36 37 37 37 38 38 38 39 39 39 40 40 40 41 41 41 42 42 42 43 43 43 44 44 44 45 45 45 46 46 46 47 47 47 48 48 48 49 49 49 50 ], [ -0.1000 1.0000 1.0000 -0.1314 0.2487 1.0000 -0.2237 0.4818 1.0000 -0.3710 0.6845 1.0000 -0.5642 0.8443 1.0000 -0.7910 0.9511 1.0000 -1.0372 0.9980 1.0000 -1.2874 0.9823 1.0000 -1.5258 0.9048 1.0000 -1.7374 0.7705 1.0000 -1.9090 0.5878 1.0000 -2.0298 0.3681 1.0000 -2.0921 0.1253 1.0000 -2.0921 -0.1253 1.0000 -2.0298 -0.3681 1.0000 -1.9090 -0.5878 1.0000 -1.7374 -0.7705 1.0000 -1.5258 -0.9048 1.0000 -1.2874 -0.9823 1.0000 -1.0372 -0.9980 1.0000 -0.7910 -0.9511 1.0000 -0.5642 -0.8443 1.0000 -0.3710 -0.6845 1.0000 -0.2237 -0.4818 1.0000 -0.1314 1.0000 -0.2487 1.0000 -0.1314 -0.2487 1.0000 -0.2237 -0.4818 1.0000 -0.3710 -0.6845 1.0000 -0.5642 -0.8443 1.0000 -0.7910 -0.9511 1.0000 -1.0372 -0.9980 1.0000 -1.2874 -0.9823 1.0000 -1.5258 -0.9048 1.0000 -1.7374 -0.7705 1.0000 -1.9090 -0.5878 1.0000 -2.0298 -0.3681 1.0000 -2.0921 -0.1253 1.0000 -2.0921 0.1253 1.0000 -2.0298 0.3681 1.0000 -1.9090 0.5878 1.0000 -1.7374 0.7705 1.0000 -1.5258 0.9048 1.0000 -1.2874 0.9823 1.0000 -1.0372 0.9980 1.0000 -0.7910 0.9511 1.0000 -0.5642 0.8443 1.0000 -0.3710 0.6845 1.0000 -0.2237 0.4818 1.0000 -0.1314 0.2487 ]);
    A = full(A);
    B = eye(size(A,1));
end

% ------------------------------ END OF CODE ------------------------------