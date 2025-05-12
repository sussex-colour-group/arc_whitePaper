function arc_pltFig(filename,meta)

set(findall(gcf,'-property','FontName'),'FontName','San Serif');

% print(gcf,'-vector','-dsvg',...
%     [saveLocation,filename,'_',meta.figType,'.svg'])

print(gcf,...
    [saveLocation,filename,'_',meta.figType,'.png'])

end