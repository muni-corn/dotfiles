#!/run/current-system/sw/bin/bash

# For debugging
set -x

# Load variables we defined
source "/etc/libvirt/hooks/kvm.conf"

# Unload vfio module
modprobe -r vfio_iommu_type1
modprobe -r vfio_pci
modprobe -r vfio

# Attach GPU devices from host
virsh nodedev-reattach $VIRSH_GPU_VIDEO
virsh nodedev-reattach $VIRSH_GPU_AUDIO

# Load amdgpu kernel modules
modprobe amdgpu

# Avoid race condition
sleep 5

# XXX: Supposedly, this causes a segfault with amd hardware
# Bind EFI Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

# Bind VTconsoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

# Start display manager
systemctl start display-manager.service
systemctl start gdm.service

# TODO: needed?
# Return host to all cores
# systemctl set-property --runtime -- user.slice AllowedCPUs=0-3
# systemctl set-property --runtime -- system.slice AllowedCPUs=0-3
# systemctl set-property --runtime -- init.scope AllowedCPUs=0-3

# TODO: needed?
# Change to powersave governor
# echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
