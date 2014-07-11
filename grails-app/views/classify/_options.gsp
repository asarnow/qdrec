%{--
  - Copyright (C) 2014 Daniel Asarnow
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


<b>Options: </b>
<label for="Lines">Lines</label>
<g:if test="${xdim=='time'}">
  <g:checkBox name="Lines" onclick="updatePlotters(g2,this.checked)" checked="${false}"/>
</g:if>
<g:else>
  <g:checkBox name="Lines" onclick="updatePlotters(g,this.checked)" checked="${false}"/>
</g:else>