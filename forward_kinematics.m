function end_effector_pos = forward_kinematics(thetas)
    % thetas: joint angles (column vector)

    % Define robot parameters (length of each link)
    l1 = 1; % length of link 1
    l2 = 1; % length of link 2
    l3 = 1; % length of link 3
    l4 = 1; % length of link 4
    l5 = 1; % length of link 5

    % Forward kinematics equations for a 2D manipulator
    x = l1 * cos(thetas(1)) + l2 * cos(thetas(1) + thetas(2)) + l3 * cos(sum(thetas(1:3))) + l4 * cos(sum(thetas(1:4))) + l5 * cos(sum(thetas(1:5)));
    y = l1 * sin(thetas(1)) + l2 * sin(thetas(1) + thetas(2)) + l3 * sin(sum(thetas(1:3))) + l4 * sin(sum(thetas(1:4))) + l5 * sin(sum(thetas(1:5)));

    end_effector_pos = [x; y];
end

