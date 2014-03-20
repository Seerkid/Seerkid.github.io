#!/bin/sh

echo "正在关闭独显..."
echo IGD > /sys/kernel/debug/vgaswitcheroo/switch 
echo OFF > /sys/kernel/debug/vgaswitcheroo/switch
cat /sys/kernel/debug/vgaswitcheroo/switch 
echo "关闭成功..."
