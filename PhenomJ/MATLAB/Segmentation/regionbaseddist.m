function [segmentedImage] = regionbaseddist(img, threshold, a)
% Input:
%  img        M x N intensity image matrix
%  threshold  treshold value for RBDF
%  a          scale factor for Gaussian RBDF
% Output:
%  segmentedImage    M x N binary image of segmented foreground
%
% Applies a region-based distributing function with a global threshold to
% obtain a foreground mask. The output binary image contains true values
% for foreground pixels.
% 
% Described in:
% D. Asarnow and R. Singh,
% "Segmenting the Etiological Agent of Schistosomiasis
% for High-Content Screening," 
% IEEE Transactions on Medical Imaging, 
% vol. 32, no. 6, pp. 1007-10018, 2013.
% 
% Copyright (C) 2013 Daniel Asarnow
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

if nargin == 2
    a = 3; % default scale factor
end
orig_size = size(img);

% converting to double for processing
img = double(img);

epsilon=0.0001;

gamma = double(threshold);

[pre_pad_i post_pad_i] = getPadding(img);
imgMask = specialPadArray(ones(size(img)), pre_pad_i, post_pad_i);
img = specialPadArray(img, pre_pad_i, post_pad_i);

[Mpad,Npad]=size(img);
[X,Y]=ndgrid([0:floor(Mpad/2),-floor(Mpad/2)+1:-1],[0:floor(Npad/2),-floor(Npad/2)+1:-1]);

g1=exp(-(1/(a^2))*(X.^2+Y.^2));
g1Scale=ifft2(fft2(imgMask).*fft2(g1));
f=(ifft2(fft2(img).*fft2(g1)))./(g1Scale+epsilon);

% psi=-1.*erf(f-gamma);
psi = -(f-gamma);
% segmentedImage = ones(orig_size(1), orig_size(2), length(a));
psiUnpad = removePadding(psi, orig_size);        
% segmentedImage(psiUnpad > 0) = 0;
segmentedImage = psiUnpad <= 0;
% segmentedImage = psiUnpad == -1;

end

function [ A ] = removePadding(A, s)
    if size(size(A),2)
        A = removePadding3D(A, s);
    else
        pre_pad_i = floor((size(A)-s)/2);
        post_pad_i = round((size(A)-s)/2);
        A = A(pre_pad_i(1)+1:end-post_pad_i(1), pre_pad_i(2)+1:end-post_pad_i(2));
    end
end

function [ A ] = removePadding3D(A, s)
    tempA = [size(A, 1) size(A, 2)];
    tempS = [s(1) s(2)];
    pre_pad_i = floor((tempA-tempS)/2);
    post_pad_i = round((tempA-tempS)/2);
    A = A(pre_pad_i(1)+1:end-post_pad_i(1), pre_pad_i(2)+1:end-post_pad_i(2), :);
end

function [pre_pad_i post_pad_i] = getPadding(A)
    size_new = get_size_power2(size(A));
    pre_pad_i = floor((size_new-size(A))/2);
    post_pad_i = round((size_new-size(A))/2);
end

function [paddedArray] = specialPadArray(A, pre_pad_i, post_pad_i)
    paddedArray = padarray(A, pre_pad_i, 0, 'pre');
    paddedArray = padarray(paddedArray, post_pad_i, 0, 'post');
end

function [ result ] = get_size_power2(s)
    result = zeros(1, length(s));
    for i=1:length(s)
        result(i) = 2^nextpow2(s(i));
    end
end
