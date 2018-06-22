use master
go

IF  EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'TicketBalanzaDB') 
ALTER DATABASE [TicketBalanzaDB] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
go

IF  EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'TicketBalanzaDB') 
drop database TicketBalanzaDB 
go

create database TicketBalanzaDB
go
  

use TicketBalanzaDB 
go

IF OBJECT_ID ('BALANZA') IS NOT NULL
	DROP TABLE BALANZA
GO

IF OBJECT_ID ('CATALOGOTABLAS') IS NOT NULL
	DROP TABLE CATALOGOTABLAS
GO

IF OBJECT_ID ('CORRELATIVO') IS NOT NULL
	DROP TABLE CORRELATIVO
GO

IF OBJECT_ID ('DETALLECATALOGO') IS NOT NULL
	DROP TABLE DETALLECATALOGO
GO

IF OBJECT_ID ('LOGLLAMADAS') IS NOT NULL
	DROP TABLE LOGLLAMADAS
GO

IF OBJECT_ID ('MENUOPCION') IS NOT NULL
	DROP TABLE MENUOPCION
GO

IF OBJECT_ID ('PERMISO') IS NOT NULL
	DROP TABLE PERMISO
GO

IF OBJECT_ID ('PERMISOROL') IS NOT NULL
	DROP TABLE PERMISOROL
GO

IF OBJECT_ID ('ROL') IS NOT NULL
	DROP TABLE ROL
GO

IF OBJECT_ID ('ROLUSUARIO') IS NOT NULL
	DROP TABLE ROLUSUARIO
GO

IF OBJECT_ID ('TICKET') IS NOT NULL
	DROP TABLE TICKET
GO

IF OBJECT_ID ('USUARIO') IS NOT NULL
	DROP TABLE USUARIO
GO

IF OBJECT_ID ('usp_ActualizarTicket') IS NOT NULL
	DROP PROCEDURE usp_ActualizarTicket
GO

IF OBJECT_ID ('usp_AnularTicket') IS NOT NULL
	DROP PROCEDURE usp_AnularTicket
GO

IF OBJECT_ID ('usp_Correlativo') IS NOT NULL
	DROP PROCEDURE usp_Correlativo
GO

IF OBJECT_ID ('usp_GuardarTicket') IS NOT NULL
	DROP PROCEDURE usp_GuardarTicket
GO

IF OBJECT_ID ('usp_InsertBalanza') IS NOT NULL
	DROP PROCEDURE usp_InsertBalanza
GO

IF OBJECT_ID ('usp_InsertLogMapa') IS NOT NULL
	DROP PROCEDURE usp_InsertLogMapa
GO

IF OBJECT_ID ('usp_InsertUsuario') IS NOT NULL
	DROP PROCEDURE usp_InsertUsuario
GO

IF OBJECT_ID ('usp_ListBalanza') IS NOT NULL
	DROP PROCEDURE usp_ListBalanza
GO

IF OBJECT_ID ('usp_ListCatalogo') IS NOT NULL
	DROP PROCEDURE usp_ListCatalogo
GO

IF OBJECT_ID ('usp_ListEstado') IS NOT NULL
	DROP PROCEDURE usp_ListEstado
GO

IF OBJECT_ID ('usp_ListMenuOpcion') IS NOT NULL
	DROP PROCEDURE usp_ListMenuOpcion
GO

IF OBJECT_ID ('usp_ListPermisoUsuario') IS NOT NULL
	DROP PROCEDURE usp_ListPermisoUsuario
GO

IF OBJECT_ID ('usp_ListRol') IS NOT NULL
	DROP PROCEDURE usp_ListRol
GO

IF OBJECT_ID ('usp_ListTicketBalanza') IS NOT NULL
	DROP PROCEDURE usp_ListTicketBalanza
GO

IF OBJECT_ID ('usp_ListUsuario') IS NOT NULL
	DROP PROCEDURE usp_ListUsuario
GO

IF OBJECT_ID ('usp_UpdateBalanza') IS NOT NULL
	DROP PROCEDURE usp_UpdateBalanza
GO

IF OBJECT_ID ('usp_UpdateParametros') IS NOT NULL
	DROP PROCEDURE usp_UpdateParametros
GO

IF OBJECT_ID ('usp_UpdateUsuario') IS NOT NULL
	DROP PROCEDURE usp_UpdateUsuario
GO

IF OBJECT_ID ('usp_ValidarUsuario') IS NOT NULL
	DROP PROCEDURE usp_ValidarUsuario
GO

IF OBJECT_ID ('f_CorrelativoTicketBalanza') IS NOT NULL
	DROP FUNCTION f_CorrelativoTicketBalanza
GO

IF OBJECT_ID ('f_RolesUsuario') IS NOT NULL
	DROP FUNCTION f_RolesUsuario
GO

IF OBJECT_ID ('f_Split') IS NOT NULL
	DROP FUNCTION f_Split
GO

IF OBJECT_ID ('f_ValidarBalanza') IS NOT NULL
	DROP FUNCTION f_ValidarBalanza
GO

IF OBJECT_ID ('f_ValidarUsuario') IS NOT NULL
	DROP FUNCTION f_ValidarUsuario
GO

CREATE TABLE dbo.BALANZA
	(
	IdBalanza INT IDENTITY NOT NULL,
	NumeroBalanza INT NOT NULL,
	NombreBalanza VARCHAR (100) NOT NULL,
	UsuarioInterface VARCHAR (50) NOT NULL,
	EstadoRegistro BIT NOT NULL,
	Estado BIT NOT NULL,
	UsuarioCreacion VARCHAR (60) NOT NULL,
	FechaHoraCreacion DATETIME NOT NULL,
	UsuarioActualizacion VARCHAR (60) NULL,
	FechaHoraActualizacion DATETIME NULL,
	CuerposImpresionPrimeraPesada INT NULL,
	CuerposImpresionSegundaPesada INT NULL,
	CONSTRAINT XPKBALANZA PRIMARY KEY (IdBalanza)
	)
GO

CREATE TABLE dbo.CATALOGOTABLAS
	(
	IdCatalogo INT IDENTITY NOT NULL,
	Codigo VARCHAR (10) NULL,
	Nombre VARCHAR (50) NULL,
	Descripcion VARCHAR (250) NULL,
	CodigoTabla VARCHAR (30) NULL,
	UsuarioCreacion VARCHAR (60) NOT NULL,
	FechaHoraCreacion DATETIME NOT NULL,
	UsuarioActualizacion VARCHAR (60) NULL,
	FechaHoraActualizacion DATETIME NULL,
	EstadoRegistro BIT NOT NULL,
	CONSTRAINT XPKTABLA_TABLAS PRIMARY KEY (IdCatalogo)
	)
GO

CREATE TABLE dbo.CORRELATIVO
	(
	IDCORRELATIVO INT IDENTITY NOT NULL,
	CORRELATIVO BIGINT NULL,
	TIPO VARCHAR (20) NOT NULL,
	CONSTRAINT XPKCORRELATIVO PRIMARY KEY (IDCORRELATIVO)
	)
GO

CREATE TABLE dbo.DETALLECATALOGO
	(
	IdDetalleCatalogo INT IDENTITY NOT NULL,
	IdCatalogo INT NOT NULL,
	Codigo VARCHAR (10) NOT NULL,
	Label VARCHAR (50) NOT NULL,
	Descripcion VARCHAR (50) NULL,
	Mnemonico VARCHAR (20) NULL,
	Val1 VARCHAR (400) NULL,
	Val2 VARCHAR (20) NULL,
	Val3 VARCHAR (20) NULL,
	UsuarioCreacion VARCHAR (60) NOT NULL,
	FechaHoraCrecion DATETIME NOT NULL,
	UsuarioActualizacion VARCHAR (60) NULL,
	FechaHoraActualizacion DATETIME NULL,
	EstadoRegistro BIT NOT NULL,
	CONSTRAINT XPKDETALLECATALOGO PRIMARY KEY (IdDetalleCatalogo),
	CONSTRAINT R_12 FOREIGN KEY (IdCatalogo) REFERENCES dbo.CATALOGOTABLAS (IdCatalogo)
	)
GO

CREATE TABLE dbo.LOGLLAMADAS
	(
	IdLog INT IDENTITY NOT NULL,
	IdTrace VARCHAR (10) NOT NULL,
	FechaHoraInicio DATETIME NOT NULL,
	FechaHoraFin DATETIME NULL,
	Milisegundos INT NULL,
	Segundos DECIMAL (6,2) NULL,
	IPLocal VARCHAR (30) NULL,
	Usuario VARCHAR (60) NULL,
	TipoLlamada VARCHAR (20) NULL,
	URL VARCHAR (500) NULL,
	JsonRequest TEXT NULL,
	JsonResponse TEXT NULL,
	UsuarioCreacion VARCHAR (60) NOT NULL,
	FechaHoraCreacion DATETIME NOT NULL,
	UsuarioActualizacion VARCHAR (60) NULL,
	FechaHoraActualizacion DATETIME NULL,
	EstadoRegistro BIT NOT NULL,
	CONSTRAINT XPKLog PRIMARY KEY (IdLog)
	)
GO

CREATE TABLE dbo.MENUOPCION
	(
	IdMenuOpcion INT NOT NULL,
	IdPadre INT NOT NULL,
	Nombre VARCHAR (300) NOT NULL,
	FormName VARCHAR (500) NOT NULL,
	EstadoRegistro BIT NOT NULL,
	CONSTRAINT XPKMENUOPCION PRIMARY KEY (IdMenuOpcion)
	)
GO

CREATE TABLE dbo.PERMISO
	(
	IdPermiso INT IDENTITY NOT NULL,
	NombrePermiso VARCHAR (50) NOT NULL,
	UsuarioCreacion VARCHAR (60) NOT NULL,
	FechaHoraCreacion DATETIME NULL,
	UsuarioActualizacion VARCHAR (60) NULL,
	FechaHoraActualizacion DATETIME NULL,
	EstadoRegistro BIT NOT NULL,
	CONSTRAINT XPKPERMISO PRIMARY KEY (IdPermiso)
	)
