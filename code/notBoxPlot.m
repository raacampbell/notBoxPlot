function varargout=notBoxPlot(y,x,varargin)
% notBoxPlot - Doesn't plot box plots!
%
% function notBoxPlot(y,x,'Param1',val1,'Param2',val2,...)
%
%
% Purpose
% An alternative to a box plot, where the focus is on showing raw
% data. Plots columns of y as different groups located at points
% along the x axis defined by the optional vector x. Points are
% layed over a 1.96 SEM (95% confidence interval) in red and a 1 SD
% in blue. The user has the option of plotting the SEM and SD as a
% line rather than area. Raw data are jittered along x for clarity. This
% function is suited to displaying data which are normally distributed.
% Since, for instance, the SEM is meaningless if the data are bimodally
% distributed. 
%
%
% Inputs
% y - A vector, matrix, or table of the data to plot. 
%      * vector and no x is provided: all data are grouped at one x position.
%      * matrix and no x is provided: each column is plotted in a different x position. 
%      * vector with x grouping variable provided: data grouped accordig to x
%      * a table is treated such that the first column is y and the second x.
%
% x - [optional], the x axis points at which y columns should be
%     plotted. This allows more than one set of y values to appear
%     at one x location. Such instances are coloured differently. 
%     Contrast the first two panels in Example 1 to see how this input behaves.
%     x need not be provided if y is a table.
%
% Note that if x and y are both vectors of the same length this function
% behaves like boxplot (see Example 5).
%
%
% Parameter/Value paies
% 'jitter' - how much to jitter the data for visualization
%          (optional). The width of the boxes are automatically
%          scaled to the jitter magnitude. If jetter is empty or
%          missing then a default value is used. 
%
% 'style' - a string defining plot style of the data.
%        'patch' [default] - plots 95% SEM (by default, see below) and SD as a 
%                box using patch objects. 
%        'line' - create a plot where the SD and 95% SEM (see below) are
%                constructed from lines. 
%        'sdline' - a hybrid of the above, in which only the SD is 
%                replaced with a line.
%
% 'interval' - 'SEM' [default] Plots a 95% confidence interval for the mean
%            - 'tInterval' Plots a 95% t-interval for the mean
%
% 'markMedian' - false [default] if true the median value is highlighted
%                The median is highlighted as a dotted line or an open square 
%                (if "line" style was used).
%
%
% Outputs (all area optional)
% H - structure of handles for plot objects.
% stats - the values of the mean, SD, etc, used for the plots
% 
%
% 
%
% Example 1 - simple example
% clf 
% subplot(2,2,1)  
% notBoxPlot(randn(20,5));
% subplot(2,2,2)  
% notBoxPlot(randn(20,5),[1:4,7]);
% subplot(2,2,3:4)
% h=notBoxPlot(randn(10,40));
% d=[h.data];
% set(d(1:4:end),'markerfacecolor',[0.4,1,0.4],'color',[0,0.4,0])
%
% Example 2 - overlaying with areas
% clf
% x=[1,2,3,4,5,5];
% y=randn(20,length(x));
% y(:,end)=y(:,end)+3;
% y(:,end-1)=y(:,end-1)-1;
% notBoxPlot(y,x);
%
% Example 3 - lines
% clf
% H=notBoxPlot(randn(20,5),[],'style','line');
% set([H.data],'markersize',10)
%
% Example 4 - mix lines and areas [note that the way this function
% sets the x axis limits can cause problems when combining plots
% this way]
%
% clf
% h=notBoxPlot(randn(10,1)+4,5,'style','line');
% set(h.data,'color','m')  
% h=notBoxPlot(randn(50,10));
% set(h(5).data,'color','m')
%  
% Example 5 - x and y are vectors
% clf
% x=[1,1,1,3,2,1,3,3,3,2,2,3,3];
% y=[7,8,6,1,5,7,2,1,3,4,5,2,4];
% notBoxPlot(y,x);
% 
% Note: an alternative to the style used in Example 5 is to call
% notBoxPlot from a loop in an external function. In this case, the
% user will have to take care of the x-ticks and axis limits. 
%
% Example 6 - replacing the SD with bars
% clf
% y=randn(50,1);
% clf
% notBoxPlot(y,1,'style','sdline')
% notBoxPlot(y,2)   
% xlim([0,3])
%
%
% Example 7 - the effect of jitter (default jitter is 0.3)
% clf
% subplot(2,1,1)
% notBoxPlot(randn(20,5),[],'jitter',0.15)
% subplot(2,1,2)
% notBoxPlot(randn(20,5),[],'jitter',0.75);
%
% 
% Example 8 - The 95% SEM vs the 95% t-interval
% clf
% y=randn(8,3);
% subplot(1,2,1)
% notBoxPlot(y), title('95% SEM (n=8)')
%
% subplot(1,2,2)
% notBoxPlot(y,[],'interval','tInterval'), title('95% t-interval (n=8)')
%
%
% Example 9 - Add the median (dotted line) to plots
% clf
% n=[5,10,20,40];
% for ii=1:4, rng(555), notBoxPlot(rand(1,n(ii)),ii,'markMedian',true), end
%
%
% Example 10 - Table call format
% clf
% albert=[1,1,1,3,2,1,3,3,3,2,2,3,3]';
% victoria=[7,8,6,1,5,7,2,1,3,4,5,2,4]';
% M = table(victoria,albert); %place data in first column and groups in the second
% notBoxPlot(M)
%
% Example 11 - Table call format with optional arguments
% clf
% albert=[1,1,1,3,2,1,3,3,3,2,2,3,3]';
% victoria=[7,8,6,1,5,7,2,1,3,4,5,2,4]';
% M = table(victoria,albert); %place data in first column and groups in the second
% notBoxPlot(M,'jitter',0.75)
%
%
% Rob Campbell - August 2016
%
% Also see: NBP.example, boxplot




