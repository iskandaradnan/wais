USE UetrackMasterdbPreProd
GO
CREATE TABLE PPMLoadBalanceWeekCalendar
(
Autoid bigint identity(1,1),
Year int,
Month NVARCHAR(5),
Week int,
Week_start date,
Week_end date,
CreatedDatetime datetime
)