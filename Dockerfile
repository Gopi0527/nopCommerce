FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src                                                                    
COPY ./src ./

# restore solution
RUN dotnet restore NopCommerce.sln

WORKDIR /src/Presentation/Nop.Web   

# build project   
RUN dotnet build Nop.Web.csproj -c Release

# build plugins
WORKDIR /src/Plugins/Nop.Plugin.DiscountRules.CustomerRoles
RUN dotnet build Nop.Plugin.DiscountRules.CustomerRoles.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.ExchangeRate.EcbExchange
RUN dotnet build Nop.Plugin.ExchangeRate.EcbExchange.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.ExternalAuth.Facebook
RUN dotnet build Nop.Plugin.ExternalAuth.Facebook.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Misc.Brevo
RUN dotnet build Nop.Plugin.Misc.Brevo.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Misc.WebApi.Frontend
RUN dotnet build Nop.Plugin.Misc.WebApi.Frontend.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Misc.Zettle
RUN dotnet build Nop.Plugin.Misc.Zettle.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.MultiFactorAuth.GoogleAuthenticator
RUN dotnet build Nop.Plugin.MultiFactorAuth.GoogleAuthenticator.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Payments.CheckMoneyOrder
RUN dotnet build Nop.Plugin.Payments.CheckMoneyOrder.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Payments.CyberSource
RUN dotnet build Nop.Plugin.Payments.CyberSource.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Payments.Manual
RUN dotnet build Nop.Plugin.Payments.Manual.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Payments.PayPalCommerce
RUN dotnet build Nop.Plugin.Payments.PayPalCommerce.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Pickup.PickupInStore
RUN dotnet build Nop.Plugin.Pickup.PickupInStore.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Shipping.FixedByWeightByTotal
RUN dotnet build Nop.Plugin.Shipping.FixedByWeightByTotal.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Shipping.UPS
RUN dotnet build Nop.Plugin.Shipping.UPS.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Tax.Avalara
RUN dotnet build Nop.Plugin.Tax.Avalara.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Tax.FixedOrByCountryStateZip
RUN dotnet build Nop.Plugin.Tax.FixedOrByCountryStateZip.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Widgets.FacebookPixel
RUN dotnet build Nop.Plugin.Widgets.FacebookPixel.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Widgets.GoogleAnalytics
RUN dotnet build Nop.Plugin.Widgets.GoogleAnalytics.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Widgets.NivoSlider
RUN dotnet build Nop.Plugin.Widgets.NivoSlider.csproj -c Release
WORKDIR /src/Plugins/Nop.Plugin.Widgets.What3words
RUN dotnet build Nop.Plugin.Widgets.What3words.csproj -c Release

# publish project
WORKDIR /src/Presentation/Nop.Web   
RUN dotnet publish Nop.Web.csproj -c Release -o /app/published

WORKDIR /app/published

RUN mkdir logs
RUN mkdir bin


FROM mcr.microsoft.com/dotnet/aspnet:8.0
EXPOSE 5000
COPY --from=build /app/published /app
WORKDIR /app
CMD ["dotnet", "run","Nop.Web.dll", "--urls", "http://0.0.0.0:5000"]
