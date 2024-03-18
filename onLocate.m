function current_location = onLocate(dist_1_1, dist_5_5, dist_1_10, initialGuess)

    % Known coordinates of the three points
    point1 = [1, 1];  % set locator 1 at grid 1,1
    point2 = [5, 5];  % set locator 2 at grid 5,5
    point3 = [1, 10];  % set locator 3 at grid 1,10

    % Known distances to the fourth point
    d1 = double(dist_1_1);  % distance to grid 1.1
    d2 = double(dist_5_5);  % distance to grid 5.5
    d3 = double(dist_1_10);  % distance to grid 2.10

    % Initial guess for the fourth point's coordinates (always the center of the map)
    if(isempty(initialGuess))
        initialGuess = [2.5,5];
    end

    % I solve using the optomization toolkit
    options = optimset('Display', 'off', 'Algorithm', 'levenberg-marquardt');
    [current_location, ~, ~] = fsolve(@(x) nonLinearSystem3Point(x, point1, point2, point3, d1, d2, d3), initialGuess, options);

    %options = optimset('Display', 'off');
    %[current_location, ~, ~] = fsolve(@(x) nonLinearSystem2Point(x, point1, point2, d1, d2 ), initialGuess, options);

end

function result = nonLinearSystem3Point(point, p1, p2, p3, d1, d2, d3)
    % Equations for the distances from the point to each of the three known grid locations
    result(1) = sqrt((point(1) - p1(1))^2 + (point(2) - p1(2))^2) - d1;
    result(2) = sqrt((point(1) - p2(1))^2 + (point(2) - p2(2))^2) - d2;
    result(3) = sqrt((point(1) - p3(1))^2 + (point(2) - p3(2))^2) - d3;
end

function result = nonLinearSystem2Point(point, p1, p2, d1, d2)
    % Equations for the distances from the point to each of the three known grid locations
    result(1) = sqrt((point(1) - p1(1))^2 + (point(2) - p1(2))^2) - d1;
    result(2) = sqrt((point(1) - p2(1))^2 + (point(2) - p2(2))^2) - d2;
end
