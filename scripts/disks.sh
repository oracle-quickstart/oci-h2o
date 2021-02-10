
echo "Running disks.sh"

device="/dev/sdb"

dataDir="/data"
mkdir -p $dataDir

echo "Creating filesystem and mounting on /data..."
mke2fs -F -t ext4 -b 4096 -E lazy_itable_init=1 -O sparse_super,dir_index,extent,has_journal,uninit_bg -m1 $device
mount -t ext4 -o noatime $device $dataDir
UUID=$(lsblk -no UUID $device)
echo "UUID=$UUID   $dataDir    ext4   defaults,noatime,_netdev,nofail,discard,barrier=0 0 1" | sudo tee -a /etc/fstab
