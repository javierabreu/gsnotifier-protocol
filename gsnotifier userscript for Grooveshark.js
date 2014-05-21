// ==UserScript==
// @name       Grooveshark Notifier
// @namespace  http://javierabr.eu/
// @version    0.1
// @description Calls a custom protocol gsnotifier:albumarturi/songbyartist, so OS can pickup and notify you through i.e. notify-send
// @match      http://grooveshark.com*
// @copyleft   2014, Javier Abreu
// ==/UserScript==

(function(){
    console.log("gsnotifier: checking for jQuery...");
    if (window.jQuery){
        console.log("gsnotifier: INJECTING!");
        jQuery(document).ready( function(){
            jQuery("#now-playing-image").on("load", function(e){
                var albumArtUri = e.target.src,
                    songName    = jQuery("#now-playing-metadata .now-playing-link.song").attr("title"),
                    artistName  = jQuery("#now-playing-metadata .now-playing-link.artist").attr("title"),
                    notifierUrl = "gsnotifier:" + encodeURIComponent(albumArtUri) + "/" + encodeURIComponent(songName + " By " + artistName);
                
                if (jQuery("#gsnotifierframe").length == 0){
                    jQuery('body').append('<iframe id="gsnotifierframe" src=""></iframe>');
                }
                jQuery("#gsnotifierframe").attr("src", notifierUrl);
                console.log("gsnotifier: Executing "+notifierUrl);
            });
            console.log("gsnotifier: PLUGGED!");
        });
    }else{
        console.log("gsnotifier: NO jQuery yet, scheduling for 1s");
        setTimeout("("+arguments.callee+")()", 1000); // Hack: scheduling injector function without closure
    }
})();
