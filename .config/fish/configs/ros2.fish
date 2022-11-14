# https://zenn.dev/kenji_miyake/articles/c149cc1f17e168
alias colcon='__colcon_find_workspace_dir > /dev/null && cd (__colcon_find_workspace_dir); command colcon'
alias roscd="ccd -o"
register-python-argcomplete --shell fish ros2 | source

function colcon_all
    colcon build --cmake-clean-cache --symlink-install --continue-on-error --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations"
end

function colcon_select
    colcon build --packages-up-to $argv --cmake-clean-cache --symlink-install --continue-on-error --cmake-args -DCMAKE_BUILD_TYPE=RelWihtDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations"
end
