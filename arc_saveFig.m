function arc_saveFig(filename,meta)

set(findall(gcf,'-property','FontName'),'FontName','San Serif');

print(gcf,'-dpng',...
    [filename,'.png'])

% print(gcf,'-vector','-dpdf',...
%     [filename,'.pdf'])

exportgraphics(gcf,[filename,'.pdf'],... 
    'ContentType','vector',...
    'BackgroundColor','none')

end