GO

CREATE TABLE dbo.ROL
	(
	IdRol INT IDENTITY NOT NULL,
	NombreRol VARCHAR (20) NOT NULL,
	UsuarioCreacion VARCHAR (60) NOT NULL,
	FechaHoraCreacion DATETIME NOT NULL,
	UsuarioActualizacion VARCHAR (60) NULL,
	FechaHoraActualizacion DATETIME NULL,
	EstadoRegistro BIT NOT NULL,
	CONSTRAINT XPKROL PRIMARY KEY (IdRol)
	)
GO


CREATE TABLE dbo.USUARIO
	(
	IdUsuario INT IDENTITY NOT NULL,
	NombreUsuario VARCHAR (20) NOT NULL,
	Contrasena VARCHAR (85) NULL,
	UsuarioCreacion VARCHAR (60) NOT NULL,
	FechaHoraCreacion DATETIME NOT NULL,
	UsuarioActualizacion VARCHAR (60) NULL,
	FechaHoraActualizacion DATETIME NULL,
	EstadoRegistro BIT NOT NULL,
	Estado BIT NOT NULL,
	CONSTRAINT XPKUSUARIO PRIMARY KEY (IdUsuario)
	)
GO

CREATE TABLE dbo.PERMISOROL
	(
	IdPermisoRol INT IDENTITY NOT NULL,
	IdRol INT NOT NULL,
	IdPermiso INT NOT NULL,
	UsuarioCreacion VARCHAR (60) NOT NULL,
	FechaHoraCreacion DATETIME NOT NULL,
	UsuarioActualizacion VARCHAR (60) NULL,
	FechaHoraActualizacion DATETIME NULL,
	EstadoRegistro BIT NOT NULL,
	CONSTRAINT XPKR PRIMARY KEY (IdPermisoRol),
	CONSTRAINT R_8 FOREIGN KEY (IdRol) REFERENCES dbo.ROL (IdRol),
	CONSTRAINT R_9 FOREIGN KEY (IdPermiso) REFERENCES dbo.PERMISO (IdPermiso)
	)
GO

CREATE TABLE dbo.ROLUSUARIO
	(
	IdRolUsuario INT IDENTITY NOT NULL,
	IdUsuario INT NOT NULL,
	IdRol INT NOT NULL,
	UsuarioCreacion VARCHAR (60) NOT NULL,
	FechaHoraCreacion DATETIME NOT NULL,
	UsuarioActualizacion VARCHAR (60) NULL,
	FechaHoraActualizacion DATETIME NULL,
	EstadoRegistro BIT NOT NULL,
	CONSTRAINT XPKROLUSUARIO PRIMARY KEY (IdRolUsuario),
	CONSTRAINT R_4 FOREIGN KEY (IdUsuario) REFERENCES dbo.USUARIO (IdUsuario),
	CONSTRAINT R_6 FOREIGN KEY (IdRol) REFERENCES dbo.ROL (IdRol)
	)
GO

CREATE TABLE dbo.TICKET
	(
	IdTicket INT IDENTITY NOT NULL,
	IdBalanza INT NOT NULL,
	AlmacenDestino VARCHAR (4) NULL,
	AlmacenOrigen VARCHAR (4) NULL,
	Chofer VARCHAR (40) NULL,
	CicloPesaje VARCHAR (14) NOT NULL,
	EstadoTicketSAP CHAR (1) NULL,
	EstadoTicketSoftwareBalanza VARCHAR (10) NOT NULL,
	FechaHoraPrimeraPesada DATETIME NOT NULL,
	FechaHoraSegundaPesada DATETIME NULL,
	FormaCapturaPrimeraPesada CHAR (1) NOT NULL,
	FormaCapturaSegundaPesada CHAR (1) NULL,
	Material VARCHAR (18) NULL,
	MensajeSAP VARCHAR (300) NULL,
	NotaEntrega VARCHAR (14) NULL,
	NumeroEnvases INT NULL,
	NumeroTicketSAP BIGINT NULL,
	NumeroTicketSoftwareBalanza BIGINT NOT NULL,
	NumeroTransportista BIGINT NULL,
	OrdenMovimientoBalanza BIGINT NOT NULL,
	Pedido BIGINT NULL,
	PesoBruto INT NULL,
	PesoNeto BIGINT NULL,
	PesoNetoTeorico INT NULL,
	Placa VARCHAR (6) NOT NULL,
	PosicionPedido INT NULL,
	PrimeraPesada INT NOT NULL,
	SegundaPesada INT NULL,
	Solicitante VARCHAR (10) NULL,
	DestinatarioMercancia VARCHAR(10) NULL,
	StatusSAP VARCHAR (10) NULL,
	Tara INT NULL,
	TaraEnvase INT NULL,
	TaraTotalEnvase BIGINT NULL,
	TextoCabecera VARCHAR (25) NULL,
	UsuarioPrimeraPesada VARCHAR (20) NOT NULL,
	UsuarioSegundaPesada VARCHAR (20) NULL,
	UsuarioCreacion VARCHAR (60) NOT NULL,
	FechaHoraCreacion DATETIME NOT NULL,
	UsuarioActualizacion VARCHAR (60) NULL,
	FechaHoraActualizacion DATETIME NULL,
	EstadoRegistro BIT NOT NULL,
	UsuarioAnulacion VARCHAR (20) NULL,
	DescripcionOMB nvarchar (150) NULL,
	NombreEmpresaTransp nvarchar (150) NULL,
    PlacaCarreta varchar(50) NULL,
    ProveedorCompra  varchar(50) NULL,
    TipoMovBalanza  varchar(50)NULL,
    Referencia1 varchar(50) NULL,
	CONSTRAINT XPKTICKET PRIMARY KEY (IdTicket),
	CONSTRAINT R_11 FOREIGN KEY (IdBalanza) REFERENCES dbo.BALANZA (IdBalanza)
	)
GO


  
CREATE PROCEDURE [dbo].[usp_ActualizarTicket]    
(     
 @IdTicket int,    
 @IdBalanza int,    
 @AlmacenDestino varchar(4),    
 @AlmacenOrigen varchar(4),    
 @Chofer varchar(40),    
 @CicloPesaje varchar(14),    
 @EstadoTicketSAP char(1),    
 @EstadoTicketSoftwareBalanza varchar(10),    
 @FechaHoraPrimeraPesada datetime,    
 @FormaCapturaPrimeraPesada char(1),    
 @FechaHoraSegundaPesada datetime=null,    
 @FormaCapturaSegundaPesada char(1)=null,    
 @Material varchar(18),    
 @MensajeSAP varchar(300),    
 @NotaEntrega varchar(14),    
 @NumeroEnvases int=NULL,    
 @NumeroTicketSAP bigint=NULL,    
 @NumeroTicketSoftwareBalanza bigint,    
 @NumeroTransportista bigint=NULL,    
 @OrdenMovimientoBalanza bigint,    
 @Pedido bigint=NULL,    
 @PesoBruto int=NULL,    
 @PesoNeto bigint,    
 @PesoNetoTeorico int=NULL,    
 @Placa varchar(6),    
 @PosicionPedido int=NULL,    
 @PrimeraPesada int,    
     
 @SegundaPesada int=NULL,    
     
 @Solicitante varchar(10),    
    
 @DestinatarioMercancia VARCHAR(10)=NULL,    
    
 @StatusSAP varchar(10),    
 @Tara int=NULL,    
 @TaraEnvase int=NULL,    
 @TaraTotalEnvase bigint=NULL,    
 @TextoCabecera varchar(25),    
 @UsuarioPrimeraPesada varchar(20),    
 @UsuarioSegundaPesada varchar(20)=null,    
 @Usuario varchar(60),    
 @EstadoRegistro bit,    
 @DescripcionOMB NVARCHAR(150),    
 @NombreEmpresaTransp NVARCHAR(150) ,   
   @PlacaCarreta VarChar(50),  
@ProveedorCompra  VarChar(50),  
@TipoMovBalanza  VarChar(50),  
@Referencia1 VarChar(50)  
)    
AS    
BEGIN    
    
 UPDATE TICKET SET    
  [IdBalanza]=@IdBalanza,    
  [AlmacenDestino]=@AlmacenDestino,    
  [AlmacenOrigen]=@AlmacenOrigen,    
  [Chofer] =@Chofer,    
  [CicloPesaje] =@CicloPesaje,    
  [EstadoTicketSAP] =@EstadoTicketSAP,    
  [EstadoTicketSoftwareBalanza] =@EstadoTicketSoftwareBalanza,    
  [FechaHoraSegundaPesada] =@FechaHoraSegundaPesada,    
  [FormaCapturaSegundaPesada] =@FormaCapturaSegundaPesada,    
  [FechaHoraPrimeraPesada] =@FechaHoraPrimeraPesada,    
  [FormaCapturaPrimeraPesada] =@FormaCapturaPrimeraPesada,    
  [Material] =@Material,    
  [MensajeSAP] =@MensajeSAP,    
  [NotaEntrega] =@NotaEntrega,    
  [NumeroEnvases] =@NumeroEnvases,    
  [NumeroTicketSAP] =@NumeroTicketSAP,    
  --[NumeroTicketSoftwareBalanza] =@NumeroTicketSoftwareBalanza,    
  [NumeroTransportista] =@NumeroTransportista,    
  [OrdenMovimientoBalanza] =@OrdenMovimientoBalanza,    
  [Pedido] =@Pedido,    
  [PesoBruto] =@PesoBruto,    
  [PesoNeto] =@PesoNeto,    
  [PesoNetoTeorico] =@PesoNetoTeorico,    
  [Placa] =@Placa,    
  [PosicionPedido] =@PosicionPedido,    
  [PrimeraPesada] =@PrimeraPesada,    
  [SegundaPesada] =@SegundaPesada,    
  [Solicitante] =@Solicitante,    
  [DestinatarioMercancia]=@DestinatarioMercancia,    
  [StatusSAP] =@StatusSAP,    
  [Tara] =@Tara,    
  [TaraEnvase] =@TaraEnvase,    
  [TaraTotalEnvase] =@TaraTotalEnvase,    
  [TextoCabecera] =@TextoCabecera,    
  [UsuarioPrimeraPesada] =@UsuarioPrimeraPesada,     
  [UsuarioSegundaPesada] =@UsuarioSegundaPesada,    
  [UsuarioActualizacion] =@Usuario,    
  [FechaHoraActualizacion] =GETDATE(),    
  [DescripcionOMB]=ISNULL(@DescripcionOMB,DescripcionOMB),    
  [NombreEmpresaTransp]=ISNULL(@NombreEmpresaTransp,NombreEmpresaTransp) ,  
  [PlacaCarreta] = @PlacaCarreta ,  
  ProveedorCompra =@ProveedorCompra  ,  
  TipoMovBalanza=  @TipoMovBalanza  ,  
  Referencia1 = @Referencia1    
 WHERE [IdTicket]=@IdTicket AND [NumeroTicketSoftwareBalanza] =@NumeroTicketSoftwareBalanza    
    
