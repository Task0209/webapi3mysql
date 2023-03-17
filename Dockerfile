FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80/tcp

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["myapp.csproj", "./"]
RUN dotnet restore "myapp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "myapp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "myapp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "myapp.dll"]