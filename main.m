clear all; close all; clc; clf;

hold on;
axis equal;

start = [0 0.5];
destination = [2 0.5];

rectangle_pos = [1 0 0.75 0.75];

polygon_x = [start(1), rectangle_pos(1), rectangle_pos(1) + rectangle_pos(3), rectangle_pos(1) + rectangle_pos(3), rectangle_pos(1), start(1)];
polygon_y = [start(2), rectangle_pos(2) + rectangle_pos(4), rectangle_pos(2) + rectangle_pos(4), rectangle_pos(2), rectangle_pos(2), start(2)];

plot(polygon_x, polygon_y, '.r');
fill(polygon_x,polygon_y,'r');
rectangle('Position', rectangle_pos);



function inside = is_in_rectangle(x, rectangle_pos)
    inside = (x(1) >= rectangle_pos(1)) && (x(1) <= rectangle_pos(1) + rectangle_pos(3)) && ...
             (x(2) >= rectangle_pos(2)) && (x(2) <= rectangle_pos(2) + rectangle_pos(4));
end

plot(start(1), start(2), '+r','MarkerSize', 30)

for i = 1:4
    angle = position_to_angle(start, destination)
    rad2deg(angle)
    proj = line_point_svd_with_projection(angle, start);
    % Move the projected point away from the rectangle if it's inside
    while is_in_rectangle(proj, rectangle_pos)
        % Calculate the vector from the projected point to the rectangle center
        vec_to_center = [rectangle_pos(1) + rectangle_pos(3)/2 - proj(1); rectangle_pos(2) + rectangle_pos(4)/2 - proj(2)]

        % Calculate the normal vector to the rectangle boundary
        normal_vec = [-vec_to_center(2); vec_to_center(1)];

        % Normalize the normal vector
        normal_vec = vec_to_center / norm(vec_to_center);

        % Move the projected point away from the rectangle along the boundary
        proj = proj + 0.01 * vec_to_center; % Adjust the factor as needed
    end

    start = proj;
    plot(proj(1), proj(2), 'MarkerSize', 30)
end



