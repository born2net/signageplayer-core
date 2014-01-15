function LoaderManager()
{
    this.root = this;
    this.m_dataBaseManager = new DataBaseManager();
    this.m_domain = null;
    this.m_businessId = -1;
    this.m_user = null;
    this.m_password = null;
    this.filesToUpload = [];
};


LoaderManager.prototype.create = function(i_user, i_password, i_requestCallback)
{
    var me = this;
    this.m_user = i_user;
    this.m_password = i_password;

    var url= 'https://galaxy.signage.me/WebService/getUserDomain.ashx?i_user='+i_user+'&i_password='+i_password+'&callback=?';
    $.getJSON(url,
        function(data)
        {
            me.m_domain = data.domain;
            me.m_businessId = data.businessId;
            me.m_studioLite = data.studioLite;

            if (data.studioLite==0)
            {
                i_requestCallback({status:false,error:'not a studioLite account'});
                return;
            }


            if (me.m_businessId==-1)
            {
                i_requestCallback({status:false,error:'login fail'});
                return;
            }

            me.m_dataBaseManager.createDataBase(me.m_domain, me.m_businessId);
            me.m_dataBaseManager.selectDomainBusiness(me.m_domain, me.m_businessId);

            me.requestData(
                function()
                {
                    i_requestCallback({status:true,error:''});
                }
            );
        }
    );

}

LoaderManager.prototype.requestData = function(i_callback)
{
    var self = this;
    var url= 'https://'+this.m_domain+'/WebService/RequestData.ashx?businessId='+this.m_businessId+'&callback=?';
    $.getJSON(url,
        function(data)
        {
            var s64=data.ret;
            var str = $.base64.decode(s64);
            var xml = $.parseXML(str);
            self.m_dataBaseManager.loadTables(xml);
            i_callback();
        }
    );
}



LoaderManager.prototype.createResources = function(i_uploadFileElement)
{
    var self = this;

    var resourceList = [];

    var fnAddResource = function addResource(i_file)
    {
        var filePack = {};
        filePack.file = i_file;
        var fileNameAndExt = self.getFileNameAndExt(filePack.file.name);
        var fileName = fileNameAndExt[0];
        var fileExt = fileNameAndExt[1];
        var defaultPlayer = self.getDefaultPlayer(fileExt);

        var resources = self.m_dataBaseManager.table_resources();
        var resource = resources.createRecord();
        resource.resource_name = fileName;
        resource.resource_type = fileExt;
        resource.default_player = defaultPlayer;
        resources.addRecord(resource);
        resourceList.push(resource.resource_id);
        filePack.fileName = resource.resource_id + "." +fileExt

        self.filesToUpload.push(filePack);

        //alert(fileName);
    }




    if (i_uploadFileElement.files)
    {
        //alert('multi files')
        var count = i_uploadFileElement.files.length;
        for(var iFile=0; iFile<count; iFile++)
        {
            fnAddResource(i_uploadFileElement.files[iFile])
        }
    }
    else
    {
        alert('Your browser version does not support HTML5, please upgrade to a newer version.')
        //fnAddResource(i_uploadFileElement)
    }


    return resourceList;
}






LoaderManager.prototype.getFileNameAndExt = function (i_fileName)
{
    var result = null;
    var nameAndExt = i_fileName.split(".");
    try
    {
        var ext = nameAndExt[nameAndExt.length-1];
        var name = i_fileName.substring(0, i_fileName.length-ext.length-1);
        result = [name, ext.toLowerCase()];
    }
    catch(error)
    {
        // Invalid file format
        return null;
    }
    return result;
}


LoaderManager.prototype.getDefaultPlayer = function (i_fileExt)
{
    var playerModule =  -1;
    switch(i_fileExt)
    {
        case "flv":
        case "mp4":
        case "m4v":
        case "mov":
        case "3gp":
            playerModule = 3100;
            break;
        case "jpg":
        case "jpeg":
        case "gif":
        case "png":
        case "bmp": //??? bmp
        case "swf":
        case "pdf":
            playerModule = 3130;
            break;
    }
    return playerModule;
}


