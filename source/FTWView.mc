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
var FTWMode = true;
var FTWModeMorningHour = 12;
var FTWModeAfternoonHour = 18;
var FTWModeMinutes = 15;
var FTWModeDuration = 15;

// components drawalbes instances
var timeAreaDrawable = null;
var heartBackgroundDrawable = null;
var FTWBackgroundDrawable = null;

class FTWView extends UI.WatchFace {

    private var isFTWModeLayoutLoaded = false;
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
    
    // Update "seconds"
    function onPartialUpdate(dc) {
        System.println("FTWView.onPartialUpdate");
        
        updateClockTime(dc);
        
        if (isWatchFaceLayoutLoaded) {
            if ($.timeAreaDrawable != null) {
                timeAreaDrawable.onPartialUpdate(dc);
            }
            if ($.heartBackgroundDrawable != null) {
                heartBackgroundDrawable.onPartialUpdate(dc);
            }
        }
        
        updateFTWModeView(dc, true);
    }
    
    // Update the view
    function onUpdate(dc) {
        System.println("FTWView.onUpdate");
        dc.clearClip();
         
        updateFTWModeView(dc, false);
        
        if ($.hoursFontDescent == null || $.hoursFontAscent == null) {
            $.hoursFontDescent = dc.getFontDescent($.hoursFont);
            $.hoursFontAscent = dc.getFontAscent($.hoursFont);
        }
        
        updateClockTime(dc); 
        
        View.onUpdate(dc);
    }
    
    private function updateFTWModeView(dc, isPartialUpdate) {
         if (isFTWMode()) {
            if (!isFTWModeLayoutLoaded) {
                System.println("FTWView.setLayout(Rez.Layouts.FTW(dc))");
            
                isFTWModeLayoutLoaded = true;
                isWatchFaceLayoutLoaded = false;
                
                // clean the drawable view
                dc.clearClip();
                dc.clear();
                
                // set new layout
                setLayout(Rez.Layouts.FTW(dc));
                
                // draw if partial update
                if (isPartialUpdate) {
                    $.FTWBackgroundDrawable.draw(dc);
                }
            }
         } else {
            if (!isWatchFaceLayoutLoaded) {
                System.println("FTWView.setLayout(Rez.Layouts.WatchFace(dc))");
            
                isWatchFaceLayoutLoaded = true;
                isFTWModeLayoutLoaded = false;
                
                dc.clearClip();
                dc.clear();
                
                setLayout(Rez.Layouts.WatchFace(dc));
                
                View.onUpdate(dc);
            }
         }
    }
    
    private function isFTWMode() {
        if (!FTWMode) {
            return false;
        }
        var clockTime = System.getClockTime();
        return (
            (clockTime.hour == FTWModeMorningHour || clockTime.hour == FTWModeAfternoonHour) 
            && clockTime.min == FTWModeMinutes && clockTime.sec < FTWModeDuration
         );
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
        
        FTWMode = AP.getApp().getProperty("FTWMode");
        FTWModeMorningHour = AP.getApp().getProperty("FTWModeMorningHour");
        FTWModeAfternoonHour = AP.getApp().getProperty("FTWModeAfternoonHour");
        FTWModeMinutes = AP.getApp().getProperty("FTWModeMinutes");
        FTWModeDuration = AP.getApp().getProperty("FTWModeDuration");
        
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
    function onExitSleep() { 
        System.println("FTWView.onExitSleep");
    }
    
    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() { 
        System.println("FTWView.onEnterSleep");
    }
}
