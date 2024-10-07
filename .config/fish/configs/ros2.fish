if command -v ros2 &> /dev/null
    # https://zenn.dev/kenji_miyake/articles/c149cc1f17e168
    alias colcon='__colcon_find_workspace_dir > /dev/null && cd (__colcon_find_workspace_dir); command colcon'
    alias roscd="ccd -o"
    register-python-argcomplete --shell fish ros2 | source

    # --cmake-clean-cache slows down compilation
    function colcon_all
        colcon build --symlink-install --continue-on-error --event-handlers console_cohesion+ --cmake-args " -GNinja" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations -Wno-unknown-pragmas"
    end

    function colcon_select_upto
        colcon build --packages-up-to $argv --symlink-install --continue-on-error --event-handlers console_cohesion+ --cmake-args " -GNinja" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations -Wno-unknown-pragmas"
    end

    function colcon_select
        colcon build --packages-select $argv --symlink-install --continue-on-error --event-handlers console_cohesion+ --cmake-args " -GNinja" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations -Wno-unknown-pragmas"
    end

    function colcon_test
        colcon build --packages-select-upto $argv --symlink-install --continue-on-error --event-handlers console_cohesion+ --cmake-args " -GNinja" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations -Wno-unknown-pragmas -fprofile-arcs -ftest-coverage"
        colcon test --event-handlers console_cohesion+ --packages-select $argv
    end
end
