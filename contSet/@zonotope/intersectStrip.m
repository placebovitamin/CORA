function Zres = intersectStrip(Z,C,phi,y,varargin)
% intersectStrip - computes the intersection between one zonotope and
%    list of strips according to [1] and [2]
%    the strip is defined as | Cx-y | <= phi
%
% Syntax:  
%    Zres = intersectStrip(Z,C,phi,y,varargin)
%
% Inputs:
%    Z - zonotope object
%    C - matrix of normal vectors of strips
%    phi - vector of widths of strips
%    y - center of intersected strips
%    varargin - methods to calculate the weights
%               - 'normGen' (default, analytical solution)
%               - 'svd'
%               - 'radius'
%               - 'alamo-volume' according to [3]
%               - 'alamo-FRad' according to [3]
%               - 'wang-FRad' according to [4] + auxiliary values as a struct
%               - 'bravo' accroding to [5]
%               - or lambda value
%
% Outputs:
%    res - boolean whether obj is contained in Z, or not
%
% Example: (three strips and one zonotope)
%    C = [1 0; 0 1; 1 1];
%    phi = [5; 3; 3];
%    y = [-2; 2; 2];
% 
%    Z = zonotope([1 2 2 2 6 2 8;1 2 2 0 5 0 6 ]);
%    res_zono = intersectStrip(Z,C,phi,y);
% 
%    % just for comparison
%    poly = mptPolytope([1 0;-1 0; 0 1;0 -1; 1 1;-1 -1],[3;7;5;1;5;1]);
%    Zpoly = Z & poly;
% 
%    figure; hold on 
%    plot(Z,[1 2],'r-+');
%    plot(poly,[1 2],'r-*');
%    plot(Zpoly,[1 2],'b-+');
%    plot(res_zono,[1 2],'b-*');
% 
%    legend('zonotope','strips','zono&poly','zonoStrips');
%
%
% References:
%    [1] V. T. H. Le, C. Stoica, T. Alamo, E. F. Camacho, and
%        D. Dumur. Zonotope-based set-membership estimation for
%        multi-output uncertain systems. In Proc. of the IEEE
%        International Symposium on Intelligent Control (ISIC),
%        pages 212–217, 2013.
%    [2] Amr Alanwar, Jagat Jyoti Rath, Hazem Said, Matthias Althoff
%        Distributed Set-Based Observers Using Diffusion Strategy
%    [3] T. Alamo, J. M. Bravo, and E. F. Camacho. Guaranteed
%        state estimation by zonotopes. Automatica, 41(6):1035–1043,
%        2005.
%    [4] Ye Wang, Vicenç Puig, and Gabriela Cembrano. Set-
%        membership approach and Kalman observer based on
%        zonotopes for discrete-time descriptor systems. Automatica,
%        93:435-443, 2018.
%    [5] J. M. Bravo, T. Alamo, and E. F. Camacho. Bounded error 
%        identification of systems with time-varying parameters. IEEE 
%        Transactions on Automatic Control, 51(7):1144–1150, 2006.
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Matthias Althoff
% Written:      09-Mar-2020
% Last update:  08-Sep-2020 (restructured, alamo method added)  
%               10-Sep-2020 (bravo method added)
%               17-Sep-2020 (wang and direct method added)
%               04-Jan-2021 (bravo method robustified)
%               02-Mar-2021 (notation changed)
% Last revision:---

%------------- BEGIN CODE --------------

if nargin==4
    %The optimization function is based on norm of the generators
    method = 'normGen';
elseif nargin==5
    % input is lambda value --> direct computation
    if isnumeric(varargin{1})
        Zres = zonotopeFromLambda(Z,phi,C,y,varargin{1});
        return % stop program execution
    % input is a struct
    elseif isstruct(varargin{1})
        method = varargin{1}.method;
        aux = varargin{1};
    % input is intersection method
    else
        method = varargin{1};
    end
end

