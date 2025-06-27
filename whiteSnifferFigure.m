function whiteSnifferFigure(data,meta,paths)

%%

figure("Position",meta.figSize); hold on
t = tiledlayout(2,2,"TileSpacing","tight");

for location = [0,1]
    n{location+1} = nexttile(t);
    hold on

    arc_2Dhist(data.PP(1,data.PP(5,:) == location),...
        data.PP(2,data.PP(5,:) == location),...
        meta);

    [~,xneg] = compute95pctCI(data.PP(1,data.PP(5,:) == location));
    xpos = xneg;
    [~,yneg] = compute95pctCI(data.PP(2,data.PP(5,:) == location));
    ypos = yneg;

    errorbar(mean(data.PP(1,data.PP(5,:) == location),"omitnan"),...
        mean(data.PP(2,data.PP(5,:) == location),"omitnan"),...
        yneg,ypos,xneg,xpos,...
        'x','Color','k','MarkerEdgeColor',meta.pltCols{location+1},...
        'DisplayName',meta.locationNames{location+1})

    xlabel('L/(L+M)','FontSize',meta.fontSize.big)
    ylabel('S/(L+M)','FontSize',meta.fontSize.big)

    title(meta.locationNames{location+1},...
        'FontSize',meta.fontSize.big,'FontWeight','normal')

end

% add outline
threshVal = 0; % 0 includes all the data, 85 seems like an OK value for excluding noise (excludes points in the histmatrix that are below the 85% percentile value)
for location = [0,1]
    histmatrix = histcounts2(data.GoPro(1,data.GoPro(5,:) == location),data.GoPro(2,data.GoPro(5,:) == location),...
        'XBinEdges',meta.edges{1,1},'YBinEdges',meta.edges{1,2})';
    histmatrix = histmatrix > prctile(histmatrix,threshVal,"all");
    histmatrix_big = imresize(histmatrix,100,"nearest");
    B = bwboundaries(histmatrix_big);
    axes('xlim',[1,size(histmatrix_big,1)],'ylim',[1,size(histmatrix_big,2)],...
        "Color","none",...
        "Position",n{location+1}.Position,"Visible","off")
    hold on
    for k = 1:length(B)
        plot(B{k}(:,2), B{k}(:,1),'Color',[1,1,1]) % TODO These values probably need offsetting ever so slightly to actually match, following through the the imresize etc. It might be good enough for visualisation purposes though.
    end
end

set(gcf,"InvertHardcopy","off") % required to make the white line white when saving (wtf matlab?)

%% Visual comparison check

% figure("Position",meta.figSize); hold on
% tiledlayout(1,2)
%
% meta.figType = "grayscale";
%
% for location = [0,1]
%     nexttile, hold on
%
%     arc_2Dhist(data.GoPro(1,data.GoPro(5,:) == location),...
%         data.GoPro(2,data.GoPro(5,:) == location),...
%         meta);
%
% end

%% white sniffer fig

fromScratch = false;

