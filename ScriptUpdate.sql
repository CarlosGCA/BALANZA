

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



IF NOT  EXISTS (SELECT IdPermiso  FROM dbo.PERMISOROL WHERE IDROL = 4) 
BEGIN
insert into dbo.PERMISOROL (idrol,idpermiso,usuariocreacion,fechahoracreacion,usuarioactualizacion,fechahoraActualizacion,EstadoRegistro) 
values (4,3,'SOFTBALANZA',CURRENT_TIMESTAMP,null,null,1)

insert into dbo.PERMISOROL (idrol,idpermiso,usuariocreacion,fechahoracreacion,usuarioactualizacion,fechahoraActualizacion,EstadoRegistro) 
values (4,4,'SOFTBALANZA',CURRENT_TIMESTAMP,null,null,1)

insert into dbo.PERMISOROL (idrol,idpermiso,usuariocreacion,fechahoracreacion,usuarioactualizacion,fechahoraActualizacion,EstadoRegistro) 
values (4,5,'SOFTBALANZA',CURRENT_TIMESTAMP,null,null,1)
END
GO


INSERT INTO ROLUSUARIO (IdUsuario,IdRol,UsuarioCreacion,FechaHoraCreacion,UsuarioActualizacion,FechaHoraActualizacion,EstadoRegistro)
select A.IdUsuario,4,'SOFTBALANZA',CURRENT_TIMESTAMP,NULL,NULL,0   from  USUARIO A left join  ROLUSUARIO B
on A.IdUsuario = B.IdUsuario   
where A.IdUsuario <>1 
group by A.IdUsuario 
having COUNT(A.IdUsuario)<=2
order by A.IdUsuario 

go



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


IF OBJECT_ID ('usp_InsertUsuario') IS NOT NULL
	DROP PROCEDURE usp_InsertUsuario
GO




IF OBJECT_ID ('USP_DEMOROL') IS NOT NULL
	DROP PROCEDURE USP_DEMOROL
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




IF OBJECT_ID ('f_RolesUsuario') IS NOT NULL
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




    
ALTER PROCEDURE [dbo].[usp_UpdateUsuario]    
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




CREATE PROCEDURE dbo.USP_DEMOROL
AS 
BEGIN
SELECT top 1 IdRol FROM ROL
END
GO



IF  NOT EXISTS (SELECT c.name 
FROM sys.columns c JOIN sys.tables t 
ON c.object_id = t.object_id
WHERE t.name = 'TICKET' AND c.name  = 'PLACACARRETA')
BEGIN
ALTER TABLE TICKET add  PlacaCarreta varchar(50)
ALTER TABLE TICKET add ProveedorCompra  varchar(50) 
ALTER TABLE TICKET add TipoMovBalanza  varchar(50)
ALTER TABLE TICKET add Referencia1 varchar(50)
END
GO



ALTER PROCEDURE  [dbo].[usp_GuardarTicket]  
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


ALTER PROCEDURE [dbo].[usp_ActualizarTicket]  
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




ALTER PROCEDURE [dbo].[usp_ListTicketBalanza]     
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
  



