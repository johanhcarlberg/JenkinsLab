package se.iths;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;
import java.util.GregorianCalendar;

public class ActivityManagerTest {
    
    @Test
    public void testCreateActivityManager() {
        ActivityManager aManager = new ActivityManager();

        assertEquals(0, aManager.activities.size());
    }

    @Test
    public void canAddActivityToMap() {
        ActivityManager aManager = new ActivityManager();
        Activity activity = new Activity("1", 1, 60, new GregorianCalendar(2024, 1, 1));

        aManager.addActivity(activity);
        assertEquals(1, aManager.activities.size());
    }

    @Test
    public void canGetActivityFromMap() {
        ActivityManager aManager = new ActivityManager();
        Activity activity = new Activity("1", 1, 60, new GregorianCalendar(2024, 1, 1));

        String activityId = activity.id;

        aManager.addActivity(activity);

        Activity retrievedActivity = aManager.getActivity(activityId);
        assertEquals(activity.id, retrievedActivity.id);
        assertEquals(activity.distance, retrievedActivity.distance);
        assertEquals(activity.time, retrievedActivity.time);
        assertEquals(activity.date, retrievedActivity.date);
    }

    @Test
    public void canCalculateTotalDistance() {
        ActivityManager aManager = new ActivityManager();
        Activity activity = new Activity("1", 1, 60, new GregorianCalendar(2024, 1, 1));
        Activity activity2 = new Activity("2", 4, 60, new GregorianCalendar(2024, 1, 1));

        aManager.addActivity(activity);
        aManager.addActivity(activity2);

        assertEquals(5.0, aManager.totalDistance());
    }

    @Test
    public void canCalculateAverageDistance() {
        ActivityManager aManager = new ActivityManager();
        Activity activity = new Activity("1", 1, 60, new GregorianCalendar(2024, 1, 1));
        Activity activity2 = new Activity("2", 4, 60, new GregorianCalendar(2024, 1, 1));

        aManager.addActivity(activity);
        aManager.addActivity(activity2);

        assertEquals(2.5, aManager.averageDistance());
    }

    @Test
    public void canRemoveActivity() {
        ActivityManager aManager = new ActivityManager();
        Activity activity = new Activity("1", 1, 60, new GregorianCalendar(2024, 1, 1));
        Activity activity2 = new Activity("2", 4, 60, new GregorianCalendar(2024, 1, 1));

        aManager.addActivity(activity);
        aManager.addActivity(activity2); 

        assertEquals(2, aManager.activities.size());

        aManager.removeActivity(activity2.id);

        assertEquals(1, aManager.activities.size());
    }

    @Test
    public void canGetNextActivityId() {
        ActivityManager aManager = new ActivityManager();

        assertEquals("1", aManager.getNextActivityId());
        assertEquals("2", aManager.getNextActivityId());
    }

    @Test
    public void canAutogenerateId() {
    ActivityManager aManager = new ActivityManager();
    Activity activity = new Activity(aManager.getNextActivityId(), 1, 1, 0, 0, new GregorianCalendar(2024, 0, 1));
    Activity activity2 = new Activity(aManager.getNextActivityId(), 1, 1, 0, 0, new GregorianCalendar(2024, 0, 1));

    assertEquals("1", activity.id);
    assertEquals("2", activity2.id);
    }

    @Test
    public void canNotHaveSameId() {
    ActivityManager aManager = new ActivityManager();
    Activity activity = new Activity("1", 1, 1, 0, 0, new GregorianCalendar(2024, 0, 1));
    Activity activity2 = new Activity("1", 1, 1, 0, 0, new GregorianCalendar(2024, 0, 1));

    aManager.addActivity(activity);
    assertThrows(IllegalArgumentException.class, () -> aManager.addActivity(activity2));
    }
}
