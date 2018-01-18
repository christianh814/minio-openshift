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

Test with `mc` the command found [HERE](https://docs.minio.io/docs/minio-client-complete-guide)


