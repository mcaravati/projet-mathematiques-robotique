clear all; close all; clc; clf;

hold on;
axis equal;

global thetas_init;
global steps;
global slider;
global start start_save;
global polygons_x polygons_y;
global destination;
global rectangle_pos;

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

% Calculates the distance between two points
function distance = points_distance(point_a, point_b)
    distance = sqrt(power(point_b(1) - point_a(1), 2) + power(point_b(2) - point_a(2), 2));
end

% Checks if point is inside the forbidden zone
function inside = is_forbidden_point(point, polygons_x, polygons_y)
    inside = 0;

    for i = 1:size(polygons_x, 1)
      inside = inside | inpolygon([point(1)], [point(2)], polygons_x(i,:), polygons_y(i,:));
    endfor
end

% Check if the current point is nearer to the destination than the previous one
function result = is_nearest(current, previous, dest)
    d_current = points_distance(current, dest);
    d_previous = points_distance(previous, dest);

    result = d_current < d_previous;
end

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
end

% Create slider control to select the step you have to reach
slider = uicontrol('Style', 'slider', 'Min', 1, 'Max', num_steps, 'Value', 1, ...
    'Units', 'normalized', 'Position', [0.1, 0, 0.8, 0.1], ...
    'Callback', @sliderCallback);

function draw_init()
  global polygons_x polygons_y;
  global start_save;
  global destination;
  global rectangle_pos;
  global steps;

  cla;

  hold on;
  axis equal;

  plot(start_save(1), start_save(2), '+r','MarkerSize', 30)
  plot(destination(1), destination(2), '+r','MarkerSize', 30)
  rectangle('Position', rectangle_pos, 'FaceColor', 'b');

  % Draw forbidden zones
  for i = 1:size(polygons_x, 1)
    fill(polygons_x(i,:), polygons_y(i,:),'r');
  endfor

  % Use points to represent the trajectory's steps
  for i = 1:size(steps, 2)
    plot(steps(1, i), steps(2, i), 'MarkerSize', 30)
  endfor
end

draw_init();

% Callback function for the slider
function sliderCallback(src, event)
    global thetas_init;
    global steps;

    % Get the step you have to reach
    sliderValue = round(get(src, 'Value'));

    % Execute trajectory until selected step
    thetas = thetas_init;
    for i = 1:sliderValue
      thetas = newton_n(thetas, [steps(1,i), steps(2,i)]);
    endfor

    draw_init();
    plot_robot(thetas);
end