END    
GO
    

CREATE PROCEDURE [dbo].[usp_AnularTicket]	
(
	@IdTicket int,
	@NumeroTicketSoftwareBalanza bigint,
	@StatusSAP varchar(10), 
	@EstadoTicketSAP char(1), 
	@EstadoTicketSoftwareBalanza varchar(10), 
	@Usuario varchar(60),
	@UsuarioAnulacion varchar(20),
	@MensajeSAP varchar(300)
)
AS
BEGIN
	UPDATE TICKET
	set [StatusSAP] =@StatusSAP, 
	[EstadoTicketSAP] =@EstadoTicketSAP, 
	[EstadoTicketSoftwareBalanza] =@EstadoTicketSoftwareBalanza,
	[UsuarioAnulacion] = @UsuarioAnulacion, 
	[UsuarioActualizacion]=@Usuario,
	[MensajeSAP] =@MensajeSAP,
	[FechaHoraActualizacion]= GETDATE() 
	WHERE [IdTicket]=@IdTicket AND [NumeroTicketSoftwareBalanza] =@NumeroTicketSoftwareBalanza
END

GO

CREATE PROCEDURE [dbo].[usp_Correlativo]
(
	@Tabla Varchar(20)
)
AS
BEGIN
	DECLARE @CORRELATIVO BIGINT = 0

	IF NOT EXISTS(SELECT 1 FROM dbo.CORRELATIVO with(nolock) WHERE TIPO = @Tabla)
	BEGIN
		IF (@Tabla='LOGLLAMADAS')
		BEGIN
			SELECT @CORRELATIVO = IDENT_CURRENT(@Tabla) + IDENT_INCR(@Tabla)
		END
		ELSE IF (@Tabla='TICKET')
		BEGIN
			IF EXISTS (SELECT 1 FROM dbo.TICKET with(nolock))
			BEGIN
				SELECT @CORRELATIVO = isnull(MAX(NumeroTicketSoftwareBalanza),0)+1 FROM dbo.TICKET with(nolock)
			END
			ELSE
			BEGIN
			 SET @CORRELATIVO=1
			END
		END
		INSERT INTO dbo.CORRELATIVO(CORRELATIVO,TIPO) VALUES (@CORRELATIVO,@Tabla)
		SELECT @CORRELATIVO AS CORRELATIVO
	END
	ELSE
	BEGIN
		SELECT @CORRELATIVO = ISNULL(CORRELATIVO,0)+1 FROM dbo.CORRELATIVO with(nolock) WHERE TIPO = @Tabla

		IF(@Tabla='TICKET') BEGIN
			-- Jaime: Validacion preventiva error duplicidad de Numero de Ticket de Software
			DECLARE @NumeroTicketSoftTMP int
			
			IF EXISTS(SELECT 1 FROM dbo.TICKET with(nolock) where NumeroTicketSoftwareBalanza=@CORRELATIVO)
			BEGIN
					SET @NumeroTicketSoftTMP = @CORRELATIVO+1
				
				IF EXISTS(SELECT 1 FROM dbo.TICKET with(nolock) where NumeroTicketSoftwareBalanza=@NumeroTicketSoftTMP) 
				BEGIN
					SELECT @CORRELATIVO = isnull(MAX(NumeroTicketSoftwareBalanza),0)+1 FROM dbo.TICKET with(nolock) 
				END
				ELSE
				BEGIN
					SET @CORRELATIVO = @NumeroTicketSoftTMP
				END
			END  
			-- fin validacion
		END

		UPDATE dbo.CORRELATIVO SET CORRELATIVO=@CORRELATIVO WHERE TIPO = @Tabla
		SELECT @CORRELATIVO AS CORRELATIVO 
	END
END
GO

CREATE PROCEDURE  [dbo].[usp_GuardarTicket]    
(    
 @IdBalanza int,    
 @AlmacenDestino varchar(4),    
 @AlmacenOrigen varchar(4),    
 @Chofer varchar(40),    
 @CicloPesaje varchar(14),    
 @EstadoTicketSAP char(1),    
 @EstadoTicketSoftwareBalanza varchar(10),    
 @FechaHoraPrimeraPesada datetime,    
 @FormaCapturaPrimeraPesda char(1),    
 --@FechaHoraSegundaPesada datetime,    
 --@FormaCapturaSegundaPesada char(1),    
 @Material varchar(18),    
 @MensajeSAP varchar(300),    
 @NotaEntrega varchar(14),    
 @NumeroEnvases int=NULL,    
 @NumeroTicketSAP bigint=NULL,    
 @NumeroTicketSoftwareBalanza int,    
 @NumeroTransportista bigint=NULL,    
 @OrdenMovimientoBalanza bigint,    
 @Pedido bigint=NULL,    
 @PesoBruto int=NULL,    
 @PesoNeto bigint,    
 @PesoNetoTeorico int=NULL,    
 @Placa varchar(6),    
 @PosicionPedido int=NULL,    
 @PrimeraPesada int,    
 --@SegundaPesada int,    
 @Solicitante varchar(10),    
 @DestinatarioMercancia VARCHAR(10)=NULL,    
 @StatusSAP varchar(10),    
 @Tara int=NULL,    
 @TaraEnvase int=NULL,    
 @TaraTotalEnvase bigint=NULL,    
 @TextoCabecera varchar(25),    
 @UsuarioPrimeraPesada varchar(20),    
 --@UsuarioSegundaPesada varchar(20),    
 @Usuario varchar(60),    
 --@EstadoRegistro bit    
 @DescripcionOMB NVARCHAR(150),    
 @NombreEmpresaTransp NVARCHAR(150),    
 @PlacaCarreta VarChar(50),  
 @ProveedorCompra  VarChar(50),  
 @TipoMovBalanza  VarChar(50),  
 @Referencia1 VarChar(50),  
 @IdTicket INT  OUTPUT    
 
)     
AS    
BEGIN    
    
 -- Jaime: Validacion preventiva error duplicidad de Numero de Ticket de Software    
 DECLARE @NumeroTicketSoftTMP int    
     
 IF EXISTS(SELECT 1 FROM dbo.TICKET with(nolock) where NumeroTicketSoftwareBalanza=@NumeroTicketSoftwareBalanza)    
 BEGIN    
  SELECT @NumeroTicketSoftTMP=CORRELATIVO FROM CORRELATIVO with(nolock) WHERE TIPO = 'TICKET'    
  IF(@NumeroTicketSoftTMP = @NumeroTicketSoftwareBalanza)     
  BEGIN    
   SET @NumeroTicketSoftTMP = @NumeroTicketSoftTMP+1    
  END    
      
  IF EXISTS(SELECT 1 FROM dbo.TICKET with(nolock) where NumeroTicketSoftwareBalanza=@NumeroTicketSoftTMP)     
  BEGIN    
   SELECT @NumeroTicketSoftwareBalanza = isnull(MAX(NumeroTicketSoftwareBalanza),0)+1 FROM dbo.TICKET with(nolock)     
  END    
  ELSE    
  BEGIN    
   SET @NumeroTicketSoftwareBalanza = @NumeroTicketSoftTMP    
  END    
      
  UPDATE dbo.CORRELATIVO SET CORRELATIVO=@NumeroTicketSoftwareBalanza WHERE TIPO = 'TICKET'    
 END      
 -- fin validacion    
    
 INSERT INTO dbo.TICKET    
 (    
  [IdBalanza],    
  [AlmacenDestino],    
  [AlmacenOrigen],    
  [Chofer] ,    
  [CicloPesaje],    
  [EstadoTicketSAP],    
  [EstadoTicketSoftwareBalanza],    
  [FechaHoraPrimeraPesada],    
  [FormaCapturaPrimeraPesada],    
  --[FechaHoraSegundaPesada],    
  --[FormaCapturaSegundaPesada],    
  [Material],    
  [MensajeSAP],    
  [NotaEntrega],    
  [NumeroEnvases],    
  [NumeroTicketSAP],    
  [NumeroTicketSoftwareBalanza],    
  [NumeroTransportista],    
  [OrdenMovimientoBalanza],    
  [Pedido],    
  [PesoBruto],    
  [PesoNeto],    
  [PesoNetoTeorico],    
  [Placa],    
  [PosicionPedido],    
  [PrimeraPesada],    
  --[SegundaPesada],    
  [Solicitante],    
    
  [DestinatarioMercancia],    
    
  [StatusSAP],    
  [Tara],    
  [TaraEnvase],    
  [TaraTotalEnvase],    
  [TextoCabecera],    
  [UsuarioPrimeraPesada],    
  --[UsuarioSegundaPesada],    
  [UsuarioCreacion],    
  [FechaHoraCreacion],    
  [EstadoRegistro],    
  [DescripcionOMB],    
  [NombreEmpresaTransp],    
  PlacaCarreta ,  
  ProveedorCompra  ,  
  TipoMovBalanza  ,  
  Referencia1   
 )    
 values    
 (    
  @IdBalanza,    
  @AlmacenDestino,    
  @AlmacenOrigen,    
  @Chofer,    
  @CicloPesaje,    
  @EstadoTicketSAP,    
  @EstadoTicketSoftwareBalanza,    
  @FechaHoraPrimeraPesada,    
  @FormaCapturaPrimeraPesda,    
  --@FechaHoraSegundaPesada,    
  --@FormaCapturaSegundaPesada,    
  @Material,    
  @MensajeSAP,    
  @NotaEntrega,    
  @NumeroEnvases,    
  @NumeroTicketSAP,    
  @NumeroTicketSoftwareBalanza,    
  @NumeroTransportista,    
  @OrdenMovimientoBalanza,    
  @Pedido,    
  @PesoBruto,    
  @PesoNeto,    
  @PesoNetoTeorico,    
  @Placa,    
  @PosicionPedido,    
  @PrimeraPesada,    
  --@SegundaPesada,    
  @Solicitante,    
    
  @DestinatarioMercancia,    
      
  @StatusSAP,    
  @Tara,    
  @TaraEnvase,    
  @TaraTotalEnvase,    
  @TextoCabecera,    
  @UsuarioPrimeraPesada,    
  --@UsuarioSegundaPesada,    
  @Usuario,    
  GETDATE(),    
  1,    
  @DescripcionOMB,    
  @NombreEmpresaTransp  ,  
  @PlacaCarreta ,  
  @ProveedorCompra  ,  
  @TipoMovBalanza  ,  
  @Referencia1   
    
 )    
    
 SET @IdTicket = SCOPE_IDENTITY()    
    
