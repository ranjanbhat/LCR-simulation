color pink=color(255,20,147);

float V0=1;
float w=1;
float L=2;
float R=1.75;
float C=1;
float qi=0;
float ii=0;

float Xc=(C==0? 0 : 1/(w*C) );
float Xl=w*L;
float Z=pow(( R*R + pow((Xc-Xl),2) ),0.5);
float i0= V0/Z;
float phi = atan((Xc-Xl)/R);

float V;
float p;
float i=ii;
float q=qi;

float t=0;
float dt=0.01;

float x;
float y;

int k=3;
float yrange=V0;
float xrange=k*2*PI/w;
float scale=0.6;
int count=1;

int select=0;

void axes()
{
  strokeWeight(6);
  stroke(pink);
  line(0,0,width,0);
  line(0,-height/2,0,height/2);
}

void keyPressed()
{
  if(keyCode==RIGHT)
  {
    select=(select+1)%7;
    redraw();
  }
  else
  if(keyCode==LEFT)
  {
    select=(7+select-1)%7;
    redraw();
  }
  else
  if(keyCode==UP)
  {
    switch(select)
    {
      case 0: V0+= 0.1; V0=round(V0*100)/100.0; break;
      case 1: w += 0.1; w =round(w *100)/100.0; break;
      case 2: L += 0.1; L =round(L *100)/100.0; break;
      case 3: C += 0.1; C =round(C *100)/100.0; break;
      case 4: R +=0.05; R =round(R *100)/100.0; break; 
      case 5: ii+=0.1; ii =round(ii*100)/100.0; i=ii; break;
      case 6: qi+=0.1; qi =round(qi*100)/100.0; q=qi; break;
    }
    redraw();
  }else
  if(keyCode==DOWN)
  {
    switch(select)
    {
      case 0: if (V0>0){ V0-= 0.1; V0=round(V0*100)/100.0; }     break;
      case 1: if (w >0){ w -= 0.1; w =round(w *100)/100.0; }     break;
      case 2: if (L >0){ L -= 0.1; L =round(L *100)/100.0; }     break;
      case 3: if (C >0){ C -= 0.1; C =round(C *100)/100.0; }     break;
      case 4: if (R >0){ R -=0.05; R =round(R *100)/100.0; }     break; 
      case 5:            ii-=0.1; ii =round(ii*100)/100.0; i=ii; break;
      case 6:            qi-=0.1; qi =round(qi*100)/100.0; q=qi; break;
    }
    redraw();
  }
    i=ii;
    q=qi;
    Xc= C==0? 0 : 1/(w*C);
    Xl= w*L;
    Z=sqrt(R*R + pow((Xc-Xl),2));
    i0=V0/Z;
    phi=atan((Xc-Xl)/R);
}

void show_selected()
{
  float lshift=0,rshift=0;
  
  switch(select)
  {
    case 0: lshift=0;    rshift=0;    break;
    case 1: lshift=250;  rshift=300;  break;
    case 2: lshift=550;  rshift=550;  break;
    case 3: lshift=800;  rshift=800;  break;
    case 4: lshift=1050; rshift=1070; break;
    case 5: lshift=1300; rshift=1300; break;
    case 6: lshift=1550; rshift=1570; break;
  }
  
  stroke(pink);
  line(30+lshift,height/2-125,240+rshift,height/2-125);
  line(30+lshift,height/2-40,240+rshift,height/2-40);
  line(240+rshift,height/2-40,240+rshift,height/2-125);
  line(30+lshift,height/2-125,30+lshift,height/2-40);
  
}

void show_calculated_values()
{
  String s;
  textSize(40);
  
  s="Z  =  " + str(Z) + "Ω";
  text(s,50,-height/2+75);
 
  s="i₀ =  " + str(i0) + "A";
  text(s,450,-height/2+75);
  
  s="φ  =  " + str(phi);
  text(s,850,-height/2+75);
}

void show_initial_values()
{
  String s;
  textSize(32);
  
  s="V₀ =  " + str(V0) + "V";
  text(s,50, height/2-75);
  
  s="ω  =  " + str(w) + "rad/s";
  text(s,300,height/2-75);
  
  s="L  =  " + str(L) + "H";
  text(s,600, height/2-75);
  
  s="C  =  " + str(C) + "F";
  text(s,850, height/2-75);
  
  s="R  =  " + str(R) + "Ω";
  text(s,1100, height/2-75);
  
  s="i(0)=  " + str(ii) + "A";
  text(s,1350, height/2-75);
  
  s="q(0)=  " + str(qi) + "C";
  text(s,1600, height/2-75);

}

void legend()
{
  stroke(pink);
  line(width-680,-height/2+10,width-50,-height/2+10);
  line(width-680,-height/2+170,width-50,-height/2+170);
  line(width-50,-height/2+10,width-50,-height/2+170);
  line(width-680,-height/2+10,width-680,-height/2+170);
  
  stroke(255,255,255);
  textSize(32);
  text("V=V₀sin(ωt)",width-650,-height/2+50);
  line(width-200,-height/2+40,width-100,-height/2+40);  
  
  stroke(0,255,0);
  textSize(32);
  text("i=i₀sin(ωt+φ)",width-650,-height/2+100);
  line(width-200,-height/2+90,width-100,-height/2+90);
  
  stroke(0,0,255);
  textSize(32);
  text("Exact analytical solution",width-650,-height/2+150);
  line(width-200,-height/2+140,width-100,-height/2+140);
}


void calculate_values()
{
  V  =  V0*sin(w*t);
  if(C==0 && L==0)
  {
    i=0;
    q=0;
    i=V/R;
    q+=i*dt;
  }
  else 
  if(C==0 && R==0)
  {
    p  = V/L;
    i += p*dt;
  }
  else
  if(L==0 && R==0)
  {
    i=0;
    float qnew=C*V;
    i=(qnew-q)/dt;
    q=qnew;
  }
  else
  if(R==0)
  {
    p=(V-q/C)/L;
    i += p*dt;
    q += i*dt;
  }
  else 
  if(C==0)
  {
    p=(V-i*R)/L;
    i += p*dt;
  }
  else
  if(L==0)
  {
    i=(V-q/C)/R;
    q += i*dt;
  }
  else
  {
    p  = (V-i*R-q/C)/L;
    i += p*dt;
    q += i*dt;
  }
}

void show_points()
{
  //float yscale = -0.75*height/2 / V0;
  strokeWeight(4);
  
  x=map(t,0,xrange,0,width);
  
  y=map(V,-yrange,yrange,scale*height/2,-scale*height/2);
  //y= V * yscale;
  stroke(255,255,255);
  point(x,y);
  
  y=map(i,-yrange,yrange,scale*height/2,-scale*height/2);
  //y=i * yscale;
  stroke(0,0,255);
  point(x,y);
  
  if(count++%(6)==0)
  {
  float g=i0*sin(w*t+phi);
  y=map(g,-yrange,yrange,scale*height/2,-scale*height/2);
  strokeWeight(4);
  stroke(0,255,0);
  point(x,y);
  }
}

void setup()
{
  fullScreen();
  colorMode(RGB);
}

void draw()
{
  background(0);
  translate(0,height/2);
  axes();
  legend();
  show_calculated_values();
  show_initial_values();
  show_selected();
  for(t=0; t<k*k*2*PI/w; t+=dt)
  {
      calculate_values();
      show_points();
  }
  noLoop();
}
