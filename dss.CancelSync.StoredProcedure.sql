/****** Object:  StoredProcedure [dss].[CancelSync]    Script Date: 2022/2/10 上午 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[CancelSync]
    @SyncGroupId	UNIQUEIDENTIFIER
AS
BEGIN
    IF (([dss].[IsSyncGroupActive] (@SyncGroupId)) = 0)
    BEGIN
        RAISERROR('SYNCGROUP_DOES_NOT_EXIST_OR_NOT_ACTIVE', 15, 1);
        RETURN
    END

    UPDATE [dss].[task]
    SET
        [state] = -4  --set task state to cancelling
    WHERE [type] = 2 AND [state] <= 0   -- all sync tasks in ready, pending and processing states
        AND ([actionid] IN
        (SELECT
            [id]
        FROM [dss].[action]
        WHERE ([syncgroupid] = @SyncGroupID)))
END
GO