LoaderManager.prototype.save = function(i_saveCallback)
{
    var sv = this;
    var url1= 'https://'+sv.m_domain+'/WebService/SubmitData.ashx?command=Begin&user='+sv.m_user+'&password='+sv.m_password+'&appVersion=4.12&appType=StudioLite'+'&callback=?';

    $.getJSON(url1, function(d1) { uploadNextFile(d1.ret); } );


    function uploadNextFile(i_cookie)
    {
        var filePack = sv.filesToUpload.shift();
        if (filePack!=null)
        {
            var httpRequest = new XMLHttpRequest();
            try
            {
                httpRequest.onload = function(oEvent)
                {
                    if (httpRequest.status == 200)
                    {
                        uploadNextFile(i_cookie);
                    }
                };
                var formData = new FormData();
                formData.append("cookie", i_cookie);
                formData.append("file", filePack.file);
                formData.append("filename", filePack.fileName);
                httpRequest.open("POST", 'https://'+sv.m_domain+'/WebService/JsUpload.ashx');
                httpRequest.send(formData);
            }
            catch(error)
            {
                alert(error)
            }
        }
        else
        {
            uploadTables(i_cookie);
        }


        /*
        var iframe = document.createElement("iframe");
        iframe.setAttribute("id", "upload_iframe");
        iframe.setAttribute("name", "upload_iframe");
        iframe.setAttribute("width", "0");
        iframe.setAttribute("height", "0");
        iframe.setAttribute("border", "0");
        iframe.setAttribute("style", "width: 0; height: 0; border: none;");

        // Add to document...
        sv.m_uploadFormElement.parentNode.appendChild(iframe);
        window.frames['upload_iframe'].name = "upload_iframe";

        iframeId = document.getElementById("upload_iframe");

        // Add event...
        var eventHandler = function () {

            if (iframeId.detachEvent) iframeId.detachEvent("onload", eventHandler);
            else iframeId.removeEventListener("load", eventHandler, false);

            // Message from server...
            if (iframeId.contentDocument) {
                content = iframeId.contentDocument.body.innerHTML;
            } else if (iframeId.contentWindow) {
                content = iframeId.contentWindow.document.body.innerHTML;
            } else if (iframeId.document) {
                content = iframeId.document.body.innerHTML;
            }

            document.getElementById(div_id).innerHTML = content;

            // Del the iframe...
            setTimeout('iframeId.parentNode.removeChild(iframeId)', 250);
        }

        if (iframeId.addEventListener) iframeId.addEventListener("load", eventHandler, true);
        if (iframeId.attachEvent) iframeId.attachEvent("onload", eventHandler);

        // Set properties of form...
        sv.m_uploadFormElement.setAttribute("target", "upload_iframe");
        sv.m_uploadFormElement.setAttribute("action", 'https://'+sv.m_domain+'/WebService/JsUpload.ashx');
        sv.m_uploadFormElement.setAttribute("method", "post");
        sv.m_uploadFormElement.setAttribute("enctype", "multipart/form-data");
        sv.m_uploadFormElement.setAttribute("encoding", "multipart/form-data");


        // Submit the form...
        sv.m_uploadFormElement.submit();

        sv.m_uploadDivElement.innerHTML = "Uploading...";
        */
    }


    function uploadTables(i_cookie)
    {
        //alert('up1');
        var changelist = sv.m_dataBaseManager.getChangelist();
        var s64 = $.base64.encode(changelist);
        s64 = s64.replace(/=/g, ".");
        s64 = s64.replace(/[+]/g, "_");
        s64 = s64.replace(/[/]/g, "-");
        multiPost(i_cookie, s64, 0)
    }



    function multiPost(i_cookie, i_data, i)
    {
      var url2= 'https://'+sv.m_domain+'/WebService/SubmitData.ashx?command=Commit&cookie='+i_cookie+'&callback=?';
        var j = Math.min(i+300, i_data.length);
        var d1 = i_data.substring(i, j);
        //alert(d1);
        
        $.getJSON(url2,
            {prm:d1},
            function (data)
            {
		        if (i==j)
        	    {
                  //alert(data.ret);
                  if (data!=null && data.ret!="")
                  {
                    var s64=data.ret;
                    var str = $.base64.decode(s64);
                    var xml = $.parseXML(str);
                    onSubmitData(xml.documentElement)

                    if (i_saveCallback!=null)
                    {
                        i_saveCallback({status:true});
                    }
                  }
                  else
                  {
                    if (i_saveCallback!=null)
                    {
                        i_saveCallback({status:false,error:data.error});
                    }
                  }
                }
                else
        		{
                	multiPost(i_cookie, i_data, j);
		        }
            },
            'JSON'
            );
    }



    function onSubmitData(i_xmlTables)
    {
        var xmlTable;
        var iTable;
        var table;

        sv.m_dataBaseManager.selectDomainBusiness(sv.m_domain, sv.m_businessId);
        var primaryToTables = sv.m_dataBaseManager.getPrimaryToTableMap();


        var changelistId = i_xmlTables.getAttribute("lastChangelistId");
        sv.m_dataBaseManager.lastChangelist = changelistId;

        for (iTable in i_xmlTables.childNodes)
        {
            if (iTable=="item" || iTable=="iterator" || iTable=="length")
                continue;

            xmlTable = i_xmlTables.childNodes[iTable];

            var field = xmlTable.getAttribute("name");
            var tableList = primaryToTables[field];
            for(iTable in tableList)
            {
                var table =  tableList[iTable];
                for(var iRec in xmlTable.childNodes)
                {
                    if (iRec=="item" || iRec=="iterator" || iRec=="length")
                        continue;


                    var xmlRec = xmlTable.childNodes[iRec];
                    var handle = xmlRec.getAttribute("handle");
                    var id = xmlRec.getAttribute("id");
                    var rec = table.getRec(handle);
                    if (rec!=null)
                    {
                        rec.native_id = id;
                        table.setRecordId(handle, id);
                    }
                }
            }
        }
        sv.m_dataBaseManager.commitChanges(changelistId);
    }
}

// b2