% Check input arguments
if nargin==0
    help(mfilename)
    return
end


%Handle table call 
if istable(y)

    tableCall=true;
    if nargin>1 %so user doesn't need to specify a blank variable for x
        if ~isempty(x)
            varargin = [x,varargin];
        end
    end
    thisTable=y;
    varNames=thisTable.Properties.VariableNames;
    if length(varNames) ~= 2
        fprintf('% s can only handle tables with two variables\n',mfilename)
        return
    end
    y = thisTable.(varNames{1});
    x = thisTable.(varNames{2});

else
    tableCall=false;

    if isvector(y)
        y=y(:); 
    end

    % Handle case where user doesn't supply X, but have user param/val pairs. e.g.
    % notBoxPlot(rand(20,5),'jitter',0.5)
    if nargin>2 && ischar(x)
        varargin = [x,varargin];
        x=[];
    end

    % Generate an monotonically increasing X variable if the user didn't supply anything
    % for the grouping variable
    if nargin<2 || isempty(x)
        x=1:size(y,2);
    end
end

%If x is logical then the function fails. So let's make sure it's a double
x=double(x);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Parse input arguments
params = inputParser;
params.CaseSensitive = false;
params.addParameter('jitter', 0.3, @(x) isnumeric(x) & isscalar(x));
params.addParameter('style','patch', @(x) ischar(x) && any(strncmp(x,{'patch','line','sdline'},inf)) ); 
params.addParameter('interval','SEM', @(x) ischar(x) && any(strncmp(x,{'SEM','tInterval'},inf)) ); 
params.addParameter('markMedian', false, @(x) islogical(x));

params.parse(varargin{:});

%Extract values from the inputParser
jitter     = params.Results.jitter;
style      = params.Results.style;
interval   = params.Results.interval;
markMedian = params.Results.markMedian;

%Set interval function
switch interval
    case 'SEM'
        intervalFun = @NBP.SEM_calc;
    case 'tInterval'
        intervalFun = @NBP.tInterval_calc;
    otherwise
        error('Interval %s is unknown',interval)
end




if jitter==0 && strcmp(style,'patch') 
    warning('A zero value for jitter means no patch object visible')
end


if isvector(y) && isvector(x) && length(x)>1
    x=x(:);
   
    if length(x)~=length(y)
        error('length(x) should equal length(y)')
    end

    u=unique(x);
    for ii=1:length(u)
        f = x==u(ii);
        h(ii)=notBoxPlot(y(f),u(ii),varargin{:}); %recursive call
    end


    %Make plot look pretty
    if length(u)>1
        xlim([min(u)-1,max(u)+1])
        set(gca,'XTick',u)
    end

    if nargout==1
        varargout{1}=h;
    end

    %If we had a table we can label the axes
    if tableCall
        ylabel(varNames{1})
        xlabel(varNames{2})
    end

    return

end

 
if length(x) ~= size(y,2)
    error('length of x doesn''t match the number of columns in y')
