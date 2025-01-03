helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm repo update
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=10.101.10.5 --set nfs.path=/mnt/array1/kubepvc --set storageClass.onDelete=true --set storageClass.archiveOnDelete=false --set storageClass.name=gold
sleep 30
kubectl patch storageclass gold -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
kubectl get storageclass gold