END    
GO
    
CREATE PROCEDURE usp_InsertBalanza 
	(
		@NumeroBalanza int,
        @NombreBalanza varchar(100),
		@UsuarioInterface varchar(50),
        @Estado bit,
        @CuerposImpresionPrimeraPesada int,
        @CuerposImpresionSegundaPesada int,
        @Usuario varchar(60)
	)
	AS
	BEGIN
	
	INSERT INTO [TicketBalanzaDB].[dbo].[BALANZA]
           ([NumeroBalanza]
           ,[NombreBalanza]
		   ,[UsuarioInterface] 
           ,[EstadoRegistro]
           ,[Estado]
           ,[UsuarioCreacion]
           ,[FechaHoraCreacion]
           ,[CuerposImpresionPrimeraPesada]
           ,[CuerposImpresionSegundaPesada])
     VALUES
           (@NumeroBalanza,
            @NombreBalanza,
			@UsuarioInterface,
            1,
            @Estado,
            @Usuario,
            GETDATE(),
            @CuerposImpresionPrimeraPesada,
            @CuerposImpresionSegundaPesada)
	
	END

GO

CREATE  PROCEDURE [dbo].[usp_InsertLogMapa]
(
@IdTrace varchar(10),
@FechaInicio DATETIME,
@FechaFin DATETIME,
@DuracionMS INT,
@DuracionSeg decimal(6,2),
@IPLocal VARCHAR(30),
@Usuario VARCHAR(60),
@TipoLlamada VARCHAR(20),
@URL VARCHAR(500),
@JsonRequest text=null,
@JsonResponse text=null
)
AS
BEGIN
--ConfirmacionDeProceso, TipoEntrada,

 INSERT INTO LogLLamadas
            (IdTrace, 
             FechaHoraInicio, 
             FechaHoraFin, 
             Milisegundos, 
             Segundos, 
             IPLocal, 
             Usuario, 
             TipoLlamada, 
             URL, 
             JsonRequest, 
             JsonResponse,
             UsuarioCreacion, 
             FechaHoraCreacion, 
             EstadoRegistro)
VALUES     (@IdTrace,
			@FechaInicio,
			@FechaFin,
			@DuracionMS,
			@DuracionSeg,
			@IPLocal,
			@Usuario,
			@TipoLlamada,
			@URL,
			@JsonRequest,
			@JsonResponse,
			@Usuario,
            GETDATE(),
            1)
END
GO


 
CREATE PROCEDURE [dbo].[usp_InsertUsuario]     
 (    
  @NombreUsuario  varchar(20),    
        @Contrasena varchar(85),    
        @Estado bit,    
        @IdRol varchar(50),    
        @Usuario varchar(60)    
 )    
 AS    
 BEGIN    
     
 DECLARE @IdUsuario int,    
   @EstReg varchar(4),    
   @count int=0,    
   @iRol int    
 DECLARE C_RolesUsuario CURSOR FOR     
 select splitdata FROM dbo.f_Split(@IdRol,',')    
     
  INSERT INTO [TicketBalanzaDB].[dbo].[USUARIO]    
           (NombreUsuario    
           ,Contrasena    
           ,UsuarioCreacion    
           ,FechaHoraCreacion    
           ,EstadoRegistro    
           ,Estado)    
  VALUES    
  (@NombreUsuario,    
   @Contrasena,    
   @Usuario,    
   GETDATE(),    
   1,    
   @Estado)    
       
  SET @IdUsuario=SCOPE_IDENTITY()    
      
  OPEN C_RolesUsuario    
      
  FETCH NEXT FROM C_RolesUsuario INTO @EstReg    
      
  WHILE @@FETCH_STATUS = 0    
  BEGIN    
   set @count = @count+1    
      
   if (@count=1)    
   begin    
    set @iRol=1    
      INSERT INTO [TicketBalanzaDB].[dbo].[ROLUSUARIO]    
       (IdUsuario    
       ,IdRol    
       ,UsuarioCreacion    
       ,FechaHoraCreacion    
       ,EstadoRegistro)    
    VALUES    
       (@IdUsuario,    
     @iRol,    
     @Usuario,    
     GETDATE(),    
     @EstReg)    
   end    
   else if (@count=2)    
   begin    
    set @iRol=2     
    INSERT INTO [TicketBalanzaDB].[dbo].[ROLUSUARIO]    
       (IdUsuario    
       ,IdRol    
       ,UsuarioCreacion    
       ,FechaHoraCreacion    
       ,EstadoRegistro)    
    VALUES    
       (@IdUsuario,    
     @iRol,    
     @Usuario,    
     GETDATE(),    
     @EstReg)    
   end    
   else if (@count=3)    
   begin    
    set @iRol=4    
    INSERT INTO [TicketBalanzaDB].[dbo].[ROLUSUARIO]    
       (IdUsuario    
       ,IdRol    
       ,UsuarioCreacion    
       ,FechaHoraCreacion    
       ,EstadoRegistro)    
    VALUES    
       (@IdUsuario,    
     @iRol,    
     @Usuario,    
     GETDATE(),    
     @EstReg)    
   end    
   FETCH NEXT FROM C_RolesUsuario INTO @EstReg    
  END    
  close C_RolesUsuario    
  deallocate C_RolesUsuario    
 END    
  
GO

CREATE PROCEDURE [dbo].[usp_ListBalanza]
	(
	 @IdBalanza int,
	 @NumeroBalanza int,
     @NombreBalanza varchar(100),
     @IdEstado VARCHAR(2)
	)
	AS
	BEGIN
		IF (@IdEstado='-1')
	  BEGIN
		SELECT B.IdBalanza
		  ,B.NumeroBalanza
		  ,B.NombreBalanza
		  ,B.UsuarioInterface
		  ,B.EstadoRegistro
		  ,B.Estado
		  ,B.UsuarioCreacion
		  ,B.FechaHoraCreacion
		  ,B.UsuarioActualizacion
		  ,B.FechaHoraActualizacion
		  ,B.CuerposImpresionPrimeraPesada
		  ,B.CuerposImpresionSegundaPesada
		  ,DC.Descripcion AS DescripcionEstado
		FROM [TicketBalanzaDB].[dbo].[BALANZA] B  with(nolock) 
		INNER JOIN dbo.DETALLECATALOGO DC with(nolock)  ON DC.Val1=B.Estado  
		INNER JOIN dbo.CATALOGOTABLAS CT  with(nolock) ON CT.IdCatalogo=DC.IdCatalogo AND CT.Codigo=DC.Codigo
		WHERE B.EstadoRegistro=1 AND CT.CodigoTabla='01' AND DC.Label='IdEstado' AND (@IdBalanza=0 OR B.IdBalanza=@IdBalanza)
		AND (@NumeroBalanza=0 OR B.NumeroBalanza=@NumeroBalanza)
		AND B.NombreBalanza LIKE '%' + @NombreBalanza + '%'
		order by B.NumeroBalanza  
	  END
	  ELSE
	  BEGIN
		 SELECT B.IdBalanza
		  ,B.NumeroBalanza
		  ,B.NombreBalanza
		  ,B.UsuarioInterface
		  ,B.EstadoRegistro
		  ,B.Estado
		  ,B.UsuarioCreacion
		  ,B.FechaHoraCreacion
		  ,B.UsuarioActualizacion
		  ,B.FechaHoraActualizacion
		  ,B.CuerposImpresionPrimeraPesada
		  ,B.CuerposImpresionSegundaPesada
		  ,DC.Descripcion AS DescripcionEstado
		FROM [TicketBalanzaDB].[dbo].[BALANZA] B with(nolock)   
		INNER JOIN dbo.DETALLECATALOGO DC with(nolock)  ON DC.Val1=B.Estado  
		INNER JOIN dbo.CATALOGOTABLAS CT with(nolock)  ON CT.IdCatalogo=DC.IdCatalogo AND CT.Codigo=DC.Codigo
		WHERE B.EstadoRegistro=1 AND CT.CodigoTabla='01' AND DC.Label='IdEstado' AND (@IdBalanza=0 OR B.IdBalanza=@IdBalanza)
		AND (@NumeroBalanza=0 OR B.NumeroBalanza=@NumeroBalanza)
		AND (B.Estado=@IdEstado) AND B.NombreBalanza LIKE '%' + @NombreBalanza + '%'
		order by B.NumeroBalanza 
	  END
	  
	END

