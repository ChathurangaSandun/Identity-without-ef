USE [Identity]
GO
/****** Object:  StoredProcedure [dbo].[Identity_InsertUser]    Script Date: 11/21/2017 12:55:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Identity_InsertUser]
	@UserID              UNIQUEIDENTIFIER,
    @Email                NVARCHAR (256) ,
    @EmailConfirmed       BIT             ,
    @PasswordHash         NVARCHAR (MAX)   ,
    @SecurityStamp      NVARCHAR (MAX)   ,   
    @PhoneNumberConfirmed BIT              ,
    @TwoFactorEnabled    BIT              ,
    @LockoutEndDateUtc    DATETIME         ,
    @LockoutEnabled       BIT              ,
    @AccessFailedCount    INT             ,
    @UserName             NVARCHAR (256)   ,
    @CreateBy            UNIQUEIDENTIFIER ,
    @ModifyBy             UNIQUEIDENTIFIER
AS
BEGIN
	BEGIN TRY
    BEGIN TRANSACTION

-- user
INSERT INTO [dbo].[IdentityUser]
            ([UserId]
            ,[Email]
            ,[EmailConfirmed]
            ,[PasswordHash]
            ,[SecurityStamp]        
            ,[PhoneNumberConfirmed]
            ,[TwoFactorEnabled]
            ,[LockoutEndDateUtc]
            ,[LockoutEnabled]
            ,[AccessFailedCount]
            ,[UserName]
            ,[CreateBy]
            ,[ModifyBy])
     VALUES
            (@USERID
            ,@EMAIL
            ,@EMAILCONFIRMED
            ,@PASSWORDHASH
            ,@SECURITYSTAMP

            ,@PHONENUMBERCONFIRMED
            ,@TWOFACTORENABLED
            ,@LOCKOUTENDDATEUTC
            ,@LOCKOUTENABLED
            ,@ACCESSFAILEDCOUNT
            ,@USERNAME
            ,@CREATEBY
            ,@MODIFYBY)

-- profile
INSERT INTO [dbo].[IdentityProfile]
           ([UserId]
           ,[CreateBy]
           ,[ModifyBy])
     VALUES
           (@USERID
           ,@CREATEBY
           ,@MODIFYBY)

    COMMIT TRANSACTION

END TRY

BEGIN CATCH
    IF @@ERROR<>0 AND @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    DECLARE
        @ErrorMessage nvarchar(4000) = ERROR_MESSAGE(),
        @ErrorNumber int = ERROR_NUMBER(),
        @ErrorSeverity int = ERROR_SEVERITY(),
        @ErrorState int = ERROR_STATE(),
        @ErrorLine int = ERROR_LINE(),
        @ErrorProcedure nvarchar(200) = ISNULL(ERROR_PROCEDURE(), '-');
    SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 'Message: ' + @ErrorMessage;
    RAISERROR (@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine)

    --THROW --if on SQL2012 or above
END CATCH
END

GO
