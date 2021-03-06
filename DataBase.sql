USE [master]
GO
/****** Object:  Database [FarmingSimulator]    Script Date: 2018/06/06 07:52:40 ******/
CREATE DATABASE [FarmingSimulator]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FarmingSimulator', FILENAME = N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\FarmingSimulator.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'FarmingSimulator_log', FILENAME = N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\FarmingSimulator_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [FarmingSimulator] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FarmingSimulator].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FarmingSimulator] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FarmingSimulator] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FarmingSimulator] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FarmingSimulator] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FarmingSimulator] SET ARITHABORT OFF 
GO
ALTER DATABASE [FarmingSimulator] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [FarmingSimulator] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [FarmingSimulator] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FarmingSimulator] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FarmingSimulator] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FarmingSimulator] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FarmingSimulator] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FarmingSimulator] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FarmingSimulator] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FarmingSimulator] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FarmingSimulator] SET  DISABLE_BROKER 
GO
ALTER DATABASE [FarmingSimulator] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FarmingSimulator] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FarmingSimulator] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FarmingSimulator] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FarmingSimulator] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FarmingSimulator] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [FarmingSimulator] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FarmingSimulator] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [FarmingSimulator] SET  MULTI_USER 
GO
ALTER DATABASE [FarmingSimulator] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FarmingSimulator] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FarmingSimulator] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FarmingSimulator] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [FarmingSimulator]
GO
/****** Object:  StoredProcedure [dbo].[AddNewFarmAnimal]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddNewFarmAnimal]
(@Species varchar(20),@Name varchar(20),@Gender varchar(6),@DateofBirth varchar(10))
AS
BEGIN
INSERT INTO dbo.FarmAnimalTable
(AnimalBirthDate,AnimalGender,AnimalID,SaveID)
VALUES (@DateofBirth,@Gender, (Select AnimalID
From dbo.AnimalTable where AnimalSpecies = @Species),(Select SaveID
From dbo.SaveTable where FarmID = (Select FarmID
From dbo.FarmTable where FarmName = @Name)))
END


GO
/****** Object:  StoredProcedure [dbo].[DeleteDeadAnimals]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDeadAnimals]
(@Name varchar(20),@Species varchar(20),@DateofBirth varchar(10))
AS
BEGIN
DELETE FROM dbo.FarmAnimalTable WHERE AnimalBirthDate = @DateofBirth 
AND SaveID = (Select SaveID
From dbo.SaveTable where FarmID = (Select FarmID
From dbo.FarmTable where FarmName = @Name)) 
AND AnimalID = (Select AnimalID 
From dbo.AnimalTable where AnimalSpecies = @Species)
END


GO
/****** Object:  StoredProcedure [dbo].[InsertFarmAnimals]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertFarmAnimals]
(@Species varchar(20),@DateofBirth varchar(10),@Gender varchar(6),@FarmName varchar(20))
AS
BEGIN
INSERT INTO dbo.FarmAnimalTable
(AnimalBirthDate,AnimalGender,AnimalID,SaveID)
VALUES (@DateofBirth,@Gender, (Select AnimalID 
From dbo.AnimalTable where AnimalSpecies = @Species), (Select SaveID 
From dbo.SaveTable where FarmID = (Select FarmID
From dbo.FarmTable where FarmName = @FarmName)))
END


GO
/****** Object:  StoredProcedure [dbo].[InsertNewFarm]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertNewFarm]
(@Name varchar(20),@Size int, @Username varchar(20))
AS
BEGIN
INSERT INTO dbo.FarmTable
(FarmName,FarmSize,UserID)
VALUES (@Name,@Size, (Select UserID
From dbo.UserTable where UserUsername = @Username))
END




GO
/****** Object:  StoredProcedure [dbo].[InsertNewUse]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertNewUse]
(@Name varchar(15),@Surname varchar(20),@Gender varchar(6),@Password varchar(20),@Username varchar(20))
AS
BEGIN
INSERT INTO dbo.UserTable
(UserName,UserSurname,UserGender,UserPassword,UserUsername)
VALUES
(@Name, @Surname, @Gender, @Password, @Username)
END


GO
/****** Object:  StoredProcedure [dbo].[InsertNewUser]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertNewUser]
(@ID int,@Name varchar(15),@Surname varchar(20),@Gender varchar(6),@Password varchar(20),@Username varchar(20))
AS
BEGIN
INSERT INTO dbo.UserTable
(UserID,UserName,UserSurname,UserGender,UserPassword,UserUsername)
VALUES
(@ID, @Name, @Surname, @Gender, @Password, @Username)
END


GO
/****** Object:  StoredProcedure [dbo].[InsertTheNewUser]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertTheNewUser]
(@Name varchar(15),@Surname varchar(20),@Gender varchar(6),@Password varchar(20),@Username varchar(20),@UserDateOfBirth varchar(10))
AS
BEGIN
INSERT INTO dbo.UserTable
(UserName,UserSurname,UserGender,UserPassword,UserUsername,UserDateOfBirth)
VALUES
(@Name, @Surname, @Gender, @Password, @Username,@UserDateOfBirth)
END

GO
/****** Object:  StoredProcedure [dbo].[InsertTheNewUsers]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertTheNewUsers]
(@ID int ,@Name varchar(15),@Surname varchar(20),@Gender varchar(6),@Password varchar(20),@Username varchar(20),@UserDateOfBirth varchar(10))
AS
BEGIN
INSERT INTO dbo.UserTable
(UserID,UserName,UserSurname,UserGender,UserPassword,UserUsername,UserDateOfBirth)
VALUES
(@ID , @Name, @Surname, @Gender, @Password, @Username,@UserDateOfBirth)
END



GO
/****** Object:  StoredProcedure [dbo].[SelectAnimalEatingSpeed]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectAnimalEatingSpeed]
(@Species varchar(20))
AS
BEGIN
SELECT FeedingNewborn,FeedingChild,FeedingAdult,FeedingLateAdult,FeedingOld,FeedingPregnant
From dbo.FeedingTable
Where AnimalID = (Select AnimalID from dbo.AnimalTable where AnimalSpecies = @Species)
END


GO
/****** Object:  StoredProcedure [dbo].[SelectAnimalInformation]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectAnimalInformation]
AS
BEGIN
SELECT AnimalID,AnimalSpecies,AnimalType,AnimalSize,AnimalLifespan,AnimalPregnancyTime
FROM dbo.AnimalTable
END


GO
/****** Object:  StoredProcedure [dbo].[SelectAnimalWalkingSpeed]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectAnimalWalkingSpeed]
(@Species varchar(20))
AS
BEGIN
SELECT WalkingNewborn,WalkingChild,WalkingAdult,WalkingLateAdult,WalkingOld,WalkingPregnant
From dbo.WalkingTable
Where AnimalID = (Select AnimalID from dbo.AnimalTable where AnimalSpecies = @Species)
END
GO
/****** Object:  StoredProcedure [dbo].[SelectComboBoxInfo]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectComboBoxInfo]
AS
BEGIN
SELECT AnimalSpecies,AnimalType
FROM dbo.AnimalTable;
END


GO
/****** Object:  StoredProcedure [dbo].[SelectFarmAnimals]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectFarmAnimals]
(@Name varchar(20))
AS
BEGIN
SELECT AnimalGender, AnimalBirthDate, AnimalID
FROM dbo.FarmAnimalTable
WHERE SaveID = (Select SaveID
From dbo.SaveTable where FarmID = (Select FarmID
From dbo.FarmTable where FarmName = @Name))
END


GO
/****** Object:  StoredProcedure [dbo].[SelectFarmSize]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectFarmSize]
(@Name varchar(20))
AS
BEGIN
SELECT FarmSize
FROM dbo.FarmTable
WHERE FarmName = @Name;
END


GO
/****** Object:  StoredProcedure [dbo].[SelectLoginDetails]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectLoginDetails]
AS
BEGIN
SELECT UserUsername,UserPassword 
FROM dbo.UserTable;
END


GO
/****** Object:  StoredProcedure [dbo].[SelectUserFarms]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectUserFarms]
(@Username varchar(20))
AS
BEGIN
SELECT FarmName
FROM dbo.FarmTable
WHERE UserID = (Select UserID from dbo.UserTable where UserUsername = @Username)
END


GO
/****** Object:  StoredProcedure [dbo].[UserInformation]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserInformation]
(@Username varchar(20),@Password varchar(20))
AS
BEGIN
SELECT UserName,UserSurname,UserGender
FROM dbo.UserTable
WHERE UserUsername = @Username AND UserPassword = @Password
END


GO
/****** Object:  Table [dbo].[AnimalTable]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AnimalTable](
	[AnimalID] [int] IDENTITY(1,1) NOT NULL,
	[AnimalSpecies] [varchar](20) NULL,
	[AnimalType] [varchar](8) NULL,
	[AnimalSize] [int] NULL,
	[AnimalLifespan] [int] NULL,
	[AnimalPregnancyTime] [int] NULL,
 CONSTRAINT [PK_AnimalTable] PRIMARY KEY CLUSTERED 
(
	[AnimalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FarmAnimalTable]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FarmAnimalTable](
	[FarmAnimalID] [int] NULL,
	[SaveID] [int] NULL,
	[AnimalID] [int] NULL,
	[AnimalGender] [varchar](6) NULL,
	[AnimalBirthDate] [varchar](10) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FarmTable]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FarmTable](
	[FarmID] [int] IDENTITY(1,1) NOT NULL,
	[FarmName] [varchar](20) NULL,
	[FarmSize] [int] NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_FarmTable] PRIMARY KEY CLUSTERED 
(
	[FarmID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FeedingTable]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FeedingTable](
	[FeedingID] [int] IDENTITY(1,1) NOT NULL,
	[FeedingNewborn] [int] NULL,
	[FeedingChild] [int] NULL,
	[FeedingAdult] [int] NULL,
	[FeedingLateAdult] [int] NULL,
	[FeedingOld] [int] NULL,
	[FeedingPregnant] [int] NULL,
	[AnimalID] [int] NULL,
 CONSTRAINT [PK_FeedingTable] PRIMARY KEY CLUSTERED 
(
	[FeedingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SaveTable]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SaveTable](
	[SaveID] [int] IDENTITY(1,1) NOT NULL,
	[FarmID] [int] NULL,
 CONSTRAINT [PK_SaveTable] PRIMARY KEY CLUSTERED 
(
	[SaveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserTable]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserTable](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](15) NULL,
	[UserSurname] [varchar](20) NULL,
	[UserGender] [varchar](6) NULL,
	[UserPassword] [varchar](20) NULL,
	[UserUsername] [varchar](20) NULL,
	[UserDateOfBirth] [varchar](10) NULL,
 CONSTRAINT [PK_UserTable] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[WalkingTable]    Script Date: 2018/06/06 07:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WalkingTable](
	[WalkingID] [int] IDENTITY(1,1) NOT NULL,
	[WalkingNewborn] [int] NULL,
	[WalkingChild] [int] NULL,
	[WalkingAdult] [int] NULL,
	[WalkingLateAdult] [int] NULL,
	[WalkingOld] [int] NULL,
	[WalkingPregnant] [int] NULL,
	[AnimalID] [int] NULL,
 CONSTRAINT [PK_WalkingTable] PRIMARY KEY CLUSTERED 
(
	[WalkingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[FarmAnimalTable]  WITH CHECK ADD  CONSTRAINT [FK_FarmAnimalTable_AnimalTable] FOREIGN KEY([AnimalID])
REFERENCES [dbo].[AnimalTable] ([AnimalID])
GO
ALTER TABLE [dbo].[FarmAnimalTable] CHECK CONSTRAINT [FK_FarmAnimalTable_AnimalTable]
GO
ALTER TABLE [dbo].[FarmAnimalTable]  WITH CHECK ADD  CONSTRAINT [FK_FarmAnimalTable_SaveTable] FOREIGN KEY([SaveID])
REFERENCES [dbo].[SaveTable] ([SaveID])
GO
ALTER TABLE [dbo].[FarmAnimalTable] CHECK CONSTRAINT [FK_FarmAnimalTable_SaveTable]
GO
ALTER TABLE [dbo].[FarmTable]  WITH CHECK ADD  CONSTRAINT [FK_FarmTable_UserTable] FOREIGN KEY([UserID])
REFERENCES [dbo].[UserTable] ([UserID])
GO
ALTER TABLE [dbo].[FarmTable] CHECK CONSTRAINT [FK_FarmTable_UserTable]
GO
ALTER TABLE [dbo].[FeedingTable]  WITH CHECK ADD  CONSTRAINT [FK_FeedingTable_AnimalTable] FOREIGN KEY([AnimalID])
REFERENCES [dbo].[AnimalTable] ([AnimalID])
GO
ALTER TABLE [dbo].[FeedingTable] CHECK CONSTRAINT [FK_FeedingTable_AnimalTable]
GO
ALTER TABLE [dbo].[SaveTable]  WITH CHECK ADD  CONSTRAINT [FK_SaveTable_FarmTable] FOREIGN KEY([FarmID])
REFERENCES [dbo].[FarmTable] ([FarmID])
GO
ALTER TABLE [dbo].[SaveTable] CHECK CONSTRAINT [FK_SaveTable_FarmTable]
GO
ALTER TABLE [dbo].[WalkingTable]  WITH CHECK ADD  CONSTRAINT [FK_WalkingTable_AnimalTable] FOREIGN KEY([AnimalID])
REFERENCES [dbo].[AnimalTable] ([AnimalID])
GO
ALTER TABLE [dbo].[WalkingTable] CHECK CONSTRAINT [FK_WalkingTable_AnimalTable]
GO
USE [master]
GO
ALTER DATABASE [FarmingSimulator] SET  READ_WRITE 
GO
