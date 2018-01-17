FROM minio/minio
RUN mkdir -m 777 /data
EXPOSE 9000
ENTRYPOINT ["minio"]
CMD ["server", "/data"]
