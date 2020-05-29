using Toybox.WatchUi as UI;
using Toybox.ActivityMonitor as AM;

class ActivityBackground extends UI.Drawable {

    private var textCenter = $.TEXT_CENTER;
    private var textColor = $.TEXT_COLOR;
    
    function initialize(params) {
        Drawable.initialize(params);
    }
    
    function draw(dc) {
        System.println("ActivityBackground.draw");
        
        var halfOfWidth = dc.getWidth() / 2;
        var halfOfHeight = dc.getHeight() / 2;
        
        var steps = AM.getInfo().steps;
        drawSteps(dc, halfOfWidth, halfOfHeight, steps);
    }
    
    private function drawSteps(dc, x, y, steps) {
        var prefix = "";
        var suffix = "";
        var yOffsetBetweenLetters = -3;
        
        var array = Lang.format("$1$", [steps]).toCharArray();
        var size = array.size();
        
        x = x + ($.minutesDim[0] / 2) + $.secondsDim[0] + 35;
        y = y - ((size / 2) * ($.secondsDim[1] + yOffsetBetweenLetters));
        if (size % 2 != 0) {
            y = y - ($.secondsDim[1] / 2);
        }
        
        // compute text dimension
        var textDim = dc.getTextDimensions(prefix + 5 + suffix, $.secondsFont);
        
        // draw background 
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(x - (textDim[0] / 2), 0, textDim[0], dc.getHeight());
        
        // display steps in vertical mode
        dc.setColor(textColor, Graphics.COLOR_BLACK);
        for (var i = 0; i < size; i += 1 ) {
            var yOffset = (i * ($.secondsDim[1] + yOffsetBetweenLetters));
            dc.drawText(
                x,
                y + yOffset,
                $.secondsFont,
                prefix + array[i] + suffix,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
        
        // draw border effect to text
        var totalSize = size * ($.secondsDim[1] + yOffsetBetweenLetters);
        var borderWidth = 3;
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(x - (textDim[0] / 2) - borderWidth, y + ((yOffsetBetweenLetters * -1)), borderWidth, totalSize);
        dc.fillRectangle(x - (textDim[0] / 2) + textDim[0], y + ((yOffsetBetweenLetters * -1)), borderWidth + 1, totalSize);
    }
}
