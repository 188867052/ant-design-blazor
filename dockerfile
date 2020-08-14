### PREPARE
FROM mcr.microsoft.com/dotnet/core/sdk:3.1.201 AS build
WORKDIR /src

# Copy csproj and sln and restore as distinct layers
COPY site/AntDesign.Docs.Server/*.csproj AntDesign.Docs.Server/
COPY site/AntDesign.Docs.Wasm/*.csproj AntDesign.Docs.Wasm/
COPY site/AntDesign.Docs.WasmHost/*.csproj AntDesign.Server/
COPY site/AntDesign.Docs/*.csproj AntDesign.Docs/
COPY site/AntDesign.Docs.Build.CLI/*.csproj AntDesign.Docs.Build.CLI/
#COPY tests/AntDesign.Tests/*.csproj AntDesign.Tests/
#COPY components/AntDesign.sln .
RUN dotnet restore

### BUILD
COPY . .
RUN dotnet build "AntDesign.Docs.Server.sln" -c Release -o /app

### PUBLISH
FROM build as publish
COPY . .
RUN dotnet publish "AntDesign.Docs.Server.sln" -c Release -o /app

### RUNTIME IMAGE
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS final
WORKDIR /app
COPY --from=publish /app .
EXPOSE 80
ENTRYPOINT ["dotnet", "AntDesign.Docs.Server.dll"]