GO

CREATE PROCEDURE usp_ListCatalogo
(
	@NombreTabla varchar(50),
	@Campo varchar(50),
	@FlagEmpresa varchar(20)=NULL
)
AS
BEGIN

	SELECT DC.Val1 as Codigo,DC.Descripcion  
	FROM  dbo.DETALLECATALOGO DC with(nolock) 
	INNER JOIN dbo.CATALOGOTABLAS CT with(nolock) ON CT.IdCatalogo=DC.IdCatalogo AND CT.Codigo=DC.Codigo
	WHERE  CT.Nombre=@NombreTabla AND DC.Label=@Campo and (@FlagEmpresa IS NULL OR DC.Val2=@FlagEmpresa);

END
GO

CREATE PROCEDURE [dbo].[usp_ListEstado]
--(
-- @CodigoTabla varchar(30)='',
-- @Campo varchar(50)=''
--)
AS
BEGIN
  select J.Codigo,J.Descripcion  from 
  (SELECT 1 as orden, '-1' as Codigo,'Todos' as Descripcion
  UNION
  select RANK() over(order by DC.Val1 )+1 as orden , DC.Val1 AS Codigo, DC.Descripcion      
  FROM dbo.DETALLECATALOGO DC with(nolock)
  INNER JOIN dbo.CATALOGOTABLAS CT with(nolock) ON CT.IdCatalogo=DC.IdCatalogo AND CT.Codigo=DC.Codigo
  WHERE CT.CodigoTabla='01' AND DC.Label='IdEstado') J
   order by orden 
  --WHERE  (@CodigoTabla='' OR CT.CodigoTabla=@CodigoTabla) AND (@Campo='' and DC.Label=@Campo) 
END 

GO

CREATE PROCEDURE [dbo].[usp_ListMenuOpcion]
			AS
			BEGIN
			 SELECT IdMenuOpcion,IdPadre,Nombre,FormName,EstadoRegistro FROM MENUOPCION with(nolock)
			END
GO

CREATE PROCEDURE [dbo].[usp_ListPermisoUsuario](@IdUsuario int)
 AS
 BEGIN
 
	 SELECT MIN(PR.IdRol) as IdRol,PR.IdPermiso,P.NombrePermiso,ru.EstadoRegistro   
	 FROM dbo.USUARIO U with(nolock)
	 INNER JOIN dbo.ROLUSUARIO RU with(nolock) ON RU.IdUsuario=U.IdUsuario    
	 INNER JOIN dbo.PERMISOROL PR with(nolock) ON PR.IdRol=RU.IdRol
	 INNER JOIN dbo.PERMISO P with(nolock) ON P.IdPermiso=PR.IdPermiso   
	 WHERE U.IdUsuario=@IdUsuario and RU.EstadoRegistro=1
	 GROUP BY PR.IdPermiso,P.NombrePermiso,ru.EstadoRegistro   
 
 END
GO

CREATE PROCEDURE [dbo].[usp_ListRol]
AS

BEGIN 
 SELECT 0 as IdRol,'Todos' as NombreRol
 UNION
 SELECT IdRol,NombreRol FROM dbo.ROL with(nolock)
END
GO

  
CREATE PROCEDURE [dbo].[usp_ListTicketBalanza]     
(    
 @IdTicket int,    
 @NumeroBalanza int,    
 @NombreBalanza varchar(100),    
 @NumeroTicketSoftwareBalanza bigint,    
 @NumeroTicketSAP bigint,    
 @OMB bigint,    
 @StatusSAP varchar(10),    
 @Placa varchar(6),    
 @FechaProcesoIni Datetime=null,    
 @FechaProcesoFin Datetime=null,    
 @EstadoTicketSoftwareBalanza varchar(10)    
)    
AS    
BEGIN    
  SELECT     
      TMP.IdTicket,    
      TMP.IdBalanza,      
      TMP.NumeroBalanza,    
      TMP.NombreBalanza,    
      TMP.NumeroTicketSoftwareBalanza,    
      TMP.EstadoTicketSoftwareBalanza,    
      TMP.NumeroTicketSAP,    
      TMP.EstadoTicketSAP,    
      TMP.StatusSAP,    
      TMP.MensajeSAP,    
      TMP.OrdenMovimientoBalanza,    
      TMP.Placa,    
      TMP.CicloPesaje,    
      TMP.FechaHoraPrimeraPesada,    
      TMP.FechaHoraSegundaPesada,    
      TMP.FormaCapturaPrimeraPesada,    
      TMP.FormaCapturaSegundaPesada,      
      TMP.PrimeraPesada,    
      TMP.SegundaPesada,    
      TMP.PesoNeto,    
      TMP.Pedido,    
      TMP.PosicionPedido,     
      TMP.Material,    
      TMP.AlmacenOrigen,     
      TMP.AlmacenDestino,    
      TMP.Solicitante,    
      TMP.DestinatarioMercancia,     
      TMP.NotaEntrega,     
      TMP.TextoCabecera,    
      TMP.Chofer,    
      TMP.NumeroTransportista,     
      TMP.PesoBruto,    
      TMP.Tara,    
      TMP.PesoNetoTeorico,    
      TMP.TaraEnvase,    
      TMP.NumeroEnvases,    
      TMP.TaraTotalEnvase,    
      TMP.UsuarioPrimeraPesada,    
      TMP.UsuarioSegundaPesada,    
      TMP.EstadoRegistro,    
      TMP.DescripcionOMB,    
      TMP.NombreEmpresaTransp,    
      TMP.UsuarioAnulacion,  
      TMP.PlacaCarreta  ,  
   TMP.ProveedorCompra   ,  
   TMP.TipoMovBalanza  ,  
   TMP.Referencia1     
           
  FROM    
  (SELECT     
      -- Datos para Pool de Tickes y Anulacion    
      T.IdTicket,    
      T.IdBalanza,      
      B.NumeroBalanza,    
      B.NombreBalanza,    
      T.NumeroTicketSoftwareBalanza,    
      T.EstadoTicketSoftwareBalanza,    
      T.NumeroTicketSAP,    
      T.EstadoTicketSAP,    
      T.StatusSAP,    
      T.MensajeSAP,    
      T.OrdenMovimientoBalanza,    
      T.Placa,    
      T.CicloPesaje,    
      T.FechaHoraPrimeraPesada,    
      --CONVERT(VARCHAR(10),T.FechaHoraPrimeraPesada,103) AS Fecha1raPesada,    
      --CONVERT(VARCHAR(10),T.FechaHoraPrimeraPesada,108) AS Hora1raPesada,    
      T.FechaHoraSegundaPesada,    
      --CONVERT(VARCHAR(10),T.FechaHoraSegundaPesada,103) AS Fecha2daPesada,    
      --CONVERT(VARCHAR(10),T.FechaHoraSegundaPesada,108) AS Hora2daPesada,    
      ISNULL(T.FormaCapturaPrimeraPesada,'') AS FormaCapturaPrimeraPesada,    
      ISNULL(T.FormaCapturaSegundaPesada,'') AS FormaCapturaSegundaPesada,      
      T.PrimeraPesada,    
      T.SegundaPesada,    
      T.PesoNeto,    
      -- Datos para pantalla de pesaje    
      T.Pedido,    
      T.PosicionPedido,     
      T.Material,    
      T.AlmacenOrigen,     
      T.AlmacenDestino,    
      T.Solicitante,    
      T.DestinatarioMercancia,     
      T.NotaEntrega,     
      T.TextoCabecera,    
      T.Chofer,    
      T.NumeroTransportista,     
      T.PesoBruto,    
      T.Tara,    
      T.PesoNetoTeorico,    
      T.TaraEnvase,    
      T.NumeroEnvases,    
      T.TaraTotalEnvase,    
      T.UsuarioPrimeraPesada,    
      T.UsuarioSegundaPesada,    
      T.EstadoRegistro,    
      CASE WHEN T.FechaHoraSegundaPesada IS NOT NULL THEN CONVERT(DATETIME,CONVERT(VARCHAR(10),T.FechaHoraSegundaPesada,103),103) ELSE CONVERT(DATETIME,CONVERT(VARCHAR(10),T.FechaHoraPrimeraPesada,103),103) END AS FechaProceso,    
      T.DescripcionOMB,    
      T.NombreEmpresaTransp,    
      T.UsuarioAnulacion  ,  
      T.PlacaCarreta ,  
  T.ProveedorCompra   ,  
  T.TipoMovBalanza  ,  
  T.Referencia1     
  FROM dbo.TICKET T with(nolock)     
  INNER JOIN dbo.BALANZA B with(nolock) ON B.IdBalanza=T.IdBalanza      
  WHERE (@IdTicket=0 OR T.IdTicket=@IdTicket) AND (@NumeroBalanza=0 OR B.NumeroBalanza=@NumeroBalanza) AND    
  (@NumeroTicketSoftwareBalanza=0 OR T.NumeroTicketSoftwareBalanza=@NumeroTicketSoftwareBalanza) AND    
  (@NumeroTicketSAP=0 OR T.NumeroTicketSAP=@NumeroTicketSAP) AND     
  (@OMB=0 OR T.OrdenMovimientoBalanza=@OMB) AND (@EstadoTicketSoftwareBalanza='' OR T.EstadoTicketSoftwareBalanza=@EstadoTicketSoftwareBalanza) AND    
  (@Placa='' OR T.Placa=@Placa) AND    
  (@StatusSAP='Todas' OR T.StatusSAP=@StatusSAP) AND    
  (B.NombreBalanza LIKE '%' + @NombreBalanza + '%')) TMP    
  WHERE ((@FechaProcesoIni IS NULL OR TMP.FechaProceso>= @FechaProcesoIni) AND (@FechaProcesoFin IS NULL OR TMP.FechaProceso<=@FechaProcesoFin) )    
     
