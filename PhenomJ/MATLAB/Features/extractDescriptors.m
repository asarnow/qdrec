function parasites = extractDescriptors(images,datasetDir)
% extractDescriptors(images,datasetDir);
% images     - cell array with filenames of target images
% datasetDir - directory containing img and bw data dirs
%
% extractDescriptors will read the original and segmented images
% found in the 'img' and 'bw' subdirs of datasetDir.
% The features of each segmented region (parasite) will be measured
% and placed into a struct array with an element for each parasite.
% This struct array is output for further analysis.
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
pcel = cell(length(images),1);
for i=1:length(images)
    RGB = imread( fullfile(imgDir,[images{i} '.png']) );
    I = rgb2intensity(RGB);
    I = im2uint8(normalise(I));    
    bw = imread( fullfile(segDir,[images{i} '.png']) );
    I = correctLighting(I,'dif','square',200);
    props = parasiteFeatures(I,bw);
    [props(:).Video] = deal(images{i});
    [props(:).VideoIndex] = deal(i);
    pcel{i} = props;
end
parasites = vertcat(pcel{:});