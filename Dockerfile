FROM microsoft/dotnet:1.1-sdk AS build-env

COPY . ./

WORKDIR iop-profile-server/src/ProfileServer

# RUN dotnet restore --configfile NuGet.Config
RUN dotnet restore
RUN dotnet publish -c Release -r ubuntu.16.04-arm -o ../../../build

FROM microsoft/dotnet:2.0.0-runtime-stretch-arm32v7
WORKDIR /usr/app
COPY --from=build-env /build /usr/app

# We run on a different runtime so collect the *.so
# because somehow it's not done automatically
COPY --from=build-env /usr/share/dotnet/sdk/1.1.0/*.so /usr/app/

# COPY ProfileServer.runtimeconfig.json /usr/app
ENTRYPOINT ["dotnet", "ProfileServer.dll"]