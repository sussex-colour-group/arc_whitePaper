function data = transformGoProData(inputData)

data = NaN(6,size(inputData,1));

for i = 1:size(inputData,1)
    try
        data(1,i) = inputData(i).meanMB(1);
        data(2,i) = inputData(i).meanMB(2);
        data(3,i) = inputData(i).meanMB(3);

        % seasonNames = {'Summer','Autumn','Winter','Spring'};
        if strcmp(inputData(i).season,'Summer')
            data(4,i) = 1;
        elseif strcmp(inputData(i).season,'Autumn')
            data(4,i) = 2;
        elseif strcmp(inputData(i).season,'Winter')
            data(4,i) = 3;
        elseif strcmp(inputData(i).season,'Spring')
            data(4,i) = 4;
        end

        % locationNames = {'Tromso','Oslo'};
        if strcmp(inputData(i).location,'Tromso')
            data(5,i) = 0;
        elseif strcmp(inputData(i).location,'Oslo')
            data(5,i) = 1;
        end

        % CL
        % data(6,i) = ...;

    catch
        %
    end
end

end