helm install nfs-subdir-external-provisioner \
nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
--set nfs.server=10.101.10.5 \
--set nfs.path=/kubepvc \
--set storageClass.onDelete=true \
--set storageClass.name=gold
sleep 30
kubectl patch storageclass gold -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
kubectl get storageclass nfs-client
