/****** Object:  Table [dbo].[Event]    Script Date: 1/11/2017 9:36:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Event](
	[AggregateId] [uniqueidentifier] NOT NULL,
	[Data] [varbinary](max) NOT NULL,
	[Version] [int] NOT NULL,
	[Date] [date] NOT NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[AggregateId] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Event]  WITH CHECK ADD  CONSTRAINT [FK_Event_EventSource] FOREIGN KEY([AggregateId])
REFERENCES [dbo].[EventSource] ([AggregateId])
GO

ALTER TABLE [dbo].[Event] CHECK CONSTRAINT [FK_Event_EventSource]
GO
