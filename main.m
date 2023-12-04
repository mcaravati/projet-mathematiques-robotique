clear all; close all; clc; clf;

%pkg load symbolic;

hold on;
axis equal;

x_offset = 0;
y_offset = 0;

destination = [4., 0.5];

radius = destination(1);
nb_points=5;

theta = linspace(0, pi/2, nb_points);

x = radius * cos(theta) + x_offset;
y = radius * sin(theta) + y_offset;

% x = flip(x);
% y = flip(y);

% Add destination point to the curve
% x = [destination(1), x];
% y = [destination(2), y];

plot(x, y, 'o');

thetas_init = [deg2rad(90), 0, 0, 0, 0];

rectangle('Position',[1 0 0.75 0.75]);
thetas = thetas_init;

display(x);
display(y);

for i=nb_points:-1:2
    thetas = newton_n(thetas, [x(i); y(i)]);
end
plot_robot(thetas); % Vertical position


