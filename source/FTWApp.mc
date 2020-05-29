using Toybox.Application as AP;

class FTWApp extends AP.AppBase {

    private var view = null;
    
    function initialize() {
        AppBase.initialize();
    }
    
    // onStart() is called on application start up
    function onStart(state) {
	   System.println("onStart: " + loadResource(Rez.Strings.AppNameTitle));
    }
    
    // onStop() is called when your application is exiting
    function onStop(state) { }
    
    function onSettingsChanged() {
        if (view != null) {
            System.println("FTWApp.onSettingsChanged");
            view.onSettingsChanged();
        }
        
    }
    
    // Return the initial view of your application here
    function getInitialView() {
        if (view == null) {
            view = new FTWView(); 
       }
        return [ view ];
    }
}
