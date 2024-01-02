function angle = position_to_angle(start, destination)
    % Calculates the angle (in radians) between a starting point and a destination point

    % Calculate the displacement vector
    displacement = destination - start;

    % Use atan2 to get the angle
    angle = atan2(displacement(2), displacement(1)) * pi;
end

