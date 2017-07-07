#!/usr/bin/env python

import signal
import docker
import time

class TimeOutException(Exception):
    pass

def setTimeout(num, callback):
    def wrape(func):
        def handle(signum, frame):
            raise TimeOutException("Run timeout!")
        def toDo(*args, **kwargs):
            try:
                signal.signal(signal.SIGALRM, handle)
                signal.alarm(num) # Start alarm signal  
                rs = func(*args, **kwargs)
                signal.alarm(0) # End alarm signal 
                return rs
            except TimeOutException, e:
                callback()

        return toDo
    return wrape

if __name__ == '__main__':

    def doSome():
        print 0

    @setTimeout(4,doSome )
    def get_docker_status():
        client = docker.DockerClient(base_url='tcp://127.0.0.1:2375',version='1.24')
        client.containers.list()
        print 1

    get_docker_status()
