function varargout = run_tests
% run all unit tests for settings handler
%
% function results = run_tests	
%
% No input arguments. Results printed to screen and optionally 
% returned to the workspace. 


testCase = core_tests;
results = run(testCase);
out{1}=results;


fprintf('\n------------------------  RESULTS  ------------------------\n')
for ii=1:length(out)
	disp(out{ii});
end
if nargout>0
	varargout{1}=out;
end
