function jac = sym_jacobian(q1, q2, q3, q4, q5, x, y)
    xy_qs = forward_kinematics([q1, q2, q3, q4, q5]);
    function_matrix = xy_qs - [x; y];
    jac = jacobian(function_matrix, [q1, q2, q3, q4, q5, x, y]);
end
