docker build --rm --tag mozc_ubuntu22.04 .

docker create --interactive --tty --name mozc_build mozc_ubuntu22.04

docker start mozc_build

docker exec mozc_build bazel build package --config oss_linux -c opt

docker cp mozc_build:/home/mozc_builder/work/mozc/src/bazel-bin/unix/mozc.zip .

sudo apt install mozc-utils-gui emacs-mozc-bin libqt6widgets6 qt6-wayland qt6-qpa-plugins

ibus exit

cp -i ibus_config.textproto ~/.config/mozc/ibus_config.textproto

ibus write-cache
