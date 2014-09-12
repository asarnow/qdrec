function R = classifyOnly(images,svmsFile,datasetDir)
% R = classifyOnly(vids,svmsFile,datasetDir);
% Runs classification for PhenomJ/QDREC.
%
% images     - cell array of images to read (no file extension)
% svmsFile   - path to MAT file containing classifier and info struct
% datasetDir - project directory
%              must contain two directories named 'img' and 'bw'
%              containing the original and segmented images, respectively.
%
% R is a N x 2 matrix containing the quantal phenotypic response values and
% parasite counts (1st and 2nd columns respectively) for each image.
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

load(svmsFile,'svms2','svms1','svmsInfo');
parasites = extractDescriptors(images,datasetDir);
if svmsInfo.classifier == 2 % Naive Bayes
    votingfun = @nb_voting;
elseif svmsInfo.classifier == 3 % Random Forest
    votingfun = @tb_voting;
else % SVM (RBF and linear)
    votingfun = @svm_voting;
end
R = testTwoStage(parasites,svms2,svms1,votingfun);