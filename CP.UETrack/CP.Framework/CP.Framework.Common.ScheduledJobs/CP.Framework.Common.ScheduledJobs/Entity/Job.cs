namespace CP.Framework.Common.ScheduledJobs
{
    using Model;
    using System;
    using System.Collections.Generic;
    public abstract class Job
    {
        private ScheduledJob jobInstance;

        public Job(ScheduledJob job)
        {
            jobInstance = job;
        }

        public ScheduledJob GetInstance
        {
            get { return jobInstance; }
            private set { jobInstance = value; }
        }

        public bool IsScheduleDue()
        {
            var isScheduleDue = false;
            var currentDate = DateTime.Now;
            
            if (jobInstance.StartDate <= currentDate || jobInstance.EndDate >= currentDate)
                return false;

            if (jobInstance.StartTime.HasValue)
            {
                var startTime = jobInstance.StartTime.Value;
                var endTime = new TimeSpan(23, 59, 59);

                if (jobInstance.EndTime.HasValue)
                    endTime = jobInstance.EndTime.Value;

                if (!TimeBetween(currentDate, startTime, endTime))
                    return false;

            }

            var frequencyCode = jobInstance.FrequencyCode.Substring(0, 1).ToUpper();
            
            switch (frequencyCode)
            {
                case "O":
                    if (jobInstance.StartDate == currentDate)
                    {
                        if (TimeBetween(jobInstance.JobTime, new TimeSpan(currentDate.Hour, currentDate.Minute - 5, 0), new TimeSpan(currentDate.Hour, currentDate.Minute + 5, 0)))
                            if (jobInstance.LastRunOn == null)
                                isScheduleDue = true;
                    }
                    
                    break;

                case "Y":
                    if (jobInstance.StartDate.Day == currentDate.Day && jobInstance.StartDate.Month == currentDate.Month)
                    {
                        if (TimeBetween(jobInstance.JobTime, new TimeSpan(currentDate.Hour, currentDate.Minute - 5, 0), new TimeSpan(currentDate.Hour, currentDate.Minute + 5, 0)))
                            if (jobInstance.LastRunOn == null)
                                isScheduleDue = true;
                            else
                            {
                                if ((currentDate - jobInstance.LastRunOn).Value.TotalDays > 300)
                                    isScheduleDue = true;
                            }
                    }
                    break;

                case "M":

                    break;

                case "W":

                    break;

                case "D":

                    break;

                case "R":

                    break;

            }


            return isScheduleDue;

        }

        public abstract void ExecuteJob();

        bool TimeBetween(TimeSpan time, TimeSpan start, TimeSpan end)
        {
            // see if start comes before end
            if (start < end)
                return start <= time && time <= end;
            // start is after end, so do the inverse comparison
            return !(end < time && time < start);

        }
        bool TimeBetween(DateTime datetime, TimeSpan start, TimeSpan end)
        {
            // convert datetime to a TimeSpan
            TimeSpan now = datetime.TimeOfDay;
            return TimeBetween(now, start, end);
        }
    }

}
