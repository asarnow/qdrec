function erosion = selectiveErode(bw,maxIntersect)
% B = selectiveErode(A)
% Computes in B the binary erosion of image A (assumed logical) while
% preserving pixels at the image border. Pixels may still be eroded if
% certain conditions are met, namely that the "area of contact" between a
% region and the border is small. The pupose of this exception is to sever
% regions from the border if they overlap it only negligibly.
%
% Described in:
% D. Asarnow and R. Singh,
% "Segmenting the Etiological Agent of Schistosomiasis
% for High-Content Screening," 
% IEEE Transactions on Medical Imaging, 
% vol. 32, no. 6, pp. 1007-10018, 2013.
%
% Copyright (C) 2013 Daniel Asarnow
% San Francsico State University
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
    maxIntersect = 2;
end
[m,n] = size(bw);
% 1D vector of border pixels taken clockwise
border = [bw(1,1:n-1) bw(1:m-1,n)' bw(m,n:-1:2) bw(m:-1:2,1)'];

% borderMask = false(m-2,n-2);
% borderMask = padarray(new,[1 1],true,'both');
% border = bw(borderMask);

erosion = bwmorph(bw,'erode'); % 3x3 square SE, deletes 1px along border
% bwcc = bwconncomp(border,4);
bwcc = bwconncomp(border,4);
stats = regionprops(bwcc,'Area');
keep = ([stats.Area] > maxIntersect); % mask over bwcc of kept regions
border(vertcat(bwcc.PixelIdxList{~keep})) = 0;

erosion(1,1:n-1) = border(1:n-1);
erosion(1:m-1,n) = border(n:n-1+m-1);
erosion(m,n:-1:2) = border(n+m-1:n+m-1-1+n-1);
erosion(m:-1:2,1) = border(n+m-1-1+n:end);