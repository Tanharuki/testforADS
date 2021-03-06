/****** Object:  StoredProcedure [dss].[CheckAndDeleteUnusedDatabase]    Script Date: 2022/2/10 上午 11:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dss].[CheckAndDeleteUnusedDatabase]
    @DatabaseId UNIQUEIDENTIFIER
AS
BEGIN
    DECLARE @IsOnPremise BIT
    DECLARE @AgentId	UNIQUEIDENTIFIER

    SELECT
        @IsOnPremise = [is_on_premise],
        @AgentId = [agentid]
    FROM [dss].[userdatabase]
    WHERE [id] = @DatabaseId

    IF (@IsOnPremise = 0) -- cloud database
    BEGIN
        -- there is no member for this database or this database is not a hub for any syncgroup
        IF (
            NOT EXISTS (SELECT 1 FROM [dss].[syncgroupmember] WHERE [databaseid] = @DatabaseId) AND
            NOT EXISTS (SELECT 1 FROM [dss].[syncgroup] WHERE [hub_memberid] = @DatabaseId)
            )
        BEGIN
            EXEC [dss].[DeleteUserDatabase] @AgentId, @DatabaseId
        END
    END
END
GO
