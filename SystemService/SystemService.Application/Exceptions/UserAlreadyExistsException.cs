namespace SystemService.Application.Exceptions;

public class UserAlreadyExistsException : ConflictException
{
    public UserAlreadyExistsException(string message) : base(message)
    {
    }

    public UserAlreadyExistsException(string message, Exception innerException) : base(message, innerException)
    {
    }
}
