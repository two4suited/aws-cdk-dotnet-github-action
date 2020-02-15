ARG REPO=mcr.microsoft.com/dotnet/core/sdk
FROM $REPO:3.1-alpine3.10

RUN apk --update --no-cache add nodejs nodejs-npm curl bash 

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]