/****** Object:  User [mitest1234]    Script Date: 2022/2/10 上午 11:00:15 ******/
CREATE USER [mitest1234] FROM  EXTERNAL PROVIDER 
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'mitest1234'
GO
