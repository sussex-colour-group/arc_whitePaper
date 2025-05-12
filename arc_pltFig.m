function arc_pltFig(filename,meta)

set(findall(gcf,'-property','FontName'),'FontName','San Serif');

% print(gcf,'-vector','-dsvg',...
%     [saveLocation,filename,'_',meta.figType,'.svg'])

print(gcf,'-dpng',...
    [filename,'_',meta.figType,'.png'])

end