# minio-openshift

This is a quick and ditry way to get this up and running on openshift

## Create a new app

```
oc new-project store
oc new-app https://github.com/christianh814/minio-openshift --name=miniocp
```

## It needs to run as root

```
oc project store
oc create serviceaccount useroot
oc adm policy add-scc-to-user anyuid -z useroot
oc patch dc/miniocp  --patch '{"spec":{"template":{"spec":{"serviceAccountName": "useroot"}}}}'
```

## Add custom keys/secrets

```
oc env dc/miniocp MINIO_ACCESS_KEY=W6IMLTS1S3E025TE0ZKM MINIO_SECRET_KEY=LPPszHYFcNQ1+r9Nx/w9m/pQOj5CQhYVlvpZKZsw
```

## Add a PVC for persistance from an existing PV

NOTE, it assumes `/data` for all your files

```
oc volume dc/miniocp --add --name=minio-data --mount-path=/data -t pvc --claim-name=minio-pv --overwrite
```

## Expose Service

```
oc expose svc/miniocp
```

# Testing

Test with `mc` the command install/docs found [HERE](https://docs.minio.io/docs/minio-client-complete-guide)

It'll look like this to add your obj storage server

```
mc config host add myminio http://$(oc get route/miniocp -o jsonpath='{.spec.host}' -n store) W6IMLTS1S3E025TE0ZKM LPPszHYFcNQ1+r9Nx/w9m/pQOj5CQhYVlvpZKZsw
```
Make a bucket and list it...

```
 mc mb minio/test
Bucket created successfully `minio/test`.

mc ls minio
[2018-01-17 17:36:31 PST]     0B test/
```

Upload a local file...

```
echo test > /tmp/file.txt

mc cp /tmp/file.txt minio/test/
/tmp/file.txt:   5 B / 5 B ┃▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓┃ 100.00% 126 B/s 


mc ls minio/test
[2018-01-17 17:37:55 PST]     5B file.txt

```


