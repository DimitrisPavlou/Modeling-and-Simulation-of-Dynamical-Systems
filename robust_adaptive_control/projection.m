function dX_proj = projection(X, dX, lb, ub)

    % Element-wise projection operator

    if isscalar(lb), lb = lb * ones(size(X)); end
    if isscalar(ub), ub = ub * ones(size(X)); end

    % Compute mask where projection is needed
    % if we are on the boundary with with the derivative pointing outwards
    % then zero out the derivative. Starting inside the convex set S that the
    % constraints create, then the chosen design will not let the
    % parameters escape S so this projection is correct.
    mask = (X <= lb & dX < 0) | (X >= ub & dX > 0); 

    % Apply projection
    dX_proj = dX;
    dX_proj(mask) = 0;

end
