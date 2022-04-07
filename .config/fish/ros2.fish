function command_exist
    if type $argv[1] >/dev/null 2>&1
        return 0
    else
        echo $argv[1]: not found
        return 1
    end
end

set -g ROS2_WS "ros2_ws"

if test -d /opt/ros/foxy/
   set -g ROS2_VER "foxy"
end
if test -d /opt/ros/eloquent/
   set -g ROS2_VER "eloquent"
end
if test -d /opt/ros/dashing/
   set -g ROS2_VER "dashing"
end

bass source /opt/ros/{$ROS2_VER}/setup.bash
bass source /usr/share/colcon_cd/function/colcon_cd.sh
set -g -x _colcon_cd_root ~/{$ROS2_WS}

if command_exist register-python-argcomplete
   register-python-argcomplete --shell fish ros2 | source
end

bass source ~/{$ROS2_WS}/install/local_setup.bash
bass source ~/{$ROS2_WS}/install/setup.bash

echo "ros2.fish: Loaded."
