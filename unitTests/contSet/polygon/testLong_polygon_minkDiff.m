function res = testLong_polygon_minkDiff()
% testLong_polygon_minkDiff - unit test function for polygon/minkDiff
%
% Syntax:
%    res = testLong_polygon_minkDiff()
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
% See also: polygon

% Authors:       Niklas Kochdumper
% Written:       16-June-2021
% Last update:   27-June-2023 (TL, comments)
%                20-September-2024 (TL, fixed subset test if [0;0] is contained)
% Last revision: 25-May-2023 (TL, split unit tests)

% ------------------------------ BEGIN CODE -------------------------------

% test if the Minkowski difference yields a correct result

for i = 1:3

    % create random polygons
    pgonMinuend = polygon.generateRandom();
    pgonSubtrahend = polygon.generateRandom();

    scale = 0.1 * rad(interval(pgonMinuend)) ./ rad(interval(pgonSubtrahend));
    c = center(pgonSubtrahend);
    pgonSubtrahend = c + diag(scale) * (pgonSubtrahend - c);

    % compute Minkowski difference
    pgonRes = minkDiff(pgonMinuend, pgonSubtrahend);

    % check correctness for random points
    points = randPoint(pgonMinuend, 100);

    % shift points by center to translate it to result space
    points = points - c;

    for j = 1:size(points, 2)
        if contains(pgonRes, points(:, j))
            % if point is within result,
            % then minkAddition of point with subtrahend
            % has to be within minuend
            assertLoop(contains(pgonMinuend, points(:, j)+pgonSubtrahend),i,j);
        end
    end

    % test if subtrahend contains [0;0]
    if contains(pgonSubtrahend, [0;0])
        % then the result must be a subset of the minuend
        assertLoop(contains(pgonMinuend,pgonRes),i)
    end
end

res = true;

% ------------------------------ END OF CODE ------------------------------
