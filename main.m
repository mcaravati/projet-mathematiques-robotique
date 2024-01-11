clear all; close all; clc; clf;

hold on;
axis equal;

start = [0.5 0.5];
start_save = start;
destination = [2 0.5];

rectangle_pos = [1 0 0.75 0.75];

% Forbidden zones x
polygons_x = [
  [start(1) rectangle_pos(1) rectangle_pos(1) start(1)]; % Left triangle
  [start(1) rectangle_pos(1) rectangle_pos(1)+rectangle_pos(3) start(1)]; % Top triangle
  [start(1) rectangle_pos(1)+rectangle_pos(3) rectangle_pos(1)+rectangle_pos(3) start(1)]; % Right triangle
  [start(1) rectangle_pos(1) rectangle_pos(1)+rectangle_pos(3) start(1)]; % Bottom triangle
];

% Forbidden zones y
polygons_y = [
  [start(2) rectangle_pos(2)+rectangle_pos(4) rectangle_pos(2) start(2)]; % Left triangle
  [start(2) rectangle_pos(2)+rectangle_pos(4) rectangle_pos(2)+rectangle_pos(4) start(2)]; % Top triangle
  [start(2) rectangle_pos(2)+rectangle_pos(4) rectangle_pos(2) start(2)]; % Right triangle
  [start(2) rectangle_pos(2) rectangle_pos(2) start(2)]; % Bottom triangle
];

% Draw forbidden zones
for i = 1:size(polygons_x, 1)
  fill(polygons_x(i,:), polygons_y(i,:),'r');
endfor

function distance = points_distance(point_a, point_b)
    distance = sqrt(power(point_b(1) - point_a(1), 2) + power(point_b(2) - point_a(2), 2));
end

function inside = is_forbidden_point(point, polygons_x, polygons_y)
    inside = 0;

    for i = 1:size(polygons_x, 1)
      inside = inside | inpolygon([point(1)], [point(2)], polygons_x(i,:), polygons_y(i,:));
    endfor
end

function result = is_nearest(current, previous, dest)
    d_current = points_distance(current, dest);
    d_previous = points_distance(previous, dest);

    result = d_current < d_previous;
end

plot(start(1), start(2), '+r','MarkerSize', 30)
plot(destination(1), destination(2), '+r','MarkerSize', 30)
rectangle('Position', rectangle_pos, 'FaceColor', 'b');

% Robot's parameters
thetas_init = [deg2rad(90), 0, 0, 0, 0];
limbs_length = [1, 1, 1, 1, 1];
max_robot_length = sum(limbs_length);
num_steps = 10;
steps = [];

% Generate trajectory
for i = 1:num_steps
    % Parameters for the circle
    radius = 0.5;
    num_points = 50;

    % Generate random points inside the circle
    theta = 2 * pi * rand(1, num_points);
    r = radius * sqrt(rand(1, num_points));
    x = start(1) + r .* cos(theta);
    y = start(2) + r .* sin(theta);

    for j = 1:num_points
        proj = [x(j), y(j)];
        distance_from_start = points_distance(start_save, proj);

        if !is_forbidden_point(proj, polygons_x, polygons_y) && is_nearest(proj, start, destination) && distance_from_start > 0 && distance_from_start <= max_robot_length
          start = proj;
        endif
    endfor

    steps = [steps start'];
    plot(start(1), start(2), 'MarkerSize', 30)
end

% Make end effector follow the trajectory
thetas = thetas_init;
for i = 1:1
  thetas = newton_n(thetas, [steps(1,i), steps(2,i)]);
endfor

plot_robot(thetas);
