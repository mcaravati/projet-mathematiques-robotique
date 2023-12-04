function end_effector_position = forward_kinematics(theta)
    display(theta);
    % DH parameters
    L = [1, 1, 1, 1, 1]; % Replace with your actual link lengths
    a = [0, L(1), L(2), L(3), L(4)]; % link lengths

    % Compute transformation matrices
    T01 = transformation_matrix(theta(1), a(1));
    T12 = transformation_matrix(theta(2), a(2));
    T23 = transformation_matrix(theta(3), a(3));
    T34 = transformation_matrix(theta(4), a(4));
    T45 = transformation_matrix(theta(5), a(5));

    % Compute the overall transformation matrix
    T = T01 * T12 * T23 * T34 * T45;
    end_effector_position = T(1:2, 3);
end
