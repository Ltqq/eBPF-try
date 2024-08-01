#!/bin/sh

# 挂载内核头文件目录和必要文件系统
if ! mountpoint -q /sys; then
    mount -t sysfs sysfs /sys
fi

if ! mountpoint -q /sys/kernel/debug; then
    mount -t debugfs debugfs /sys/kernel/debug
fi

echo "Starting webapp and eBPF script..."
/usr/local/bin/webapp &
python3 /usr/local/bin/trace.py
echo "Scripts completed."

