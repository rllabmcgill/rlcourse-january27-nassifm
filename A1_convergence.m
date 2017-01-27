% Situation variables
% gamma: discount factor (will be changed in the simulations for loop)
% p: transition matrix
% R: expected reward for next transition
p = zeros(25);
R = zeros(25,1);
for i=[1:5, 5:5:25, 21:25, 1:5:21]
    p(i,i) = p(i,i) + 0.25;
    R(i) = R(i) - 0.25;
end
for i=6:25
    p(i,i-5) = 0.25;
end
for i=1:20
    p(i,i+5) = 0.25;
end
for i=1:25
    if mod(i,5) ~= 0
        p(i,i+1) = 0.25;
    end
    if mod(i,5) ~= 1
        p(i,i-1) = 0.25;
    end
end
for i=1:25
    p(i,2) = 0;
    p(i,4) = 0;
end
p(22,2) = 1;
p(14,4) = 1;
R(2) = 10;
R(4) = 5;

% ==========================================
% ================ EXP 1 ===================
% ==========================================
% Parameters
k = 101;
tests = [0.999 0.99 0.9 0.75 0.5 0.25 0.1 0.01 0.001];
err = zeros(length(tests),k);
% Simulations
for i=1:length(tests)
    gamma = tests(i);
    % Exact solution
    v_star = (eye(25) - gamma * p')^-1 * R;
    % Convergence
    v = zeros(25,1);
    for j=1:k
        err(i,j) = max(abs(v - v_star));
        v = R + gamma * p' * v;
    end
end

% ==========================================
% ================ EXP 2 ===================
% ==========================================
% Parameters
tests = 1 - 2.^(-15:-1);
lims = 10.^(-1:-1:-6);
iters = zeros(length(lims), length(tests));
% Simulations
for i=1:length(tests)
    gamma = tests(i);
    % Exact solution
    v_star = (eye(25) - gamma * p')^-1 * R;
    % Convergence
    v = zeros(25,1);
    j = 0;
    for l=1:length(lims)
        lim = lims(l);
        while max(abs(v - v_star)) > lim
            v = R + gamma * p' * v;
            j = j + 1;
        end
        iters(l,i) = j;
    end
end