END    
GO

CREATE PROCEDURE [dbo].[usp_ListUsuario]
	(
	 @IdUsuario int,
	 @NombreUsuario varchar(20),
	 @IdRol int,
	 @IdEstado varchar(2) 
	)
	AS
	BEGIN
	  IF (@IdEstado='-1')
	  BEGIN
		  SELECT distinct U.IdUsuario
			  ,U.NombreUsuario
			  ,U.Contrasena
			  ,U.UsuarioCreacion
			  ,U.FechaHoraCreacion
			  ,U.UsuarioActualizacion
			  ,U.FechaHoraActualizacion
			  ,U.EstadoRegistro
			  ,U.Estado AS IdEstado
			  ,DC.Descripcion AS DescripcionEstado
			  ,dbo.f_RolesUsuario(1,U.IdUsuario) as IdRol 
			  ,dbo.f_RolesUsuario(2,U.IdUsuario) AS DescripcionRol  
		  FROM dbo.USUARIO U with(nolock)
		  INNER JOIN dbo.ROLUSUARIO RU with(nolock) ON RU.IdUsuario=U.IdUsuario
		  INNER JOIN dbo.ROL R with(nolock) ON R.IdRol=RU.IdRol    
		  INNER JOIN dbo.DETALLECATALOGO DC with(nolock) ON DC.Val1=U.Estado  
		  INNER JOIN dbo.CATALOGOTABLAS CT with(nolock) ON CT.IdCatalogo=DC.IdCatalogo AND CT.Codigo=DC.Codigo
		  WHERE U.EstadoRegistro=1 AND RU.EstadoRegistro=1 AND CT.CodigoTabla='01' AND DC.Label='IdEstado' AND (@IdUsuario=0 OR U.IdUsuario=@IdUsuario)
		  AND (@IdRol=0 OR RU.IdRol=@IdRol)
		  AND U.NombreUsuario LIKE '%' + @NombreUsuario + '%'
		  --order by U.NombreUsuario
		END
		ELSE
		BEGIN
		 SELECT distinct U.IdUsuario
			  ,U.NombreUsuario
			  ,U.Contrasena
			  ,U.UsuarioCreacion
			  ,U.FechaHoraCreacion
			  ,U.UsuarioActualizacion
			  ,U.FechaHoraActualizacion
			  ,U.EstadoRegistro
			  ,U.Estado AS IdEstado
			  ,DC.Descripcion AS DescripcionEstado
			  ,dbo.f_RolesUsuario(1,U.IdUsuario) as IdRol 
			  ,dbo.f_RolesUsuario(2,U.IdUsuario) AS DescripcionRol  
		  FROM dbo.USUARIO U with(nolock)
		  INNER JOIN dbo.ROLUSUARIO RU with(nolock) ON RU.IdUsuario=U.IdUsuario
		  INNER JOIN dbo.ROL R with(nolock) ON R.IdRol=RU.IdRol    
		  INNER JOIN dbo.DETALLECATALOGO DC with(nolock) ON DC.Val1=U.Estado  
		  INNER JOIN dbo.CATALOGOTABLAS CT with(nolock) ON CT.IdCatalogo=DC.IdCatalogo AND CT.Codigo=DC.Codigo
		  WHERE U.EstadoRegistro=1 AND RU.EstadoRegistro=1 AND CT.CodigoTabla='01' AND DC.Label='IdEstado' AND (@IdUsuario=0 OR U.IdUsuario=@IdUsuario)
		  AND (@IdRol=0 OR RU.IdRol=@IdRol)
		  AND (U.Estado=@IdEstado) AND U.NombreUsuario LIKE '%' + @NombreUsuario + '%'
		  --order by U.NombreUsuario
		END 
	END

GO

CREATE PROCEDURE usp_UpdateBalanza
	(
	 @IdBalanza int,
	 @NumeroBalanza int,
     @NombreBalanza varchar(100),
	 @UsuarioInterface varchar(50),
     @Estado bit,
     @CuerposImpresionPrimeraPesada int,
     @CuerposImpresionSegundaPesada int,
     @Usuario varchar(60),
     @EstadoRegistro bit
	)
	AS
	BEGIN

		UPDATE [TicketBalanzaDB].[dbo].[BALANZA]
		   SET [NumeroBalanza] = @NumeroBalanza
			  ,[NombreBalanza] = @NombreBalanza
			  ,[EstadoRegistro] = @EstadoRegistro
			  ,[UsuarioInterface] = @UsuarioInterface
			  ,[Estado] = @Estado
			  ,[UsuarioActualizacion] = @Usuario
			  ,[FechaHoraActualizacion] = GETDATE()
			  ,[CuerposImpresionPrimeraPesada] = @CuerposImpresionPrimeraPesada
			  ,[CuerposImpresionSegundaPesada] = @CuerposImpresionSegundaPesada
		 WHERE IdBalanza=@IdBalanza
		 
	END

GO

CREATE PROCEDURE dbo.usp_UpdateParametros
(
	@Tabla varchar(50),
	@Campo varchar(50),
	@Valor varchar(400),
	@Usuario varchar(60),
	@FlagEmpresa varchar(20)=NULL
)
AS
BEGIN
	
	UPDATE B SET B.Val1=@Valor,
	B.UsuarioActualizacion=@Usuario,
	B.FechaHoraActualizacion=GETDATE()    
	FROM dbo.CATALOGOTABLAS A
	INNER JOIN dbo.DETALLECATALOGO B ON B.IdCatalogo=A.IdCatalogo AND B.Codigo=A.Codigo     
	where A.Nombre=@Tabla and B.Label=@Campo and (@FlagEmpresa IS NULL OR B.Val2=@FlagEmpresa);
	 
END

GO

  
    
CREATE PROCEDURE [dbo].[usp_UpdateUsuario]    
 (    
  @IdUsuario int,    
  @NombreUsuario varchar(20),    
  @Contrasena varchar(85),    
  @IdRol varchar(50),    
  @Estado bit,    
  @Usuario varchar(60),    
  @EstadoRegistro bit     
 )    
 AS    
 BEGIN    
  DECLARE @EstReg varchar(4),    
    @count int=0,    
    @iRol int    
  DECLARE C_RolesUsuario CURSOR FOR     
  select splitdata FROM dbo.f_Split(@IdRol,',')    
    
    UPDATE dbo.USUARIO    
    SET NombreUsuario = @NombreUsuario,    
     Contrasena = @Contrasena,    
     UsuarioActualizacion =@Usuario ,    
     FechaHoraActualizacion =GETDATE() ,    
     EstadoRegistro =@EstadoRegistro ,     
     Estado =@Estado     
    WHERE IdUsuario = @IdUsuario    
     
     OPEN C_RolesUsuario    
      
  FETCH NEXT FROM C_RolesUsuario INTO @EstReg    
      
  WHILE @@FETCH_STATUS = 0    
  BEGIN    
   set @count = @count+1    
      
   if (@count=1)    
   begin    
    set @iRol=1    
    UPDATE dbo.ROLUSUARIO    
    SET UsuarioActualizacion =@Usuario ,    
     FechaHoraActualizacion =GETDATE(),    
     EstadoRegistro =@EstReg     
    WHERE IdUsuario = @IdUsuario and IdRol=@iRol    
        
   end    
   else if (@count=2)    
   begin    
    set @iRol=2     
    UPDATE dbo.ROLUSUARIO    
    SET UsuarioActualizacion =@Usuario ,    
     FechaHoraActualizacion =GETDATE(),    
     EstadoRegistro =@EstReg     
    WHERE IdUsuario = @IdUsuario and IdRol=@iRol     
        
   end    
     
   else if (@count=3)    
   begin    
    set @iRol=4    
    UPDATE dbo.ROLUSUARIO    
    SET UsuarioActualizacion =@Usuario ,    
     FechaHoraActualizacion =GETDATE(),    
     EstadoRegistro =@EstReg     
    WHERE IdUsuario = @IdUsuario and IdRol=@iRol     
        
   end    
   FETCH NEXT FROM C_RolesUsuario INTO @EstReg    
  END    
  close C_RolesUsuario    
  deallocate C_RolesUsuario    
    
 END      
GO

CREATE PROCEDURE [dbo].[usp_ValidarUsuario]
(
	@Usuario varchar(20)--,
	--@Clave varchar(20)
)
AS
BEGIN
	
	SELECT IdUsuario,NombreUsuario,Contrasena,Estado FROM dbo.USUARIO with(nolock)
	WHERE Estado=1 AND  NombreUsuario=@Usuario AND Contrasena is not null   
	
END


GO

CREATE FUNCTION [dbo].[f_CorrelativoTicketBalanza]() Returns int
	AS
	BEGIN
	
	declare @Correlativo int=-1;
	
	IF EXISTS( select 1 from dbo.CORRELATIVO with(nolock) WHERE TIPO='TICKET' )
	BEGIN
		select @Correlativo = isnull(max(CORRELATIVO),0)+1  
	    from dbo.CORRELATIVO with(nolock) WHERE TIPO='TICKET'
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM dbo.TICKET with(nolock))
		BEGIN
			SELECT @CORRELATIVO = isnull(MAX(NumeroTicketSoftwareBalanza),0)+1 FROM dbo.TICKET with(nolock)
		END
		ELSE
		BEGIN
		 SET @CORRELATIVO=1
		END
	END

	 
	RETURN @Correlativo
	END

