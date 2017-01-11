/****** Object:  UserDefinedTableType [dbo].[EventType]    Script Date: 1/11/2017 9:38:25 PM ******/
CREATE TYPE [dbo].[EventType] AS TABLE(
	[AggregateId] [uniqueidentifier] NOT NULL,
	[Data] [varbinary](max) NOT NULL,
	[Version] [int] NOT NULL,
	[Date] [date] NOT NULL
)
GO