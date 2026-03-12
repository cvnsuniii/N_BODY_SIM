import 'dart:math';
import 'package:flutter/material.dart';
const double G=6.673e-11;
double timestep=200;
double sp1=1;
double simtimes=10;
List<List<List<double>>> animation=[];
Map<String,List<dynamic>> simdata={'ssc': [BodyDetails('one',[10,5,0],[0,0,0],[0,0,0],3,Colors.grey.toARGB32(),1),BodyDetails('two',[2,-1,0],[0,0,0],[0,0,0],1,Colors.grey.toARGB32(),1)]};
String simtitle='ssc';
void calculate(Map<String,List<dynamic>> simdata,double timestep, sp1,simtimes){
  int dt=sp1*timestep;
  List<List<double>> L=[];
  for(int k=0; k<simdata[simtitle]!.length;k++){
    L.add(simdata[simtitle]![k].lastValue.addAll(simdata[simtitle]![k].lastVelocities));
  }
  animation.add(L);
  print(animation);
  L=[];
  for (int k=0; k<(simtimes*1000/timestep).toInt();k++){
    List l=animation[-1];
    for (int m=0; m<simdata[simtitle]!.length;m++){
      double ax=0,ay=0,az=0,vx=l[m][3],vy=l[m][4],vz=l[m][5],px=l[m][0],py=l[m][1],pz=l[m][2];
      for (int d=0; d<simdata[simtitle]!.length;d++){
        
        num r=pow((pow((l[d][0]-px),2)+pow((l[d][1]-py),2)+pow((l[d][2]),2)),0.5);
        if (d!=0){
          ax+=G*simdata[simtitle]![d].mass*(l[m][0]-l[d][0])/(r*r*r);
          ay+=G*simdata[simtitle]![d].mass*(l[m][1]-l[d][1])/(r*r*r);
          az+=G*simdata[simtitle]![d].mass*(l[m][2]-l[d][2])/(r*r*r);
        }
        else{
        }
        vx+=ax*dt;
        vy+=ay*dt;
        vz+=az*dt;
        px+=(vx*vx-l[m][3]*l[m][3])/(2*ax);
        py+=(vy*vy-l[4][4]*l[m][4])/(2*ay);
        px+=(vz*vz-l[m][5]*l[m][5])/(2*az);
        
        
      }
      /*mx+=px;
      my+=py;
      mz+=pz;*/
      print([px,py,pz,vx,vy,vz]);
      L.add([px,py,pz,vx,vy,vz]);
    }
    /*mx/=simdata[simtitle].length;
    my/=simdata[simtitle].length;
    mz/=simdata[simtitle].length;*/
    print(L);
    animation.add(L);
    L=[];
  }
  //setState((){});
}



class BodyDetails  {

  String name;


  List<double> lastValue;


  List<double> lastVelocities;


  List<double> lastAcceleration;


  double radius;


  int color;


  double mass;

  BodyDetails(
    this.name,
    this.lastValue,
    this.lastVelocities,
    this.lastAcceleration,
    this.radius,
    this.color,
    this.mass
  );
}
//calculate( simdata,double timestep, sp1,simtimes);
void main(){
  calculate( simdata, timestep, sp1,simtimes);
}