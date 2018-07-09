function shift_fig(xd, yd, delta, deltaCI,x,y,ind,med)
% shift_fig(xd, yd, delta, deltaCI,x,y,ind,med)
% Plots a shift function using the outputs xd, delta and deltaCI from either
% shifthd, shiftdhd, shifthd_pbci, or shiftdhd_pbci.
% 
% INPUTS:
% - xd, delta, deltaCI = outputs from a shift function function
% - x & y are vectors of data used to create the shift function
% - ind = 1 if groups are independent (default), 0 otherwise
% - med = location of the median, default = empty, don't mark the median 
%
% See also SHIFTHD, SHIFTDHD, SHIFTHD_PBCI, SHIFTDHD_PBCI

% Copyright (C) 2016 Guillaume Rousselet - University of Glasgow
% GAR 2016-07-29 - first version

if nargin<7;ind=1;end
if nargin<8;med=[];end

if ind == 1
    label = 'group';
else
    label = 'condition';
end

Nq = numel(delta);
x = x(:);
y = y(:);

% add noise to create 1D scatterplots
ypts1 = UnivarScatter_nofig(x);
ypts2 = UnivarScatter_nofig(y)+1;

c = @cmu.colors;

figure('Color','w','NumberTitle','off')

subplot(2,1,1);hold on % 1D scatterplots
plot(x,ypts1,'ko','MarkerFaceColor',c('pastel orange'),'MarkerEdgeColor',[.95 .95 .95],'MarkerSize',10)
plot(y,ypts2,'ko','MarkerFaceColor',c('light blue'),'MarkerEdgeColor',[.95 .95 .95],'MarkerSize',10)
set(gca,'FontSize',14,'YTick',[1 2],'YTickLabel',{[label,' 1'];[label,' 2']})
box on
xlabel('Data','FontSize',16)
% superimpose quantiles
minp = min(min(ypts1),min(ypts2-1));
maxp = max(max(ypts1),max(ypts2-1));
for q=1:Nq
   plot([xd(q) xd(q)],[minp maxp],'Color',[.7 .7 .7],'LineWidth',1) 
   plot([yd(q) yd(q)],[minp+1 maxp+1],'Color',[.7 .7 .7],'LineWidth',1) 
end

if ~isempty(med)
    plot([xd(med) xd(med)],[minp maxp],'Color',[.7 .7 .7],'LineWidth',3) 
   plot([yd(med) yd(med)],[minp+1 maxp+1],'Color',[.7 .7 .7],'LineWidth',3) 
end

subplot(2,1,2);hold on % shift function

ext = 0.1*(max(xd)-min(xd));
plot([min(xd)-ext max(xd)+ext],[0 0],'LineWidth',1,'Color',[.5 .5 .5],'LineStyle','--') % zero line
for qi = 1:Nq % plot confidence intervals
    plot([xd(qi) xd(qi)],[deltaCI(qi,1) deltaCI(qi,2)],'Color',c('persian green'),'LineWidth',2)
end
if ~isempty(med) % mark median
    v = axis;plot([xd(med) xd(med)],[v(3) v(4)],'k--')    
end
% plot quantiles
plot(xd,delta,'Color',c('persian green'),'LineWidth',1)
plot(xd,delta,'Color',c('persian green'),'Marker','o','MarkerEdgeColor',c('persian green'),'MarkerFaceColor',[.95 .95 .95],'MarkerSize',10,'LineWidth',1)
set(gca,'FontSize',14,'XLim',[min(xd)-ext max(xd)+ext])
box on
xlabel([label,' 1 quantiles'],'FontSize',16)
ylabel([label,' 1 - ',label,' 2 quantiles'],'FontSize',16)

pos = get(gcf, 'Position');
set(gcf,'Position',[pos(1),pos(2),pos(3),pos(4)*1.5])


