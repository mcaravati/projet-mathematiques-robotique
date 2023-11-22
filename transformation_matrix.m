function A = transformation_matrix(theta, a)
    % Homogeneous transformation matrix for DH parameters
    A = [
          [cos(theta), -sin(theta), a*cos(theta)];
          [sin(theta), cos(theta), a*sin(theta)];
          [0, 0, 1]
        ];
end
