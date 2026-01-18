import math 
import flask
from flask import Flask, render_template, request, flash, redirect, url_for
#from flask_socketio import SocketIo
import threading
 
#import bpy
#bpy.ops.object.delete(use_global=False)
G=6.6743*10**(-11)
ms=False
run=True
app=Flask(__name__)
app.config['SECRET_KEY'] = 'dev'  
@app.route('/',methods=['GET','POST'])

def get_details():
    if request.method=='POST':
        flash("hi")
        try:
            k=int(request.form['no_of_objects'])
            m=list(map(float,str(request.form['masses']).split(',')))
            Px=list(map(float,str(request.form['pos_x']).split(',')))
            Py=list(map(float,str(request.form['pos_y']).split(',')))
            Pz=list(map(float,str(request.form['pos_z']).split(',')))
            Vx=list(map(float,str(request.form['vel_x']).split(',')))
            Vy=list(map(float,str(request.form['vel_y']).split(',')))
            Vz=list(map(float,str(request.form['vel_z']).split(',')))
            r=list(map(float,str(request.form['radii']).split(','))) # add radius in html 
            dt=int(request.form['sim_frequency'])
            texts=int(request.form['sim_speed'])
            total_t=int(request.form['sim_time'])

            if k==len(m)==len(Px)==len(Py)==len(Pz)==len(Vx)==len(Vy)==len(Vz):
                #scene=bpy.context.scene
                objets=[]
                Ax=[0 for k in range(k)]
                Ay=Az=Ax
                t=dt*texts/1000
                '''for  i in range(n):
                    bpy.ops.mesh.primitive_uv_sphere_add(radius=r[i],enter_editmode=False,location=(0,0,0))
                    new_object = bpy.context.active_object
                    new_object.name = str(i)
                    objets.append(new_object)'''
                #for frame in range(1,int(total_t/dt)+1):
                
                for i in range(k):
                    Px[i]+=Vx[i]*t
                    Py[i]+=Vy[i]*t
                    Pz[i]+=Vz[i]*t
                    for n in range(k):
                        if n!=i:
                            Ax[i]+=G*m[n]*(Px[n]-Px[i])/((Px[n]-Px[i])**2+(Py[n]-Py[i])**2+(Pz[n]-Pz[i])**2)**1.5
                            Ay[i]+=G*m[n]*(Py[n]-Py[i])/((Px[n]-Px[i])**2+(Py[n]-Py[i])**2+(Pz[n]-Pz[i])**2)**1.5
                            Az[i]+=G*m[n]*(Pz[n]-Pz[i])/((Px[n]-Px[i])**2+(Py[n]-Py[i])**2+(Pz[n]-Pz[i])**2)**1.5
                    Vx[i]=Ax[i]*t
                    Vy[i]=Ay[i]*t
                    Vz[i]=Az[i]*t
                    Px[i]+=0.5*Ax[i]*t**2
                    Py[i]+=0.5*Ay[i]*t**2
                    Pz[i]+=0.5*Az[i]*t**2
                    #objets[i].location=(Px[i],Py[i],Pz[i])
                    #bpy.context.scene.frame_set(frame)
                    #objets[i].keyframe_insert(data_path='animation')                
                '''bpy.app.handlers.render_complete.clear()
                scene.render.engine="BLENDER_EEVEE"
                scene.render.imagesettings.file_format='FFMPEG'
                scene.render.ffmpeg.format = 'MPEG4'
                scene.render.ffmpeg.codec = 'H264'
                scene.render.filepath="//output/video.mp4"
                scene.frame_start=1
                scene.frame_end=int(total_t/dt)
                bpy.app.handlers.render_complete.append(ms=True)'''                
            else:
                flash('INVALID INPUTS. try cheking the number of values inputted')
        except ValueError:
            flash('INVALID INPUTS')
    return render_template('simulation1.html')
# if ms is true display file 


'''socketio=SocketIo(app)
@socketio.on('disconnect')
def on_disconnect():
    global run
    run=False
'''
def run_flask():
    if __name__ == '__main__' :
        app.run(host='127.0.0.1', debug=False, use_reloader=False)
        #gets()
        get_details()
  
t = threading.Thread(target=run_flask)
t.daemon = True
t.start()