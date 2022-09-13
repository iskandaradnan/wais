using AutoMapper;
using CP.UETrack.Model;
using CP.UETrack.DAL;



namespace CP.UETrack.BLL
{
    public class AutoMapperConfiguration : IAutomapperConfiguration
    {
        public Profile MappingProfile
        {
            get
            {
                return new BALMappingProfile();
            }
        }

        private class BALMappingProfile : Profile
        {
            protected override void Configure()
            {
                base.Configure();
                CreateMaps();
            }

            /// <summary>
            /// Method to generate profile on the basis of UserMapping.
            /// </summary>
            protected void CreateMaps()
            {
                
            }
        }
    }
}
