using Toybox.WatchUi as UI;

class Background extends UI.Drawable {

    function initialize(params) {
        Drawable.initialize(params);
    }
    
    function draw(dc) {
       System.println("Background.draw");
       
       var width = dc.getWidth();
       var halfOfWidth = dc.getWidth() / 2;
       
        var height = dc.getHeight();
        
        var minutesWidth = $.minutesDim[0];
        var secondsWidth = $.secondsDim[0];
        
        dc.setColor($.backgroundThemeColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(
            halfOfWidth + (minutesWidth / 2) + secondsWidth,
            0,
            width - halfOfWidth + (minutesWidth / 2) + (secondsWidth / 2),
            height
        );
        
        // drawTickBackground(dc, halfOfWidth, height / 2);
    }
    
    private function drawTickBackground(dc, x, y) {
        var clockTime = System.getClockTime();
        var seconds = clockTime.sec;
        
        var radius = x;
        var ratio = 360.toDouble() / 60;
        var tick = 360 - (seconds * ratio);
        
        drawEachTick(dc, x, y, radius, 360, 270, tick);
        drawEachTick(dc, x, y, radius, 270, 180, tick);
        drawEachTick(dc, x, y, radius, 180, 90, tick);
        drawEachTick(dc, x, y, radius, 90, 35, tick);
        drawEachTick(dc, x, y, radius, 15, 0, tick);
    }
    
    private function drawEachTick(dc, x, y, radius, start, end, tick) {
        var offset = 4;
        
        if (tick <= start && tick >= (end + offset)) {
            dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, start, tick);
            dc.drawArc(x, y, radius - 1, Graphics.ARC_CLOCKWISE, start, tick);
            dc.drawArc(x, y, radius - 2, Graphics.ARC_CLOCKWISE, start, tick);
            dc.drawArc(x, y, radius - 3, Graphics.ARC_CLOCKWISE, start, tick);
            
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, tick, end + offset);
            dc.drawArc(x, y, radius - 1, Graphics.ARC_CLOCKWISE, tick, end + offset);
            dc.drawArc(x, y, radius - 2, Graphics.ARC_CLOCKWISE, tick, end + offset);
            dc.drawArc(x, y, radius - 3, Graphics.ARC_CLOCKWISE, tick, end + offset);
        } else {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, start, end + offset);
            dc.drawArc(x, y, radius - 1, Graphics.ARC_CLOCKWISE, start, end + offset);
            dc.drawArc(x, y, radius - 2, Graphics.ARC_CLOCKWISE, start, end + offset);
            dc.drawArc(x, y, radius - 3, Graphics.ARC_CLOCKWISE, start, end + offset);
        }
    }
}
