function [xkp,vkp,rk] = alphaBetaFilter(xm, dt, xk, vk, alpha, beta)
% alphaBetaFilter - alpha-beta filter for linear state estimation

% Inputs:
%     xm - measured system state (ie: position)
%     dt - delta time
%     xk - current system state (ie: position)
%     vk - current derivative of system state (ie: velocity)
% Outputs:
%    xkp - next system state (ie: position)
%    vkp - next derivative of system state (ie: velocity)
%     rk - residual error

% Author: Marco Borges, Ph.D. Student, Computer/Biomedical Engineer
% UFMG, PPGEE, Neurodinamica Lab, Brazil
% email address: marcoafborges@gmail.com
% Website: http://www.cpdee.ufmg.br/
% June 2013; Version: v1; Last revision: 2013-09-18
% Changelog:

xkp = xk + dt * vk;         % update estimated state x from the system
vkp = vk;                   % update estimated velocity
rk = xm - xkp;              % residual error
xkp = xkp + alpha * rk;     % update our estimates
vkp = vkp + beta/dt * rk;   %    given residual error
end