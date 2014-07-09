function images_controls = vids2controls(images)
% Parse a N x 1 cell array of image names, identifying the controls and
% pairing them to the appropriate experimental images.
% The output is a N x 1 cell array containing the name of the control
% which should be matched to each image in the input list.
%
% The image names must obey the convention laid out in imageDatabase.m and
% trainAndClassify.m.
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

control_idx = false(size(images));
for i=1:length(images)
    if ~isempty(strfind(lower(images{i}),'cont')) || ...
            ~isempty(strfind(lower(images{i}),'ctrl'))
        control_idx(i) = true;
    end
end
control_idx = find(control_idx);

images_controls = zeros(size(images));

for i=1:length(images)
    vid = lower(images{i});
    [datestr,~,~,day,series] = parseImage(vid);
    for j=1:length(control_idx)
        control = lower(images{control_idx(j)});
        [condatestr,~,~,conday,conseries] = parseImage(control);
        if strcmp(datestr,condatestr) && ...
                day == conday && strcmp(series,conseries)
            images_controls(i) = control_idx(j);
            break;
        end
    end
end

% Parse the image file name.
function [datestr,cmpd,co,dy,series] = parseImage(image)
    tok = regexp(lower(image),'-','split');
    datestr = tok{1};
    cmpd = tok{2};
    [co,dy,series] = convention1(cmpd,tok);


% Apply the file name convention.
function [co,dy,series] = convention1(cmpd,tok)
if strcmp('control',cmpd)
    co = 0;
else
    co = concFromStr(tok{3});
end
if length(tok) > 4
    dy = str2double(tok{4}(1));
    series = tok{5};
elseif strcmp('control',cmpd)
    dy = str2double(tok{3}(1));
    series = tok{4};
else
    dy = str2double(tok{4}(1));
    series = 'a';
end