using Toybox.WatchUi as UI;
using Toybox.Activity as AC;
using Toybox.ActivityMonitor as AM;

class HeartBackground extends UI.Drawable {

    private var textCenter = $.TEXT_CENTER;
    private var textColor = $.TEXT_COLOR;
    
    private var heartRateTextFont = smallFont;
    
    function initialize(params) {
        Drawable.initialize(params);
    }
    
    function draw(dc) {
        System.println("HeartBackground.draw");
        
        if (!$.showHeartRate) {
            return;
        }
        
        var heartRate = AC.getActivityInfo().currentHeartRate;
        
        /*var hrIterator = ActivityMonitor.getHeartRateHistory(null, false);
        if (hrIterator != null && heartRate == null) {
            var previous = hrIterator.next();
            if (previous != null) {
                heartRate =	previous.heartRate;
            }
        }*/
        
        var heartRateText = "N/A";
        if (heartRate != null) {
            heartRateText = heartRate.toString();
        }
        
        var heartRateTextFontDim = dc.getTextDimensions(heartRateText, heartRateTextFont);
        
        var width = dc.getWidth() / 2;
        var height = dc.getHeight();
        var yOffsetText = 24;
        
        var locX = width;
        var locY = height - ((height - ((height / 2) + ($.minutesDim[1] / 2) + ((heartRateTextFontDim[1] + yOffsetText) / 2))) / 2);
        if ($.hoursFontAscent > 0 && $.hoursFontDescent > 0) {
            // for font with too margin
            locY = locY - 10;
        }
        
        // display heart rate text
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            locX,
            locY - yOffsetText,
            heartRateTextFont,
            heartRateText,
            textCenter
        );
        
        // display heart rate curve
        var heartRateSize = 50;
        locX = locX - (heartRateSize / 2);
        
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        drawHeartRate(dc, locX, locY, locX + 15);
    }
    
    private function drawHeartRate(dc, locX, locY, locXPlusOffset) {
        // first line
        dc.drawLine(locX, locY, locXPlusOffset, locY);
        drawFillCircle(dc, locX + 7, locY);
        
        // second line up
        locX = locXPlusOffset;
        locXPlusOffset = locXPlusOffset + 5;
        dc.drawLine(locX, locY, locXPlusOffset, locY - 10);
        
        // third line down
        locX = locXPlusOffset;
        locXPlusOffset = locXPlusOffset + 5;
        dc.drawLine(locX, locY - 10, locXPlusOffset, locY + 10);
        drawFillCircle(dc, locXPlusOffset, locY + 10);
        
        // fourth line up
        locX = locXPlusOffset;
        locXPlusOffset = locXPlusOffset + 5;
        dc.drawLine(locX, locY + 10, locXPlusOffset, locY - 5);
        
        // fifth to the end 
        locX = locXPlusOffset;
        locXPlusOffset = locXPlusOffset + 20;
        dc.drawLine(locX, locY - 5, locXPlusOffset, locY - 5);
        drawFillCircle(dc, locXPlusOffset, locY - 5);
    }
    
    private function drawFillCircle(dc, locX, locY) {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_DK_RED);
        dc.fillCircle(locX, locY, 2);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
    }
}
