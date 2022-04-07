set -g ROS1_WS "ros1_ws"

if test -d /opt/ros/kinetic/
   set -g ROS1_VER "kinetic"
end
if test -d /opt/ros/lunar/
   set -g ROS1_VER "lunar"
end
if test -d /opt/ros/melodic/
   set -g ROS1_VER "melodic"
end
if test -d /opt/ros/noetic/
   set -g ROS1_VER "noetic"
end

if test -f /opt/ros/{$ROS1_VER}/setup.bash
   bass source /opt/ros/{$ROS1_VER}/setup.bash
end
if test -f ~/{$ROS1_WS}/devel/setup.bash
   bass source ~/{$ROS1_WS}/devel/setup.bash
else
    echo "~/ros1_ws/devel not found."
end
if test -f /opt/ros/{$ROS1_VER}/share/rosbash/rosfish
   source /opt/ros/{$ROS1_VER}/share/rosbash/rosfish
end

echo "ros1.fish: Loaded."
