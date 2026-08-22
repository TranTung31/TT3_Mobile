namespace SystemService.Application.Services;

public interface IKeycloakSettingsProvider
{
    string DefaultImportedUserPassword { get; }
}
