#!/bin/bash

NUMID_DRONE=111
DRONE_SWARM_ID=1
MAV_NAME="hummingbird"

export AEROSTACK_PROJECT=${AEROSTACK_STACK}/projects/fast_drone_gazebo

. ${AEROSTACK_STACK}/config/mission/setup.sh

#---------------------------------------------------------------------------------------------
# INTERNAL PROCESSES
#---------------------------------------------------------------------------------------------
gnome-terminal  \
`#---------------------------------------------------------------------------------------------` \
`# Basic Behaviors                                                                             ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Basic Behaviors" --command "bash -c \"
roslaunch basic_quadrotor_behaviors basic_quadrotor_behaviors.launch --wait \
    namespace:=drone$NUMID_DRONE;
exec bash\"" \
`#---------------------------------------------------------------------------------------------` \
`# Quadrotor Motion With MPC Control                                                           ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Quadrotor Motion With MPC Control" --command "bash -c \"
roslaunch quadrotor_motion_with_mpc_control quadrotor_motion_with_mpc_control.launch --wait \
    namespace:=drone$NUMID_DRONE \
    drone_max_speed:=3;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Quadrotor Motion With PID Control                                                           ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Quadrotor Motion With PID Control" --command "bash -c \"
roslaunch quadrotor_motion_with_pid_control quadrotor_motion_with_pid_control.launch --wait \
    namespace:=drone$NUMID_DRONE \
    robot_config_path:=${AEROSTACK_PROJECT}/configs/drone$NUMID_DRONE \
    uav_mass:=0.7;
exec bash\"" \
`#---------------------------------------------------------------------------------------------` \
`# Gazebo motor speed controller                                                               ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Motor speed controller"  --command "bash -c \"
roslaunch motor_speed_controller motor_speed_controller.launch --wait \
  namespace:=drone$NUMID_DRONE \
  mav_name:=$MAV_NAME;
exec bash\"" \
`#---------------------------------------------------------------------------------------------` \
`# Gazebo Interface                                                                            ` \
`#---------------------------------------------------------------------------------------------` \
  --tab --title "Gazebo Interface" --command "bash -c \"
roslaunch gazebo_interface gazebo_interface.launch --wait \
    robot_namespace:=drone$NUMID_DRONE \
    drone_id:=$DRONE_SWARM_ID \
    mav_name:=$MAV_NAME;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Behavior Execution Viewer                                                                   ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Behavior Execution Viewer" --command "bash -c \"
roslaunch behavior_execution_viewer behavior_execution_viewer.launch --wait \
  robot_namespace:=drone$NUMID_DRONE \
  drone_id:=$NUMID_DRONE \
  catalog_path:=${AEROSTACK_PROJECT}/configs/mission/behavior_catalog.yaml;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Belief Memory Viewer                                                                        ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Belief memory Viewer" --command "bash -c \"
roslaunch belief_memory_viewer belief_memory_viewer.launch --wait \
  robot_namespace:=drone$NUMID_DRONE \
  drone_id:=$NUMID_DRONE;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Python Interpreter                                                                          ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Python Interpreter" --command "bash -c \"
roslaunch python_based_mission_interpreter_process python_based_mission_interpreter_process.launch --wait \
  drone_id_namespace:=drone$NUMID_DRONE \
  drone_id_int:=$NUMID_DRONE \
  mission_configuration_folder:=${AEROSTACK_PROJECT}/configs/mission;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Belief Manager                                                                              ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Belief Manager" --command "bash -c \"
roslaunch belief_manager_process belief_manager_process.launch --wait \
    drone_id_namespace:=drone$NUMID_DRONE \
    drone_id:=$NUMID_DRONE \
    config_path:=${AEROSTACK_PROJECT}/configs/mission;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Belief Updater                                                                              ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Belief Updater" --command "bash -c \"
roslaunch belief_updater_process belief_updater_process.launch --wait \
    drone_id_namespace:=drone$NUMID_DRONE \
    drone_id:=$NUMID_DRONE;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Behavior Coordinator                                                                       ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Behavior coordinator" --command "bash -c \" sleep 2;
roslaunch behavior_coordinator behavior_coordinator.launch --wait \
  robot_namespace:=drone$NUMID_DRONE \
  catalog_path:=${AEROSTACK_PROJECT}/configs/mission/behavior_catalog.yaml;
exec bash\""  &
#---------------------------------------------------------------------------------------------
# SHELL INTERFACE
#---------------------------------------------------------------------------------------------
gnome-terminal  \
`#---------------------------------------------------------------------------------------------` \
`# alphanumeric_viewer                                                                         ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "alphanumeric_viewer"  --command "bash -c \"
roslaunch alphanumeric_viewer alphanumeric_viewer.launch --wait \
    drone_id_namespace:=drone$NUMID_DRONE;
exec bash\""  &
