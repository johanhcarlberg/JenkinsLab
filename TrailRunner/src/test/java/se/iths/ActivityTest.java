package se.iths;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;
import java.util.GregorianCalendar;

public class ActivityTest {

    @Test
    public void createActivity() {
        Activity activity = new Activity("1", 1, 60, new GregorianCalendar(2024, 1, 1));

        assertEquals(1, activity.distance);
        assertEquals(60, activity.time.getSeconds());
        assertEquals(new GregorianCalendar(2024, 1, 1), activity.date);
    }

    @Test
    public void activityHasIdString() {
        Activity activity = new Activity("1", 1, 60, new GregorianCalendar(2024, 1, 1));
        
        assertEquals("1", activity.id);

        Activity activity2 = new Activity("2", 1, 60, new GregorianCalendar(2024, 1, 1));

        assertEquals("2", activity2.id);
    }
    
    @Test
    public void createActivityInHourMinuteSecond() {
        Activity activity = new Activity("1", 1, 1, 2, 3, new GregorianCalendar(2024, 1, 1));

        assertEquals(3723, activity.time.getSeconds());
    }

    @Test
    public void calculateAverageSpeed() {
        Activity activity = new Activity("1", 1, 1, 0, 0, new GregorianCalendar(2024, 1, 1));  

        assertEquals(1, activity.averageSpeed());
    }

    @Test
    public void canCalculatePace() {
        Activity activity = new Activity("1", 1, 1, 0, 0, new GregorianCalendar(2024, 1, 1));  

        assertEquals(60, activity.calculatePace().toMinutes());

        Activity activity2 = new Activity("2", 5, 0, 26, 30, new GregorianCalendar(2024, 1, 1));  

        assertEquals(318, activity2.calculatePace().getSeconds());
    }

    @Test
    public void canGetDetailsFromToString() {
        Activity activity = new Activity("1", 1, 1, 0, 0, new GregorianCalendar(2024, 0, 1));
        String[] actualStrings = activity.toString().split("\n");
        assertEquals("Distance: 1.0km", actualStrings[0]);
        assertEquals("Duration: 1 hour, 0 minutes, 0 seconds.", actualStrings[1]);
        assertEquals("Date: 2024-01-01", actualStrings[2]);
        assertEquals("Average speed: 1.0km/h", actualStrings[3]);
        assertEquals("Pace: 60:0min/km", actualStrings[4]);
    }

    @Test
    public void canCreateActivityWithId() {
        Activity activity = new Activity("5", 1, 60, new GregorianCalendar(2024, 1, 1));
        Activity activity2 = new Activity("6", 1, 1, 0, 60, new GregorianCalendar(2024, 1, 1));

        assertEquals("5", activity.id);
        assertEquals("6", activity2.id);
    }
    
}
