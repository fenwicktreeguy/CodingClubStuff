

//K-means (and potentially K-medians) clustering algorithm code

//THE IMPORTANT STRUCTURES WE NEED:

//datapoints stores the unlabeled points
//k_means stores the possible centroids
//NUM_DATA_POINTS gives the number of unlabeled points, and NUM_K_MEANS is the number of centroids
//belong_to_point stores the unlabeled points that we associate with some centroid
//arr lets us assign random colors to different centroids

ArrayList<Point> datapoints = new ArrayList<Point>();
ArrayList<Point> k_means = new ArrayList<Point>();
HashMap<Point, ArrayList<Point> > belong_to_point = new HashMap<Point, ArrayList<Point> >();
static int NUM_DATA_POINTS = 9999;
static int NUM_K_MEANS = 40;
//draw convex hull around each cluster(?)
boolean initiate = false;


//HIGH LEVEL DESCRIPTION OF K-MEANS CLUSTERING

//The idea is that we can assign some number of centroids that we want to cluster around, and we do the following:

//if we have some points p, we will classify the unclassified points to the closest centroid to it. Then, once we have a collection of the points that cluster
//around a centroid, we update the point to the MEAN of the points in the cluster

//This can be thought of in two critical steps:

//1. CLASSIFICATION: We take unlabeled points and attempt to match them with one of our centroids (based on the closest centroid to the unmatched point)
//2. OPTIMIZATION: We use the unlabeled points we associate with some centroid and update the centroid to be the mean of the points in its cluster

//The mean is defined as the ( sum of all the x values divided by size of cluster, sum of all the y values divided by the size of size of the cluster)


void keyPressed(){
   if(key==BACKSPACE){
     initiate=true;
   }
}




void setup(){
  frameRate(40);
  size(1450,800);
  
  for(int i = 0; i < NUM_DATA_POINTS; i++){
      Point p = new Point(random(0,1450), random(0,800));
      datapoints.add(p);
  }
  /*
  datapoints.add(new Point(350,351));
  datapoints.add(new Point(354,354));
  datapoints.add(new Point(352,352));
  datapoints.add(new Point(356,354));
  datapoints.add(new Point(351,350));
  datapoints.add(new Point(353,353));
  */
  //each k_mean point will have color with it
  for(int i = 0; i < NUM_K_MEANS; i++){
    color c= color(random(0,255),random(0,255),random(0,255));
    k_means.add(new Point(random(0,354),random(0,354),c));
  }
}


//TODO: recompute() is a function which updates the position of the centroid based on the points in its cluster (using the mean, since this is k-means-clustering)
//i.e. it returns a new ArrayList<Point> representing the new positions of the centroids
ArrayList<Point> recompute(){
  ArrayList<Point> newk_means = new ArrayList<Point>();
  for(int i = 0; i < k_means.size(); i++){
    ArrayList<Point> cur_cluster = belong_to_point.get(k_means.get(i));
    float avg_x = 0.0, avg_y = 0.0;
    for(int j = 0; j < cur_cluster.size(); j++){
        avg_x += (cur_cluster.get(j).getX());
        avg_y += (cur_cluster.get(j).getY());
    }
    avg_x /= (float)(cur_cluster.size());
    avg_y /= (float)(cur_cluster.size());
    newk_means.add(new Point(avg_x, avg_y, k_means.get(i).getLabel()));
  }
  
  return newk_means;
}

//TODO: this function should implement code to assign our unassigned points to some known centroids.
void assign_points_to_centroids(){
   for(int i = 0; i < datapoints.size(); i++){
     Point p = new Point(0,0);
     float MIN_VALUE = 1000000007;
     for(int j = 0; j < k_means.size(); j++){
       if(dist(k_means.get(j).getX(), k_means.get(j).getY(), datapoints.get(i).getX(), datapoints.get(i).getY()) < MIN_VALUE){
         MIN_VALUE = dist(k_means.get(j).getX(), k_means.get(j).getY(), datapoints.get(i).getX(), datapoints.get(i).getY());
         p = k_means.get(j);
       }
     }
     println("GIVE POINT : " + p.getX() + " " + p.getY());
     if(belong_to_point.containsKey(p)){
       ArrayList<Point> cluster = belong_to_point.get(p);
       cluster.add(datapoints.get(i));
       //belong_to_point.put(p,cluster);
       //(we technically don't need this line above because by updating cluster,
       //we update belong_to_point.get(p), because both cluster and belong_to_point.get(p) point to the same thing in memory 
       //(this is a feature in java and is tied to an idea referred to as the pointer machine model of computation)
       
     } else {
       ArrayList<Point> new_cluster = new ArrayList<Point>();
       new_cluster.add(datapoints.get(i));
       belong_to_point.put(p,new_cluster);
     }
   }
}

void visualize(){
   for(int i = 0; i < k_means.size(); i++){
     color c = k_means.get(i).getLabel();
     ArrayList<Point> p =belong_to_point.get(k_means.get(i));
     for(int j = 0; j < p.size(); j++){
       fill(c);
       circle(p.get(j).getX(), p.get(j).getY(), 10);
     }
   }
}

void draw(){
  if(initiate){
    background(255);
    
    //TODO: we want to associate some unlabeled point with some centroid based on choosing the closest centroid to the point, and we will use a HashMap<Point, ArrayList<Point> >
    //to store the unlabeled points associated with a centroid.
    //WRITE CODE BENEATH HERE: 
    
    assign_points_to_centroids();
    visualize();
    k_means=recompute(); //k_means should be updated with the return value of recompute() here
    for(int i = 0; i < k_means.size(); i++){
      fill(k_means.get(i).label);
      circle(k_means.get(i).x, k_means.get(i).y, 10);
    }
  }
 }
 
 
class Point{
    public float x, y;
    public color label;
    public Point(float x, float y){
      this.x=x;
      this.y=y;
    }
    public Point(float x, float y, color label){
      this.x =x;
      this.y=y;
      this.label=label;
    }
    public float getX(){
      return x;
    }
    public float getY(){
      return y;
    }
    public color getLabel(){
      return label;
    }
}