% extract generators
G = generators(Z);
% obtain dimesnion and nr of generators
[dim, gens] = size(G);

% different methods for finding good lambda values
%% svd and radius method
if strcmp(method,'svd') || strcmp(method,'radius') 
    % initialize lambda
    lambda0 = zeros(dim,length(phi));
    options = optimoptions(@fminunc,'Algorithm', 'quasi-newton','Display','off');
    %find optimal lambda
    lambda = fminunc(@fun,lambda0, options);
    % resulting zonotope
    Zres = zonotopeFromLambda(Z,phi,C,y,lambda);
    
%% volume minimization according to Alamo, [3]    
elseif strcmp(method,'alamo-volume') 
    % warning if more than one strip is used
    if length(phi)>1
        error('Alamo method should only be used for single strips to ensure convergence');
    end
    % implement volume expression from [3], Vol(\hat{X}(lambda)) (last eq.
    % before Sec. 7); from now on referred to as (V)
    % obtain possible combinations of generators
    comb_A = combinator(gens,dim,'c');
    comb_B = combinator(gens,dim-1,'c');
    a_obj = 0;
    % |1-c'*lambda| can be pulled out from first summation in (V)
    for iComb=1:size(comb_A,1)
        a_obj = a_obj + 2^dim*abs(det(G(:,comb_A(iComb,:))));
    end
    
    b_obj = zeros(size(comb_B,1),1);
    Bp_cstr = zeros(size(comb_B,1),dim);
    % as we set z_i = |v_i'*lambda| (also see below), each summand in
    % second summation of (V) is exactly the coefficient for z_i
    for iComb=1:size(comb_B,1)
        Bi = G(:,comb_B(iComb,:));
        if rank(Bi)<dim-1
            b_obj(iComb) = 0;
            continue;
        end
        % rank(Bi) = n-1 => there exists exactly 1 vector orthogonal to
        % image(Bi) (vi'*Bi = 0)
        vi = null(Bi');
        b_obj(iComb) = 2^dim*phi*abs(det([Bi,vi]));
        Bp_cstr(iComb,:) = vi';
    end
    % clean-up zeros
    ind_0 = b_obj==0;
    b_obj(ind_0) = [];
    Bp_cstr(ind_0,:) = [];
    nz = length(b_obj);
    
    % formulate linear program
    % opt variables:lambda, r, z (r=|1-phi'*lambda|,z_i = |v_i'*lambda|)
    % x = [lambda;r;z];
    f_obj = [zeros(dim,1);a_obj;b_obj];
    
    % constraints for |1-phi'*lambda|<=r (same as =r since we want to
    % minimize the expression)
    Cr_cstr = [-C,-1,zeros(1,nz);
                C,-1,zeros(1,nz)];
    dr_cstr = [-1;1];
    
    % constraints handling z_i = |v_i'*lambda|
    Cz_cstr = [Bp_cstr,zeros(nz,1),-eye(nz);
              -Bp_cstr,zeros(nz,1),-eye(nz)];
    dz_cstr = zeros(2*nz,1);
    % collect all constraints
    C_cstr = [Cr_cstr;Cz_cstr];
    d_cstr = [dr_cstr;dz_cstr];
    
    % solve linear program
    x_opt = linprog(f_obj,C_cstr,d_cstr);
    
    % extract lambda
    lambda = x_opt(1:dim);
    
    % resulting zonotope
    Zres = zonotopeFromLambda(Z,phi,C,y,lambda);
    

%% F-radius minimization according to Alamo, [3]    
elseif strcmp(method,'alamo-FRad') 
    
    % auxiliary variables
    aux1 = G*G'; 
    aux2 = aux1*C(1,:)';
    aux3 = C(1,:)*aux1*C(1,:)' + phi(1)^2; 

    % return lambda
    lambda = aux2/aux3;
    
    % resulting zonotope
    Zres = zonotopeFromLambda(Z,phi,C,y,lambda);
    
    % warning
    if length(phi) > 1
        disp('Alamo method should only be used for single strips to ensure convergence');
    end
    
%% F-radius minimization according to Wang, Theorem 2 in [4]    
elseif strcmp(method,'wang-FRad') 
    
    % auxiliary variables
    P = G*G'; 
    Q_w = aux.E*aux.E';
    Q_v = aux.F*aux.F'; 

    % eq. (15)
    Rbar = aux.A*P*aux.A' + Q_w;
    
    % eq. (14)
    S = aux.C*Rbar*aux.C' + Q_v;
    
    % eq. (13)
    L = Rbar*aux.C';
    
    % eq. (12)
    lambda = L*inv(S);
    
    % resulting zonotope
    Zres = zonotopeFromLambda(Z,phi,C,y,lambda);
    
  
%% method according to Bravo, [5]   
elseif strcmp(method,'bravo') 
    
    %% Property 1 in [5]  
    % obtain center of zonotope
    p = center(Z);
    % loop through generators
    for j = 0:gens
        % normal vector of strip and generator are not perpendicular
        if  j>0 && abs(C(1,:)*G(:,j)) > 1e10*eps
            % init T
            T = zeros(dim,gens);
            for iGen =1:gens
                if iGen~=j
                    T(:,iGen) = G(:,iGen)  - C(1,:)*G(:,iGen)/(C(1,:)*G(:,j))*G(:,j);
                else
                    T(:,iGen) = phi(1)/(C(1,:)*G(:,j))*G(:,j);
                end
            end
            v =  p + ((y(1)-C(1,:)*p)/(C(1,:)*G(:,j)))*G(:,j);
        % first generator or normal vector of strip and generator are perpendicular
        else
            v = p; % new center
            T = G; % new generators
        end
        % save center and generator
        c_cell{j+1} = v;
        G_cell{j+1} = T;
      
        % approximate volume of obtained zonotope
        volApproxZ(j+1)  = det(G_cell{j+1}*G_cell{j+1}');
    end
    % find zonotope with minimum approximated volume
    [~,ind] = min(volApproxZ);

    % return best zonotope
    Zres = zonotope([c_cell{ind}, G_cell{ind}]);
    
    % warning
    if length(phi) > 1
        disp('Bravo method is only applied to the first strip');
    end


%% norm Gen method
elseif strcmp(method,'normGen')
    % Find the analytical solution  
    gamma=eye(length(C(:,1)));
    num= G*G'*C';
    den = C*G*G'*C';
    for iStrip=1:length(C(:,1))
        den = den + gamma(:,iStrip) *phi(iStrip)^2* gamma(:,iStrip)';
    end
    
    lambda = num * den^-1;
    % resulting zonotope
    Zres = zonotopeFromLambda(Z,phi,C,y,lambda);
    
    
%% selected method does not exist
else
    disp('Method is not supported');
    return;
end


    % embedded function to be minimized for optimal lambda
    function nfro = fun(lambda)
        part1 = eye(length(Z.center));
        for i=1:length(phi)
            part1 = part1 - lambda(:,i)*C(i,:);
            part2(:,i) = phi(i)*lambda(:,i);
        end
        part1 = part1 * G;
        G_new = [part1 part2];
        if strcmp(method,'svd')
            nfro = sum(svd(G_new));
        elseif strcmp(method,'radius')
            nfro = radius(zonotope([zeros(length(Z.center),1) G_new]));
        end

    end

end

% return zonotope from a given lambda vector, see Prop. 1 of [1]
function Z = zonotopeFromLambda(Z,phi,C,y,Lambda)
    % strips: |Cx − y| <= phi
    % zonotope: Z = c+G[-1,1]^o

    % new center
    c_new = Z.center + Lambda*(y-C*Z.center);
    % new generators
    I = eye(length(c_new));
    G_new = [(I - Lambda*C)*Z.generators, Lambda*diag(phi)];

    % resulting zonotope
    Z.Z = [c_new G_new];

end

%------------- END OF CODE --------------
