package se.iths;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ActivityController {
    DatabaseAPI db;
    public ActivityController(DatabaseAPI db) {
        this.db = db;
    }

    public void addActivity(Activity activity) {
        db.createRecord(activity.id, activity.distance, (int) activity.time.toSeconds(), LocalDate.ofInstant(activity.date.toInstant(), ZoneId.systemDefault()));
    }

    public Activity getActivityById(String id) {
        ActivityRecord activityRecord = (ActivityRecord) db.readRecord(id);
        return new Activity(activityRecord.id(), activityRecord.distance(), (int) activityRecord.time(), activityRecord.date());
    }

    public List<String> getActivityIDs() {
        return db.getRecordIDs();
    }

    public void deleteActivity(String id) {
        db.deleteRecord(id);
    }

    public List<Activity> getActivitiesByDistance(double distance) {
        List<String> activityIDs = db.getRecordIDs();
        List<ActivityRecord> activityRecords = new ArrayList<>();
        for (String id : activityIDs) {
            activityRecords.add((ActivityRecord) db.readRecord(id));
        }

        return activityRecords.stream()
        .map(a -> new Activity(a.id(), a.distance(), (int) a.time(), a.date()))
        .filter(a -> a.distance >= distance)
        .collect(Collectors.toList());
    }
}
