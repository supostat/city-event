if (TheCity == null || typeof(TheCity) != "object") { var TheCity = {}; }

TheCity.PluginHelper = function() {

    $(document).data('TheCity.PluginHelper.Settings',{
        subdomain: 'www',
        useSSL: false,
        extra: 50,
        refresh: 250,
        forceResize: false
    });

    return {
        resizeIFrame: function(options) {
            //Merge previous settings w/ passed options
            var settings = $.extend(
                $(document).data('TheCity.PluginHelper.Settings'),
                options
            );

            var body = document.body;
            var html = document.documentElement;
            var height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight);

            //Check to see if height has changed since last call -- if NOT and height > 0
            //This prevents an infinite loop where we keep expanding the iFrame size. We test for a difference of
            // > 50 because (at least on Chrome) an extra ~30 pixels are added to the height AFTER we've stored the new height
            var diff = Math.abs($(document).data('TheCity.PluginHelper.height') - height) ;
            if ( diff < 85 && $(document).height() && !settings.forceResize) {
                return;
            }

            //Overwrite saved settings with new ones
            $(document).data('TheCity.PluginHelper', settings);
            var schema = settings.useSSL ? "https" : "http";
            var url = schema + '://' + settings.subdomain + '.onthecity.org/#' + encodeURIComponent(document.location.href);
            window.parent.postMessage(height + settings.extra, url);

            if (settings.refresh != 0){
                var height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight);
                $(document).data('TheCity.PluginHelper.height', height);
                setInterval(function(){TheCity.PluginHelper.resizeIFrame();}, settings.refresh);
            }
        }

    };
}();