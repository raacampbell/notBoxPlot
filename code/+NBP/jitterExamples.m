function jitterExamples

% 
% % Jitter examples 
% % default jitter is 0.3
%
% clf
%
% R = randn(20,5);
%
% subplot(2,1,1)
% notBoxPlot(R,'jitter',0.15)
%
% subplot(2,1,2)
% notBoxPlot(R,'jitter',0.75);
%

help(['NBP.',mfilename])

clf

R = randn(20,5);

subplot(2,1,1)
notBoxPlot(R,'jitter',0.15)

subplot(2,1,2)
notBoxPlot(R,'jitter',0.75);


