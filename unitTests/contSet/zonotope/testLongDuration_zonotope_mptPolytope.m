function res = testLongDuration_zonotope_mptPolytope
% testLongDuration_zonotope_mptPolytope - unit test function of mptPolytope
%
% Syntax:  
%    res = testLongDuration_zonotope_mptPolytope
%
% Inputs:
%    -
%
% Outputs:
%    res - boolean 
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: -

% Author:       Matthias Althoff
% Written:      26-July-2016
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

res = true;
N = 100;
Tol = 1e-12;

% loop over different dimensions
for n = 1:4
    
   % loop over the number of generators
   for m = 1:6
      
       % construct random zonotope
       Z = zonotope(rand(n,m+1)-0.5*ones(n,m+1));
       
       % convert to polytope and extract inequality constraints
       poly = mptPolytope(Z);
       A = poly.P.A;
       b = poly.P.b;
       
       % draw random points from inside the zonotope
       pointsIn = zeros(n,N);
       
       for i = 1:N
          pointsIn(:,i) = randPoint(Z); 
       end
       
       % draw random points outside the zonotope
       pointsOut = zeros(n,N);
       I = interval(Z);
       I_ = interval(center(I)-2*rad(I),center(I)+2*rad(I));
       Z_ = zonotope(I_);
       counter = 1;
       
       while counter <= N
           p = randPoint(Z_);
           if ~contains(I,p)
              pointsOut(:,counter) = p;
              counter = counter + 1;
           end
       end
       
       % check if the inside points fullfil the inequality constraints
       temp = A*pointsIn - b * ones(1,N);
       
       if any(any(temp > Tol))
          res = false;
          path = pathFailedTests(mfilename());
          save(path,'Z','pointsIn','p');
          throw(CORAerror('CORA:testFailed'));
       end
       
       % check if the outside points violate the inequality constraints
       temp = A*pointsOut - b * ones(1,N);
       
       for i = 1:N
           if ~any(temp(:,i) > -Tol)
              res = false;
              path = pathFailedTests(mfilename());
              save(path,'Z','pointsIn','p');
              throw(CORAerror('CORA:testFailed'));
           end  
       end
   end
end

%------------- END OF CODE --------------