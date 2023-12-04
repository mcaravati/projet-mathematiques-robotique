function thetas = newton_n(thetas_init, xy_target)
    thetas = thetas_init;
    xy_0 = forward_kinematics(thetas_init);
    xy_delta = xy_target-xy_0;
    while norm(xy_delta) > 0.1
        jacob = sym_jacobian(thetas(1), thetas(2), thetas(3), thetas(4), thetas(5), xy_0(1,1), xy_0(2, 1));
        [U,S,V] = svd(jacob);
        thetas_delta = pinv(jacob) * xy_delta; % + ...
        thetas = thetas + thetas_delta;
        xy_0 = forward_kinematics(thetas);
        xy_delta = xy_target-xy_0;
    end
end 