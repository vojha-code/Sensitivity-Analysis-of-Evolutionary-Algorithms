function [f,Q_sim,STATES,FLUXES]=hymod_MulObj(x,rain,evap,flow)
%
% This function runs the rainfall-runoff Hymod model
% and returns 2 metrics of model performance: RMSE and BIAS
%
% [f,Q_sim,STATES,FLUXES] = hymod_MulObj(param,rain,evap,flow)
% 
% Input:
% param = vector of model parameters (Smax,beta,alfa,Rs,Rf)  - vector (1,5)
%  rain = time series of rainfall                            - vector (T,1)
%  evap = time series of potential evaporation               - vector (T,1)
%  flow = time series of observed flow                       - vector (T,1)
%
%
% Output:
%      f = vector of objective functions (RMSE,BIAS)         - vector (1,2)
%  Q_sim = time series of simulated flow                     - vector (T,1)
% STATES = time series of simulated storages (all in mm)     - matrix (T,5)
% FLUXES = time series of simulated fluxes (all in mm/Dt)    - matrix (T,8)
%
% See also hymod_sim about the model parameters, simulated variables,
% and references.


M = 5 ; % number of model parameters
x = x(:);
if ~isnumeric(x); error('input argument ''param'' must be numeric'); end
if length(x)~=M; error('input argument ''param'' must have %d components',M); end

[Q_sim,STATES,FLUXES] = hymod_sim(x,rain,evap) ;

warmup = 30 ; % warmup period to be discarded

Qs = Q_sim(warmup+1:end);
Qo = flow(warmup+1:end);

f(1) = sqrt(mean((Qs - Qo).^2)) ; % RMSE
f(2) = abs(mean(Qs - Qo))       ; % BIAS


