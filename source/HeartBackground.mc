using Toybox.WatchUi as UI;
using Toybox.Activity as AC;
using Toybox.ActivityMonitor as AM;

class HeartBackground extends UI.Drawable {

    private var textCenter = $.TEXT_CENTER;
    private var textColor = $.TEXT_COLOR;
    
    private var heartRateTextFont = smallFont;
    private var heartRateTextFontDim;
    
    private var yOffsetText = 24;
    private var locY;
    
    function initialize(params) {
        Drawable.initialize(params);
        
         $.heartBackgroundDrawable = self;
    }
    
    function draw(dc) {
        System.println("HeartBackground.draw");
        
        if (!$.showHeartRate) {
            return;
        }
        
        var heartRateText = getHeartValueText(dc);
        
        var width = dc.getWidth() / 2;
        var height = dc.getHeight();
       
        var locX = width;
        locY = height - ((height - ((height / 2) + ($.minutesDim[1] / 2) + ((heartRateTextFontDim[1] + yOffsetText) / 2))) / 2);
        if ($.hoursFontAscent > 0 && $.hoursFontDescent > 0) {
            // for font with too margin
            locY = locY - 10;
        }
        
        drawHeartText(dc, locX, locY, heartRateText);
        
        // display heart rate curve
        var heartRateSize = 50;
        locX = locX - (heartRateSize / 2);
        
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        drawHeartRate(dc, locX, locY, locX + 15);
    }
    
    // Partial update called every second by FTWView.onPartialUpdate(dc).
    function onPartialUpdate(dc) {
        var clockTime = System.getClockTime();
        
        if (clockTime.sec == 0 || clockTime.sec == 30) {
            System.println("HeartBackground.onPartialUpdate");

            // add clip to clear only the heart rate text drawable part
            dc.clearClip();
            dc.setClip(
                (dc.getWidth() / 2) - (heartRateTextFontDim[0] / 2), 
                (locY - yOffsetText) - (heartRateTextFontDim[1] / 2),
                heartRateTextFontDim[0],
                heartRateTextFontDim[1]);
            
            // clean the content of the clip area
            dc.clear();
            
            var heartRateText = getHeartValueText(dc);
            drawHeartText(dc, dc.getWidth() / 2, locY, heartRateText);
        }
    }
    
    private function drawHeartText(dc, locX, locY, value) {
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            locX,
            locY - yOffsetText,
            heartRateTextFont,
            value,
            textCenter
        );
    }
    private function getHeartValueText(dc) {
        var heartRate = AC.getActivityInfo().currentHeartRate;
        
        /*var hrIterator = ActivityMonitor.getHeartRateHistory(null, false);
        if (hrIterator != null && heartRate == null) {
            var previous = hrIterator.next();
            if (previous != null) {
                heartRate = previous.heartRate;
            }
        }*/
        
        var value = "N/A";
        if (heartRate != null) {
            value = heartRate.toString();
        }
        
        // save the current text dimensions
        heartRateTextFontDim = dc.getTextDimensions(value, heartRateTextFont);
        
        return value;
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
