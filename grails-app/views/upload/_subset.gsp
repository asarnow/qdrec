<g:select name="subsetList" from="${subsets}" size="${subsets.size()}"
        optionKey="id" optionValue="description" multiple="false"
        onchange="${remoteFunction(controller: 'upload', action: 'imageList',
                update: 'imageListDiv', params:'\'subsetID=\'+this.value',
                method: 'GET')}"
/>