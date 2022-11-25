function res = testLongDuration_linParamSys_reach_01_rlc_const()
% testLongDuration_linParamSys_reach_01_rlc_const - unit_test_function of 
%    linear parametric reachability analysis
%
% Checks the solution of the linParamSys class for a RLC circuit example;
% It is checked whether the enclosing interval of the final reachable set 
% is close to an interval provided by a previous solution that has been saved
%
% Syntax:  
%    res = testLongDuration_linParamSys_reach_01_rlc_const()
%
% Inputs:
%    -
%
% Outputs:
%    res - boolean 
%
% Example: 
%    -
 
% Author:       Matthias Althoff, Niklas Kochdumper
% Written:      05-August-2016
% Last update:  23-April-2020 (restructure params/options)
%               05-June-2020 (NK, adapted to bug fix in commit fdc7bba)
% Last revision:---

%------------- BEGIN CODE --------------


%init: get matrix zonotopes of the model
[matZ_A,matZ_B] = RLCcircuit();
matI_A = intervalMatrix(matZ_A);

%get dimension
dim=matZ_A.dim;

%compute initial set
%specify range of voltages
u0 = intervalMatrix(0,0.2);

%compute inverse of A
intA = intervalMatrix(matZ_A);
invAmid = inv(center(intA.int)); 

%compute initial set
intB = intervalMatrix(matZ_B);
R0 = invAmid*intB*u0 + intervalMatrix(0,1e-3*ones(dim,1));

%convert initial set to zonotope
R0 = zonotope(interval(R0));

%initial set
params.R0=R0; %initial state for reachability analysis
%inputs
u = intervalMatrix(1,0.01);
params.U = zonotope(interval(intB*u));
% time horizon
params.tFinal=0.05; %final time

%algorithm parameters
options.timeStep = 0.001;
options.zonotopeOrder=400; %zonotope order
options.taylorTerms=8;
options.intermediateTerms = 2;

%instantiate linear dynamics with constant parameters
linSys  = linParamSys(matZ_A, eye(dim));
linSys2 = linParamSys(matI_A, eye(dim));

%initialize reachable set computations
R = reach(linSys, params, options);
R2 = reach(linSys2, params, options);

IH = interval(R.timeInterval.set{end});
IH2 = interval(R2.timeInterval.set{end});

%saved result
IH_saved = interval( ...
    [0.3474711660292502; 0.2936285219436148; 0.2451829534230048; 0.0941617672654410; 0.1583635984956000; 0.1547305257052254; -0.0886015376802425; -0.3712520048978424; -0.5139955925397003; -0.5597831909865391; -0.5698271507693706; -0.5695959829836099; -0.5591659803639416; -0.4949420491463762; -0.4764319271836627; -0.4837629246883909; -0.4766999639006279; -0.4044130960584761; -0.3791284134674616; -0.3277805304599952; -0.0502710485373086; -0.0540612315133956; -0.0590298439081489; -0.0542352350085667; -0.0555324780121296; -0.0651675676587509; -0.0608254109922299; -0.0470296494949901; -0.0373084136696641; -0.0331490983473796; -0.0319331400108459; -0.0316086980201895; -0.0311754957595848; -0.0300858364122304; -0.0267322182673178; -0.0283354561154593; -0.0234216676026429; -0.0261306106691016; -0.0254940009059353; -0.0239076569802236], ...
    [0.9771699932663527; 0.9814879232418650; 1.0411302534872604; 0.9557203827875239; 1.0690778752260774; 1.1310018903123353; 0.9319793843763793; 0.7308026664753969; 0.6214915193152194; 0.5836874628735770; 0.5739543282928163; 0.5701672293177285; 0.5592309455100420; 0.4949482392038857; 0.4764324292284234; 0.4837629598056866; 0.4766999660426920; 0.4044130961734985; 0.3791284134729438; 0.3277805304602377; -0.0196528696166673; -0.0114328157516352; -0.0130698218780298; -0.0089148139290295; -0.0060091743049666; -0.0134713375078318; -0.0063840851336447; 0.0114413564717003; 0.0246339089101652; 0.0298891070526812; 0.0312956627482176; 0.0315103122492826; 0.0311631682177972; 0.0300845545356608; 0.0267321056798593; 0.0283354476416890; 0.0234216670494931; 0.0261306106374619; 0.0254940009043355; 0.0239076569801517]);
IH_saved2 = interval( ...
    [0.3179764943608208; 0.2579604637855726; 0.2057775091528118; 0.0523417974733139; 0.1165091136619396; 0.1147110906543174; -0.1229566429155803; -0.4021343001027438; -0.5433940225823857; -0.5887411379349932; -0.5986615600457043; -0.5982902586872733; -0.5875600051946414; -0.5223067295892047; -0.5017205849495959; -0.5076878087920774; -0.4989084942800047; -0.4244389409232775; -0.3961130457881354; -0.3435691250640025; -0.0516307347171256; -0.0560642616692560; -0.0612867237738892; -0.0566391483537111; -0.0579966328164944; -0.0676458352981037; -0.0630696368885849; -0.0489801316932734; -0.0391116274472326; -0.0348999668155173; -0.0336701978222146; -0.0333396077463367; -0.0328965709675283; -0.0317741134870245; -0.0282929431581833; -0.0298152208599641; -0.0247768309421345; -0.0273781942176900; -0.0266088515672265; -0.0248309118590221], ...
    [1.0066665296745079; 1.0171576984529966; 1.0805375770093057; 0.9975416528698736; 1.1109341578549923; 1.1710235055271283; 0.9663359797839247; 0.7616855981585051; 0.6508901370062583; 0.6126454506479655; 0.6027887444324006; 0.5988615059430892; 0.5876249704421462; 0.5223129196560362; 0.5017210869950842; 0.5076878439094218; 0.4989084964220718; 0.4244389410383000; 0.3961130457936176; 0.3435691250642450; -0.0182932088162304; -0.0094298635087939; -0.0108130456991773; -0.0065109821565098; -0.0035450953856461; -0.0109931922018164; -0.0041399728861010; 0.0133917775819042; 0.0264371011399985; 0.0316399700910836; 0.0330327195256379; 0.0332412218206690; 0.0328842434069959; 0.0317728316085761; 0.0282928305705661; 0.0298152123861824; 0.0247768303889840; 0.0273781941860503; 0.0266088515656267; 0.0248309118589501]);
       
%check if slightly bloated versions enclose each other for IH
res_11 = (IH <= enlarge(IH_saved,1+1e-8));
res_12 = (IH_saved <= enlarge(IH,1+1e-8));

%check if slightly bloated versions enclose each other for IH2
res_21 = (IH2 <= enlarge(IH_saved2,1+1e-8));
res_22 = (IH_saved2 <= enlarge(IH2,1+1e-8));

%final result
res = res_11 && res_12 && res_21 && res_22;

end

%------------- END OF CODE --------------