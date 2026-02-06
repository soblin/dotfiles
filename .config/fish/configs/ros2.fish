if command -v ros2 &>/dev/null
    # https://zenn.dev/kenji_miyake/articles/c149cc1f17e168
    register-python-argcomplete --shell fish ros2 | source

    # --cmake-clean-cache slows down compilation
    function colcon_all
        colcon build --symlink-install $argv --continue-on-error --event-handlers console_cohesion+ --cmake-args " -GNinja" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations -Wno-unknown-pragmas"
    end

    function colcon_select_upto
        colcon build --packages-up-to $argv --symlink-install --continue-on-error --event-handlers console_cohesion+ --cmake-args " -GNinja" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations -Wno-unknown-pragmas"
    end

    function colcon_select
        colcon build --packages-select $argv --symlink-install --continue-on-error --event-handlers console_cohesion+ --cmake-args " -GNinja" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations -Wno-unknown-pragmas"
    end

    function colcon_test_simple
        colcon build --packages-select $argv --symlink-install --continue-on-error --event-handlers console_cohesion+ --cmake-args " -GNinja" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations -Wno-unknown-pragmas"; and colcon test --event-handlers console_cohesion+ --packages-select $argv
    end

    function colcon_test_coverage
        colcon build --packages-select $argv --symlink-install --continue-on-error --event-handlers console_cohesion+ --cmake-args " -GNinja" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_CXX_COMPILER=/usr/lib/ccache/g++ -DCMAKE_C_COMPILER=/usr/lib/ccache/gcc -DCMAKE_CXX_FLAGS="-Wno-deprecated-declarations -Wno-unknown-pragmas -fprofile-arcs -ftest-coverage"; and colcon test --event-handlers console_cohesion+ --packages-select $argv; and colcon lcov-result --packages-select $argv --filter "*/test/*"
    end
end
