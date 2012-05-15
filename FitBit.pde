Table day1;
Table day2;
Table day3;
Table day4;
Table day5;
Table day6;
Table day7;

String[] days = {
  "day1", "day2", "day3", "day4", "day5", "day6", "day7"
};

ArrayList<FitBitObject> fitbitList = new ArrayList();

HashMap<String, FitBitDay> fitbitHash = new HashMap();


void setup() {
  size(800, 600);
  smooth();
  background(0);
  for (int i = 0; i < days.length; i++) {
    getData(days[i]);
    findWalks(days[i]);
  }
  for (int f = 0; f < days.length; f++) {
    FitBitDay d = fitbitHash.get(days[f]);
    println(days[f]);
    println("Total Minutes = " + d.minutesWalked);
    println("Total Steps = " + d.totalSteps);
    println("Total Calories = " + d.totalCalories);
    println();
  }
  renderDay(days[0]);
}

void draw() {
}

void getData(String thisDay) {
  Table t = new Table(this, thisDay + ".csv");
  for (int i = 0; i < t.getRowCount(); i++) {
    int steps = t.getInt(i, 0);
    float calories = t.getFloat(i, 1);

    MinuteObject m = new MinuteObject();
    m.steps = steps;
    m.calories = calories;

    //add data to minuteList in HashMap
    if (fitbitHash.containsKey(thisDay)) {
      FitBitDay d = fitbitHash.get(thisDay);
      d.minuteList.add(m);
    } 
    //create HashMap bin if doesn't exist; add minuteList data
    else {
      FitBitDay d = new FitBitDay();
      d.label = thisDay;
      d.minuteList.add(m);
      fitbitHash.put(thisDay, d);
    }
  }
}

void findWalks(String thisDay) {
  FitBitDay d = fitbitHash.get(thisDay);
  int counter = 0;
  int steps = 0;
  float calories = 0;
  ArrayList<MinuteObject> l = fitbitHash.get(thisDay).minuteList;

  ArrayList walks = new ArrayList();
  for (int i = 0; i < l.size(); i++) {
    MinuteObject m = l.get(i);
    //if current steps is greater than 0, user is walking
    if (m.steps > 0) {
      counter++;
      steps += m.steps;
      calories += m.calories;
    }
    //if current steps is zero, check to see if the next 4 minutes are also 0
    //if more than 5 minutes have zero steps, user stopped walking - total walk and add to list
    //otherwise, user paused and then continued - continue counting
    try { 

      if (m.steps == 0 && l.get(i-1).steps > 0 && l.get(i+1).steps == 0 && 
        l.get(i+2).steps == 0 && l.get(i+3).steps == 0 && l.get(i+4).steps == 0 && l.get(i+5).steps == 0) {

        if (counter >= 10) {
          print("i = " + i + " " + (i-1) + " " + (i+1) + " " + (i+2) + " " + (i+3)+" "+(i+4)+" "+(i+5)+" ");
          println("count = " + counter);
          println();

          FitBitObject fb = new FitBitObject();
          fb.startingPoint = i - counter;
          fb.minutes = counter;
          fb.steps = steps;
          fb.calories = calories;

          d.fitbitList.add(fb);
          //fitbitList.add(fb);
          walks.add(counter);
        } 
        counter = 0;
        steps = 0;
        calories = 0;
      }
    }
    catch(Exception e) {
      //println(e);
    }
  }
  for (int k = 0; k < d.fitbitList.size(); k++) {
    d.totalCalories +=int(d.fitbitList.get(k).calories);
    d.totalSteps += d.fitbitList.get(k).steps;
    d.minutesWalked += d.fitbitList.get(k).minutes;
    println(thisDay);

    println("Workout " + (k+1));
    println("minutes: " + d.fitbitList.get(k).minutes);
    println("steps: " + d.fitbitList.get(k).steps);
    println("calories: " + d.fitbitList.get(k).calories);
    println();
  }
}

void renderDay(String thisDay) {
  FitBitDay d = fitbitHash.get(thisDay);
  ArrayList<MinuteObject> l = fitbitHash.get(thisDay).minuteList;
  //for (FitBitObject fb:d.fitbitList) {
  FitBitObject fb = d.fitbitList.get(1);
  int startPoint = fb.startingPoint;
  int endPoint = startPoint + fb.minutes;
  println(startPoint + " - " + endPoint);
  int inc = 1;
  for (int j = startPoint; j < endPoint; j++) {
    fill(255, 0, 0);
    rect(15*inc, height - 100, 10, -l.get(j).steps*(5));
    inc++;
  }

  //println("S = " + s);
  //}

  fill(255);
  text("Summary for " + thisDay.toUpperCase(), 20, 20);
  text("Total Calories Burned: " + d.totalCalories, 20, 60);
  text("Total Steps Taken: " + d.totalSteps, 20, 100);
  text("Time Spent Walking/Running: " + d.minutesWalked, 20, 140);
}

