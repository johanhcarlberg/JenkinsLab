package se.iths;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.GregorianCalendar;

public class ActivityRecordTest {
    @Test
    public void canCreateRecord() {
        ActivityRecord activityRecord = new ActivityRecord("1", 5.0, 120, new GregorianCalendar(2024, 0, 1));

        assertEquals("1", activityRecord.id());
        assertEquals(5.0, activityRecord.distance());
        assertEquals(120, activityRecord.time());
        assertEquals(new GregorianCalendar(2024, 0, 1), activityRecord.date());
    }
}
