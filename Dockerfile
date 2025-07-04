# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /src

# Copy solution and project files
COPY CAB.sln .
COPY CAB/CAB.csproj ./CAB/

# Restore dependencies
RUN dotnet restore CAB/CAB.csproj

# Copy all source files
COPY CAB/. ./CAB/

WORKDIR /src/CAB

# Publish the app as a self-contained deployment (optional) or framework-dependent
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

WORKDIR /app

# Set environment variable so ASP.NET Core listens on port 7097
ENV ASPNETCORE_URLS=http://*:7097

# Copy the published output from the build stage
COPY --from=build /app/publish .

# Expose port 7097
EXPOSE 7097

# Use entrypoint to run the app
ENTRYPOINT ["dotnet", "CAB.dll"]
