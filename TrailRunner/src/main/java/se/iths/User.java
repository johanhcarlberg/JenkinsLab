package se.iths;

public class User {
    int height;
    int weight;

    public User(int height, int weight) {
        this.height = height;
        this.weight = weight;
    }

    public double calculateBMI() {
        double heightDouble = (double) height;
        return weight/Math.pow((heightDouble/100),2);
    }
}
