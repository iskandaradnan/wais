using AutoMapper;
using CP.UETrack.DAL.Model;
using CP.UETrack.Models.UM;

namespace CP.UETrack.DAL
{
    public interface IAutomapperConfiguration
    {
        Profile MappingProfile { get; }
    }
    public class AutoMapperConfiguration : IAutomapperConfiguration
    {
        public Profile MappingProfile
        {
            get
            {
                return new DALMappingProfile();
            }
        }
        private class DALMappingProfile : Profile
        {
            protected override void Configure()
            {
                base.Configure();
                CreateMaps();
            }
            private void CreateMaps()
            {
                CreateMap<ASISUserRegistrationViewModel, AsisUserRegistration>().ReverseMap();
            }
        }
    }
}

