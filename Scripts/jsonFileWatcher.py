#!/usr/bin/python
import os
import time
import subprocess
from subprocess import Popen
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import json

class MyHandler(FileSystemEventHandler):
   def on_modified(self, event):
       if event.is_directory == False:
           #print('path name----')
           #print(event.src_path)

           #filename = event.src_path.split("/")
           #file= filename[4]
           #file= filename[2]
           #print('file name----')
           #print(file)

           # Read the json file and call shell script for each node
           with open(event.src_path) as json_file:
               data = json.load(json_file)
               #print('----------- Json Data--------------')
               print(data)
               for node in data:
                  name=node['name'] 
                  ip=node['ip']
                  package=node['package']
                  subprocess.call(['bash','/home/scripts/iChef.sh', name, ip, package])
if __name__ == "__main__":
    event_handler = MyHandler()
    observer = Observer()
    observer.schedule(event_handler, path='./chef_json/', recursive=False)
    observer.start()

    try:
        while 1:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
        observer.join()

