function [L_hat, m_hat, c_hat] = estimate_params(x_data, u_data, t_data, filter_params, measurable_x)

    l1 = filter_params(1); 
    l2 = filter_params(2);

    x1 = x_data(:,1);
    x2 = x_data(:,2);

    u = u_data; 
    ts = t_data;

    g = 9.81;


    if measurable_x
        %ζ1 filter -sQ(s)/Λ(s) = - X2(s)/Λ(s)
        num1 = [0 0 1]; 
        den1 = [1 l1 l2];
        H1 = tf(num1, den1);
        zeta1 = - lsim(H1, x2, ts);
    else 
        %ζ1 filter -sQ(s)/Λ(s) = - X2(s)/Λ(s)
        num1 = [0 1 0]; 
        den1 = [1 l1 l2];
        H1 = tf(num1, den1);
        zeta1 = - lsim(H1, x1, ts);
    end

    %ζ2 filter -Q(s)/Λ(s) = -X1(s)/Λ(s)
    num2 = [0 0 1]; 
    den2 = [1 l1 l2]; 
    H2 = tf(num2, den2); 
    zeta2 = - lsim(H2, x1,ts);

    %ζ3 filter U(s)/Λ(s)
    num3 = [0 0 1]; 
    den3 = [1 l1 l2]; 
    H3 = tf(num3, den3); 
    zeta3 = lsim(H3, u, ts);

    %regression matrix 
    X = [zeta1, zeta2, zeta3];

    %find theta_lambda
    theta_hat = (X' * X) \ X' * x1;
    L_hat = g / ( theta_hat(2) + l2 );
    m_hat = 1 / (L_hat^2 * theta_hat(3));
    c_hat = ( l1 + theta_hat(1) )/ theta_hat(3);

end