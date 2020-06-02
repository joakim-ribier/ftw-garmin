using Toybox.WatchUi as UI;
using Toybox.ActivityMonitor as AM;

class FTWBackground extends UI.Drawable {

    private var textCenter = $.TEXT_CENTER;
    private var textColor = $.TEXT_COLOR;
    
    private var title = null;
    private var bitmap = null;
    
    private var ftwText1Dim, ftwText2Dim;
    
    private var ftwText1, ftwText2, ftwText3;
    
    function initialize(params) {
        Drawable.initialize(params);
        
        ftwText1 = UI.loadResource(Rez.Strings.FTW_1);
        ftwText2 = UI.loadResource(Rez.Strings.FTW_2);
        ftwText3 = UI.loadResource(Rez.Strings.FTW_3);
        
        $.FTWBackgroundDrawable = self;
    }
    
    function draw(dc) {
        System.println("FTWBackground.onUpdate");
        
        if (ftwText1Dim == null) {
            ftwText1Dim = dc.getTextDimensions(ftwText1, Graphics.FONT_TINY);
            ftwText2Dim = dc.getTextDimensions(ftwText2, Graphics.FONT_MEDIUM);
        }
        
        bitmap = UI.loadResource(Rez.Drawables.apero);
        title = UI.loadResource(Rez.Strings.AppName);
         
        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;
        
        var imageSize = 64;
        var offset = imageSize / 2;
        
        /* 
          FTW
          IT'S
          {ftw.png}
          APERO
          TIME
        */
        
        dc.setColor(backgroundThemeColor, Graphics.COLOR_BLACK);
        dc.drawText(x, 15, Graphics.FONT_TINY, title, textCenter);
        
        dc.setColor(textColor, Graphics.COLOR_BLACK);
        dc.drawText(x, y - offset - 30, Graphics.FONT_TINY, ftwText1, textCenter);
        
        dc.drawBitmap(x - offset, y - offset, bitmap);
        
        dc.setColor(backgroundThemeColor, Graphics.COLOR_BLACK);
        dc.drawText(x, y + offset + 30, Graphics.FONT_MEDIUM, ftwText2, textCenter);
        
        dc.setColor(textColor, Graphics.COLOR_BLACK);
        dc.drawText(x, y + offset + 30 + ftwText2Dim[1], Graphics.FONT_TINY, ftwText3, textCenter);
    }
}
