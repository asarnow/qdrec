function co = concFromStr(cstr)
% co = concFromStr(cstr);
% concFromStr converts a string representation of a decimal fraction with
% leading zeros and no decimal point to a double.
% E.g. "001" => 0.01, etc.
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

cflt = str2double(cstr);
nz = 0;
for i=1:length(cstr)
    if strcmp('0',cstr(i))
        nz = nz+1;
    else
        break;
    end
end

if nz == 0
    co = str2double(cstr);
else
    co = 10^(-(nz)) * cflt;
end