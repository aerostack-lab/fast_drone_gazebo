#!/usr/bin/env python3

import mission_execution_control as mxc
import rospy

def mission():
  print("Starting mission...")

  print("TAKE_OFF...")
  mxc.executeTask('TAKE_OFF')

  print("ROTATE...")
  mxc.executeTask('ROTATE', angle = 60)

  print("FOLLOW_PATH...")
  mxc.executeTask('FOLLOW_PATH', path = [ [0, 20, 1] , [20, 20, 1] , [20, 0, 1] , [0, 0, 1] ])

  print("LAND...")
  mxc.executeTask('LAND')

  print('Mission completed.')
