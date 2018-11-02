FROM gcr.io/spinnaker-marketplace/halyard:stable
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
