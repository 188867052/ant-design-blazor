### PREPARE
FROM mcr.microsoft.com/dotnet/core/sdk:3.1.201 AS build
WORKDIR /src

# Copy csproj and sln and restore as distinct layers
COPY site/AntDesign.Docs.Server/*.csproj site/AntDesign.Docs.Server/
COPY site/AntDesign.Docs.Wasm/*.csproj site/AntDesign.Docs.Wasm/
COPY site/AntDesign.Docs.WasmHost/*.csproj site/AntDesign.Docs.WasmHost/
COPY site/AntBlazor.Docs/*.csproj site/AntBlazor.Docs/
COPY site/AntDesign.Docs.Build.CLI/*.csproj site/AntDesign.Docs.Build.CLI/
COPY tests/*.csproj tests/
COPY components/*.csproj components/
COPY AntDesign.sln .
RUN dotnet restore

### BUILD
COPY . .
RUN dotnet build "site/AntDesign.Docs.Server/AntDesign.Docs.Server.csproj" -c Release -o /app

### PUBLISH
FROM build as publish
COPY . .
RUN dotnet publish "site/AntDesign.Docs.Server/AntDesign.Docs.Server.csproj" -c Release -o /app

### RUNTIME IMAGE
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS final
WORKDIR /app
COPY --from=publish /app .
EXPOSE 80
ENTRYPOINT ["dotnet", "AntDesign.Docs.Server.dll"]