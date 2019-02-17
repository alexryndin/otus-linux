import os, time
import sys
import signal
import time


def handle_signal(signum, frame):
  print ('Caught signal "%s"' % signum)
  if signum == signal.SIGTERM:
    print ('SIGTERM. Exiting!')
    sys.exit(1)
  elif signum == signal.SIGHUP:
    print ('SIGHUP')
  elif signum == signal.SIGUSR1:
    print ('SIGUSR1 Calling wait()')
    pid, status = os.wait()
    print ('PID was: %s.' % pid)
  elif signum == signal.SIGINT:
    print("fuck off!")


def main():
  print ('Starting..')
  signal.signal(signal.SIGCHLD, handle_signal)
  signal.signal(signal.SIGHUP, handle_signal)
  signal.signal(signal.SIGTERM, handle_signal)
  signal.signal(signal.SIGUSR1, handle_signal)
  signal.signal(signal.SIGINT, handle_signal)
  print('Hello! I am an example')
  pid = os.fork()
  print('pid of my child is %s' % pid)

  if pid == 0:
      print('I am a child. Im going to sleep')
      for i in range(1,40):
        print('mrrrrr')
        a = 2**i
        print(a)
        pid = os.fork()
        if pid == 0:
              print('my name is %s' % a)
              sys.exit(0)
        else:
              print("my child pid is %s" % pid)
        time.sleep(1)
      print('Bye')
      sys.exit(0)

  else:
      for i in range(1,200):
        print('HHHrrrrr')
        time.sleep(1)
        print(3**i)
      print('I am the parent')

if __name__== "__main__":
  main()
