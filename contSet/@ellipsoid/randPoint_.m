function p = randPoint_(E,N,type,varargin)
% randPoint_ - samples a random point from within an ellipsoid
%
% Syntax:
%    p = randPoint_(E)
%    p = randPoint_(E,N)
%    p = randPoint_(E,N,type)
%
% Inputs:
%    E - ellipsoid object
%    N - number of random points
%    type - type of the random point ('standard' or 'extreme')
%
% Outputs:
%    p - random point in R^n
%
% Example: 
%    E = ellipsoid([9.3 -0.6 1.9;-0.6 4.7 2.5; 1.9 2.5 4.2]);
%    p = randPoint(E);
% 
%    figure; hold on;
%    plot(E);
%    scatter(p(1,:),p(2,:),16,'r','filled');
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: contSet/randPoint, interval/randPoint_

% Authors:       Victor Gassmann, Mark Wetzlinger, Maximilian Perschl, Adrian Kulmburg
% Written:       18-March-2021
% Last update:   25-June-2021 (MP, add type gaussian)
%                19-August-2022 (MW, integrate standardized pre-processing)
%                12-March-2024 (AK, made the distribution truly uniform and random)
% Last revision: 28-March-2023 (MW, rename randPoint_)

% ------------------------------ BEGIN CODE -------------------------------

% 'all' vertices not supported
if ischar(N) && strcmp(N,'all')
    throw(CORAerror('CORA:notSupported',...
        "Number of vertices 'all' is not supported for class ellipsoid."));
end

% ellipsoid is just a point -> replicate center N times
if representsa_(E,'point',eps)
    p = repmat(E.q,1,N);
    return;
end

% save original center
c_orig = E.q;
% shift ellipsoid to be centered at the origin
E = E + E.q;

% compute rank and dimension
r = rank(E);
n = dim(E);

% determine degeneracy: if so, project on proper subspace (via SVD)
n_rem = n-r;
[T,~,~] = svd(E.Q);
E = T'*E;
E = project(E,1:r);
G = inv(sqrtm(E.Q));
E = G*E;


% generate different types of extreme points
if strcmp(type,'standard') || startsWith(type,'uniform')
    % generate points uniformly distributed (with N -> infinity)
    % on the unit hypersphere
    X = randn(dim(E),N);
    pt = X./sqrt(sum(X.^2,1));
    
    % Uniform radius
    r = rand(1,N).^(1/dim(E));
    pt = r.*pt;
    
    % stack again, backtransform and shift
    p = T*[inv(G)*pt;zeros(n_rem,N)] + c_orig;

elseif strcmp(type,'extreme')
    % Do the same as above, but without the radius
    X = randn(dim(E),N);
    pt = X./sqrt(sum(X.^2,1));
    
    % stack again, backtransform and shift
    p = T*[inv(G)*pt;zeros(n_rem,N)] + c_orig;

end

% ------------------------------ END OF CODE ------------------------------
