# ========================
# BUILD
# ========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY . .

WORKDIR /src/src/Services/SystemService/SystemService.Api
RUN dotnet restore

RUN dotnet publish -c Release -o /app/publish

# ========================
# RUNTIME
# ========================
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine
WORKDIR /app

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "SystemService.Api.dll"]