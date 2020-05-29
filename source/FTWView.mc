using Toybox.WatchUi as UI;
using Toybox.Graphics;
using Toybox.Application as AP;

// global const
const TEXT_COLOR = Graphics.COLOR_LT_GRAY;
const TEXT_CENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

// global "font" var
var largeFont, mediumFont, smallFont;
var hoursFont, minutesFont, secondsFont;
var hoursFontDescent, hoursFontAscent;

var batteryRatioOffset;

// global "datetime" var
var hours, minutes, seconds;
var hoursDim, minutesDim, secondsDim;

var batteryColor, batteryLowColor;

// global values from settings.xml configuration
var batteryLowLevel = 35;
var backgroundThemeColor = Graphics.COLOR_DK_RED;
var showMonthDate = true;
var showDayDate = true;
var showHeartRate = true;
var showBatteryPercent = true;
var isFTWMode = false;

class FTWView extends UI.WatchFace {

    private var activeAperoTime = true;
    private var isAperoTimeLayoutLoaded = false;
    private var isWatchFaceLayoutLoaded = true;
    
    private var themeColors = [
        Graphics.COLOR_DK_BLUE,
        Graphics.COLOR_DK_GREEN,
        Graphics.COLOR_DK_RED
    ];
    
    function initialize() {
        System.println("FTWView.mc loaded.");
        WatchFace.initialize();
        
        $.smallFont = Graphics.FONT_XTINY;
        $.secondsFont = smallFont;
        
        $.mediumFont = Graphics.FONT_NUMBER_MEDIUM;
        $.hoursFont = mediumFont;
        
        $.largeFont = Graphics.FONT_NUMBER_THAI_HOT;
        $.minutesFont = largeFont;
        
        $.batteryColor = Graphics.COLOR_BLUE;
        $.batteryLowColor = Graphics.COLOR_RED;
        
        onSettingsChanged();
    }
    
    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }
    
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() { }
    
    // Update the view
    function onUpdate(dc) {
        System.println("FTWView.onUpdate");
        
        if (!istItAperoTime(dc) && !isWatchFaceLayoutLoaded) {
            setLayout(Rez.Layouts.WatchFace(dc));
            isWatchFaceLayoutLoaded = true;
            isAperoTimeLayoutLoaded = false;
        }
        
        if ($.hoursFontDescent == null || $.hoursFontAscent == null) {
            $.hoursFontDescent = dc.getFontDescent($.hoursFont);
            $.hoursFontAscent = dc.getFontAscent($.hoursFont);
        }
        
        updateClockTime(dc); 
        
        View.onUpdate(dc);
    }
    
    private function istItAperoTime(dc) {
        if (!activeAperoTime) {
            return false;
        }
        
        var clockTime = System.getClockTime();
        if ((clockTime.hour == 12 || clockTime.hour == 18) &&
            clockTime.min == 15 && clockTime.sec < 15) {
            if (!isAperoTimeLayoutLoaded) {
                setLayout(Rez.Layouts.FTW(dc));
                isAperoTimeLayoutLoaded = true;
                isWatchFaceLayoutLoaded = false;
            }
            return true;
        }
        return false;
    }
    
    private function updateClockTime(dc) {
        var clockTime = System.getClockTime();
        
        $.hours = clockTime.hour.format("%02d");
        $.minutes = clockTime.min.format("%02d");
        $.seconds = clockTime.sec.format("%02d");
        
        $.hoursDim = dc.getTextDimensions(hours, hoursFont);
        $.minutesDim = dc.getTextDimensions(minutes, minutesFont);
        $.secondsDim = dc.getTextDimensions(seconds, secondsFont);
    }
    
    function onSettingsChanged() {
        System.println("FTWView.onSettingsChanged");
        
        activeAperoTime = AP.getApp().getProperty("ActiveAperoTime");
        isFTWMode = AP.getApp().getProperty("FTWMode");
        
        updateBatterySettings();
        updateThemeSettings();
        updateDateSettings();
        updateHeartRateSettings();
    }
    
    private function updateThemeSettings() {
        var theme = AP.getApp().getProperty("Theme");
        if (theme != null) {
            $.backgroundThemeColor = themeColors[theme];
        }
    }
    
    private function updateBatterySettings() {
        var value = AP.getApp().getProperty("BatteryLevelLow");
        if (value != null) {
            $.batteryLowLevel = value;
        }
        
        value = AP.getApp().getProperty("ShowBatteryPercent");
        if (value != null) {
            $.showBatteryPercent = value;
        }
    }
    
    private function updateDateSettings() {
        var value = AP.getApp().getProperty("ShowMonthDate");
        if (value != null) {
            $.showMonthDate = value;
        }
        
        value = AP.getApp().getProperty("ShowDayDate");
        if (value != null) {
            $.showDayDate = value;
        }
    }
    
    private function updateHeartRateSettings() {
        var value = AP.getApp().getProperty("ShowHeartRate");
        if (value != null) {
            $.showHeartRate = value;
        }
    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() { }
    
    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() { }
    
    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() { }
}
