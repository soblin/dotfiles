function command_exist
    if type $argv[1] >/dev/null 2>&1
        return 0
    else
        echo $argv[1]: not found
        return 1
    end
end

bass source /opt/ros/foxy/setup.bash
bass source /usr/share/colcon_cd/function/colcon_cd.sh
set -g -x _colcon_cd_root "ros2_ws"

if command_exist ros2
    if command_exist register-python-argcomplete3
        register-python-argcomplete3 --shell fish ros2 | source
    end

    bass source ~/ros2_ws/install/local_setup.bash
    bass source ~/ros2_ws/install/setup.bash
end
