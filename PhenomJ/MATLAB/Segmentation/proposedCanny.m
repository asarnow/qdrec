function new = proposedCanny(fname,sigma,low,high,lighting,minSize,maxBorder)
% Asarnow-Singh variant using Canny edge dection instead of
% phase congruency and grayscale morphological thinning.
%
% fname     - an intensity image matrix, a RGB image or a file path
%             identifying an image file to be read from disk.
% sigma     - scale for difference of Gaussians filter
% low       - low relative threshold for hysteresis, 0 for automatic
% high      - high relative threshold for hysteresis, 0 for automatic
% lighting  - integer size of strucuring element for lighting correction
% minSize   - the minimum size of a segmented region
% maxBorder - the maximum intersection of a region with the image border
%             (see selectiveErode.m)
%
% The segmented image is returned as a logical matrix.

% Copyright (C) 2014 Daniel Asarnow
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

if nargin == 1
    thresh = [];
    sigma = sqrt(2);
    lighting = 200;
    minSize = 500;
    maxBorder = 10;
else
    if low == 0
        low = 0.4 * high;
    end
    
    if high == 0
        high = low / 0.4;
    end
    
    if high == 0 && low == 0
        thresh = [];
    else
        thresh = [ low high ];
    end
end

if ~ischar(fname)
    gr = fname;
else
    gr = imread(fname);
end

if ndims(gr) == 3
    gr = rgb2gray(gr);
end
gr = gr(2:end-1,2:end-1);
gr = correctLighting(gr,'dif','square',lighting);
% Compute threshold using Otsu's method.
th = graythresh(gr)*255;
if th > 127 % invert if necessary
    % Segment foreground using RBDF with Otsu
    bw = regionbaseddist(255-gr,(255-th)/2,2);
else
    bw = regionbaseddist(gr,th/2);
end
bw = selectiveErode(bw,maxBorder); % correct oversegmentation
bw = bwareaopen(bw,minSize); % remove small regions (debris, etc.)
bwcc = bwconncomp(bw); % compute connected components
stats = regionprops(bwcc,'BoundingBox'); % compute bounding boxes, etc.
bwl = labelmatrix(bwcc); % label connected components
padsize = 25; % limits edge effects
new = false(size(bw)); % binary output image
% Per-region processing.
for i=1:bwcc.NumObjects
    y = round(stats(i).BoundingBox(2)): ...
                round(stats(i).BoundingBox(2))+stats(i).BoundingBox(4)-1;
    x = round(stats(i).BoundingBox(1)): ...
                round(stats(i).BoundingBox(1))+stats(i).BoundingBox(3)-1;    
    roi = gr(y,x); % original grayscale type (e.g. uint8)
    roib = bwl(y,x) == i; % logical subimage of labeled region
    ed = edge(roi,'canny',thresh,sigma); % edge detection
    ed = padarray(ed,[padsize padsize],255); % bright-field image, pad with 255
    roib = padarray(roib,[padsize padsize],0);
    ed = findRelevantEdges3(roib,ed); % keep relevant edges
    ed = bwmorph(ed,'diag'); % remove 8-connectivity
    roib2 = roib & ~ed; % everything in the region that isn't an edge
    roib2 = bwareaopen(roib2,minSize); % remove nose regions
    % Compute minimum edges with inwards watershed (see publication).
    roib2th = watershed( bwdist(roib2) ) == 0; % select watershed lines
    roib3 = roib &~ roib2th; % subtract minimum edge set
    roib3 = imfill(roib3,'holes'); % fix holes created by edge subtraction
    new(y,x) = new(y,x) | roib3(padsize+1:end-padsize,padsize+1:end-padsize); % unpad, insert, no overwrite
end
% Clean-up.
new = imclearborder(new);
new = bwareaopen(new,minSize);
new = padarray(new,[1 1],0,'both');