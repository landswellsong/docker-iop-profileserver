FROM microsoft/dotnet:1-sdk AS build-env

COPY . ./

WORKDIR iop-profile-server/src/ProfileServer

RUN dotnet restore
RUN dotnet publish -c Release -r linux-arm -o out

FROM microsoft/dotnet:2.0.0-runtime-stretch-arm32v7
WORKDIR /app
COPY --from=build-env /app/out ./
ENTRYPOINT ["dotnet", "dotnetapp.dll"]