end




%We're going to render points with the same x value in different
%colors so we loop through all unique x values and do the plotting
%with nested functions. No clf in order to give the user more
%flexibility in combining plot elements.
hold on
[uX,a,b]=unique(x);


H=[];
stats=[];
for ii=1:length(uX)
    f=b==ii;
    [hTemp,statsTemp]=myPlotter(x(f),y(:,f));
    H = [H,hTemp];
    stats = [stats,statsTemp];
end

hold off

%Tidy up plot: make it look pretty 
if length(x)>1
    set(gca,'XTick',unique(x))
    xlim([min(x)-1,max(x)+1])
end


%handle the output arguments
if nargout>0
    varargout{1}=H;
end

if nargout>1
    varargout{2}=stats;
end




%Nested functions follow


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h,statsOut]=myPlotter(X,Y)

    SEM=intervalFun(Y); %Supplied external function
    SD=std(Y,'omitnan');  %Requires the stats toolbox 
    mu=mean(Y,'omitnan'); %Requires the stats toolbox 
    if markMedian
       med = median(Y,'omitnan');
    end



    %The plot colors to use for multiple sets of points on the same x
    %location
    cols=hsv(length(X)+1)*0.5;
    cols(1,:)=0;
    jitScale=jitter*0.55; %To scale the patch by the width of the jitter

    for k=1:length(X)
        thisY=Y(:,k);
        thisY=thisY(~isnan(thisY));    
        thisX=repmat(X(k),1,length(thisY));

        %Assemble stats for optional command line output
        statsOut(k).mu = mu(k);
        statsOut(k).interval = SEM(k);
        statsOut(k).sd = SD(k);


        %Add the SD as a patch if the user asked for this
        if strcmp(style,'patch') 
            h(k).sdPtch=patchMaker(SD(k),[0.6,0.6,1]);
        end

        %Build patch surfaces for SEM, the means, and optionally the medians
        if strcmp(style,'patch') || strcmp(style,'sdline')
            h(k).semPtch=patchMaker(SEM(k),[1,0.6,0.6]);
            h(k).mu=plot([X(k)-jitScale,X(k)+jitScale],[mu(k),mu(k)],'-r',...
                'linewidth',2);
            if markMedian
                statsOut(k).median = med(k);
                h(k).med=plot([X(k)-jitScale,X(k)+jitScale],[med(k),med(k)],':r',...
                    'linewidth',2);
            end
        end
        
        %Overlay the jittered raw data
        C=cols(k,:);
        J=(rand(size(thisX))-0.5)*jitter;
            
        h(k).data=plot(thisX+J, thisY, 'o', 'color', C,...
                       'markerfacecolor', C+(1-C)*0.65);
    end  %for k=1:length(X)


    %Plot SD as a line
    if strcmp(style,'line') || strcmp(style,'sdline')
        for k=1:length(X)
            h(k).sd=plot([X(k),X(k)],[mu(k)-SD(k),mu(k)+SD(k)],...
                      '-','color',[0.2,0.2,1],'linewidth',2);
            set(h(k).sd,'ZData',[1,1]*-1)
        end
    end


    %Plot mean and SEM as a line, the means, and optionally the medians
    if strcmp(style,'line')
        for k=1:length(X)

            h(k).mu=plot(X(k),mu(k),'o','color','r',...
                'markerfacecolor','r',...
                'markersize',10);

            h(k).sem=plot([X(k),X(k)],[mu(k)-SEM(k),mu(k)+SEM(k)],'-r',...
                'linewidth',2);   
            if markMedian
                h(k).med=plot(X(k),med(k),'s','color',[0.8,0,0],...
                'markerfacecolor','none',...
                'lineWidth',2,...
                'markersize',12);
            end

             h(k).xAxisLocation=x(k);
        end
    end % if strcmp(style,'line')

    for ii=1:length(h)
        h(ii).interval=interval;
    end



    function ptch=patchMaker(thisInterval,color)
        %This nested function builds a patch for the SD or SEM
        l=mu(k)-thisInterval;
        u=mu(k)+thisInterval;
        ptch=patch([X(k)-jitScale, X(k)+jitScale, X(k)+jitScale, X(k)-jitScale],...
                [l,l,u,u], 0);
        set(ptch,'edgecolor',color*0.8,'facecolor',color)
    end %function patchMaker



end %function myPlotter






end %function notBoxPlot
