FROM microsoft/dotnet:2.0.0-sdk AS build-env

COPY iop-profile-server ./iop-profile-server

WORKDIR iop-profile-server/src/ProfileServer

# Linux nuget requires those files to be present
# TODO: this is probably my bug if you know how to do
# it better pls contribute
RUN for i in ../Iop*; do ln -s `pwd`/NuGet.Config $i/; done

# e_sqlite3.so missing on ARM
RUN dotnet add package SQLitePCLRaw.lib.e_sqlite3.linux --version 1.1.8-pre20170717084758

RUN dotnet restore --configfile NuGet.Config
RUN dotnet publish -c Release -r linux-arm -o ../../../build
RUN dotnet ef database update
RUN cp ProfileServer.db ../../../build

FROM microsoft/dotnet:2.0.0-runtime-stretch-arm32v7
WORKDIR /usr/app
COPY --from=build-env /build /usr/app

# TODO: establish why doesn't publish get it
COPY --from=build-env /root/.nuget/packages/sqlitepclraw.lib.e_sqlite3.linux/1.1.8-pre20170717084758/runtimes/linux-arm/native/libe_sqlite3.so /usr/app/

COPY run_server.sh /usr/app/

EXPOSE 16987 16988

ENTRYPOINT [ "./run_server.sh" ]