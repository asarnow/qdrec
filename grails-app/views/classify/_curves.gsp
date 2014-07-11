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
%{--<label for="curves">Available curves:</label>--}%
%{--
<br />
<g:if test="${curves?.size()>1}">
  <g:select name="curves" from="${curves}" multiple="true" size="${curves.size()}"/>
</g:if>
<g:else>
  <g:select name="curves" from="${curves}" multiple="false" size="1"/>
</g:else>--}%
<b>Display: </b>
<g:each in="${0..<curves.size()}">
  <label for="${xdim + it}">${curves[it]}</label>
  <g:if test="${xdim=='time'}">
    <g:checkBox name="${xdim + it}" onclick="g2.setVisibility(${it},this.checked)" checked="${true}"/>
  </g:if>
  <g:else>
    <g:checkBox name="${xdim + it}" onclick="g.setVisibility(${it},this.checked)" checked="${true}"/>
  </g:else>
</g:each>
