#!/run/current-system/sw/bin/bash

# For debugging
set -x

# Load variables we defined
source "/etc/libvirt/hooks/kvm.conf"

# TODO: needed?
# Change to performance governor
# echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# TODO: needed?
# Isolate host to core 0
# systemctl set-property --runtime -- user.slice AllowedCPUs=0
# systemctl set-property --runtime -- system.slice AllowedCPUs=0
# systemctl set-property --runtime -- init.scope AllowedCPUs=0

# Stop display manager
systemctl stop display-manager.service
systemctl stop gdm.service

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# XXX: Supposedly, this causes a segfault with amd hardware
# Unbind EFI Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid race condition
# sleep 5

# Unload amdgpu kernel modules
modprobe -r amdgpu

# Detach GPU devices from host
virsh nodedev-detach $VIRSH_GPU_VIDEO
virsh nodedev-detach $VIRSH_GPU_AUDIO

# Load vfio module
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
