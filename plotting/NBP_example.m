function NBP_example

clf 

subplot(2,2,1)  
r=randn(10,5);
for ii=1:5
  r(:,ii)=r(:,ii)+ii*0.3;
end
H=notBoxPlot(r,[],0.5);



subplot(2,2,2)
r=randn(10,25);
r(:,1:4:end)=0.75*r(:,1:4:end)+1.75;
H=notBoxPlot(r);
d=[H.data];
set(d(1:4:end),'markerfacecolor',[0.4,1,0.4],'color',[0,0.4,0])
set(gca,'XTick',[]) 
set([H.data],'MarkerSize',3,'LineWidth',0.5)


subplot(2,2,3)
x=[1,2,3,3];
y=randn(20,length(x));
y(:,end)=0.5*y(:,end)+4;
y(:,end-1)=y(:,end-1)-1;
y(1:8,end-1:end)=nan;

H=notBoxPlot(y,x,0.6,'sdline');
set(H(end).data,'Marker','^','MarkerSize',5)


subplot(2,2,4)
H=notBoxPlot(randn(10,1)+7,5,[],'line');
set(H.data,'color','b','Marker','.') 

r=randn(20,10);
for ii=1:10
  r(:,ii)=r(:,ii)+ii*0.65;
end

H=notBoxPlot(r,[],0.5);
set([H.data],'color',[1,1,1]*0.35,'marker','.')
set([H.mu],'color','w')
J=jet(length(H));
for ii=1:length(H)
  set(H(ii).sdPtch,'FaceColor',J(ii,:),...
                   'EdgeColor',J(ii,:)*0.6)

  set(H(ii).semPtch,'FaceColor',J(ii,:)*0.3,...
                   'EdgeColor','none')
  
end
box on
set(gca,'TickDir','Out')

