namespace CP.Framework.Security.Authentication
{
    public interface IAuthenticationService
    {
        void SignIn(string username, bool isPersistent);

        void CreateCustomPrincipal();

        string GetUserName();
    }
}
