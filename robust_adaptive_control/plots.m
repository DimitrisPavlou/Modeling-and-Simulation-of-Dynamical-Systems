function plots(t, z, plot_title) 
    

    if nargin < 3
        plot_title = "";
    end
    % Unpack results
    x = z(:, 1:2);
    xhat = z(:, 3:4);
    A = z(:, 5:8);
    B = z(:, 9:10);
    a11_hat = A(:,1); 
    a12_hat = A(:,2); 
    a21_hat = A(:,3); 
    a22_hat = A(:,4); 
    b1_hat = B(:,1); 
    b2_hat = B(:,2);
    %compute output error 
    error_pos1 = x(:,1) - xhat(:,1);
    % Plotting
    
    figure;
    plot(t, x(:,1),LineWidth=1.5);
    hold on;
    plot(t, xhat(:,1), 'LineStyle', '--', 'LineWidth',2, Color = "#FF0000");
    legend('$x_1$','$\hat{x_1}$', 'interpreter', 'latex', 'FontSize', 12); 
    ylabel('Value', 'FontSize',12);
    xlabel("Time (s)");
    title("Estimation of $x_1(t)$ " + plot_title, 'Interpreter','latex', 'FontSize',12); 
    grid on; 
    
    figure;
    plot(t, error_pos1, LineWidth = 1.5);
    xlabel("Time (s)");
    ylabel('Value');
    legend("$e_1 = x_1(t) - \hat{x_1}(t)$", 'Interpreter','latex', 'FontSize',12);
    title("Modeling Error " + plot_title);
    grid on;
    
    figure;
    yline(-2.15, 'r--', LineWidth=1.5);
    hold on;
    plot(t, a11_hat, LineWidth = 1.5); 
    title("Parameter a11 Convergence " + plot_title);
    legend("$a_{11}$", "$\hat{a}_{11}(t)$", 'interpreter', 'latex','FontSize',12);
    grid on;
   
    
    figure; 
    yline(0.25, 'r--', LineWidth=1.5);
    hold on;
    plot(t, a12_hat, LineWidth = 1.5); 
    title("Parameter a12 Convergence " + plot_title) ;
    legend("$a_{12}$", "$\hat{a}_{12}(t)$", 'interpreter', 'latex','FontSize',12);
    grid on;
    
    figure; 
    
    yline(-0.75, 'r--', LineWidth=1.5);
    hold on;
    plot(t, a21_hat, LineWidth = 1.5); 
    title("Parameter a21 Convergence " + plot_title);
    legend("$a_{21}$", "$\hat{a}_{21}(t)$", 'interpreter', 'latex','FontSize',12, 'location', 'east');
    grid on;

    
    figure;
    
    yline(-2, 'r--', LineWidth=1.5);
    hold on;
    plot(t, a22_hat, LineWidth = 1.5); 
    title("Parameter a22 Convergence " + plot_title);
    legend("$a_{22}$", "$\hat{a}_{22}(t)$", 'interpreter', 'latex','FontSize',12);
    grid on;
    
    figure; 
    yline(0, 'r--', LineWidth=1.5);
    hold on;
    plot(t, b1_hat, LineWidth = 1.5); 
    title("Parameter b1 Convergence " + plot_title);
    legend("$b_{1}$", "$\hat{b}_{1}(t)$", 'interpreter', 'latex','FontSize',12, 'location', 'east');
    grid on;
 
    
    figure; 
    yline(1.5, 'r--', LineWidth=1.5);
    hold on;
    plot(t, b2_hat, LineWidth = 1.5); 
    title("Parameter b2 Convergence " + plot_title);
    legend("$b_{2}$", "$\hat{b}_{2}(t)$", 'interpreter', 'latex','FontSize',12);
    grid on;


end