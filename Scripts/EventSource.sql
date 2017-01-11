/****** Object:  Table [dbo].[EventSource]    Script Date: 1/11/2017 9:37:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EventSource](
	[AggregateId] [uniqueidentifier] NOT NULL,
	[Version] [int] NOT NULL,
 CONSTRAINT [PK_EventSource] PRIMARY KEY CLUSTERED 
(
	[AggregateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


