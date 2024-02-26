package se.iths;

import java.time.Duration;
import java.util.Calendar;
import java.text.SimpleDateFormat;

public class Activity {
    double distance;
    Duration time;
    Calendar date;
    String id;

    public Activity(String id, double distance, int seconds, Calendar date) {
        this.id = id;
        this.distance = distance;
        this.time = Duration.ofSeconds(seconds);
        this.date = date;
    }

    public Activity(String id, double distance, int hours, int minutes, int seconds, Calendar date){
        Duration tempTime = Duration.ofHours(hours);
        tempTime = tempTime.plusMinutes(minutes);
        tempTime = tempTime.plusSeconds(seconds);
        this.distance = distance;
        this.time = tempTime;
        this.date = date; 
        this.id = id;
    }

    public double averageSpeed() {
        return distance/(time.toHours());
    }

    public Duration calculatePace() {
        double seconds = time.getSeconds() / distance;
        return Duration.ofSeconds((long) seconds);
    }

    @Override
    public String toString() {
        
        String returnString = "";
        returnString += "Distance: " + distance + "km\n";
        returnString += "Duration: " + time.toHoursPart() + " hour, " + time.toMinutesPart() + " minutes, " + time.toSecondsPart() + " seconds.\n";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        returnString += "Date: " + sdf.format(date.getTime()) + "\n";
        returnString += "Average speed: " + averageSpeed() + "km/h\n";
        returnString += "Pace: " + calculatePace().toMinutes() + ":" + calculatePace().toSecondsPart() + "min/km";
        return returnString;
    }
}
