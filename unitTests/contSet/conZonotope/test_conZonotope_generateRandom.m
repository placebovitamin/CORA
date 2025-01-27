function res = test_conZonotope_generateRandom
% test_conZonotope_generateRandom - unit test function of generateRandom
%
% Syntax:
%    res = test_conZonotope_generateRandom
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
% Written:       19-May-2022
% Last update:   ---
% Last revision: ---

% ------------------------------ BEGIN CODE -------------------------------

% empty call
cZ = conZonotope.generateRandom();

% values for tests
n = 3;
c = [2;1;-1];
nrGens = 10;
nrCons = 5;

% only dimension
cZ = conZonotope.generateRandom('Dimension',n);
assert(dim(cZ) == n);

% only center (no check)
cZ = conZonotope.generateRandom('Center',c);

% only number of generators
cZ = conZonotope.generateRandom('NrGenerators',nrGens);
assert(size(generators(cZ),2) == nrGens);

% only number of constraints
cZ = conZonotope.generateRandom('NrConstraints',nrCons);
assert(size(cZ.A,1) == nrCons);

% dimension and number of generators
cZ = conZonotope.generateRandom('Dimension',n,'NrGenerators',nrGens);
assert(dim(cZ) == n && size(generators(cZ),2) == nrGens);

% dimension and number of constraints
cZ = conZonotope.generateRandom('Dimension',n,'NrConstraints',nrCons);
assert(dim(cZ) == n && size(cZ.A,1) == nrCons);

% center and number of generators
cZ = conZonotope.generateRandom('Center',c,'NrGenerators',nrGens);
assert(size(generators(cZ),2) == nrGens);

% center and number of constraints
cZ = conZonotope.generateRandom('Center',c,'NrConstraints',0);
assert(all(abs(center(cZ) - c) < eps));

% center and number of constraints (no check)
cZ = conZonotope.generateRandom('Center',c,'NrConstraints',nrCons);

% number of generators and number of constraints
cZ = conZonotope.generateRandom('NrGenerators',nrGens,'NrConstraints',nrCons);
assert(size(generators(cZ),2) == nrGens && size(cZ.A,1) == nrCons);

% dimension, number of generators, and number of constraints
cZ = conZonotope.generateRandom('Dimension',n,'NrGenerators',nrGens,'NrConstraints',nrCons);
assert(dim(cZ) == n && size(generators(cZ),2) == nrGens && size(cZ.A,1) == nrCons);

% center, number of generators, and number of constraints
cZ = conZonotope.generateRandom('Center',c,'NrGenerators',nrGens,'NrConstraints',nrCons);
assert(size(generators(cZ),2) == nrGens && size(cZ.A,1) == nrCons);

% unify results
res = true;

% ------------------------------ END OF CODE ------------------------------
