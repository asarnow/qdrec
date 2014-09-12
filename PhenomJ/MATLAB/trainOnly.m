function [cm,R_train] = trainOnly(images,datasetDir,svmsFile,G,params)
% R = classifyOnly(vids,svmsFile,datasetDir);
%
% images - list of images to read (no file extension)
% datasetDir - project directory
%              must contain two directories named 'img' and 'bw'
%              containing the original and segmented images, respectively.
% svmsFile - path to MAT file containing classifier to use
% G - training vector, must contain a boolean value for each parasite
%     named images
% params - Java LinkedHashMap containing method parameters:
%       classifier - classifier type to use
%              0 - SVM (RBF)
%              1 - SVM (linear)
%              2 - Naive Bayes
%              3 - Random Forest
%       C - box constraint, sigma - RBF sigma, kktlevel - KKT violation
%       level, tolkkt - KKT tolerance, nTrees - number of RF trees,
%       twoStage - true for two-stage classification
%
% cm contains the cross-validated confusion matrix obtained during
% training.
%
% R is a N x 2 matrix containing the quantal phenotypic response values and
% parasite counts (1st and 2nd columns respectively) for each image.
% These response values are also cross-validated.
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

parasites_train = extractDescriptors(images,datasetDir);

svmsInfo.classifier = params.get('classifier');
if svmsInfo.classifier == 0
    svmsInfo.classifierType = 'SVM (RBF)';
    svmsInfo.C = params.get('rbfBoxConstraint');
    svmsInfo.sigma = params.get('sigma');
    svmsInfo.kktlevel = params.get('rbfKktLevel');
    svmsInfo.tolkkt = params.get('rbfTolKkt');
elseif svmsInfo.classifier == 1
    svmsInfo.classifierType = 'SVM (linear)';
    svmsInfo.C = params.get('boxConstraint');
    svmsInfo.kktlevel = params.get('kktLevel');
    svmsInfo.tolkkt = params.get('tolKkt');
elseif svmsInfo.classifier == 2
    svmsInfo.classifierType = 'Naive Bayes';
elseif svmsInfo.classifier == 3
    svmsInfo.classifierType = 'Random Forest';
    svmsInfo.nTrees = params.get('nTrees');
end
svmsInfo.twoStage = params.get('twoStage');

[R_train,cm,svms2,svms1] = trainTwoStage(parasites_train,G,svmsInfo); %#ok<ASGLU,NASGU>

save(svmsFile,'svms2','svms1','svmsInfo','-v7.3');