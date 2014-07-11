function typ = classifierType(svmsFile)
% typ = classifierType(svmsFile);
% Reads the svmsInfo struct from specified MAT file path and returns the
% 'classifierType' field. If the classifier described by the svmsInfo
% struct is two-stage, classifierType will add that to the returned string.
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
load(svmsFile,'svmsInfo');
typ = svmsInfo.classifierType;
if svmsInfo.twoStage
    typ = ['two-stage ' typ];
else
    typ = ['one-stage ' typ];
end