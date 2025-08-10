# set up the ASP.NET Core runtime image as the base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 7135

# SDK image to build the application and generate certs
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project files
COPY ["CardValidation.Web/CardValidation.Web.csproj", "CardValidation.Web/"]
COPY ["CardValidation.Core/CardValidation.Core.csproj", "CardValidation.Core/"]
RUN dotnet restore "CardValidation.Web/CardValidation.Web.csproj"

# Copy entire solution
COPY . .

# Installing OpenSSL to generate self-signed cert
RUN apt-get update && apt-get install -y openssl

# Generating cert with SANs for localhost and container name
RUN mkdir /certs && \
    echo "[req]" > /certs/openssl.cnf && \
    echo "distinguished_name=req" >> /certs/openssl.cnf && \
    echo "[v3_req]" >> /certs/openssl.cnf && \
    echo "subjectAltName=@alt_names" >> /certs/openssl.cnf && \
    echo "[alt_names]" >> /certs/openssl.cnf && \
    echo "DNS.1=localhost" >> /certs/openssl.cnf && \
    echo "DNS.2=cardvalidation-api" >> /certs/openssl.cnf && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout /certs/server.key \
      -out /certs/server.crt \
      -subj "/CN=cardvalidation-api" \
      -config /certs/openssl.cnf \
      -extensions v3_req && \
    openssl pkcs12 -export \
      -out /certs/server.pfx \
      -inkey /certs/server.key \
      -in /certs/server.crt \
      -password pass:securepass
COPY . .
# Build and publish app
WORKDIR "/src/CardValidation.Web"
RUN dotnet build "CardValidation.Web.csproj" -c Release -o /app/build
RUN dotnet publish "CardValidation.Web.csproj" -c Release -o /app/publish

# Final image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
COPY --from=build /certs/server.pfx /https/aspnetapp.pfx

# Configure environment for ASP.NET to use HTTPS
ENV ASPNETCORE_URLS=https://+:443;http://+:80
ENV ASPNETCORE_Kestrel__Certificates__Default__Path=/https/aspnetapp.pfx
ENV ASPNETCORE_Kestrel__Certificates__Default__Password=securepass

ENTRYPOINT ["dotnet", "CardValidation.Web.dll"]
