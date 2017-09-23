FROM microsoft/dotnet:2.0.0-sdk AS build-env

COPY iop-profile-server ./iop-profile-server

WORKDIR iop-profile-server/src/ProfileServer

RUN dotnet restore --configfile NuGet.Config
RUN dotnet publish -c Release -r linux-arm -o ../../../build
RUN dotnet ef database update
RUN cp ProfileServer.db ../../../build

FROM microsoft/dotnet:2.0.0-runtime-stretch-arm32v7
WORKDIR /usr/app
COPY --from=build-env /build /usr/app
COPY run_server.sh /usr/app/

ENTRYPOINT [ "./run_server.sh" ]