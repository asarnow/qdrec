function img = correctLighting(img,method,shape,n)
% Correct uneven lighting in an image using morphological operations.
% img - RGB or intensity image
% method - 'dif' uses subtraction of morphological tophat
%        - 'div' uses division by morphological closing
% shape  - 'square', 'disk', etc. (see strel)
%   n    - size of structuring element (e.g. n x n)
%
% Copyright (C) 2014 Daniel Asarnow
% San Francisco State Unversity
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

se = strel(shape,n);

switch method
    case 'dif'
        img = imcomplement(...
                imtophat(...
                  imcomplement(img),se...
                  ));
    case 'div'
        cl = class(img);
        img = im2double(img);
        img = imdivide(img,imclose(img,se));
        switch cl
            case 'uint8'
                img = im2uint8(img);
            case 'uint16'
                img = im2uint16(img);
            case 'single'
                img = im2single(img);
        end
    otherwise
        error('method must be ''div'' or ''dif''');
end