function [result, A, b, proj] = line_point_svd_with_projection(a, c, random_vector)
    K = numel(a);

    A = zeros(K, 2);
    b = zeros(K, 1);
    random_vector = [rand(1); rand(1)];

    for i = 1:K
        A(i, :) = [sin(a(i)), -cos(a(i))];
        b(i) = sin(a(i)) * c(1) - cos(a(i)) * c(2);
    end

    result = A \ b;

    % Projection
    proj = ((eye(2) - A * pinv(A)) * random_vector)';
end

