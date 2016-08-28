classdef core_tests < matlab.unittest.TestCase
	% Unit tests for notBoxPlot

	properties

	end %properties


	methods (Test)

		function checkForNonLegacyCall(testCase)
			% Legacy function calls take the form: notBoxPlot(y,x,jitter,style)
			% From release v1.2 the form is  notBoxPlot(y,x,'param','val',...)
			% Here we test that NBP is correctly able to find non-legacy usage
			y=rand(10,2);
			x=1:2;

			clf
 			[~,legacyCall] = notBoxPlot(y);
 			testCase.verifyTrue(legacyCall == false);

			clf
 			[~,legacyCall] = notBoxPlot(y,x);
 			testCase.verifyTrue(legacyCall == false);

			clf
 			[~,legacyCall] = notBoxPlot(y,x,'jitter',0.3);
 			testCase.verifyTrue(legacyCall == false);

			clf
 			[~,legacyCall] = notBoxPlot(y,x,'style','patch');
 			testCase.verifyTrue(legacyCall == false);

			clf
 			[~,legacyCall] = notBoxPlot(y,x,'style','line','jitter',0.2);
 			testCase.verifyTrue(legacyCall == false);

 			close(gcf)
		end

		function checkForLegacyCall(testCase)
			% Legacy function calls take the form: notBoxPlot(y,x,jitter,style)
			% From release v1.2 the form is  notBoxPlot(y,x,'param','val',...)
			% Here we test that NBP is correctly able to find legacy usage
			y=rand(10,2);
			x=1:2;

			clf
 			[~,legacyCall] = notBoxPlot(y,[],0.3);
 			testCase.verifyTrue(legacyCall == true);

			clf
 			[~,legacyCall] = notBoxPlot(y,[],[],'line');
 			testCase.verifyTrue(legacyCall == true);

			clf
 			[~,legacyCall] = notBoxPlot(y,x,0.2,'line');
 			testCase.verifyTrue(legacyCall == true);

 			close(gcf)
		end

		function checkForMixedCalls(testCase)
			% Legacy function calls take the form: notBoxPlot(y,x,jitter,style)
			% From release v1.2 the form is  notBoxPlot(y,x,'param','val',...)
			% Here we test that NBP is correctly able to catch erroneous mixed usage
			y=rand(10,2);
			x=1:2;

			clf
 			testCase.verifyError(@() notBoxPlot(y,x,0.3,'style','line'),'notBoxPlot:legacyError')

			clf
 			testCase.verifyError(@() notBoxPlot(y,x,'style','line',0.3),'notBoxPlot:legacyError')

 			close(gcf)
		end

	end %methods (Test)

end %classdef core_tests < matlab.unittest.TestCase