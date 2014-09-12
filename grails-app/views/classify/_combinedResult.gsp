%{--
  - Copyright (C) 2014
  - Daniel Asarnow
  - Rahul Singh
  - San Francisco State University
  -
  - This program is free software: you can redistribute it and/or modify
  - it under the terms of the GNU Affero General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - This program is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU Affero General Public License
  - along with this program.  If not, see <http://www.gnu.org/licenses/>.
  --}%
<h3>Display Results</h3>
<h4 style="margin-top: 0.25em;">Tabular Results</h4>
<button class="button" type="button" onclick="$('#numericalResult').toggle();">Display</button>
<a href="${createLink(action: 'downloadResults')}"><button class="button" type="button">Download</button></a>
<g:render template="result" model="[cm:cm, testImages:testImages, trainImages:trainImages, Rtest:Rtest, Rtrain:Rtrain]"/>
<div class="clearDiv"></div>
<g:render template="resultPlot" model="[error:error, compounds:compounds]"/>
