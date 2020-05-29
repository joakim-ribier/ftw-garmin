using Toybox.WatchUi as UI;

class BatteryBackground extends UI.Drawable {

    private var textCenter = $.TEXT_CENTER;
    private var textColor = $.TEXT_COLOR;
    
    private var batteryFont = $.smallFont;
    
    function initialize(params) {
        Drawable.initialize(params);
    }
    
    function draw(dc) {
        System.println("BatteryBackground.draw");
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        var batteryLevel = System.getSystemStats().battery;
        var batteryText = "N/A";
        if (batteryLevel != null) {
            batteryText = batteryLevel.toNumber() + "%";
        }
        var batteryFontDim = dc.getTextDimensions(batteryText, batteryFont);
        
        var batteryWidth = 40;
        var batteryHeight = 12;
        
        var batteryWidthWithBorder = batteryWidth + 5;
        var batteryHeightWithBorder = batteryHeight + 4;
        
        var locX = width / 2 - (batteryWidthWithBorder / 2);
        var locY = (((height / 2) - ($.minutesDim[1] / 2)) / 2) - (batteryHeightWithBorder / 2) - (batteryFontDim[1] / 2);	
        if ($.hoursFontAscent > 0 && $.hoursFontDescent > 0) {
            // for font with too margin...
            locY = locY + 10;	
        }
        
        drawBattery(dc, locX, locY, batteryWidth, batteryHeight, batteryLevel);
        
        if ($.showBatteryPercent) {
            var yOffsetText = 30;
            drawBatteryLevelText(dc, width / 2, locY + yOffsetText, batteryText, batteryFontDim);
        }
    }
    
    private function drawBatteryLevelText(dc, x, y, batteryText, batteryFontDim) {
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x,
            y,
            batteryFont,
            batteryText,
            textCenter
        );
    }
    
    private function drawBattery(dc, baseLocX, baseLocY, batteryWidth, batteryHeight, batteryLevel) {
        var ratio = batteryWidth.toDouble() / 100;
        var newBatteryLevel = batteryLevel * ratio;
        
        // draw inside (level part)
        dc.setColor($.batteryColor, Graphics.COLOR_TRANSPARENT);
        if ($.batteryLowLevel >= batteryLevel) {
            dc.setColor($.batteryLowColor, Graphics.COLOR_TRANSPARENT);
        }
        
        dc.fillRectangle(
            baseLocX,
            baseLocY,
            newBatteryLevel,
            batteryHeight
        );
        
        // add margin
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(
            baseLocX - 1,
            baseLocY - 1,
            batteryWidth + 2, 
            batteryHeight + 2
        );
        
        // add border
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(
            baseLocX - 2,
            baseLocY - 2,
            batteryWidth + 4, 
            batteryHeight + 4
        );
        
        // draw right side (battery's nose)
        var width = 3;
        var height = 9;
        dc.fillRectangle(
            baseLocX + batteryWidth + 2,
            baseLocY + (batteryHeight / 2) - (height / 2),
            width, 
            height
        );
    }
}
