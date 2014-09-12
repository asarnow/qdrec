function imageDatabase(datasetDir,segmentation)
% imageDatabase(datasetDir,segmentation);
% datasetDir   - directory containing img and bw dirs
% segmentation - segmentation flag
%
% imageDatabase will read all of the PNG-format images in datasetDir
% and attempt to segment them using one of the following methods:
% Segmenter        Flag
%  Read from disk   0
%  Asarnow-Singh    1
%   Canny           2
%  Watershed        3
%
% datasetDir must contain two directories named 'img' and 'bw' for
% the original and segmented images, respectively.
% 'img' must not be emtpy, but 'bw' may be empty as long as
% segmentation ~= 0.
% imageDatabase will also write a file 'imagedb.csv' to the
% dataset directory, listing the locations of the parasites found
% in the images.
%
% The filenames must use the following convention:
% [6-digit date]-[compound]-[concentration]-[exposure]-[series]
% E.g. 032612-Meva-001-3-a
% Corresponding to an image with:
%   collection date of 26 March, 2012
%   a compound called 'Meva'
%   concentration of 0.01 units (the decimal point is elided)
%   exposure time of 3 units
%   series 'a' (use 'b', 'c', etc. for duplicate runs)
% Deviations from the convention will result in errors.
% In addition, every image must be accompanied in the list by its
% control image, which should have 'control' as the compund and '0'
% as the concentration.
%
% Copyright (C) 2014 Daniel Asarnow
% Rahul Singh
% San Francisco State University
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

imgDir = fullfile(datasetDir,'img');
segDir = fullfile(datasetDir,'bw');
fname = fullfile(datasetDir,'imagedb.csv');
fid = fopen(fname,'w');
images = dir(fullfile(imgDir,'*.png'));
for i=1:length(images)
    [~,vid,~] = fileparts(images(i).name);
    vidl = lower(vid);
    tok = regexp(vidl,'-','split');
    datestr = tok{1};
    cmpdstr = tok{2};
    concstr = tok{3};
    daystr = tok{4};
    if length(tok) == 5
        series = tok{5};
    else
        series = 'a';
    end
    
    conc = concFromStr(concstr);
    
    imgfile = fullfile(imgDir,[vid '.png']);
    bwfile = fullfile(segDir,[vid '.png']);
    
    if segmentation == 0
        bw = imread( bwfile );
    elseif segmentation == 1
        bw = proposed(imgfile);
        imwrite(bw,bwfile);
    elseif segmentation == 2
        bw = proposedCanny(imgfile);
        imwrite(bw,bwfile);
    elseif segmentation == 3
        bw = watershedSegmentation(imgfile);
        imwrite(bw,bwfile);
    end
                
    props = regionprops(bw,'BoundingBox');
    
    parasites = '"';
    for j=1:length(props)
        parasites = [ parasites ...
        [   num2str(j) ','...
            num2str(round(props(j).BoundingBox(1))) ','...
            num2str(round(props(j).BoundingBox(2))) ','...
            num2str(round(props(j).BoundingBox(3))) ','...
            num2str(round(props(j).BoundingBox(4))) ...
            ';'
        ] ];
    end
    parasites(end) = '"';
%     parasites = [parasites '"'];
    
    line = [ vid ',' cmpdstr ',' ...
                 num2str(conc) ',' num2str(daystr) ',' ...
                 series ',' ...
                 datestr ',' parasites ];
    
    fprintf( fid, '%s\n', line);
end
fclose(fid);