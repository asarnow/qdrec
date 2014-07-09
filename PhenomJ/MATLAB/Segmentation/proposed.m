function new = proposed(fname,nscale,minwl,mult,sigma,noise,lighting,minSize,maxBorder)
% Asarnow-Singh algorithm for segmentation of juvenile schistosomes
% in bright-field micrographs.
%
% Described in:
% D. Asarnow and R. Singh,
% "Segmenting the Etiological Agent of Schistosomiasis
% for High-Content Screening," 
% IEEE Transactions on Medical Imaging, 
% vol. 32, no. 6, pp. 1007-10018, 2013.
%
% fname     - an intensity image matrix, a RGB image or a file path
%             identifying an image file to be read from disk.
% nscale    - number of wavelet scales for phase congruency
% minwl     - smallest filter wavelength (in pixels)
% mult      - multiplier between phase congruency scales
% sigma     - ratio of wavelet transfer function st. dev. to center frequency
% noise     - number of standard deviations beyond median for noise
%             threshold (higher for noisier images)
% lighting  - integer size of strucuring element for lighting correction
% minSize   - the minimum size of a segmented region
% maxBorder - the maximum intersection of a region with the image border
%             (see selectiveErode.m)
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
    nscale = 5;
    minwl = 3;
    mult = 2.1;
    sigma = 0.4;
    noise = 12.0;
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
grc = correctLighting(gr,'dif','square',lighting);
% Compute threshold using Otsu's method (as a fallback).
th = graythresh(grc)*255;
% Compute threshold using maximum likelihood.
thm = th_maxlik(grc);
% Sanity check, invert if necessary.
if isreal(thm) && thm<255 && thm>127
    th = 255 - thm;
else % maxlik did not converge
    th = round((255 - th)/2); % Otsu requires bias correction
end
% Initial segmentation using RBDF and final threshold.
bw = regionbaseddist(255-grc,th,2);
bw = selectiveErode(bw,maxBorder); % correct oversegmentation
bw = bwareaopen(bw,minSize); % remove small regions
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
    roib = bwl(y,x) == i; % logical
    % Compute phase congruency edge weights using monogenic filters.
    ed = phasecongmono(roi,nscale,minwl,mult,sigma,noise,-2,0.5,10);
    % Grayscale morphological thinning of edge weights.
    ed = imthin(ed);
    ed = normalise(ed);
    th = graythresh(ed); % Otsu's threshold
    ed = hysthresh(ed,th,th*0.25);
    % Cleaning pattern to deal with noise pixels.
    ed = bwmorph(ed,'thin',Inf);
    ed = bwmorph(ed,'bridge');
    ed = bwmorph(ed,'spur',Inf);
    ed = bwmorph(ed,'fill');
    ed = bwmorph(ed,'thin',Inf);
    ed = padarray(ed,[padsize padsize],0);
    roib = padarray(roib,[padsize padsize],0);
    ed = findRelevantEdges3(roib,ed); % keep relevant edges
    ed = bwmorph(ed,'diag');% remove 8-connectivity
    roib2 = roib & ~ed; % everything in the region that isn't an edge
    roib2 = bwareaopen(roib2,minSize); % remove nose regions
    % Compute minimum edges with inwards watershed (see publication).
    roib2th = watershed( bwdist(roib2) ) == 0; % select watershed lines
    roib3 = roib &~ roib2th;  % subtract minimum edge set
    roib3 = imfill(roib3,'holes'); % fix holes created by edge subtraction
    new(y,x) = new(y,x) | roib3(padsize+1:end-padsize,padsize+1:end-padsize); % unpad, insert, no overwrite
end
% Clean-up.
new = imclearborder(new);
new = bwareaopen(new,minSize);
new = padarray(new,[1 1],0,'both');