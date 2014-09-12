function [Z,descl_c] = descToZDat(parasites)
% Convert a length-P struct array of parasite feature data to Z, a
% P x D matrix of feature vectors.
% The order of the field names specified in the constant cell array desc
% determines the order of the features in Z
% The second output, descl_c contains the column indices in Z corresponding
% to each requested feature.
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

desc = { %'Area'
         %'ConvexArea'
%          'Eccentricity'
         %'EquivDiameter'
%          'Extent'
         %'MajorAxisLength'
         %'MinorAxisLength'
         %'Perimeter'
         'ForegroundDifference'
         'MLThreshold'
         'OtsuThreshold'
         'MinIntensity'
         'MaxIntensity'
         'Moments'
         'Solidity'
         'InternalThreshArea'
         'InvariantMoments'
         'Contrast'
         'Correlation'
         'Energy'
         'Homogeneity'
         'GLCMEntropy'
         'Entropy'
%          'FourierDescriptor'

%          'InternalThreshInvariantMoments'
%         'GaborFeatures'
        
%         'HistogramMoments'
%         'Histogram'
        'GaborMoments'
     };

desc_l = ones(size(desc));
for i=1:length(desc)
    desc_l(i) = length(parasites(1).(desc{i}));
end
descl_c = cumsum(desc_l);

Z = zeros(size(parasites,1),sum(desc_l));
% discard = [];
for i=1:size(parasites,1)
    Z(i,1) = parasites(i).(desc{1});
    for j=2:length(desc)
%         if length(parasites(i).(desc{j})) ~= desc_l(j)
%             discard = [discard; i j];
%             continue
%         end
        Z(i,descl_c(j-1)+1:descl_c(j)) = parasites(i).(desc{j});
    end
end