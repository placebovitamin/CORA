function res = testnn_polyZonotope_cnn_verivital_avg()
% testnn_polyZonotope_cnn_verivital_avg - test a CNN from the verivital
%    benchmark [1] with avg pooling.
%
%
% Syntax:
%    res = testnn_polyZonotope_cnn_verivital_avg
%
% Inputs:
%    -
%
% Outputs:
%    res - boolean
%
% References:
%    [1] Bak, Stanley, et al. "The second international verification of 
%    neural networks competition (vnn-comp 2021): Summary and results." 
%    arXiv preprint arXiv:2109.00498 (2021).
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: -

% Authors:       Tobias Ladner
% Written:       02-December-2022
% Last update:   ---
% Last revision: ---

% ------------------------------ BEGIN CODE -------------------------------
 
% assume true
res = true;

assert(run_cnn_unittest('vnn_verivital_avgpool.onnx'));

end

% ------------------------------ END OF CODE ------------------------------
