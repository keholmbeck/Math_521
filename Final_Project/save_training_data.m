clear;

folder = 'TIFFtraining/';
files = dir( folder );
files = files(3:end);

DATA = [];
classes = zeros(1, length(files));

for ii = 1:length(files)
    fname = files(ii).name;
    dat = imread([folder, fname]);
    dat = dat(:,:,1);
    dat0 = double(dat);
    
    DATA = [DATA, dat(:)];

    if ~isempty( strfind(lower(fname), 'cat') )
        classes(ii) = 1;
    else
        classes(ii) = 0;
    end
end
DATA = double(DATA);

save data/cats_and_dogs.mat DATA classes