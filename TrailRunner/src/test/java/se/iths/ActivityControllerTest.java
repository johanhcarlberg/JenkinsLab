package se.iths;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.stream.Collectors;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

public class ActivityControllerTest {
    private DatabaseAPI db;

    @BeforeEach
    public void setup() {
        db = mock(DatabaseAPI.class);
    }

    @Test
    public void canAddActivity() {
        ActivityController activityController = new ActivityController(db);
        Activity activity = new Activity("1", 10.0, 60, new GregorianCalendar(2024, 1, 1));
        when(db.createRecord(activity.id, activity.distance, (int) activity.time.toSeconds(), LocalDate.ofInstant(activity.date.toInstant(), ZoneId.systemDefault()))).thenReturn(true);

        activityController.addActivity(activity);

        verify(db).createRecord(activity.id, activity.distance, (int) activity.time.toSeconds(), LocalDate.ofInstant(activity.date.toInstant(), ZoneId.systemDefault()));
    }

    @Test
    public void canReadRecordFromId() {
        ActivityController activityController = new ActivityController(db);
        Activity activity = new Activity("1", 10.0, 60, new GregorianCalendar(2024, 1, 1));

        when(db.readRecord(activity.id)).thenReturn(new ActivityRecord(activity.id, activity.distance, (int) activity.time.getSeconds(), activity.date));
        Activity activityFromDb = activityController.getActivityById(activity.id);
        
        verify(db).readRecord(activity.id);

        assertEquals("1", activityFromDb.id);
        assertEquals(10.0, activityFromDb.distance);
        assertEquals(60, activityFromDb.time.getSeconds());
        assertEquals(new GregorianCalendar(2024, 1, 1), activityFromDb.date);
    }

    @Test
    public void canGetRecordIds() {
        ActivityController activityController = new ActivityController(db);
        List<String> idList = new ArrayList<>();
        idList.add("1");
        idList.add("2");

        when(db.getRecordIDs()).thenReturn(idList);
        List<String> idListFromDb = activityController.getActivityIDs();

        verify(db).getRecordIDs();
        assertTrue(idListFromDb.contains(idList.get(0)));
        assertTrue(idListFromDb.contains(idList.get(1)));
    }

    @Test
    public void canDeleteRecord() {
        ActivityController activityController = new ActivityController(db);

        when(db.deleteRecord("1")).thenReturn(true);
        activityController.deleteActivity("1");
        verify(db).deleteRecord("1");

    }

    @Test
    public void canFilterActivities() {
        ActivityController activityController = new ActivityController(db);

        List<String> idList = new ArrayList<>();
        idList.add("1");
        idList.add("2");
        idList.add("3");
        when(db.getRecordIDs()).thenReturn(idList);

        List<ActivityRecord> activities = new ArrayList<>();
        activities.add(new ActivityRecord("1", 20.0, 60, new GregorianCalendar(2024, 0, 1)));
        activities.add(new ActivityRecord("2", 30.0, 120, new GregorianCalendar(2024, 0, 2)));
        activities.add(new ActivityRecord("3", 35.0, 120, new GregorianCalendar(2024, 0, 2)));

        when(db.readRecord(anyString())).thenAnswer(new Answer<ActivityRecord>() {
            @Override
            public ActivityRecord answer(InvocationOnMock invocation) throws Throwable {
                return activities.stream().filter(a -> a.id().equals(invocation.getArgument(0))).findAny().get();
            }
        });

        List<Activity> filteredActivities = activityController.getActivitiesByDistance(25);

        verify(db).getRecordIDs();
        verify(db, times(3)).readRecord(anyString());

        assertEquals(2, filteredActivities.size());
        assertEquals(2, filteredActivities.stream().filter(a -> a.distance >= 25).collect(Collectors.toList()).size());
    }
}
