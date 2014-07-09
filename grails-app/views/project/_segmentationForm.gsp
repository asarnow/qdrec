%{--
  - Copyright (C) 2014 Daniel Asarnow
  - San Francisco State University
  -
  - This program is free software: you can redistribute it and/or modify
  - it under the terms of the GNU General Public License as published by
  - the Free Software Foundation, either version 3 of the License, or
  - (at your option) any later version.
  -
  - This program is distributed in the hope that it will be useful,
  - but WITHOUT ANY WARRANTY; without even the implied warranty of
  - MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  - GNU General Public License for more details.
  -
  - You should have received a copy of the GNU General Public License
  - along with this program.  If not, see <http://www.gnu.org/licenses/>.
  --}%

<div id="segmentationFormDiv">
  <g:formRemote name="segmentationForm"
                url="[controller: 'project', action: 'resegment']"
                before="if (\$('#segmentationForm').valid()){
                          if (confirmResegmentation()){"
                after="}}"
                class="validatedForm"
                update="reviewDiv"

                onLoading="\$('#segmentationFormMeta').hide(); \$('#spinner').show();"
                onComplete="\$('#spinner').hide(); \$('#resegmentationButton').show(); \$('#reviewDiv').show();">

    <label for="segmentation">Segmentation</label>
    <g:select name="segmentation" from="['Asarnow-Singh','Canny','Watershed']"
              value="Asarnow-Singh"
              onchange="showOptions(this.value);"/>

      %{-- Phase congruency parameters --}%
      <div id="parameterDiv">
        <div id="pcParamDiv">
        <label for="nscale">Number of scales:</label>
        <g:textField name="nscale" value="5" />
        <br />
        <label for="minwl">Minimum log-Gabor wavelength (pixels):</label>
        <g:textField name="minwl" value="3" />
        <br />
        <label for="mult">Scale multiplier:</label>
        <g:textField name="mult" value="2.1" />
        <br />
        <label for="sigma">Log-Gabor wavelet scale:</label>
        <g:textField name="sigma" value="0.4" />
        <br />
        <label for="noise">Relative noise amplitude:</label>
        <g:textField name="noise" value="12.0" />
        <br />
      </div>

      %{-- Canny parameters --}%
      <div id="cannyParamDiv" hidden="hidden">
        <label for="sigmaCanny">Gaussian scale:</label>
        <g:textField name="sigmaCanny" value="1.414" />
        <br />
        <label for="lowCanny">Low hysteresis threshold (relative):</label>
        <g:textField name="lowCanny" value="0.0" />
        <span>Use 0 for automatic determination</span>
        <br />
        <label for="highCanny">High hysteresis threshold (relative):</label>
        <g:textField name="highCanny" value="0.0" />
        <span>Use 0 for automatic determination</span>
        <br />
      </div>

      %{-- Watershed parameters --}%
      <div id="watershedParamDiv" hidden="hidden">
        <label for="hmin">H-min depth:</label>
        <g:textField name="hmin" value="5" />
        <br />
      </div>

      %{-- General parameters  --}%
      <label for="lighting">Lighting correction scale (pixels):</label>
      <g:textField name="lighting" value="200" />
      <br />
      <label for="minSize">Minimum parasite area (pixels):</label>
      <g:textField name="minSize" value="500"/>
      <br />
      <label for="minSize">Maximum border intersection for selective erode (pixels):</label>
      <g:textField name="maxBorder" value="10"/>
    </div>

    <g:submitButton name="resegmentationSubmit" value="Resegment Project" class="button"/>
    <button class="button" type="button" onclick="cancelResegmentation();">Cancel</button>
  </g:formRemote>
</div>