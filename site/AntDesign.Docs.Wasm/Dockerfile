FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS base
MAINTAINER cheng 542153354@qq.com

ENV "ASPNETCORE_ENVIRONMENT"="Development"
WORKDIR /app
EXPOSE 80
COPY ./bin/Debug/netstandard2.1/publish /app
ENTRYPOINT ["dotnet", "AntDesign.Docs.Wasm.dll"]