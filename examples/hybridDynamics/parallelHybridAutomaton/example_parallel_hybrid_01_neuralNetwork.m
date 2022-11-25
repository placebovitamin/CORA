function res = example_parallel_hybrid_01_neuralNetwork()
% example_parallel_hybrid_01_neuralNetwork - example for reachability of a
%    parallel hybrid automaton. The system represents a neural network with
%    three neurons, where each neuron has the three locations "charging",
%    "firing", and "reset"
%
% Syntax:  
%    res = example_parallel_hybrid_01_neuralNetwork()
%
% Inputs:
%    no
%
% Outputs:
%    res - boolean, true if completed

% Author:       Niklas Kochdumper
% Written:      15-June-2020
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

% System Dynamics ---------------------------------------------------------

% single neuron represented as a hybrid automaton
HA = integrateAndFireNeuron();

% network with 3 identical neurons 
comp = {HA,HA,HA};

% neuron connections:
inputBinds{1} = [0,1;0,2];     % input 1 -> neuron 1, input 2 -> neuron 1
inputBinds{2} = [1,1;3 1];     % neuron 1 -> neuron 2, neuron 3 -> neuron 2
inputBinds{3} = [1,1;0,1];     % neuron 1 -> neuron 3, input 1 -> neuron 3

% parallel hybrid automaton
PHA = parallelHybridAutomaton(comp,inputBinds);


% Parameter ---------------------------------------------------------------

% initial set: all neurons at equilibrium potential
params.R0 = zonotope(1e-4*interval([-1;0;-1;0;-1;0],[1;0;1;0;1;0]));

% uncertain inputs
u = 10e-6;
params.U = cartProd(zonotope(u,1e-8),zonotope(0));

% final time and initial location
params.tFinal = 14e-3;
params.startLoc = [1;1;1];


% Reachability Settings ---------------------------------------------------

% settings for continuous reachability
options.timeStep = 1e-5;
options.taylorTerms = 10;
options.zonotopeOrder = 20;

% settings for hybrid systems
options.guardIntersect = 'zonoGirard';
options.enclose = {'box','pca'};


% Reachability Analysis ---------------------------------------------------

R = reach(PHA,params,options);


% Simulation --------------------------------------------------------------

% simulation parameter
simOpt.x0 = center(params.R0);
simOpt.u = center(params.U);
simOpt.startLoc = params.startLoc;
simOpt.tFinal = params.tFinal;

% simulate the system
[t,x,loc] = simulate(PHA,simOpt);
simRes = simResult(x,t,loc);


% Visualization -----------------------------------------------------------

% neuron 1
figure; hold on; box on;
plot(R,[2,1],'FaceColor',[.6 .6 .6],'Filled',true,'EdgeColor','none');
plotOverTime(simRes,1);
xlabel('time');
ylabel('output');
title('Neuron 1');

% neuron 2
figure; hold on; box on;
plot(R,[4,3],'FaceColor',[.6 .6 .6],'Filled',true,'EdgeColor','none');
plotOverTime(simRes,3);
xlabel('time');
ylabel('output');
title('Neuron 2');

% neuron 3
figure; hold on; box on;
plot(R,[6,5],'FaceColor',[.6 .6 .6],'Filled',true,'EdgeColor','none');
plotOverTime(simRes,5);
xlabel('time');
ylabel('output');
title('Neuron 3');

res = 1;

%------------- END OF CODE --------------