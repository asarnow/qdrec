function resegmentDataset(datasetDir,tempDir,params)
% resegmentDatabase(datasetDir,segmentation,params);
% Resegments a project dataset for PhenomJ/QDREC.
%
% datasetDir - directory containing img and bw dirs
% tempDir    - directory to store re-segmented images
% params     - Java LinkedHashMap holding parameters:
%        segmentation - flag specifying segmentation method
%        lighting - size of structuring element for lighting correction
%        minSize  - minimum size of segmented region
%        maxBorder - maximum intersection of segmented region with image
%                    border
%
% 
% imageDatabase will read all of the PNG-format images in datasetDir
% and attempt to segment them using one of the following methods:
% Segmenter        Flag
%  Asarnow-Singh    1
%  Canny            2
%  Watershed        3
% datasetDir must contain two directories named 'img' and 'bw' for
% the original and segmented images, respectively.
% 'img' must not be emtpy, while 'bw' should be empty to prevent old
% segmentations from interfering with later processing.
% resegmentDataset will also write a file 'imagedb.csv' to the
% dataset directory, listing the locations of the parasites found
% in the images.
%
% The image files must obey the convention described in imageDatabase.m.
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

segmentation = params.get('segmentation');
lighting = params.get('lighting');
minSize = params.get('minSize');
maxBorder = params.get('maxBorder');

imgDir = fullfile(datasetDir,'img');
segDir = fullfile(tempDir,'bw');
fname = fullfile(tempDir,'imagedb.csv');
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
    
    if segmentation == 1
        nscale = params.get('nscale');
        minwl = params.get('minwl');
        mult = params.get('mult');
        sigma = params.get('sigma');
        noise = params.get('noise');
        
        bw = proposed(imgfile, nscale, minwl, mult, ...
            sigma, noise, lighting, minSize, maxBorder);
        
        imwrite(bw,bwfile);
    elseif segmentation == 2
        sigmaCanny = params.get('sigmaCanny');
        lowCanny = params.get('lowCanny');
        highCanny = params.get('highCanny');
        
        bw = proposedCanny(imgfile, sigmaCanny, ...
            lowCanny, highCanny, lighting, minSize, maxBorder);
        
        imwrite(bw,bwfile);
    elseif segmentation == 3
        hmin = params.get('hmin');
        
        bw = watershedSegmentation(imgfile, hmin, ...
            lighting, minSize, maxBorder);
        
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