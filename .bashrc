# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Source SubT common file
source ~/Admin/core_environment/shared/dotfiles/.bashrc


# ROS workspace (source only a single workspace)
source /opt/ros/subt/setup.bash
source ~/catkin_ws/devel/setup.bash

# ROS network settings
# * ROS_HOSTNAME and ROS_IP are mutually exclusive
export ROS_MASTER_URI=http://localhost:11311
export ROS_HOSTNAME=$(hostname)
# export ROS_IP=


# Rollocopter aliases
# alias gnc_run='/home/woody/rollo_ws/src/rollo_core/core_capability/bringup_rollo/scripts/./start_hw.sh'
# alias autonomy_run='/home/woody/catkin_ws/src/demo_rollocopter/scripts/run_autonomy.sh'
# alias mynteye='source /home/woody/MYNT-EYE-S-SDK/wrappers/ros/devel/setup.bash; roslaunch mynt_eye_ros_wrapper mynteye.launch'
# alias sparkvio='/home/woody/SparkVIO/VIO/euroc-testing/runSparkRollo.sh'
# alias goto_run_dir='cd ~/catkin_ws/src/demo_rollocopter/scripts'
# alias pixhawk_reboot='/home/woody/rollo_ws/src/rollo_core/core_capability/capability_rollo/scripts/reboot_px4.sh'

# Husky aliases
# alias launch-<robot>='tmuxp load $(rospack find tmux_scripts)/tmuxp_config/<config>.yaml'
# alias rlqv='kill -2 $(pidgrep rviz)'
# alias rlqt='rosrun tmux_scripts cleanup.sh'
alias rlqt='tmux kill-session -t husky_sim; rosrun tmux_scripts cleanup.sh'
alias rlt='tmuxp load `rospack find tmux_scripts`/tmuxp_config/husky_sim.yaml; rlqt'
