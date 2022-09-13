namespace CP.Framework.Common.ScheduledJobs
{
    using Model;
    using System.Collections.Generic;
    using System.Linq;

    public class JobManager
    {
        private ScheduledJobsEntities scheduledJobsDbEntity;
        
        //public Job(ScheduledJobsEntities dbEntity, ScheduledJob job)
        //{
        //    scheduledJobsDbEntity = dbEntity;
        //    jobInstance = job;
        //}

        public JobManager(ScheduledJobsEntities dbEntity)
        {
            scheduledJobsDbEntity = dbEntity;
        }

        public ScheduledJob Get(string jobName)
        {
            var jobDetail = scheduledJobsDbEntity.ScheduledJobs.FirstOrDefault(x => x.JobName == jobName);
            return jobDetail;
        }

        public ScheduledJob Get(int jobId)
        {
            var jobDetail = scheduledJobsDbEntity.ScheduledJobs.FirstOrDefault(x => x.ScheduledJobId == jobId);
            return jobDetail;
        }

        public List<ScheduledJob> GetAll()
        {
            var jobList = scheduledJobsDbEntity.ScheduledJobs.ToList();
            return jobList;
        }

        public void Add(ScheduledJob job)
        {

        }

        public void Update(ScheduledJob job)
        {

        }

        public virtual void EnableJob()
        {

        }

        public virtual void DisableJob()
        {

        }
    }
}