GO

  

CREATE FUNCTION [dbo].[f_Split] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata NVARCHAR(MAX) 
) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
    RETURN 
END
GO

CREATE FUNCTION [dbo].[f_ValidarBalanza]
(
	@IdBalanza int=NULL,
	@NumeroBalanza int,
    @NombreBalanza varchar(100)
) 
Returns int
	AS
	BEGIN
	
	declare @Contador int=0;
	
	if(@IdBalanza is null)
	begin
	 SELECT @Contador=count(1) FROM dbo.BALANZA with(nolock) WHERE NumeroBalanza=@NumeroBalanza OR NombreBalanza=@NombreBalanza
	end
	else
	begin
	 SELECT @Contador=count(1) FROM dbo.BALANZA with(nolock) WHERE IdBalanza<>@IdBalanza AND (NumeroBalanza=@NumeroBalanza OR NombreBalanza=@NombreBalanza)
	end  
	 
	RETURN @Contador
	END
GO

CREATE FUNCTION [dbo].[f_ValidarUsuario]
(
	@IdUsuario int=NULL,
	@NombreUsuario varchar(20)
) 
Returns int
	AS
	BEGIN
	
	declare @Contador int=0;
	
	if(@IdUsuario is null)
	begin
	 SELECT @Contador=count(1) FROM dbo.USUARIO with(nolock) WHERE NombreUsuario=@NombreUsuario
	end
	else
	begin
	 SELECT @Contador=count(1) FROM dbo.USUARIO with(nolock) WHERE IdUsuario<>@IdUsuario AND NombreUsuario=@NombreUsuario
	end  
	 
	RETURN @Contador
	END
