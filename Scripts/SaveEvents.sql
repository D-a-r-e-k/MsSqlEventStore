SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Darius Butkevicius
-- Create date: 2016-10-23
-- Description:	Process addition of events to event store
-- =============================================


CREATE PROCEDURE [dbo].[SaveEvents]
(
    @AggregatedId uniqueidentifier,   
    @ExpectedVersion int,
	@Events EventType READONLY
)
AS   
BEGIN
	set xact_abort on
	BEGIN TRAN T;

	DECLARE @CurrentVersion AS int;
	SET @CurrentVersion = (SELECT Version FROM EventSource WHERE AggregateId = @AggregatedId);
	
	IF @CurrentVersion IS NULL
	BEGIN
		SET @CurrentVersion = 0
		INSERT INTO EventSource(AggregateId, Version) VALUES (@AggregatedId, @CurrentVersion)
	END

	-- concurrency validation
	IF (@ExpectedVersion - 1) != @CurrentVersion
		THROW 50000,'Concurrency problem',1

	DECLARE @EventsCursor CURSOR
	DECLARE @E_AggregateId uniqueidentifier
	DECLARE @E_Data varbinary(max)
	DECLARE @E_Version int
	DECLARE @E_Date date

	SET @EventsCursor = CURSOR FOR
	SELECT AggregateId, Data, Version, Date FROM @Events

	OPEN @EventsCursor
	FETCH NEXT
	FROM @EventsCursor INTO @E_AggregateId, @E_Data, @E_Version, @E_Date
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @AggregatedId != @E_AggregateId 
			THROW 50000,'Events for only one aggregate are processed at the time',1
		
		SET @CurrentVersion = @CurrentVersion + 1;
		INSERT INTO Event(AggregateId, Data, Version, Date) VALUES (@E_AggregateId, @E_Data, @CurrentVersion, @E_Date);
		
		FETCH NEXT
		FROM @EventsCursor INTO @E_AggregateId, @E_Data, @E_Version, @E_Date
	END

	CLOSE @EventsCursor
	DEALLOCATE @EventsCursor

	UPDATE EventSource
	SET Version = @CurrentVersion

	COMMIT TRAN T;
END
 

GO


