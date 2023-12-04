function plot_robot(theta)
    % Plot the robot given joint angles

    % Set up the figure
    grid on;

    % DH parameters
    L = [1, 1, 1, 1, 1]; % Replace with your actual link lengths
    a = [0, L(1), L(2), L(3), L(4), L(5)]; % link lengths

    % Initialize transformation matrix
    T = eye(3);

    % Plot the robot links
    for i = 1:length(theta)
        % Update the transformation matrix
        T = T * transformation_matrix(theta(i), a(i));

        % Extract the joint position
        joint_position = T(1:2, 3);

        % Plot the link
        if i < length(theta)
            length(theta)
            length(a)
            tmp = T * transformation_matrix(theta(i+1), a(i+1));
            next_joint_position = tmp(1:2, 3);
            plot([joint_position(1), next_joint_position(1)], [joint_position(2), next_joint_position(2)], 'bo-');
        end

        % Plot the joint
        plot(joint_position(1), joint_position(2), 'ro');
    end

    % Plot the end-effector position
    end_effector_position = forward_kinematics(theta);
    plot(end_effector_position(1), end_effector_position(2), 'go', 'MarkerSize', 10);

    % Set axis labels
    xlabel('X');
    ylabel('Y');

    % Show the plot
    title('Robot Manipulator');
    hold off;
end

