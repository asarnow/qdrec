function I = rgb2intensity(I)
% I = rgb2intensity(I);
% Converts RGB images (M x N x 3 matrix) to intensity values (M x N).
% The intensity is defined as the Euclidean magnitude of the RGB vector.
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

% I = sqrt( R^2 + G^2 + B^2 )
I = double(I);
% I = ( I(:,:,1).^2 + I(:,:,2).^2 + I(:,:,3).^2 ).^0.5;
I = sum( I.^2, 3 ).^0.5;