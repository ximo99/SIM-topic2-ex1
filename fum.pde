// Código principal
ParticleSystem ps;
PVector wind;

void setup()
{
  size(640, 460);
  ps = new ParticleSystem(new PVector(width/2, height));
}

void draw()
{
  background(0);
  
  float dx = map(mouseX, 0, width, -0.2, 0.2);
  wind = new PVector(dx * 0.2, 0);

  ps.applyForce(wind);
  ps.run();
  
  for (int i = 0; i < 2; i++)
    ps.addParticle();
}


// A simple Particle class
class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l)
  {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-0.5, 0.5), random(-2, -10));
    position = l.copy();
    lifespan = 100.0;
  }

  void run()
  {
    update();
    display();
  }
  
  // Method to apply a force vector to the Particle object
  // Note we are ignoring "mass" here
  void applyForce(PVector force)
  {
    acceleration.add(force);
  }

  // Method to update position
  void update()
  {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
    acceleration.set (0,0);    // Clerar Acceleration
  }

  // Method to display
  void display()
  {
    stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead()
  {
    if (lifespan < 0.0)
      return true;
    else
      return false;
  }
}

// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 
class ParticleSystem
{
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector position)
  {
    particles = new ArrayList<Particle>();
    origin = position.copy();
  }

  void addParticle()
  {
    particles.add(new Particle(origin));
  }
  
  // Method to add a force vector to all particles currently in the system
  void applyForce(PVector dir)
  {
    for(Particle ps: particles)
      ps.applyForce(dir);
  }

  void run()
  {
    for (int i = particles.size()-1; i >= 0; i--)
    {
      Particle p = particles.get(i);
      p.run();
      
      if (p.isDead())
        particles.remove(i);
    }
  }
}
