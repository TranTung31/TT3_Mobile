using Microsoft.Extensions.Options;
using SystemService.Application.Services;
using SystemService.Infrastructure.Settings;

namespace SystemService.Infrastructure.Services;

public class KeycloakSettingsProvider : IKeycloakSettingsProvider
{
    private readonly KeycloakSettings _keycloakSettings;

    public KeycloakSettingsProvider(IOptions<KeycloakSettings> keycloakSettings)
    {
        _keycloakSettings = keycloakSettings.Value;
    }

    public string DefaultImportedUserPassword => _keycloakSettings.DefaultImportedUserPassword;
}
