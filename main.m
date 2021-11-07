%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title        : Simple Linear Regression
% Author       : Azka Hariz
% Date         : November 7, 2021
% Code version : 1.1
% Availability : https://github.com/azkahariz/SimpleLinearRegression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all, close all, clc

%% Read data
Data = readtable('data.xlsx');

%% Linear Regression
n = size(Data.ObservationNumber,1);
sum_x    = sum(Data.X);
sum_y    = sum(Data.Y);
sum_xy   = Data.X'*Data.Y;
avg_x    = sum_x/n;
avg_y    = sum_y/n;
sum_sqrX = sum(Data.X'*Data.X);
sum_sqrY = sum(Data.Y'*Data.Y);
Sxx = sum_sqrX - sum_x^2/n;
Sxy = sum_xy  - (sum_x*sum_y)/n;
Beta1 = Sxy/Sxx;
Beta0 = avg_y - Beta1*avg_x;
x = min(Data.X):0.01:max(Data.X);
y_approx = Beta0 + Beta1*x;

%% Error dan variance
e = (Data.Y -  Beta0 - Beta1*Data.X);         % Residual
SSE = e'*e;                                   % Error sum of square
SSR = sum((Beta0 + Beta1*Data.X - avg_y).^2); % Regression sum of square
SST = SSE + SSR;                              % Total corrected sum of square
var = SSE/(n-2);                              % Estimator of variance

%% Hypotesis Test in Simple Linear Regression
MSR = SSR/1;               % Mean squares regression
MSE = SSE/(n-2);           % Mean squares error
F0  = MSR/MSE;             % Uji F-dist. hipotesis H0: B1 = 0;
t0  = Beta1/sqrt(var/Sxx); % Uji t-dist. hipotesis H0: B1 = 0;

%% Confidence Intervals 95%
% Confidence intervals on parameters
B1_min = Beta1 - 2.101*sqrt(var/Sxx);                   % B1 minimum
B1_max = Beta1 + 2.101*sqrt(var/Sxx);                   % B1 maksimum
B0_min = Beta0 - 2.101*sqrt(var*((1/n) + avg_x^2/Sxx)); % B0 minimum
B0_max = Beta0 + 2.101*sqrt(var*((1/n) + avg_x^2/Sxx)); % B0 minimum
% Confidence intervals on the mean response
x0_inp = input('Masukan nilai x0 untuk mencari confidence interval dari mean response : ');
y_min_x0  = Beta0 + Beta1*x0_inp - 2.101*sqrt(var*( (1/n) + (x0_inp-avg_x).^2/Sxx ));
y_max_x0  = Beta0 + Beta1*x0_inp + 2.101*sqrt(var*( (1/n) + (x0_inp-avg_x).^2/Sxx ));

x0 = min(Data.X):0.01:max(Data.X)';
y_min  = Beta0 + Beta1*x0 - 2.101*sqrt(var*( (1/n) + (x0-avg_x).^2/Sxx ));
y_max  = Beta0 + Beta1*x0 + 2.101*sqrt(var*( (1/n) + (x0-avg_x).^2/Sxx ));

%% Show output in command windows
fprintf('Persamaan linear reggression:\n');
fprintf('y = %.3f + %.3fx\n\n',Beta0,Beta1);

fprintf('Nilai SSE: %.3f\nNilai SSR: %.3f\nNilai SST: %.3f\n\n',SSE,SSR,SST);

fprintf('Uji significance of regression Beta1 (F-Distribution):\n');
fprintf('Nilai F0 : %.3f\n\n',F0);

fprintf('Uji significance of regression Beta1 (t-Distribution):\n');
fprintf('Nilai t0 : %.3f\n\n',t0);

fprintf('Confidence intervals 95%% on parameters:\n');
fprintf('%.3f < B1 < %.3f\n', B1_min, B1_max);
fprintf('%.3f < B0 < %.3f\n\n', B0_min, B0_max);

fprintf('Confidence intervals 95%% on the mean response x = %.3f:\n',x0_inp);
fprintf('%.3f < y < %.3f\n', y_min_x0, y_max_x0);

%% Plotting
figure(1)
plot(Data.X,Data.Y,'*');
grid on
hold on
plot(x,y_approx,'r');
hold on
plot(x0,y_min,'--g');
hold on
plot(x0,y_max,'--g');
xlabel('Hydrocarbon level (%),x');  % Kasih nama label untuk sumbu x
ylabel('Oxygen purity (%), y');     % Kasih nama label untuk sumbu y
legend('$y_{real}$', '$\hat{\mu}_{Y}$', '$\hat{\mu}_{Y|x_{0}} \pm t_{\alpha/2,n-2}\sqrt{V(\mu_{Y|x_{0}})}$', 'Interpreter', 'Latex','FontSize',12);