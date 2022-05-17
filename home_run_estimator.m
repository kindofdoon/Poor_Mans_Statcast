% function home_run_estimator

    % Estimates properties of a home run based on three x-y points
    
    %%
    
    clear
    clc
    
    %% Parabolic trajectory waypoints
    %  Units of ft
    
    x1 = 0;
    y1 = 2.5;
    x2 = 250;
    y2 = 10;
    x3 = 275;
    y3 = 0;
    
    %% Constants
    
    g = 32.22; % ft/s^2, gravitational acceleration
    
    fence_dist   = 250; % ft
    fence_height = 8;   % ft
    
    %% Graphics
    
    scatter_size = 125;
    inc = 25; % ft, increment for display
    fs  = 12; % font size
    
    %%
    
    % Solve for parabola using system of linear equations, matrix inversion
    A = [x1^2 x1 1; x2^2 x2 1; x3^2 x3 1];
    B = [y1 y2 y3]';
    X = inv(A) * B;
    a = X(1);
    b = X(2);
    c = X(3);
    
    % Height
    x_peak = -b/(2*a); % by setting dy/dx = 0
    y_peak = a*x_peak^2 + b*x_peak + c; % by substitution
    
    % Distance
    x_final = (-b - sqrt(b^2-4*a*c)) / (2*a); % quadratic equation
    y_final = 0;
    
    % Launch angle
    theta = atand(b);
    
    % Velocities
    dist_ascent = y_peak - y1;
    vy = sqrt(2*g*dist_ascent); % https://math.stackexchange.com/questions/785375/calculate-initial-velocity-to-reach-height-y
    v  = vy / sind(theta);
    vx = v * cosd(theta);
    
    % Time of flight
    t_flight = x_final / vx;
    
    %%
    
    figure(1)
    clf
    hold on
    set(gcf,'color','white')
    
    x_list = [x1 x2 x3];
    y_list = [y1 y2 y3];
    
    scatter(x_list, y_list, scatter_size, 'k.')
    
    for i = 1 : length(x_list)
        text(x_list(i), y_list(i), ['  ' num2str(x_list(i)) ', ' num2str(y_list(i))], 'Rotation', 90, 'HorizontalAlignment','left', 'VerticalAlignment','top', 'FontSize', fs)
    end
    
    scatter(x_peak, y_peak, scatter_size, 'k.')
    text(x_peak, y_peak, ['  (' num2str(x_peak,'%.1f') ', ' num2str(y_peak,'%.1f') ')'], 'Rotation', 90, 'HorizontalAlignment','left', 'VerticalAlignment','top', 'FontSize', fs)
    
    x = linspace(0, max([x1 x2 x3]), 1000);
    y = a.*x.^2 + b.*x + c;
    plot(x, y, 'k') % trajectory
    plot(fence_dist.*[1 1], [0 fence_height], 'LineWidth', 1, 'Color', 'k') % fence
    
    axis equal
    grid on
    grid minor
    x_max = ceil(max(xlim)/inc) * inc;
    y_max = ceil(max(ylim)/inc) * inc;
    set(gca,'xtick',0:inc:x_max)
    set(gca,'ytick',0:inc:y_max)
    axis([0 x_max 0 y_max])
    xlabel('X, ft')
    ylabel('Y, ft')
    
    lbl = {
            ['\bfDistance:     \rm' num2str(round(x_final)) ' ft' ]        
            ['\bfExit velo:    \rm' num2str(v * 0.6818,'%.1f') ' mph']
            ['\bfLaunch angle: \rm' num2str(round(theta)) '°']
            ['\bfApex:         \rm' num2str(round(y_peak)) ' ft']
            ['\bfFlight time:  \rm' num2str(t_flight,'%.1f') ' sec' ]
          };
      
    text(min(xlim)+2.5, max(ylim)-2.5, lbl, 'VerticalAlignment','top','HorizontalAlignment','left', 'FontName','FixedWidth', 'FontSize', fs)
    
    pos = get(gcf,'position');
    set(gcf,'position',[pos(1) 100 1000 500])
    
% end











































