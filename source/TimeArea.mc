using Toybox.WatchUi as UI;
using Toybox.Time.Gregorian as DT;

class TimeArea extends UI.Drawable {

    private var textCenter = $.TEXT_CENTER;
    private var textColor = $.TEXT_COLOR;
    
    private var hoursLocY, secondsLocX, secondsLocY;
    private var secondsTextFontDim;
    
    // load resource only one time
    private var months = { 
        1  => loadResource(Rez.Strings.Jan),
        2  => loadResource(Rez.Strings.Feb),
        3  => loadResource(Rez.Strings.Mar),
        4  => loadResource(Rez.Strings.Apr),
        5  => loadResource(Rez.Strings.May),
        6  => loadResource(Rez.Strings.Jun),
        7  => loadResource(Rez.Strings.Jul),
        8  => loadResource(Rez.Strings.Aug),
        9  => loadResource(Rez.Strings.Sep),
        10 => loadResource(Rez.Strings.Oct),
        11 => loadResource(Rez.Strings.Nov),
        12 => loadResource(Rez.Strings.Dec)
    };
    
    private var days = {
        1  => loadResource(Rez.Strings.Sun),
        2  => loadResource(Rez.Strings.Mon),
        3  => loadResource(Rez.Strings.Tue),
        4  => loadResource(Rez.Strings.Wed),
        5  => loadResource(Rez.Strings.Thu),
        6  => loadResource(Rez.Strings.Fri),
        7  => loadResource(Rez.Strings.Sat)
    };
    
    function initialize(params) {
        Drawable.initialize(params);
        
        $.timeAreaDrawable = self;
    }
    
    function draw(dc) {
        System.println("TimeArea.draw");
        
        var halfOfWidth = dc.getWidth() / 2;
        var halfOfHeight = dc.getHeight() / 2;
        
        var hoursLocX = ((halfOfWidth - ($.minutesDim[0] / 2)) / 2);
        hoursLocY = halfOfHeight;
        
        drawHours(dc, hoursLocX, hoursLocY);
        drawColons(dc, halfOfWidth, halfOfHeight, hoursLocX);
        drawMinutes(dc, halfOfWidth, halfOfHeight);
        drawSeconds(dc, halfOfWidth, hoursLocY);
        
        // draw date if user wants to display day or month
        if ($.showDayDate || $.showMonthDate) {
            drawDate(dc, hoursLocX, hoursLocY);
        }
    }
    
    // Partial update called every second by FTWView.onPartialUpdate(dc).
    function onPartialUpdate(dc) {
        System.println("TimeArea.onPartialUpdate");
        
        dc.clearClip();
        dc.setClip(
            secondsLocX - (secondsTextFontDim[0] / 2),
            secondsLocY - ((secondsTextFontDim[1] / 2) - 1),
            secondsTextFontDim[0],
            secondsTextFontDim[1]);
            
        dc.clear();
        
        drawSeconds(dc, dc.getWidth() / 2, hoursLocY);
    }
    
    private function drawDate(dc, x, y) {
        var date = DT.info(Time.now(), Time.FORMAT_SHORT);
        
        var formatDayDate = Lang.format("$1$ $2$", [days[date.day_of_week], date.day]);
        var formatMonthDate = Lang.format("$1$", [months[date.month]]);
        
        var dateDim = dc.getTextDimensions(formatDayDate, $.secondsFont);
        
        var dayDateLocX = x;
        var dayDateLocY = y - ($.hoursDim[1] / 2);
        
        var monthDateLocX = x;
        var monthDateLocY = y + ($.hoursDim[1] / 2);
        
        if ($.hoursFontAscent == 0 || $.hoursFontDescent == 0) {
            // font with no margin
            dayDateLocY = y - (hoursDim[1] / 2) - 10;
            monthDateLocY = y + (hoursDim[1] / 2) + 10;
        }
        
        var yTextOffset = 15;
        
        if ($.showDayDate) {
            // display: Mon, 25
            dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                dayDateLocX,
                dayDateLocY - yTextOffset,
                $.secondsFont,
                formatDayDate,
                textCenter
            );
            
            dc.setColor($.backgroundThemeColor, Graphics.COLOR_DK_RED);
            dc.fillRectangle(
                dayDateLocX - (dateDim[0] / 4),
                dayDateLocY,
                dateDim[0] / 2,
                2
            );
        }
        
        if ($.showMonthDate) {
            dc.setColor($.backgroundThemeColor, Graphics.COLOR_DK_RED);
            dc.fillRectangle(
                monthDateLocX - (dateDim[0] / 4),
                monthDateLocY,
                dateDim[0] / 2,
                2
            );
            
            // display: May
            dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                monthDateLocX,
                monthDateLocY + yTextOffset,
                $.secondsFont,
                formatMonthDate,
                textCenter
            );
        }
    }
    
    private function drawSeconds(dc, x, y) {
        dc.setColor(textColor, Graphics.COLOR_BLACK);
        
        secondsTextFontDim = dc.getTextDimensions($.seconds + " ", $.secondsFont);
        
        secondsLocX = x + ($.minutesDim[0] / 2) + secondsTextFontDim[0];
        secondsLocY = y - ($.hoursDim[1] / 2);
        
        dc.drawText(
            secondsLocX,
            secondsLocY,
            $.secondsFont,
            $.seconds + " ",
            textCenter
        );
    }
    
    private function drawColons(dc, x, y, hoursLocX) {
        var colonsHeight = 8; 
        
        var spaceFreeBetweenHoursMinutes = (x - ($.minutesDim[0] / 2)) - (hoursLocX + ($.hoursDim[0] / 2));
        var locX = hoursLocX + ($.hoursDim[0] / 2) + (spaceFreeBetweenHoursMinutes / 2) - (colonsHeight / 2);
        
        dc.setColor($.backgroundThemeColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(locX, y - colonsHeight, colonsHeight, colonsHeight);
        dc.fillRectangle(locX, y + colonsHeight, colonsHeight, colonsHeight);
    }
    
    private function drawHours(dc, x, y) {
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x,
            y,
            $.hoursFont,
            $.hours,
            textCenter
        );
    }
    
    private function drawMinutes(dc, x, y) {
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x,
            y,
            $.minutesFont,
            $.minutes,
            textCenter
        );
        
        // draw stripes on top
        /*dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        var locY = y - 10;		
        for( var i = 0; i < 3; i += 1 ) {
            dc.fillRectangle(
                x - ($.minutesDim[0] / 2), 
                locY,
                $.minutesDim[0], 
                4
            );
            locY = locY + 15;
        }*/
    }
}