if fromScratch
    load(paths.GoProProcessedData_whiteSniffer,"fileList");

    satVal = 15000; % this value chosen based on gae_satPixelount analysis, it works on the RGB values, not the calibrated saturation as it is about saturated sensor
    drkVal = 15; % this value may need revising, it works on the RGB values, not the calibrated luminance as it is about sensor noise

    addpath(genpath('imageanalysis'));

    RGBs=SelectRGBs('DC13102022');
    LMS=SelectConeFundamentals('StockmanMacleodJohnson');
    [RGB2LMS,LMS2RGB]=RGBToLMS(LMS,RGBs,0);

    num_images_to_call_oslo_white=20;
    num_images_to_call_tromso_white=37;

    whiteSnifferSum_o = [fileList.whiteSnifferSum_o];
    whiteSnifferSum_t = [fileList.whiteSnifferSum_t];

    [~,I] = maxk(whiteSnifferSum_o,num_images_to_call_oslo_white);
    lotsOfWhite_o = zeros(1,size(whiteSnifferSum_o,2));
    lotsOfWhite_o(I) = 1;

    [~,I] = maxk(whiteSnifferSum_t,num_images_to_call_tromso_white);
    lotsOfWhite_t = zeros(1,size(whiteSnifferSum_t,2));
    lotsOfWhite_t(I) = 1;

    % lotsOfWhite_o = whiteSnifferSum_o > 920000;
    OsloInd = strcmp({fileList.location},'Oslo');
    %
    % lotsOfWhite_t = whiteSnifferSum_t > 200000;
    TromsoInd = strcmp({fileList.location},'Tromso');

    median(whiteSnifferSum_o(OsloInd))
    median(whiteSnifferSum_t(TromsoInd))
    median(whiteSnifferSum_o(TromsoInd))
    median(whiteSnifferSum_t(OsloInd))

    imageSet{1} = find(lotsOfWhite_o & OsloInd);
    imageSet{2} = find(lotsOfWhite_t & TromsoInd);

    for i = 1:length(imageSet)
        counter=0;
        im6=[];
        for f = imageSet{i}
            disp(f)
            if i == 1
                stats = fileList(f).whiteSnifferStats_o;
            elseif i == 2
                stats = fileList(f).whiteSnifferStats_t;
            end
            if ~isempty(stats)
                counter=counter+1;

                % find large patches
                ind = find([stats.Area] > 3000); %change for Tromso or Oslo

                if isempty(ind)
                    continue
                end

                folderPrefix = '~/cisc2/projects/colour_arctic/data/GOpro';
                fileFolder = fileList(f).folder(53:end);
                fileFolder=fullfile(fileFolder);
                fileFolder(strfind(fileFolder,'\'))='/';
                % cd AnalysisFunctions/
                jpg_image=imread([folderPrefix,fileFolder,filesep,fileList(f).name(1:end-4),'.jpg']);
                [RAWmatrix,metaData] = cceRawReadGoPro([folderPrefix,fileFolder,filesep,fileList(f).name(1:end-4),'.dng']);

                % demosaic
                RAW_RGB = cceRawDemosaicGoPro(RAWmatrix);

                satFilter = ~any(RAW_RGB > satVal,3);
                drkFilter = ~any(RAW_RGB < drkVal,3);
                bothFilter = satFilter & drkFilter;


                [LMSmatrix,LLMmatrix,SLMmatrix,LANDMmatrix] = cceRawRGBToLMS(RAW_RGB,metaData,1,'StockmanMacleodJohnson');
                LLMmatrix(~bothFilter) = NaN;
                SLMmatrix(~bothFilter) = NaN;
                [LMSmatrix]=MacBToLMS(LLMmatrix,SLMmatrix,LANDMmatrix);
                RGB_image=ImageLMSToRGB(LMS2RGB,LMSmatrix);
                RGB_image(RGB_image<0)=0;
                recordmaxrgb(counter)=max(RGB_image(:));
                RGB_image=round(255*((RGB_image./0.0079)));
                %RGB_image=round(255*(RAW_RGB./max(RAW_RGB(:))));

                figure
                imshow(uint8(RGB_image));
                % imagesc(RGB_image)
                % pause(1)
                % close all;
                % cd ..

                % figure('Visible','off')

                im=RGB_image;
                mask=zeros(size(im(:,:,1)));
                for k=1:size(stats,1)
                    x1=ceil(stats(k).BoundingBox(1));
                    x2=x1+ceil(stats(k).BoundingBox(3));
                    y1=ceil(stats(k).BoundingBox(2));
                    y2=y1+ceil(stats(k).BoundingBox(4));
                    mask(y1:y2-1,x1:x2-1)=stats(k).Image;
                end

                % figure, imshow(mask)

                im2=double(im).*repmat(mask,1,1,3);
                im3=double(im).*(-1*(repmat(mask,1,1,3)-1));
                %figure
                %subplot(2,2,1)
                %imshow(uint8(im2));%white pixels
                %title('Tromso white pixels')
                %subplot(2,2,2)
                %imshow(uint8(im3));%other pixels
                %title('non-white pixels')
                %subplot(2,2,3)
                im4=im2;
                im4(im2==0)=im3(im2==0).*.5;%other pixels darkened
                %imshow(uint8(im4));
                %title('non-white pixels darkened')
                %subplot(2,2,4)
                im5=im2;
                g_layer_3=im3(:,:,2);
                r_layer_3=im3(:,:,1);
                g_layer_5=im5(:,:,2);
                r_layer_5=im5(:,:,1);
                b_layer_3=im3(:,:,3);
                b_layer_5=im5(:,:,3);
                g_layer_5(im2(:,:,1)==0)=g_layer_3(im2(:,:,1)==0).*1;
                b_layer_5(im2(:,:,1)==0)=b_layer_3(im2(:,:,1)==0).*1;
                r_layer_5(im2(:,:,1)==0)=r_layer_3(im2(:,:,1)==0)+75;
                r_layer_5(r_layer_5>255)=255;
                im6(:,:,2,counter)=g_layer_5;
                im6(:,:,1,counter)=r_layer_5;
                im6(:,:,3,counter)=b_layer_5;
                %imshow(uint8(im6(:,:,:,counter)));
                %title('non-white pixels reddened without being darkened')

            end
        end

        % figure,
        nexttile
        montage(uint8(im6))
    end
else
    nexttile(t)
    imshow(imread(['figs',filesep,'WS_T.png']))
    nexttile(t)
    imshow(imread(['figs',filesep,'WS_O.png']))
end

end
