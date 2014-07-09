function bw = watershedSegmentation(fname,hmin,lighting,minSize,maxBorder)
% Segment an image using Asarnow-Singh initial segmentation and the
% watershed segmentation approach for separating touching regions.
%
% fname     - an intensity image matrix, a RGB image or a file path
%             identifying an image file to be read from disk.
% hmin      - an integer specifying the depth for H-min transform
% lighting  - integer size of strucuring element for lighting correction
% minSize   - the minimum size of a segmented region
% maxBorder - the maximum intersection of a region with the image border
%             (see selectiveErode.m)
%
% The segmented image is returned as a logical matrix.
%
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
    hmin = 5;
    lighting = 200;
    minSize = 500;
    maxBorder = 10;
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
th = graythresh(gr)*255; % portable
if th > 127 % invert if necessary
    % Segment foreground using RBDF with Otsu
    bw = regionbaseddist(255-gr,(255-th)/2,2);
else
    bw = regionbaseddist(gr,th/2);
end
% Correct oversegmentation using selective erosion algorithm.
bw = selectiveErode(bw,maxBorder);

% Calculate outwards distance transform.
do = bwdist(bw);
do(bw) = 0; % discard values interior to regions
% Calculate inwards transform.
di = bwdist(~bw);
di(~bw) = 0; % discard values outside regions
% Form 'continuous' distance topography for watershed simulation.
% Region interiors are negative, borders are 0 and exteriors positive.
d = do - di;

% Flatten the 'basins' slightly.
dh = imhmin(d,hmin);
% Watershed simulation.
w = watershed(dh) == 0; % identify watershed lines
bw = bw &~ w; % split

% Clean-up.
bw = imclearborder(bw);
bw = bwareaopen(bw,minSize); % remove small regions (debris, etc.)
bw = padarray(bw,[1 1],0,'both');