GO



 
INSERT [dbo].[CATALOGOTABLAS] ([Codigo], [Nombre], [Descripcion], [CodigoTabla], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (N'0001', N'Estado', N'Contiene los Estado de una Entidad', N'01', N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (1, N'0001', N'IdEstado', N'Activo', N'CodEstado', N'1', N'', N'', N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (1, N'0001', N'IdEstado', N'Inactivo', N'CodEstado', N'0', N'', N'', N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[CATALOGOTABLAS] ( [Codigo], [Nombre], [Descripcion], [CodigoTabla], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES ( N'0002', N'CicloPesaje', N'Almacena los ciclos de pesaje de un ticket balanza', N'02', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (2, N'0002', N'IdCicloPesaje', N'PRIMERA PESADA', N'CicloPesaje', N'PRIMERA PESADA', N'', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (2, N'0002', N'IdCicloPesaje', N'SEGUNDA PESADA', N'CicloPesaje', N'SEGUNDA PESADA', N'', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[CATALOGOTABLAS] ( [Codigo], [Nombre], [Descripcion], [CodigoTabla], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES ( N'0003', N'EstadoTicketSoftwareBalanza', N'Almacena los estados del softwarebalanza de un ticket balanza', N'03', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (3, N'0003', N'IdEstadoTicketSoftBalanza', N'En Proceso', N'EstadoTicketSoft', N'En Proceso', N'', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (3, N'0003', N'IdEstadoTicketSoftBalanza', N'Terminado', N'EstadoTicketSoft', N'Terminado', N'', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (3, N'0003', N'IdEstadoTicketSoftBalanza', N'Anulado', N'EstadoTicketSoft', N'Anulado', N'', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[CATALOGOTABLAS] ( [Codigo], [Nombre], [Descripcion], [CodigoTabla], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (N'0004', N'StatusSAP', N'Almacena los statusSAP de un ticket balanza', N'04', N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (4, N'0004', N'IdStatusSAP', N'Todas', N'StatusSAP', N'Todas', N'', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (4, N'0004', N'IdStatusSAP', N'Pendiente', N'StatusSAP', N'Pendiente', N'', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (4, N'0004', N'IdStatusSAP', N'En Proceso', N'StatusSAP', N'En Proceso', N'', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (4, N'0004', N'IdStatusSAP', N'Terminado', N'StatusSAP', N'Terminado', N'', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (4, N'0004', N'IdStatusSAP', N'Anulado', N'StatusSAP', N'Anulado', N'', N'', N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[CATALOGOTABLAS] ( [Codigo], [Nombre], [Descripcion], [CodigoTabla], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (N'0005', N'Parametros', N'Almacena los parametros de softwarebalanza', N'05', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
GO
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'Impresora', N'Nombre de Impresora', N'Impresora', N'', N'', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'RutaSoftwarePesaje', N'Ruta de Soft Pesaje', N'RutaSoftwarePesaje', N'D:\Captura\Captura.exe', N'', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'RutaArchivoPesaje', N'Ruta de Archivo Pesaje', N'RutaArchivoPesaje', N'D:\Captura\weight.txt', N'', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'TimeOutBrokerProcesarTicket', N'TimeOut respuesta procesar', N'TimeOutProcesar', N'10', N'', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'TimeOutBrokerAnularTicket', N'TimeOut respuesta anular', N'TimeOutAnular', N'10', N'', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'CantidadMaximaTickets', N'Cantidad tickets procesar masivamente', N'CantMaxTickets', N'10', N'', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'TiempoEsperaPesaje', N'Tiempo de espera para obtener pesaje', N'TiempoEsperaPesaje', N'10', N'', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'DesactivarEnviosSAP', N'Activa o desactiva los envios hacia SAP', N'DesactivarEnviosSAP', N'0', N'', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'IngresarServidor', N'Forzar Ingreso servidor para conexion', N'IngresarServidor', N'0', N'', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)

INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'urlProcesarTickets', N'Nomenclatura Url Procesar Tickets', N'urlProcesarTickets', N'http://[Servidor]/integracion/alicorp/ticketbalanza/procesar', N'ALICORP', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'urlAnularTickets', N'Nomenclatura Url Anular Tickets', N'urlAnularTickets', N'http://[Servidor]/integracion/alicorp/ticketbalanza/anular', N'ALICORP', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'IpServidorActual', N'Ip del sevidor actual', N'IpServidorActual', N'10.72.14.44:7105', N'ALICORP', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'urlProcesarTickets', N'Nomenclatura Url Procesar Tickets', N'urlProcesarTickets', N'http://[Servidor]/integracion/alicorp/ticketbalanzacbrava/procesar', N'CANABRAVA', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'urlAnularTickets', N'Nomenclatura Url Anular Tickets', N'urlAnularTickets', N'http://[Servidor]/integracion/alicorp/ticketbalanzacbrava/anular', N'CANABRAVA', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'IpServidorActual', N'Ip del sevidor actual', N'IpServidorActual', N'10.72.14.44:7105', N'CANABRAVA', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)


INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'urlProcesarTickets', N'Nomenclatura Url Procesar Tickets', N'urlProcesarTickets', N'http://[Servidor]/integracion/palmas/ticketbalanza/procesar', N'PALMAS', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'urlAnularTickets', N'Nomenclatura Url Anular Tickets', N'urlAnularTickets', N'http://[Servidor]/integracion/palmas/ticketbalanza/anular', N'PALMAS', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'IpServidorActual', N'Ip del sevidor actual', N'IpServidorActual', N'10.72.14.44', N'PALMAS', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)



INSERT [dbo].[DETALLECATALOGO] ([IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (5, N'0005', N'TipoPapel', N'Formato papel pra impresion', N'TipoPapel', N'TROQUELADA', N'', N'', N'SOFTBALANZA', GETDATE(),NULL, NULL, 1)

INSERT [dbo].[CATALOGOTABLAS] ( [Codigo], [Nombre], [Descripcion], [CodigoTabla], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (N'0006', N'ServidoresBroker', N'Almacena los Ips los servidores broker', N'06', N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)

INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'DEV', N'ServidoresBroker', N'10.72.14.43:7105', N'ALICORP', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'QAS', N'ServidoresBroker', N'10.72.14.44:7105', N'ALICORP', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'PRD', N'ServidoresBroker', N'10.72.14.40', N'ALICORP', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'CNT', N'ServidoresBroker', N'10.72.16.102', N'ALICORP', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'DEV', N'ServidoresBroker', N'10.72.14.43:7105', N'CANABRAVA', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'QAS', N'ServidoresBroker', N'10.72.14.44:7105', N'CANABRAVA', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'PRD', N'ServidoresBroker', N'10.72.14.40', N'CANABRAVA', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'CNT', N'ServidoresBroker', N'10.72.16.102', N'CANABRAVA', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)

INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'DEV', N'ServidoresBroker', N'10.72.14.43:7105', N'PALMAS', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'QAS', N'ServidoresBroker', N'10.72.14.44', N'PALMAS', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'PRD', N'ServidoresBroker', N'10.72.14.40', N'PALMAS', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)
INSERT [dbo].[DETALLECATALOGO] ( [IdCatalogo], [Codigo], [Label], [Descripcion], [Mnemonico], [Val1], [Val2], [Val3], [UsuarioCreacion], [FechaHoraCrecion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (6, N'0006', N'IdServidor', N'CNT', N'ServidoresBroker', N'10.72.16.102', N'PALMAS', N'', N'SOFTBALANZA', GETDATE(), NULL, NULL, 1)

INSERT INTO dbo.ROL (NombreRol, UsuarioCreacion, FechaHoraCreacion, UsuarioActualizacion, FechaHoraActualizacion, EstadoRegistro)
VALUES ('Administrador', 'SOFTBALANZA', getdate(), NULL, NULL, 1)
GO

INSERT INTO dbo.ROL (NombreRol, UsuarioCreacion, FechaHoraCreacion, UsuarioActualizacion, FechaHoraActualizacion, EstadoRegistro)
VALUES ('Balancero', 'SOFTBALANZA', getdate(), NULL, NULL, 1)
GO

INSERT INTO dbo.ROL (NombreRol, UsuarioCreacion, FechaHoraCreacion, UsuarioActualizacion, FechaHoraActualizacion, EstadoRegistro)
VALUES ('SuperAdministrador', 'SOFTBALANZA', getdate(), NULL, NULL, 1)
GO

INSERT INTO dbo.ROL (NombreRol, UsuarioCreacion, FechaHoraCreacion, UsuarioActualizacion, FechaHoraActualizacion, EstadoRegistro)
VALUES ('AdministradorPeso', 'SOFTBALANZA', getdate(), NULL, NULL, 1)
GO


INSERT INTO dbo.MENUOPCION (IdMenuOpcion, IdPadre, Nombre, FormName, EstadoRegistro)
VALUES (0, -1, 'Maestros', ' ', 1)
GO

INSERT INTO dbo.MENUOPCION (IdMenuOpcion, IdPadre, Nombre, FormName, EstadoRegistro)
VALUES (1, -1, 'Operaciones', ' ', 1)
GO

INSERT INTO dbo.MENUOPCION (IdMenuOpcion, IdPadre, Nombre, FormName, EstadoRegistro)
VALUES (2, 0, 'Maestro Balanza', 'ALICORP.TICKETBALANZA.Windows.MAESTROS.frmMaestroBalanza', 1)
GO

INSERT INTO dbo.MENUOPCION (IdMenuOpcion, IdPadre, Nombre, FormName, EstadoRegistro)
VALUES (3, 0, 'Maestro Usuario', 'ALICORP.TICKETBALANZA.Windows.MAESTROS.frmMaestroUsuario', 1)
GO

INSERT INTO dbo.MENUOPCION (IdMenuOpcion, IdPadre, Nombre, FormName, EstadoRegistro)
VALUES (4, 1, 'Pesaje', 'ALICORP.TICKETBALANZA.Windows.OPERACION.frmPesajeTicket', 1)
GO

INSERT INTO dbo.MENUOPCION (IdMenuOpcion, IdPadre, Nombre, FormName, EstadoRegistro)
VALUES (5, 1, 'Pool de Tickets', 'ALICORP.TICKETBALANZA.Windows.OPERACION.frmPoolTicket', 1)
GO

INSERT INTO dbo.MENUOPCION (IdMenuOpcion, IdPadre, Nombre, FormName, EstadoRegistro)
VALUES (6, 1, 'Anulación', 'ALICORP.TICKETBALANZA.Windows.OPERACION.frmAnulacionTicket', 1)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USUARIO]') AND type in (N'U'))

DECLARE @IDUSUARIO INT 

INSERT INTO dbo.USUARIO (NombreUsuario,Contrasena,UsuarioCreacion,FechaHoraCreacion,EstadoRegistro,Estado) VALUES('SOFTBALANZA','o14XCYELuc0=','SOFTBALANZA',GETDATE(),1,1)
SET @IDUSUARIO=SCOPE_IDENTITY()
INSERT INTO ROLUSUARIO(IdUsuario,IdRol,UsuarioCreacion,FechaHoraCreacion,EstadoRegistro)
VALUES(@IDUSUARIO,3,'SOFTBALANZA',GETDATE(),1)
GO
--Balancero





INSERT [dbo].[PERMISO] ([NombrePermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES ( N'Maestro Balanza', N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISO] ([NombrePermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES ( N'Maestro Usuario', N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISO] ([NombrePermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES ( N'Pesaje', N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISO] ([NombrePermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES ( N'Anulación', N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISO] ([NombrePermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES ( N'Pool de Tickets', N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)


INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (1, 2, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (1, 3, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (1, 4, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (1, 5, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (2, 3, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (2, 4, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (2, 5, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (3, 1, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (3, 2, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (3, 3, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (3, 4, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
INSERT [dbo].[PERMISOROL] ([IdRol], [IdPermiso], [UsuarioCreacion], [FechaHoraCreacion], [UsuarioActualizacion], [FechaHoraActualizacion], [EstadoRegistro]) VALUES (3, 5, N'SOFTBALANZA',GETDATE(), NULL, NULL, 1)
GO




IF OBJECT_ID ('ROLADMINPESO') IS NOT NULL
	DROP TABLE ROLADMINPESO
GO

CREATE TABLE ROLADMINPESO 
(
IdRoladminpeso int identity (1,1),
NombreEmpresa varchar(25),
AdmPes char(1),
UsuarioCreacion char(60),
FechaHoraCreacion datetime

)
GO



IF NOT  EXISTS (SELECT IDROL FROM ROL WHERE IDROL = 4) 
BEGIN
 INSERT INTO dbo.ROL (NombreRol, UsuarioCreacion, FechaHoraCreacion, UsuarioActualizacion, FechaHoraActualizacion, EstadoRegistro)
 VALUES ('AdministradorPeso', 'SOFTBALANZA', getdate(), NULL, NULL, 1)
END
GO



IF OBJECT_ID ('USP_GET_ADMPESAJE') IS NOT NULL
	DROP PROCEDURE dbo.USP_GET_ADMPESAJE
GO
CREATE PROCEDURE   dbo.USP_GET_ADMPESAJE  
(
@P_EMPRESA VARCHAR(20)
)
AS
BEGIN
select NombreEmpresa,AdmPes from ROLADMINPESO nolock where  AdmPes = 1 and nombreempresa = @P_EMPRESA
END
GO


IF NOT  EXISTS (SELECT NombreEmpresa  FROM dbo.ROLADMINPESO (nolock) WHERE NombreEmpresa = 'PALMAS') 
insert into ROLADMINPESO(NombreEmpresa,AdmPes,UsuarioCreacion,FechaHoraCreacion) values ('PALMAS',1,'SOFTBALANZA',CURRENT_TIMESTAMP)
GO




IF EXISTS (SELECT name FROM sysobjects WHERE name = 'f_RolesUsuario' AND type = 'FN') 
  DROP function [dbo].[f_RolesUsuario]
GO

CREATE FUNCTION dbo.f_RolesUsuario(@tipo int,@IdUsuario int) returns Varchar(400)    
 as    
 begin    
  DECLARE @IdRol int,    
          @NombreRol varchar(20),    
          @Roles varchar(400)='',    
          @count int=0 ,   
          @EstadoReg bit  ,
          @AcumIdRol varchar(20)=''
  DECLARE C_Roles CURSOR FOR    
  SELECT R.IdRol,R.NombreRol,RU.EstadoRegistro from ROLUSUARIO RU with(nolock)     
  INNER JOIN ROL R with(nolock) ON RU.IdRol=R.IdRol    
   WHERE RU.IdUsuario=@IdUsuario and RU.EstadoRegistro=1;    
-- WHERE RU.EstadoRegistro=1 AND RU.IdUsuario=@IdUsuario;    
      
      
  SELECT @count=COUNT(1) from ROLUSUARIO RU with(nolock)     
  INNER JOIN ROL R with(nolock) ON RU.IdRol=R.IdRol    
  WHERE  RU.IdUsuario=@IdUsuario   and RU.EstadoRegistro=1
  --WHERE RU.EstadoRegistro=1 AND RU.IdUsuario=@IdUsuario    
      
      
  OPEN C_Roles    
      
  FETCH NEXT FROM C_Roles INTO @IdRol,@NombreRol ,@EstadoReg   
  
  
     
  WHILE @@FETCH_STATUS=0    
  BEGIN    
   
   if(@tipo=1)    
   begin    
    if (@count>1)    
    begin    
     if (@IdRol=1) -- administrador    
     begin    
      set @Roles =  @Roles + str(@EstadoReg) + ','    
     SET @AcumIdRol = @AcumIdRol + ltrim(str(@IdRol))  + ',' 
     end    
     else if (@IdRol =2) -- balancero    
     begin    
      set @Roles =   @Roles + str(@EstadoReg) + ','   
        SET @AcumIdRol = @AcumIdRol + ltrim(str(@IdRol))  + ',' 
     end    
      else if (@IdRol =4) -- balancero    
     begin    
      set @Roles =  @Roles +  str(@EstadoReg) + ','  
       SET @AcumIdRol = @AcumIdRol + ltrim(str(@IdRol))  + ',' 
     end    
    end    
    else    
       begin    
        if (@IdRol =1) -- administrador    
     begin    
      set @Roles =  '1,0,0' + ','    
     end    
        else if (@IdRol =2) -- balancero    
     begin    
      set @Roles =  '0,1,0' + ','    
     end  
     ELSE  if (@IdRol =4) -- administrador de peso    
     begin    
      set @Roles =  '0,0,1' + ','    
     end      
     else    
     begin --superadm    
      set @Roles =  '0,0,0' + ','  + STR( @IdRol  )
     end    
    
       end    
        
   end    
   else if(@tipo=2)    
   begin    
    set @Roles =  @Roles + @NombreRol + ','    
   end    
   FETCH NEXT FROM C_Roles INTO @IdRol,@NombreRol , @EstadoReg  
  END 
    if(@tipo=1)
    begin
  if  @AcumIdRol = '1,' 
  begin 
   set @Roles ='1,0,0,'
  end  
   if  @AcumIdRol = '2,' 
  begin 
   set @Roles ='0,1,0,'
  end   
   if  @AcumIdRol = '4,' 
  begin 
   set @Roles ='0,0,1,'
  end  
   if  @AcumIdRol = '1,2,' 
  begin 
   set @Roles ='1,1,0,'
  end  
   if  @AcumIdRol = '1,2,4,' 
  begin 
   set @Roles ='1,1,1,'
  end  
   if  @AcumIdRol = '2,4,' 
  begin 
   set @Roles ='0,1,1,'
  end  
   if  @AcumIdRol = '1,4,' 
  begin 
   set @Roles ='1,0,1,'
  end  
  end
  close C_Roles    
  deallocate C_Roles    
    
  SET @Roles = SUBSTRING(@Roles,1,len(@Roles)-1)    
  return @Roles        
 end    
  
GO
