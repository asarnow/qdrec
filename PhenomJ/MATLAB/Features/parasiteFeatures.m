function props = parasiteFeatures(I,BW)
% Compute numerical feature measurements for the segmented regions in
% binary image BW based on the intensity image I.
% Input:
%  I        M x N intensity image matrix with Q regions
%  BW       M x N logical(binary) image matrix containing segmentation of I
% Output:
%  props    Q x 1 struct array with features assigned to fields
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

% Cell arrays of feature names (see usages below)
desired = {'Area', 'BoundingBox', 'Solidity', 'MinIntensity', 'MaxIntensity' };
glcmfields = { 'Contrast', 'Correlation', 'Energy', 'Homogeneity' };
newfields = [{'GrayImage', 'Image', 'Entropy', 'GLCMEntropy', ...
    'ForegroundDifference', 'MLThreshold', 'OtsuThreshold', ...
    'FourierDescriptor', 'InvariantMoments', 'GaborMoments', ...
    'Moments', 'InternalThreshArea', 'RegionNumber'} glcmfields];

% Displacement vector scales for computing GLCM.
d = [3 7 15 29 59];
% Number of intensity levels in GLCM.
nl = 32;

% Get properties of binary regions.
bwcc = bwconncomp(BW);
props = regionprops(bwcc,I,desired);

% Compute region label image.
labels = labelmatrix(bwcc);

% Initialize struct fields.
for j=1:length(newfields)
    [props.(newfields{j})] = deal([]);
end

% Process each region from binary image.
for i=1:bwcc.NumObjects
    
    % Crop out label and intensity images for region using bounding box.
    lbMask = imcrop(labels,props(i).BoundingBox);
    lbMask = lbMask == mode(single(lbMask(lbMask>0)));
    
    grMask = imcrop(I,props(i).BoundingBox);
    
    props(i).GrayImage = grMask;
    props(i).Image = lbMask;
    
    % Ignore values outside the region, but inside the bounding box.
    grMask(~lbMask) = NaN;
    
    % Initialize GLCM for each scale.
    nglcm = length(d);
    for k=1:length(glcmfields)
        props(i).(glcmfields{k}) = zeros(nglcm,1);
    end
    % Compute GLCM
    for j=1:nglcm
        % GLCMs are computed for all four orientations.
        glcm = graycomatrix(grMask,'GrayLimits',[], ...
                                   'NumLevels',nl, ...
                                   'Symmetric',true, ...
                                   'Offset',[0 1; 1 0; 1 1; 1 -1]*d(j));
        % Sum GLCMs for each orientation.
        glcm = sum(glcm,3);
        
        % Compute GLCM properties.
        tmpprops = graycoprops(glcm,'all');
        for k=1:length(glcmfields)
            props(i).(glcmfields{k})(j) = tmpprops.(glcmfields{k});
        end

        props(i).GLCMEntropy(j) = entropy(glcm);
    end
    % Compute entropy of region's intensity image.
    props(i).Entropy = entropy(grMask(lbMask));
    
    props(i).ForegroundDifference = abs(mean(grMask(lbMask)) - ...
                                         mean(grMask(~lbMask)));
    % Compute internal thresholds.
    props(i).MLThreshold = th_maxlik(grMask(lbMask));
    props(i).OtsuThreshold = graythresh(grMask(lbMask))*255;
    
%     props(i).FourierDescriptor = frdescpbw(lbMask,10);
    
    props(i).RegionNumber = i;
    
    % Convert region label image to Cartesian coordinates.
    [y,x] = find(lbMask);
%     x = x - 1 - mean(x-1);
%     y = y - 1 - mean(y-1);
    F = double(grMask(lbMask));
    % Compute invariant image moments.
    props(i).InvariantMoments = invmoments(255-F,x,y);
    % Measure the area with intensity less than the internal threshold.
    props(i).InternalThreshArea = nnz(F<props(i).MLThreshold)/numel(F);
    % Compute wavelet textures using log-Gabor filters.
    ns = 5; % number of filter scales
    % Perform convolutions using log-Gabor filters.
    E0 = gaborconvolve(props(i).GrayImage,ns,6,3,2.1,0.55,0,0);
    gi = zeros([size(E0{1}) ns]);
%     gabfeat = zeros(ns,1);
   % Compute each pixel's max response from the six orientations.
    for j=1:ns
        for k=1:6
            gi(:,:,j) = max(gi(:,:,j),abs(E0{j,k}));
        end
    end
    
    % Compute the statistical moments of the wavelet texture distributions
    % at each of the filter scales.
    fm = 3;
    nm = 5;
%     sk = nm - fm;
    sk = 0;
    mom = zeros(ns*(nm-sk),1);
    cnt = 1;
    for k=1:ns
        tmp = gi(:,:,k);
        tmp = tmp(lbMask);
        sigma = std(tmp,1);
        mom(cnt) = mean(tmp); cnt = cnt + 1;
        mom(cnt) = var(tmp); cnt = cnt + 1;
        for or=fm:nm
            mom(cnt) = moment(tmp,or) / sigma^or;
            cnt = cnt + 1;
        end
        mom(4 - sk) = mom(4 - sk) - 3;
    end
    props(i).GaborMoments = mom;

    % Compute the statistical moments of the pixel intensity distribution.
    mom = zeros(nm-sk,1);
    sigma = std(F,1);
    mom(1) = mean(F);
    mom(2) = var(F);
    for or=fm:nm
        j = or - sk;
        mom(j) = moment(F,or) / sigma^or;
    end
    mom(4 - sk) = mom(4 - sk) - 3;
    props(i).Moments = mom; 
end