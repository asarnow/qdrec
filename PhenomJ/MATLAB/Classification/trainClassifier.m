function [Gp,svms] = trainClassifier(Z,G,svmsInfo)
% [Gp,svms] = trainClassifier(Z,G,svmsInfo)
% Input:
%  Z        P x D matrix of feature vectors
%  svmsInfo struct holding classifier parameters (see below)
% Output:
%  Gp       cross-validated output classifications
%  svms     cell array of cross-validated classifiers
%
% Trains a SVM classifier with Gaussian RBF kernel, SVM classifier with
% linear kernel or Naive Bayes classifier on binary classifications and a
% matrix of parasite feature vectors.
% Outputs cross-validated classifications and a cell array of
% cross-validated SVM classifiers.
%
% The svmsInfo struct should contain a field named "classifier" with a
% value of 0, 1, 2 or 3 for SVM (RBF), SVM (linear), Naive Bayes and Random
% Forests, respectively.
% Both SVM classifiers also require fields named "C" for the soft-margin
% box contraint, "kktlevel" to hold the permitted KKT violation level, and
% "tolkkt" for the tolerance on the KKT conditions.  The RBF kernel
% requires another field named "sigma" for its scale parameter.
% Naive Bayes requires no parameters, and Random Forest requires a single
% "nTrees" parameter defining the number of classification trees to be
% employed.
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

if length(G) < 250
    k_xval = length(G); % use leave-one-out for small data set
else
    k_xval = 10; % otherwise use 10-fold cross-validation
end
svms = cell(k_xval,1);
% Cross-validation using stratified sampling with respect to classification.
cvpart = cvpartition(G,'kfold',k_xval);
Gp = zeros(size(G));
% For each cross-validation fold.
for i=1:k_xval
    trMask = training(cvpart,i);
    teMask = test(cvpart,i);
    % Train using k-1 folds
    if svmsInfo.classifier == 0 % SVM with RBF
        svms{i} = svmtrain((Z(trMask,:))', ...
            G(trMask), ...
            'kernel_function','rbf', ...
            'autoscale',false, ...
            'showplot',false, ...
            'kktviolationlevel', svmsInfo.kktlevel, ...
            'boxconstraint', svmsInfo.C, ...
            'tolkkt', svmsInfo.tolkkt, ...);
            'rbf_sigma', svmsInfo.sigma);
    % Test using kth fold
        Gpred = svmclassify(svms{i},Z);
    elseif svmsInfo.classifier == 1 % linear SVM
        opts = statset('Display','off','MaxIter',30000);
        svms{i} = svmtrain((Z(trMask,:))', ...
            G(trMask), ...
            'kernel_function','linear', ...
            'autoscale',false, ...
            'showplot',false, ...
            'kktviolationlevel', svmsInfo.kktlevel, ...
            'boxconstraint', svmsInfo.C, ...
            'tolkkt', svmsInfo.tolkkt, ...
            'options',opts);
        Gpred = svmclassify(svms{i},Z);
    elseif svmsInfo.classifier == 2 % Naive Bayes
        svms{i} = NaiveBayes.fit(Z(trMask,:), G(trMask));
        Gpred = predict(svms{i},Z);
    elseif svmsInfo.classifier == 3 % Random forest
        svms{i} = TreeBagger(svmsInfo.nTrees, ...
            Z(trMask,:), ...
            G(trMask), ...
            'Method', 'classification');
        Gpred = svms{i}.predict(Z);
        Gpred = cellfun(@str2double,Gpred);
    end
    Gp(teMask) = Gpred(teMask);
end
