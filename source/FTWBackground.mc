using Toybox.WatchUi as UI;
using Toybox.ActivityMonitor as AM;

class FTWBackground extends UI.Drawable {

    private var textCenter = $.TEXT_CENTER;
    private var textColor = $.TEXT_COLOR;
    
    private var title = null;
    private var bitmap = null;
    private var aperoValueTextDim = null;
    
    private var aperoValueText = "APERO";
    private var timeValueText = "TIME";
    
    function initialize(params) {
        Drawable.initialize(params);
        
        
    }
    
    function draw(dc) {
        System.println("FTWBackground.onUpdate");
        
        bitmap = UI.loadResource(Rez.Drawables.apero);
        title = UI.loadResource(Rez.Strings.AppName);
        if ($.isFTWMode) {
            title = UI.loadResource(Rez.Strings.AppNameTitle);
            bitmap = UI.loadResource(Rez.Drawables.ftw);
        }
         
        if (aperoValueTextDim == null) {
            aperoValueTextDim = dc.getTextDimensions(aperoValueText, Graphics.FONT_MEDIUM);
        }
        
        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;
        
        var imageSize = 64;
        var offset = imageSize / 2;
        
        dc.setColor(textColor, Graphics.COLOR_BLACK);
        dc.drawText(x, y - offset - 30, $.smallFont, title, textCenter);
        
        dc.drawBitmap(x - offset, y - offset, bitmap);
        
        dc.drawText(x, y + offset + 30, Graphics.FONT_MEDIUM, "APERO", textCenter);
        dc.drawText(x, y + offset + 30 + aperoValueTextDim[1], $.smallFont, "TIME", textCenter);
    }
}
