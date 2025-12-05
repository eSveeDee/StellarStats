<?xml version="1.0"?><!DOCTYPE xsl:stylesheet[
<!ENTITY nbsp "&#160;">
]><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"><xsl:output method="html" /><xsl:param name="tempVal" select="none" /><xsl:variable name="only_sequential"><xsl:choose><xsl:when test="//Image/Attachment/LDM_Block_Sequential/LDM_Block_Sequential_List &#xD;&#xA;              and string-length(//Image/Attachment/LDM_Block_Sequential/LDM_Block_Sequential_List) &gt;0 &#xD;&#xA;              and /Data/Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/@VersionNumber &gt; 17">1
			</xsl:when><!-- <xsl:otherwise>0</xsl:otherwise>  --></xsl:choose></xsl:variable><xsl:template match="/"><HTML><HEAD><TITLE><xsl:value-of select="@Name" /></TITLE><script type="text/javascript">
					var visible = 0;
					var FilterSettingsDetailsVisible = 0;
					var ScannerSettingsDetailsVisible = 0;

					var ShowInactiveDetailsVisible = 1;

					function Show()
					{
						if(visible == 0)
						{
							window.document.getElementById("ID_1").style.display = "none";
							window.document.getElementById("ID_2").style.display = "block";
							visible = 1;
						}
						else
						{
							window.document.getElementById("ID_1").style.display = "block";
							window.document.getElementById("ID_2").style.display = "none";
							visible = 0;
						}
					}

					function ShowFilterSettingsDetails()
					{
						if(FilterSettingsDetailsVisible == 0)
						{
							window.document.getElementById("ID_3").style.display = "none";
							window.document.getElementById("ID_4").style.display = "block";			
							FilterSettingsDetailsVisible = 1;
						}
						else
						{
							window.document.getElementById("ID_3").style.display = "block";
							window.document.getElementById("ID_4").style.display = "none";
							FilterSettingsDetailsVisible = 0;
						}
					}

					function ShowScannerSettingsDetails()
					{
						if(ScannerSettingsDetailsVisible == 0)
						{
							window.document.getElementById("ID_5").style.display = "none";
							window.document.getElementById("ID_6").style.display = "block";
							ScannerSettingsDetailsVisible = 1;
						}
						else
						{
							window.document.getElementById("ID_5").style.display = "block";
							window.document.getElementById("ID_6").style.display = "none";
							ScannerSettingsDetailsVisible = 0;			
						}
					}

					function SetStyleDisplay(strID, strDisplay)
					{
							var ebi = document.getElementsByName(strID);

							if(null == ebi)
							{
								return;
							} 

							var i;
							for(i = 0; i != ebi.length; i++)
							{
								ebi[i].style.display = strDisplay;
							}

					}

					function ShowInactiveDetails()
					{
						if(ShowInactiveDetailsVisible == 0)
						{
							SetStyleDisplay("ID_Active_Text", "none");
							SetStyleDisplay("ID_Inactive_Text", "block");

							SetStyleDisplay("ID_Active", "inline");
							SetStyleDisplay("ID_Inactive", "inline");

							SetStyleDisplay("ID_Active_TR", "");
							SetStyleDisplay("ID_Inactive_TR", "");


							ShowInactiveDetailsVisible = 1;
						}
						else
						{
							SetStyleDisplay("ID_Active_Text", "block");
							SetStyleDisplay("ID_Inactive_Text", "none");

							SetStyleDisplay("ID_Active", "inline");
							SetStyleDisplay("ID_Inactive", "none");

							SetStyleDisplay("ID_Active_TR", "");
							SetStyleDisplay("ID_Inactive_TR", "none");

							ShowInactiveDetailsVisible = 0;					
						}
					}
				</script></HEAD><BODY topmargin="0px" leftmargin="0px" bgcolor="#EEEEEE"><xsl:apply-templates select="Data" /></BODY></HTML></xsl:template><xsl:template match="Data"><xsl:apply-templates select="Image/ImageDescription" /><xsl:apply-templates select="Image/Attachment/FRAPplus" /><xsl:apply-templates select="Image/TimeStampList" /><xsl:apply-templates select="Image/Attachment" /><xsl:apply-templates select="Image/Attachment[@Name='DetectorOverloadInfo']/Detector" /><xsl:apply-templates select="Image/Attachment/LDM_Block_Sequential/LDM_Block_Sequential_List" /><xsl:apply-templates select="Image/Attachment/LDM_Block_Sequential/LDM_Block_Sequential_Master/ATLConfocalSettingDefinition/AdditionalInfoForDeconvolution" /></xsl:template><xsl:template match="Detector"><TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><b>Detector Overloads:</b>&nbsp;</TD></TR></TABLE><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD>
                Absolute Time (h:m:s.ms)
							</TD><TD>Duration</TD><TD>Date</TD></TR><xsl:for-each select="TimeStamp"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD><xsl:value-of select="@StartTime" />.<xsl:value-of select="@StartMiliSeconds" /></TD><TD><xsl:value-of select="@DeltaTime" /></TD><TD><xsl:value-of select="@StartDate" /></TD></TR></xsl:for-each></TABLE></TD></TR></TABLE></xsl:template><xsl:template name="break"><xsl:param name="text" select="//User-Comment" /><xsl:comment>This inserts line breaks into the user description in place of line feeds</xsl:comment><xsl:choose><xsl:when test="contains($text, '&#xA;')"><xsl:value-of select="substring-before($text, '&#xA;')" /><br /><xsl:call-template name="break"><xsl:with-param name="text" select="substring-after($text,'&#xA;')" /></xsl:call-template></xsl:when><xsl:otherwise><xsl:value-of select="$text" /></xsl:otherwise></xsl:choose></xsl:template><xsl:template match="ImageDescription"><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE width="100%" align="center" border="0" cellspacing="0" cellpadding="3" bgcolor="#FFFFFF"><TR><TD align="center" valign="center" bgcolor="#EEEEEE"><xsl:choose><xsl:when test="0 != string-length(@ThumbnailPNGImage)"><img style="align:center; valign:middle" border="0" alt="thumbnail" src="data:image/png;base64,{@ThumbnailPNGImage}" /></xsl:when><xsl:otherwise></xsl:otherwise></xsl:choose></TD><TD align="left"><TABLE width="100%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR><TD height="20" width="40%" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 5px;">
											Image: <B><xsl:value-of select="Name" /></B></TD><TD width="30%" /></TR><TR><TD height="20" width="30%" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 5px;">
											Size: 
											<B><xsl:value-of select="Size" /></B></TD></TR><TR><TD width="20%" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 5px;">
											File Location: <B><xsl:value-of select="FileLocation" /></B></TD></TR><TR><TD height="20" width="30%" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 5px;">
											Start Time: <B><xsl:value-of select="StartTime" /></B></TD></TR><TR><TD height="20" width="30%" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 5px;">
											End Time: <B><xsl:value-of select="EndTime" /></B></TD></TR><TR><TD height="20" width="30%" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 5px;">
											Total Exposures: <B><xsl:value-of select="FrameCount" /></B></TD></TR><xsl:if test="/Data/Image/Attachment[@Name='HardwareSetting']/@Software != ' ' or 0 &lt; count(/Data/Image/Attachment[@Name='MicroscopicParameters' and @Application='Huygens']) "><TR><TD height="20" width="30%" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 5px;">
												Data from:
												<xsl:choose><xsl:when test="0 &lt; count(/Data/Image/Attachment[@Name='MicroscopicParameters' and @Application='Huygens'])"><b>Huygens</b><xsl:if test="/Data/Image/Attachment[@Name='HardwareSetting']/@Software != ' ' ">
															based on image data from <xsl:value-of select="/Data/Image/Attachment[@Name='HardwareSetting']/@Software" /></xsl:if></xsl:when><xsl:otherwise><b><xsl:value-of select="/Data/Image/Attachment[@Name='HardwareSetting']/@Software" /></b></xsl:otherwise></xsl:choose></TD></TR></xsl:if></TABLE></TD><TD align="center" valign="center" rowspan="2"><A href="http://www.confocal-microscopy.com/" target="about:blank"><IMG src="LeicaLogo.jpg" border="0" alt="Leica Microsystems Heidelberg GmbH" /></A><br /><DIV id="ID_Active_Text" name="ID_Active_Text" style="display:none;">
									Shown Devices: only <span id="ID_Active" name="ID_Active" style="display:inline;color:green">Active</span><span id="ID_Inactive" name="ID_Inactive" style="display:inline;color:darkgray">Inactive</span>
									(<a href="javascript:ShowInactiveDetails()">Toggle</a>)																	
								</DIV><DIV id="ID_Inactive_Text" name="ID_Inactive_Text" style="display:block">
									Shown Devices: <span id="ID_Active" name="ID_Active" style="display:inline;color:green">Active</span>  and <span id="ID_Inactive" name="ID_Inactive" style="display:inline;color:darkgray">Inactive</span>								
									(<a href="javascript:ShowInactiveDetails()">Toggle</a>)
								</DIV></TD></TR></TABLE></TD></TR></TABLE><xsl:if test="//User-Comment != ' '"><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="center" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;"><TD colspan="2" width="35%"><xsl:call-template name="break" /></TD></TR></TABLE></TD></TR></TABLE></xsl:if><HR width="98%" /><TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><b>Dimensions</b></TD></TR></TABLE><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD>Dimension</TD><TD>Logical Size</TD><TD>Physical Length</TD><TD>Start Position</TD><TD>End Position</TD><TD>Pixel Size / Voxel Size</TD></TR><xsl:for-each select="Dimensions/DimensionDescription"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD><xsl:value-of select="@DimID" /></TD><TD><xsl:value-of select="@NumberOfElements" /></TD><TD><xsl:value-of select="@Length" />&nbsp;<xsl:value-of select="@Unit" /></TD><TD><xsl:value-of select="@Origin" />&nbsp;<xsl:choose><xsl:when test="@UnitOrigin != ''"><xsl:value-of select="@UnitOrigin" /></xsl:when><xsl:otherwise><xsl:value-of select="@Unit" /></xsl:otherwise></xsl:choose></TD><TD><xsl:value-of select="@EndPosition" />&nbsp;<xsl:choose><xsl:when test="@UnitEndPosition != ''"><xsl:value-of select="@UnitEndPosition" /></xsl:when><xsl:otherwise><xsl:value-of select="@Unit" /></xsl:otherwise></xsl:choose></TD><TD><xsl:value-of select="@Voxel" />&nbsp;<xsl:value-of select="@Unit" /></TD></TR></xsl:for-each></TABLE></TD></TR></TABLE><xsl:if test="$only_sequential != 1"><TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><b>Channels</b></TD></TR></TABLE><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><xsl:variable name="channelPropertyCount" select="count(/Data/Image/ImageDescription/Channels/ChannelDescription/ChannelProperty)" /><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD colspan="2">LUT</TD><TD>Resolution</TD><TD>Min</TD><TD>Max</TD><TD>STED: DetectorMode / Huygens saturation factor / Wavelength</TD><xsl:if test="$channelPropertyCount != 0"><TD>Additional Information</TD></xsl:if></TR><xsl:for-each select="Channels/ChannelDescription"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><xsl:choose><xsl:when test="0 != string-length(@LUTPNGImage)"><TD style="border-right: none"><xsl:value-of select="@LUTName" /></TD><TD style="width:12.5%; background: #EEEEEE; border-left: none; ; padding-right:2px"><img style="align:center; valign:middle; width: 256px; height:18px " src="data:image/png;base64,{@LUTPNGImage}" /></TD></xsl:when><xsl:otherwise><TD colspan="2"><xsl:value-of select="@LUTName" /></TD></xsl:otherwise></xsl:choose><TD><xsl:value-of select="@Resolution" /></TD><TD><xsl:value-of select="@Min" />&nbsp;<xsl:value-of select="@Unit" /></TD><TD><xsl:value-of select="@Max" />&nbsp;<xsl:value-of select="@Unit" /></TD><td><xsl:choose><xsl:when test="0 &lt; string-length(@STEDDetectorModeName)"><xsl:value-of select="@STEDDetectorModeName" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose>
                  /
									<xsl:choose><xsl:when test="0 &lt; string-length(@STED_HuygensSaturationFactor)"><xsl:value-of select="@STED_HuygensSaturationFactor" /></xsl:when><xsl:otherwise>  --- </xsl:otherwise></xsl:choose>
                  /
									<xsl:choose><xsl:when test="0 &lt; string-length(@STED_Wavelength)"><xsl:value-of select="@STED_Wavelength" /> nm
										</xsl:when><xsl:otherwise>  --- </xsl:otherwise></xsl:choose></td><xsl:if test="$channelPropertyCount != 0"><td><xsl:for-each select="ChannelProperty[Key = 'DetectorName']"> 
											Detector:&nbsp;<xsl:value-of select="Value" /> 
											(
											<xsl:for-each select="../ChannelProperty[Key = 'DigitalGatingMode']"><xsl:value-of select="translate(Value, ' 	&#xA;','&nbsp;' )" />; 
											</xsl:for-each><xsl:for-each select="../ChannelProperty[Key = 'ChannelType']"><xsl:value-of select="Value" /></xsl:for-each>
											)
											<br /></xsl:for-each><xsl:for-each select="ChannelProperty[Key = 'DyeName']"> 
											Dye:&nbsp;<xsl:value-of select="Value" />&nbsp;<br /></xsl:for-each></td></xsl:if></TR></xsl:for-each></TABLE></TD></TR></TABLE></xsl:if></xsl:template><xsl:template match="TimeStampList"><TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><b>Time Stamps:</b>&nbsp;</TD></TR></TABLE><DIV ID="ID_1" style="display:block;"><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD>
									Frame &nbsp; (<a href="javascript:Show()">Show All</a>)
								</TD><TD>Relative Time (s)</TD><TD>Absolute Time (h:m:s.ms)</TD><TD>Date</TD></TR><xsl:for-each select="TimeStamp"><xsl:if test="not(position()!=1 and position()!=last())"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD><xsl:number value="position()" format="1 " /></TD><TD><xsl:choose><xsl:when test="@RelativeTime != ''"><xsl:value-of select="@RelativeTime" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD><TD><xsl:value-of select="@Time" />.<xsl:value-of select="@MiliSeconds" /></TD><TD><xsl:choose><xsl:when test="@Date != ''"><xsl:value-of select="@Date" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD></TR></xsl:if></xsl:for-each></TABLE></TD></TR></TABLE><BR /></DIV><DIV ID="ID_2" style="display:none;"><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD>
									Frame &nbsp; (<a href="javascript:Show()">Show first + last</a>)
								</TD><TD>Relative Time</TD><TD>Absolute Time</TD><TD>Date</TD></TR><xsl:for-each select="TimeStamp"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD><xsl:number value="position()" format="1 " /></TD><TD><xsl:value-of select="@RelativeTime" /></TD><TD><xsl:value-of select="@Time" />.<xsl:value-of select="@MiliSeconds" /></TD><TD><xsl:value-of select="@Date" /></TD></TR></xsl:for-each></TABLE></TD></TR></TABLE></DIV><BR /></xsl:template><xsl:template match="FRAPplus"><TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><b>Bleach Settings</b></TD></TR></TABLE><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><xsl:for-each select="Block_FRAP"><xsl:for-each select="Block_FRAP_Bleach_Info/LaserLineSettingArray"><xsl:for-each select="LaserLineSetting"><xsl:choose><xsl:when test="contains(@IntensityShow,'Shutter: off') or @IntensityShow='Shutter: on, Intensity: 0.0000%' or @IntensityShow='Shutter: on, Intensity: 0.0%' or @IntensityShow='Intensity: 0.0000%' or @IntensityShow='Intensity: 0.0%'"><TR id="ID_Inactive_TR" name="ID_Inactive_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
													Laser Line <xsl:value-of select="@AotfType" /> (<xsl:value-of select="@LaserLine" />nm)
												</TD><TD><xsl:value-of select="@IntensityShow" /></TD></TR></xsl:when><xsl:otherwise><TR id="ID_Active_TR" name="ID_Active_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
													Laser Line <xsl:value-of select="@AotfType" /> (<xsl:value-of select="@LaserLine" />nm)
												</TD><TD><xsl:value-of select="@IntensityShow" /></TD></TR></xsl:otherwise></xsl:choose></xsl:for-each></xsl:for-each></xsl:for-each><xsl:for-each select="Block_FRAP_XT"><xsl:for-each select="Block_FRAP_XT_Bleach_Info/LaserLineSettingArray"><xsl:for-each select="LaserLineSetting"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
											Laser Line <xsl:value-of select="@AotfType" /> (<xsl:value-of select="@LaserLine" />nm)
										</TD><TD><xsl:value-of select="@IntensityShow" /></TD></TR></xsl:for-each></xsl:for-each></xsl:for-each></TABLE></TD></TR></TABLE><TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><b>Pre/Post Settings</b></TD></TR></TABLE><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><xsl:for-each select="Block_FRAP"><xsl:for-each select="Block_FRAP_PrePost_Info/LaserLineSettingArray"><xsl:for-each select="LaserLineSetting"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
											Laser Line <xsl:value-of select="@AotfType" /> (<xsl:value-of select="@LaserLine" />nm)
										</TD><TD><xsl:value-of select="@IntensityShow" /></TD></TR></xsl:for-each></xsl:for-each></xsl:for-each><xsl:for-each select="Block_FRAP_XT"><xsl:for-each select="Block_FRAP_XT_PrePost_Info/LaserLineSettingArray"><xsl:for-each select="LaserLineSetting"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
											Laser Line <xsl:value-of select="@AotfType" /> (<xsl:value-of select="@LaserLine" />nm)
										</TD><TD><xsl:value-of select="@IntensityShow" /></TD></TR></xsl:for-each></xsl:for-each></xsl:for-each></TABLE></TD></TR></TABLE></xsl:template><xsl:template match="LDM_Block_Sequential_List"><xsl:for-each select="ATLConfocalSettingDefinition"><xsl:variable name="seqSetNo" select="position()" /><TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><b><xsl:choose><xsl:when test="@UserSettingName != ''&gt;Sequential ">
                  Setting "<xsl:value-of select="@UserSettingName" />"
                </xsl:when><xsl:otherwise>
                  Setting No.<xsl:number value="$seqSetNo" format="1 " /></xsl:otherwise></xsl:choose></b></TD></TR></TABLE><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD>Device Name</TD><TD>Value</TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
									Pinhole
								</TD><TD><xsl:choose><xsl:when test="@Pinhole"><xsl:value-of select="@Pinhole" /></xsl:when><xsl:otherwise><xsl:value-of select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/@Pinhole" /></xsl:otherwise></xsl:choose></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
									PinholeAiry
								</TD><TD><xsl:choose><xsl:when test="@PinholeAiry"><xsl:value-of select="@PinholeAiry" /></xsl:when><xsl:otherwise><xsl:value-of select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/@PinholeAiry" /></xsl:otherwise></xsl:choose></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
									EmissionWavelength for PinholeAiry Calculation
								</TD><TD><xsl:choose><xsl:when test="@EmissionWavelengthForPinholeAiryCalculation"><xsl:value-of select="@EmissionWavelengthForPinholeAiryCalculation" /></xsl:when><xsl:otherwise><xsl:value-of select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/@EmissionWavelengthForPinholeAiryCalculation" /></xsl:otherwise></xsl:choose></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
									FrameAverage
								</TD><TD><xsl:choose><xsl:when test="@FrameAverage"><xsl:value-of select="@FrameAverage" /></xsl:when><xsl:otherwise><xsl:value-of select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/@FrameAverage" /></xsl:otherwise></xsl:choose></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
									LineAverage
								</TD><TD><xsl:choose><xsl:when test="@LineAverage"><xsl:value-of select="@LineAverage" /></xsl:when><xsl:otherwise><xsl:value-of select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/@LineAverage" /></xsl:otherwise></xsl:choose></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
									FrameAccumulation
								</TD><TD><xsl:choose><xsl:when test="@FrameAccumulation"><xsl:value-of select="@FrameAccumulation" /></xsl:when><xsl:otherwise><xsl:value-of select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/@FrameAccumulation" /></xsl:otherwise></xsl:choose></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
									LineAccumulation
								</TD><TD><xsl:choose><xsl:when test="@Line_Accumulation"><xsl:value-of select="@Line_Accumulation" /></xsl:when><xsl:otherwise><xsl:value-of select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/@Line_Accumulation" /></xsl:otherwise></xsl:choose></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
									IsRoiScanEnable
								</TD><TD><xsl:choose><xsl:when test="@IsRoiScanEnable"><xsl:call-template name="booleanToYesNo"><xsl:with-param name="theBoolValue" select="@IsRoiScanEnable" /></xsl:call-template></xsl:when><xsl:otherwise><xsl:call-template name="booleanToYesNo"><xsl:with-param name="theBoolValue" select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/@IsRoiScanEnable" /></xsl:call-template></xsl:otherwise></xsl:choose></TD></TR><xsl:if test="@CanDoSTED='1' or //Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/@CanDoSTED='1'"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										IsSTEDActive
									</TD><TD><xsl:choose><xsl:when test="@IsSTEDActive"><xsl:call-template name="booleanToYesNo"><xsl:with-param name="theBoolValue" select="@IsSTEDActive" /></xsl:call-template></xsl:when><xsl:otherwise><xsl:call-template name="booleanToYesNo"><xsl:with-param name="theBoolValue" select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/@IsSTEDActive" /></xsl:call-template></xsl:otherwise></xsl:choose></TD></TR></xsl:if><xsl:for-each select="FilterWheel/Wheel"><xsl:choose><xsl:when test="@IsSpectrumTurnMode='1' and @FilterSpectrumValue='0'"><TR name="ID_Inactive_TR" id="ID_Inactive_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%"><xsl:value-of select="@FilterWheelName" /></TD><TD><xsl:choose><xsl:when test="@IsSpectrumTurnMode='1'"><xsl:choose><xsl:when test="@FilterDisplayValue!=''"><xsl:value-of select="@FilterDisplayValue" /></xsl:when><xsl:otherwise><xsl:value-of select="@FilterSpectrumValue" /></xsl:otherwise></xsl:choose>
                            % (
														<xsl:value-of select="@LightSourceName" />: 

														<xsl:variable name="lsn" select="@LightSourceName" /><xsl:for-each select="../../LaserArray/Laser[@LightSourceName=$lsn]"><xsl:value-of select="@Wavelength" />nm 
														</xsl:for-each>
														)
													</xsl:when><xsl:otherwise><xsl:value-of select="@FilterName" /><xsl:if test="@FilterWheelName='STED Beam Selection' and @FilterSpectrumValue">
															(<xsl:value-of select="@FilterDisplayValue" />%)
														</xsl:if></xsl:otherwise></xsl:choose></TD></TR></xsl:when><xsl:otherwise><TR name="ID_Active_TR" id="ID_Active_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%"><xsl:value-of select="@FilterWheelName" /></TD><TD><xsl:choose><xsl:when test="@IsSpectrumTurnMode='1'"><xsl:choose><xsl:when test="@FilterDisplayValue!=''"><xsl:value-of select="@FilterDisplayValue" /></xsl:when><xsl:otherwise><xsl:value-of select="@FilterSpectrumValue" /></xsl:otherwise></xsl:choose>
                            % (
														<xsl:value-of select="@LightSourceName" />: 

														<xsl:variable name="lsn" select="@LightSourceName" /><xsl:for-each select="../../LaserArray/Laser[@LightSourceName=$lsn]"><xsl:value-of select="@Wavelength" />nm 
														</xsl:for-each>
														)
													</xsl:when><xsl:otherwise><xsl:value-of select="@FilterName" /><xsl:if test="@FilterWheelName='STED Beam Selection' and @FilterSpectrumValue">
															(<xsl:value-of select="@FilterDisplayValue" />%)
														</xsl:if></xsl:otherwise></xsl:choose></TD></TR></xsl:otherwise></xsl:choose></xsl:for-each><xsl:for-each select="AotfList/Aotf"><xsl:for-each select="LaserLineSetting"><xsl:choose><xsl:when test="contains(@IntensityShow,'Shutter: off') or @IntensityShow='Shutter: on, Intensity: 0.0000%' or @IntensityShow='Shutter: on, Intensity: 0.0%' or @IntensityShow='Intensity: 0.0000%' or @IntensityShow='Intensity: 0.0%'"><TR id="ID_Inactive_TR" name="ID_Inactive_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><xsl:if test="@LaserLine &gt; 0"><TD width="40%">
														Laser Line <xsl:value-of select="@LightSourceName" /> (
														<xsl:choose><xsl:when test="@LaserLineDouble!=''"><xsl:value-of select="@LaserLineDouble" /></xsl:when><xsl:otherwise><xsl:value-of select="@LaserLine" /></xsl:otherwise></xsl:choose>
														nm)
													</TD><TD><xsl:value-of select="@IntensityShow" /></TD></xsl:if></TR></xsl:when><xsl:otherwise><TR id="ID_Active_TR" name="ID_Active_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><xsl:if test="@LaserLine &gt; 0"><TD width="40%">
														Laser Line <xsl:value-of select="@LightSourceName" /> (
														<xsl:choose><xsl:when test="@LaserLineDouble!=''"><xsl:value-of select="@LaserLineDouble" /></xsl:when><xsl:otherwise><xsl:value-of select="@LaserLine" /></xsl:otherwise></xsl:choose>
														nm)
													</TD><TD><xsl:value-of select="@IntensityShow" /></TD></xsl:if></TR></xsl:otherwise></xsl:choose></xsl:for-each></xsl:for-each></TABLE></TD><tr><TD colspan="2"><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD>
										Detector Name
									</TD><TD>
										Operating Mode
									</TD><TD>
                    Reference Line
                  </TD><TD>
										Spectral Positions/Gain/Offset
									</TD><TD>
										Image Channel
									</TD><TD>
										Channel Information
									</TD></TR><xsl:for-each select="DetectorList/Detector"><xsl:variable name="dn" select="@Name" /><xsl:variable name="refWl"><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@TimeGateWavelength" /></xsl:for-each></xsl:variable><xsl:variable name="analogTimeGateActivated"><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@IsTimeGateActivated" /></xsl:for-each></xsl:variable><xsl:variable name="analogTimeGatePulseStart"><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@TimeGatePulseStart" /></xsl:for-each></xsl:variable><xsl:variable name="analogTimeGatePulseEnd"><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@TimeGatePulseEnd" /></xsl:for-each></xsl:variable><xsl:variable name="band"><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@Band" /></xsl:for-each></xsl:variable><xsl:variable name="testBand"><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@Band" /></xsl:for-each></xsl:variable><xsl:variable name="type"><xsl:if test="@OperatingType='1' "><xsl:if test="@IsReflectionModeActive='0' ">
                        Analog
                      </xsl:if><xsl:if test="@IsReflectionModeActive='1' ">
                        Reflection
                      </xsl:if></xsl:if><xsl:if test="@OperatingType='2' "><!--Analog--><xsl:if test="@AcquisitionMode='0' ">
                        Digital
                      </xsl:if><xsl:if test="@AcquisitionMode='1' ">
                        Counting
                      </xsl:if></xsl:if><xsl:if test="@IsHPDOverloaded='1' ">&nbsp;<font color="red">Overloaded</font></xsl:if></xsl:variable><xsl:variable name="referenceLine"><xsl:value-of select="DetectionReferenceLine/@LaserWavelength" /></xsl:variable><xsl:choose><xsl:when test="@IsActive='0'"><TR name="ID_Inactive_TR" id="ID_Inactive_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD><xsl:value-of select="@Name" /></TD><TD><xsl:value-of select="$type" /></TD><TD>
                          ---
                        </TD><TD><xsl:choose><xsl:when test="@Band != '' "><xsl:value-of select="@Band" /></xsl:when><xsl:otherwise><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@Band" /></xsl:for-each></xsl:otherwise></xsl:choose>
													/
													<xsl:choose><xsl:when test="@OperatingType='2' and @AcquisitionMode='1' ">na</xsl:when><xsl:when test="@Gain != '' "><xsl:value-of select="@Gain" /></xsl:when><xsl:otherwise><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@Gain" /></xsl:for-each></xsl:otherwise></xsl:choose>
													/
													<xsl:choose><xsl:when test="@Type='HyD' or @AcquisitionMode='1'"> na </xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@Offset != '' "><xsl:value-of select="@Offset" /></xsl:when><xsl:otherwise><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@Offset" /></xsl:for-each></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></TD><TD>
															---
												</TD><TD>
																		---
												</TD></TR></xsl:when><xsl:otherwise><xsl:variable name="hasTauChan" select="count(ImageChannelArray/ImageChannel[@GatingMode='5']) &gt; 0  or count(ImageChannelArray/ImageChannel[@GatingMode='6']) &gt; 0" /><xsl:variable name="detectorName" select="@Name" /><TR id="ID_Active_TR" name="ID_Active_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD><xsl:value-of select="@Name" /></TD><TD><xsl:value-of select="$type" /></TD><TD><xsl:choose><xsl:when test="$referenceLine!=''"><xsl:value-of select="$referenceLine" /></xsl:when><xsl:otherwise>
                              n/a
                            </xsl:otherwise></xsl:choose></TD><TD><xsl:choose><xsl:when test="@Band != '' "><xsl:value-of select="@Band" /></xsl:when><xsl:otherwise><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@Band" /></xsl:for-each></xsl:otherwise></xsl:choose>
													/
													<xsl:choose><xsl:when test="@OperatingType='2' and @AcquisitionMode='1' ">na</xsl:when><xsl:when test="@Gain != '' "><xsl:value-of select="@Gain" /></xsl:when><xsl:otherwise><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@Gain" /></xsl:for-each></xsl:otherwise></xsl:choose>
													/
													<xsl:choose><xsl:when test="@Type='HyD'"> na </xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@Offset != '' "><xsl:value-of select="@Offset" /></xsl:when><xsl:otherwise><xsl:for-each select="//Image/Attachment[@Name='HardwareSetting']/ATLConfocalSettingDefinition/DetectorList/Detector[@Name=$dn]"><xsl:value-of select="@Offset" /></xsl:for-each></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></TD><TD><xsl:choose><xsl:when test="$hasTauChan"><xsl:if test="count(ImageChannelArray/ImageChannel[@GatingMode='5']) &gt; 0"><xsl:for-each select="/Data/Image/ImageDescription/Channels/ChannelDescription"><xsl:for-each select="ChannelProperty"><xsl:if test="Key = 'DetectorName' and Value = $detectorName"><xsl:for-each select="../ChannelProperty"><xsl:if test="Key = 'DigitalGatingMode' and Value = 'Tau Scan'">
                                          TauScan<br /></xsl:if></xsl:for-each></xsl:if></xsl:for-each></xsl:for-each></xsl:if><xsl:if test="count(ImageChannelArray/ImageChannel[@GatingMode='6']) &gt; 0"><xsl:for-each select="TauDefinition/TauChannel">
                                TauSeparation<br /></xsl:for-each></xsl:if><xsl:if test="count(ImageChannelArray/ImageChannel[@GatingMode='8' and @AcquisitionMode='4']) &gt; 0">
																TauContrast
															</xsl:if></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="count(ImageChannelArray/ImageChannel) &gt; 0"><xsl:for-each select="ImageChannelArray/ImageChannel"><xsl:choose><xsl:when test="@ChannelTypeName='Digital'"><xsl:choose><xsl:when test="@GatingMode='3'">
																						TauGating
																						<br /></xsl:when><xsl:when test="@GatingMode='4'">
																				GateScan
																						<br /></xsl:when><xsl:when test="@GatingMode='10'">
																				TauInteraction
																						<br /></xsl:when><xsl:when test="@GatingMode='8'"><xsl:if test="@AcquisitionMode='4'">
																							TauContrast
																							<br /></xsl:if></xsl:when><xsl:when test="@GatingMode='9'"><xsl:if test="position() = '1'">
																							TauSTED
																							<br /><br /><xsl:if test="../../TauStedDefinition/@BackgroundSupression = '1'&#xD;&#xA;                                                or ../../TauStedDefinition/@BackgroundSupression = '0'"><br /><br /></xsl:if></xsl:if></xsl:when><xsl:otherwise><xsl:value-of select="translate(@GatingModeName, ' 	&#xA;','&nbsp;' )" /><br /></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>
																		Analog
																				<br /></xsl:otherwise></xsl:choose></xsl:for-each></xsl:when><xsl:otherwise>
															--- 
														</xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></TD><TD><xsl:choose><xsl:when test="$hasTauChan"><xsl:if test="count(ImageChannelArray/ImageChannel[@GatingMode='5']) &gt; 0"><xsl:for-each select="/Data/Image/ImageDescription/Channels/ChannelDescription"><xsl:for-each select="ChannelProperty"><xsl:if test="Key = 'DetectorName' and Value = $detectorName"><xsl:for-each select="../ChannelProperty"><xsl:if test="Key = 'DigitalGatingMode' and Value = 'Tau Scan'"><xsl:for-each select="../ChannelProperty"><xsl:if test="Key = 'TauScanLine'">
                                              line:&nbsp;<xsl:value-of select="Value" /><br /></xsl:if></xsl:for-each></xsl:if></xsl:for-each></xsl:if></xsl:for-each></xsl:for-each></xsl:if><xsl:if test="count(ImageChannelArray/ImageChannel[@GatingMode='6']) &gt; 0"><xsl:for-each select="TauDefinition/TauChannel">
                                  line:
                                  <xsl:variable name="tau_channel_count" select="count(TauChannelEntry)" /><xsl:choose><xsl:when test="$tau_channel_count &gt; 0"><xsl:for-each select="TauChannelEntry"><xsl:value-of select="@TauChannelValue" /><xsl:if test="$tau_channel_count &gt; position()">,&nbsp;</xsl:if></xsl:for-each></xsl:when></xsl:choose><br /></xsl:for-each></xsl:if><xsl:if test="count(ImageChannelArray/ImageChannel[@GatingMode='8' and @AcquisitionMode='4']) &gt; 0">
																--- 
															</xsl:if></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="count(ImageChannelArray/ImageChannel) &gt; 0"><xsl:for-each select="ImageChannelArray/ImageChannel"><xsl:variable name="gate_count" select="count(DigitalGatingArray/DigitalGating)" /><xsl:choose><xsl:when test="@GatingMode = '6' or @GatingMode = '5'" /><xsl:when test="@GatingMode = '8' and @AcquisitionMode='1'" /><xsl:when test="@GatingMode = '9' and @AcquisitionMode='1'"><xsl:if test="position() = '1'"><xsl:choose><xsl:when test="../../TauStedDefinition/@BackgroundSupression = '1'">
																					TauBackground:&nbsp;on<br />
																					TauStrength:&nbsp;<xsl:value-of select="../../TauStedDefinition/@Strength" /><br />
																					Denoise:&nbsp;<xsl:value-of select="../../TauStedDefinition/@NoiseFilter" /><br /></xsl:when><xsl:otherwise>
																					TauBackground:&nbsp;off<br />
                                          TauStrength:&nbsp;<xsl:value-of select="../../TauStedDefinition/@Strength" /><br />
                                          Denoise:&nbsp;<xsl:value-of select="../../TauStedDefinition/@NoiseFilter" /><br /></xsl:otherwise></xsl:choose><xsl:choose><xsl:when test="$gate_count &gt; 0"><xsl:for-each select="DigitalGatingArray/DigitalGating">
																						TimeGate: <xsl:value-of select="@Begin" />-<xsl:value-of select="@End" />;&nbsp;</xsl:for-each></xsl:when><xsl:otherwise>
																					TimeGate: ---
																				</xsl:otherwise></xsl:choose><br /></xsl:if></xsl:when><xsl:when test="$gate_count &gt; 0"><xsl:choose><xsl:when test="$refWl &gt; 0">
																						Ref. Wavelength: &nbsp;<xsl:value-of select="$refWl" /></xsl:when></xsl:choose>
																		Gates:&nbsp;<xsl:choose><xsl:when test="string-length($analogTimeGateActivated) != 0">
																				Begin:&nbsp;<xsl:value-of select="$analogTimeGatePulseStart" />&nbsp; End:<xsl:value-of select="$analogTimeGatePulseEnd" />;
																			</xsl:when><xsl:otherwise><xsl:for-each select="DigitalGatingArray/DigitalGating"><xsl:value-of select="@Begin" />-<xsl:value-of select="@End" />;&nbsp;</xsl:for-each></xsl:otherwise></xsl:choose><br /></xsl:when><xsl:when test="@GatingMode = '10'"><xsl:choose><xsl:when test="@AcquisitionMode='4'">
                                          Donor Lifetime: <xsl:value-of select="../../@TauInteractionDonorLifetime" /><br /></xsl:when><xsl:otherwise>
                                          Intensity<br /></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>
																		--- <br /></xsl:otherwise></xsl:choose></xsl:for-each></xsl:when></xsl:choose></xsl:otherwise></xsl:choose></TD></TR></xsl:otherwise></xsl:choose></xsl:for-each></TABLE></TD></tr><xsl:if test="count(FilterWheel) &gt; 0"><tr><td colspan="2"><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD width="40%">
											Device Name
										</TD><TD>
											Filter Name/Position
										</TD></TR><xsl:for-each select="FilterWheel/Wheel"><xsl:choose><xsl:when test="@IsSpectrumTurnMode='1' and @FilterSpectrumValue='0'"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;" id="ID_Inactive_TR" name="ID_Inactive_TR"><TD><xsl:value-of select="@FilterWheelName" /></TD><TD><xsl:choose><xsl:when test="@FilterDisplayValue!=''"><xsl:value-of select="@FilterDisplayValue" /></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@IsSpectrumTurnMode='1'"><xsl:value-of select="@FilterSpectrumValue" />%
																			(
																		<xsl:value-of select="@LightSourceName" />:

																		<xsl:variable name="lsn" select="@LightSourceName" /><xsl:for-each select="../../LaserArray/Laser[@LightSourceName=$lsn]"><xsl:value-of select="@Wavelength" />nm
																		</xsl:for-each>
																			)
																	</xsl:when><xsl:otherwise><xsl:value-of select="@FilterName" /><xsl:if test="@FilterWheelName='STED Beam Selection' and @FilterSpectrumValue">
																			(<xsl:value-of select="@FilterDisplayValue" />%)
																		</xsl:if></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></TD></TR></xsl:when><xsl:otherwise><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;" id="ID_Active_TR" name="ID_Active_TR"><TD><xsl:value-of select="@FilterWheelName" /></TD><TD><xsl:choose><xsl:when test="@FilterDisplayValue!=''"><xsl:value-of select="@FilterDisplayValue" /></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@IsSpectrumTurnMode='1'"><xsl:value-of select="@FilterSpectrumValue" />%
																		(
																		<xsl:value-of select="@LightSourceName" />:

																		<xsl:variable name="lsn" select="@LightSourceName" /><xsl:for-each select="../../LaserArray/Laser[@LightSourceName=$lsn]"><xsl:value-of select="@Wavelength" />nm
																		</xsl:for-each>
																		)
																	</xsl:when><xsl:otherwise><xsl:value-of select="@FilterName" /><xsl:if test="@FilterWheelName='STED Beam Selection' and @FilterSpectrumValue">
																			(<xsl:value-of select="@FilterDisplayValue" />%)
																		</xsl:if></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></TD></TR></xsl:otherwise></xsl:choose></xsl:for-each><xsl:for-each select="ATLConfocalSettingDefinition/VariableBeamExpanderFactors/VariableBeamExpanderFactor"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td>
												VariableBeamExpander <xsl:value-of select="@Wavelength" />nm
											</td><TD>
												Factor: <xsl:value-of select="@Factor" />,&nbsp;<!--,&nbsp;Wavelength: <xsl:value-of select="@Wavelength",&nbsp;> --> Z Color Correction Offset: <xsl:value-of select="@Offset" /></TD></TR></xsl:for-each></TABLE></td></tr></xsl:if></TR></TABLE></xsl:for-each></xsl:template><xsl:template match="AdditionalInfoForDeconvolution"><TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><b>Deconvolution Information</b></TD></TR></TABLE><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD width="40%">
								Name
							</TD><TD>
								Value
							</TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
								Mounting Medium
							</TD><TD><xsl:choose><xsl:when test="@MountingMedium!=''"><xsl:value-of select="@MountingMedium" /></xsl:when><xsl:otherwise> -- </xsl:otherwise></xsl:choose></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
								Mounting Medium Refractive Index
							</TD><TD><xsl:choose><xsl:when test="@MountingMediumRefractiveIndex!=''"><xsl:value-of select="@MountingMediumRefractiveIndex" /></xsl:when><xsl:otherwise> -- </xsl:otherwise></xsl:choose></TD></TR></TABLE></TD></TR></TABLE></xsl:template><xsl:template match="Attachment"><xsl:if test="@Name='HardwareSetting'"><TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><b>Confocal Settings</b></TD></TR></TABLE><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD width="40%">
									Name
								</TD><TD>
									Value
								</TD></TR><xsl:for-each select="ATLConfocalSettingDefinition"><xsl:choose><xsl:when test="@RotatorAngle"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
												Rotator Angle
											</TD><TD><xsl:value-of select="@RotatorAngle" /></TD></TR></xsl:when></xsl:choose><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										Scan Mode
									</TD><TD><xsl:value-of select="@ScanMode" /></TD></TR><xsl:choose><xsl:when test="@ScanDirectionXName"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
												Scan Direction X
											</TD><TD><xsl:value-of select="@ScanDirectionXName" /></TD></TR></xsl:when></xsl:choose><xsl:choose><xsl:when test="@ScanSpeed"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
												Scan Speed
											</TD><TD><xsl:value-of select="@ScanSpeed" /></TD></TR></xsl:when></xsl:choose><xsl:choose><xsl:when test="@PixelDwellTime"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
												Pixel Dwell Time
											</TD><TD><xsl:value-of select="@PixelDwellTime" /></TD></TR></xsl:when></xsl:choose><xsl:if test="not[@CanDoSTED]"><!-- show for old images which do not have CanDoSTED attribute --><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px"><TD width="40%">
											IsSTEDActive
										</TD><TD><xsl:call-template name="booleanToYesNo"><xsl:with-param name="theBoolValue" select="@IsSTEDActive" /></xsl:call-template></TD></TR></xsl:if><xsl:if test="@StagePosX != ''"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
											StagePosX
										</TD><TD><xsl:value-of select="@StagePosX" /></TD></TR></xsl:if><xsl:if test="@StagePosY != ''"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
											StagePosY
										</TD><TD><xsl:value-of select="@StagePosY" /></TD></TR></xsl:if><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										ZPosition
									</TD><TD><xsl:value-of select="@ZPosition" /></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										IsSuperZ
									</TD><TD><xsl:value-of select="@IsSuperZ" /></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										Magnification
									</TD><TD><xsl:value-of select="@Magnification" /></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										ObjectiveName
									</TD><TD><xsl:value-of select="@ObjectiveName" /></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										Immersion
									</TD><TD><xsl:choose><xsl:when test="@Immersion != ''"><xsl:value-of select="@Immersion" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										Numerical Aperture
									</TD><TD><xsl:value-of select="@NumericalAperture" /></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										RefractionIndex
									</TD><TD><xsl:value-of select="@RefractionIndex" /></TD></TR><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										Zoom
									</TD><TD><xsl:value-of select="@Zoom" /></TD></TR><xsl:choose><xsl:when test="@CanDoOpticalZoom='1'"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
												OpticalZoom
											</TD><TD><xsl:value-of select="@OpticalZoom" /></TD></TR></xsl:when></xsl:choose><xsl:if test="$only_sequential != 1"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
											Pinhole
										</TD><TD><xsl:value-of select="@Pinhole" /></TD></TR></xsl:if><xsl:if test="$only_sequential != 1"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
											PinholeAiry
										</TD><TD><xsl:value-of select="@PinholeAiry" /></TD></TR></xsl:if><xsl:if test="$only_sequential != 1"><xsl:choose><xsl:when test="@EmissionWavelengthForPinholeAiryCalculation"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
													EmissionWavelength for PinholeAiry Calculation
												</TD><TD><xsl:value-of select="@EmissionWavelengthForPinholeAiryCalculation" /></TD></TR></xsl:when></xsl:choose></xsl:if><xsl:choose><xsl:when test="@MotCorrPosition"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
												MotCorrPosition
											</TD><TD><xsl:value-of select="@MotCorrPosition" />%
											</TD></TR></xsl:when></xsl:choose><xsl:if test="$only_sequential != 1"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										FrameAverage
									</TD><TD><xsl:value-of select="@FrameAverage" /></TD></TR></xsl:if><xsl:if test="$only_sequential != 1"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										LineAverage
									</TD><TD><xsl:value-of select="@LineAverage" /></TD></TR></xsl:if><xsl:if test="$only_sequential != 1"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										FrameAccumulation
									</TD><TD><xsl:value-of select="@FrameAccumulation" /></TD></TR></xsl:if><xsl:if test="$only_sequential != 1"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										LineAccumulation
									</TD><TD><xsl:value-of select="@Line_Accumulation" /></TD></TR></xsl:if><!--<TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;">
										<TD width="40%">
											IsUserSettingNameSet
										</TD>
										<TD>
											<xsl:value-of select="@IsUserSettingNameSet"/>
										</TD>
									</TR>--><xsl:if test="$only_sequential != 1"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD width="40%">
										IsRoiScanEnable
									</TD><TD><xsl:call-template name="booleanToYesNo"><xsl:with-param name="theBoolValue" select="@IsRoiScanEnable" /></xsl:call-template></TD></TR></xsl:if></xsl:for-each></TABLE></TD></TR><!--
        <TR>
          <TD>
            Spectro

            <TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF">
              <TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;">
                <TD width="40%">
                  Channel Name
                </TD>
                <TD >
                  Left
                </TD>
                <TD >
                  Right
                </TD>
                <TD >
                  Dye Name
                </TD>

              </TR>

              <xsl:for-each select="ATLConfocalSettingDefinition/Spectro/MultiBand">
                <TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;">
                  <TD>
                    <xsl:value-of select="@ChannelName"/>
                  </TD>
                  <TD >
                    <xsl:value-of select="@LeftWorld"/>
                  </TD>
                  <TD>
                    <xsl:value-of select="@RightWorld"/>
                  </TD>
                  <TD >
                    <xsl:value-of select="@DyeName"/>
                  </TD>
                </TR>
              </xsl:for-each>
            </TABLE>
          </TD>
        </TR>
        --><xsl:if test="count(../Attachment/LDM_Block_Sequential/LDM_Block_Sequential_List/ATLConfocalSettingDefinition/FilterWheel/Wheel) = 0"><TR><TD> 
							Filter Wheels / Other Motorized Devices

							<TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD width="40%">
										Device Name
									</TD><TD>
										Filter Name/Position
									</TD></TR><xsl:for-each select="ATLConfocalSettingDefinition/FilterWheel/Wheel"><xsl:choose><xsl:when test="@IsSpectrumTurnMode='1' and @FilterSpectrumValue='0'"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;" id="ID_Inactive_TR" name="ID_Inactive_TR"><TD><xsl:value-of select="@FilterWheelName" /></TD><TD><xsl:choose><xsl:when test="@FilterDisplayValue!=''"><xsl:value-of select="@FilterDisplayValue" /></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@IsSpectrumTurnMode='1'"><xsl:value-of select="@FilterSpectrumValue" />% 
																(
																	<xsl:value-of select="@LightSourceName" />: 

																	<xsl:variable name="lsn" select="@LightSourceName" /><xsl:for-each select="../../LaserArray/Laser[@LightSourceName=$lsn]"><xsl:value-of select="@Wavelength" />nm 
																	</xsl:for-each>
																)
																</xsl:when><xsl:otherwise><xsl:value-of select="@FilterName" /><xsl:if test="@FilterWheelName='STED Beam Selection' and @FilterSpectrumValue">
																	(<xsl:value-of select="@FilterDisplayValue" />%)
																	</xsl:if></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></TD></TR></xsl:when><xsl:otherwise><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;" id="ID_Active_TR" name="ID_Active_TR"><TD><xsl:value-of select="@FilterWheelName" /></TD><TD><xsl:choose><xsl:when test="@FilterDisplayValue!=''"><xsl:value-of select="@FilterDisplayValue" /></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@IsSpectrumTurnMode='1'"><xsl:value-of select="@FilterSpectrumValue" />% 
																(
																	<xsl:value-of select="@LightSourceName" />: 

																	<xsl:variable name="lsn" select="@LightSourceName" /><xsl:for-each select="../../LaserArray/Laser[@LightSourceName=$lsn]"><xsl:value-of select="@Wavelength" />nm 
																	</xsl:for-each>
																)
																</xsl:when><xsl:otherwise><xsl:value-of select="@FilterName" /><xsl:if test="@FilterWheelName='STED Beam Selection' and @FilterSpectrumValue">
																	(<xsl:value-of select="@FilterDisplayValue" />%)
																	</xsl:if></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></TD></TR></xsl:otherwise></xsl:choose></xsl:for-each><xsl:for-each select="ATLConfocalSettingDefinition/VariableBeamExpanderFactors/VariableBeamExpanderFactor"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td>VariableBeamExpander <xsl:value-of select="@Wavelength" />nm</td><TD> 
											Factor: <xsl:value-of select="@Factor" />,&nbsp;<!--,&nbsp;Wavelength: <xsl:value-of select="@Wavelength",&nbsp;> --> Z Color Correction Offset: <xsl:value-of select="@Offset" /></TD></TR></xsl:for-each></TABLE></TD></TR></xsl:if><TR><TD>
						Lasers

						<TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD width="40%">
									LaserName
								</TD><TD>
									OutputPower
								</TD></TR><xsl:for-each select="ATLConfocalSettingDefinition/LaserArray/Laser"><xsl:choose><xsl:when test="@PowerState='On' "><TR id="ID_Active_TR" name="ID_Active_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD><xsl:value-of select="@LaserName" /></TD><TD><xsl:choose><xsl:when test="@OutputPowerDisplay='' and not(@OutputPower)">
														--
													</xsl:when><xsl:when test="@OutputPowerDisplay"><xsl:value-of select="@OutputPowerDisplay" /><xsl:if test="((@PumpOutputPower) or not (@OutputPowerPercentage)) and @OutputPowerWattDisplay">
															,&nbsp;Power: <xsl:value-of select="@OutputPowerWattDisplay" /></xsl:if></xsl:when><xsl:otherwise><xsl:value-of select="@OutputPower" /> ? 
													</xsl:otherwise></xsl:choose></TD></TR></xsl:when><xsl:otherwise><TR name="ID_Inactive_TR" id="ID_Inactive_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD><xsl:value-of select="@LaserName" /></TD><TD><xsl:choose><xsl:when test="@OutputPowerDisplay='' and not(@OutputPower)">
														--
													</xsl:when><xsl:when test="@OutputPowerDisplay"><xsl:value-of select="@OutputPowerDisplay" /><xsl:if test="not(@OutputPowerPercentage) and @OutputPowerWattDisplay">
															,&nbsp;Power: <xsl:value-of select="@OutputPowerWattDisplay" /></xsl:if></xsl:when><xsl:otherwise><xsl:value-of select="@OutputPower" /> ?
													</xsl:otherwise></xsl:choose></TD></TR></xsl:otherwise></xsl:choose></xsl:for-each></TABLE></TD></TR><TR><xsl:choose><xsl:when test="$only_sequential != 1"><TD>
								Laser Lines

								<TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD width="40%">
											Laser Line
										</TD><TD>
											Intensity
										</TD></TR><xsl:for-each select="ATLConfocalSettingDefinition/AotfList/Aotf/LaserLineSetting"><xsl:choose><xsl:when test="contains(@IntensityShow,'Shutter: off') or @IntensityShow='Shutter: on, Intensity: 0.0000%' or @IntensityShow='Shutter: on, Intensity: 0.0%' or @IntensityShow='Intensity: 0.0000%' or @IntensityShow='Intensity: 0.0%'"><TR id="ID_Inactive_TR" name="ID_Inactive_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><xsl:if test="@LaserLine &gt; 0"><TD><xsl:value-of select="@LightSourceName" /> (
															<xsl:choose><xsl:when test="@LaserLineDouble!=''"><xsl:value-of select="@LaserLineDouble" /></xsl:when><xsl:otherwise><xsl:value-of select="@LaserLine" /></xsl:otherwise></xsl:choose>
															nm)
														</TD><TD><xsl:value-of select="@IntensityShow" /></TD></xsl:if></TR></xsl:when><xsl:otherwise><TR id="ID_Active_TR" name="ID_Active_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><xsl:if test="@LaserLine &gt; 0"><TD><xsl:value-of select="@LightSourceName" /> (
															<xsl:choose><xsl:when test="@LaserLineDouble!=''"><xsl:value-of select="@LaserLineDouble" /></xsl:when><xsl:otherwise><xsl:value-of select="@LaserLine" /></xsl:otherwise></xsl:choose>
															nm)
														</TD><TD><xsl:value-of select="@IntensityShow" /></TD></xsl:if></TR></xsl:otherwise></xsl:choose></xsl:for-each></TABLE></TD></xsl:when></xsl:choose></TR><xsl:if test="$only_sequential != 1"><TR><TD>
						Detectors

						<TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><TD width="10%">
									Name
								</TD><TD>
									Channel
								</TD><TD width="25%">
									Type
								</TD><TD>
									Location
								</TD><TD>
									Active
								</TD><TD>
									Gain
								</TD><TD>
									Offset
								</TD><TD>
									Gate Start
								</TD><TD>
									Gate End
								</TD><TD>
									Gate Ref. Wavelength
								</TD></TR><xsl:for-each select="ATLConfocalSettingDefinition/DetectorList/Detector"><xsl:choose><xsl:when test="@IsActive='0'"><TR name="ID_Inactive_TR" id="ID_Inactive_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD><xsl:value-of select="@Name" /></TD><TD><xsl:value-of select="@ChannelName" /></TD><TD><xsl:value-of select="@Type" />&nbsp;<xsl:value-of select="@Band" />&nbsp;<xsl:if test="@OperatingType='1' "><xsl:if test="@IsReflectionModeActive='0' ">
                            Analog
                          </xsl:if><xsl:if test="@IsReflectionModeActive='1' ">
                            Reflection
                          </xsl:if></xsl:if><xsl:if test="@OperatingType='2' "><!--Analog--><xsl:if test="@AcquisitionMode='0' ">
                            Digital
                          </xsl:if><xsl:if test="@AcquisitionMode='1' ">
                            Counting
                          </xsl:if></xsl:if><xsl:if test="@IsHPDOverloaded='1' ">&nbsp;<font color="red">Overloaded</font></xsl:if></TD><TD><xsl:choose><xsl:when test="@ScanType != ''"><xsl:value-of select="@ScanType" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD><TD><xsl:choose><xsl:when test="@ActiveShow != ''"><xsl:value-of select="@ActiveShow" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD><TD align="right"><xsl:value-of select="@Gain" /></TD><TD align="right"><xsl:choose><xsl:when test="@Type='HyD'"> -- </xsl:when><xsl:otherwise><xsl:value-of select="@Offset" /></xsl:otherwise></xsl:choose></TD><xsl:choose><xsl:when test="@CanDoTimeGate='1' "><xsl:choose><xsl:when test="@IsTimeGateActivated='1' "><TD><xsl:choose><xsl:when test="@TimeGatePulseStart != ''"><xsl:value-of select="@TimeGatePulseStart" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD><TD><xsl:choose><xsl:when test="@TimeGatePulseEnd != ''"><xsl:value-of select="@TimeGatePulseEnd" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD><TD><xsl:choose><xsl:when test="@TimeGateWavelength != ''"><xsl:value-of select="@TimeGateWavelength" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD></xsl:when><xsl:otherwise><TD colspan="3" align="center">
																-- Time Gating not activated --
															</TD></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise><TD colspan="3" align="center" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: gray; padding: 3px;">
														-- Time Gating not supported --
													</TD></xsl:otherwise></xsl:choose></TR></xsl:when><xsl:otherwise><TR id="ID_Active_TR" name="ID_Active_TR" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><TD><xsl:value-of select="@Name" /></TD><TD><xsl:value-of select="@ChannelName" /></TD><TD><xsl:value-of select="@Type" />&nbsp;<xsl:value-of select="@Band" />&nbsp;<xsl:if test="@OperatingType='1' "><xsl:if test="@IsReflectionModeActive='0' ">
                            Analog
                          </xsl:if><xsl:if test="@IsReflectionModeActive='1' ">
                            Reflection
                          </xsl:if></xsl:if><xsl:if test="@OperatingType='2' "><!--Analog--><xsl:if test="@AcquisitionMode='0' ">
                            Digital
                          </xsl:if><xsl:if test="@AcquisitionMode='1' ">
                            Counting
                          </xsl:if></xsl:if><xsl:if test="@IsHPDOverloaded='1' ">&nbsp;<font color="red">Overloaded</font></xsl:if></TD><TD><xsl:choose><xsl:when test="@ScanType != ''"><xsl:value-of select="@ScanType" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD><TD><xsl:choose><xsl:when test="@ActiveShow != ''"><xsl:value-of select="@ActiveShow" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD><TD align="right"><xsl:value-of select="@Gain" /></TD><TD align="right"><xsl:value-of select="@Offset" /></TD><xsl:choose><xsl:when test="@CanDoTimeGate='1' "><xsl:choose><xsl:when test="@IsTimeGateActivated='1' "><TD><xsl:choose><xsl:when test="@TimeGatePulseStart != ''"><xsl:value-of select="@TimeGatePulseStart" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD><TD><xsl:choose><xsl:when test="@TimeGatePulseEnd != ''"><xsl:value-of select="@TimeGatePulseEnd" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD><TD><xsl:choose><xsl:when test="@TimeGateWavelength != ''"><xsl:value-of select="@TimeGateWavelength" /></xsl:when><xsl:otherwise> --- </xsl:otherwise></xsl:choose></TD></xsl:when><xsl:otherwise><TD colspan="3" align="center">
																-- Time Gating not activated --
															</TD></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise><TD colspan="3" align="center" style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: gray; padding: 3px;">
														-- Time Gating not supported --
													</TD></xsl:otherwise></xsl:choose></TR></xsl:otherwise></xsl:choose></xsl:for-each></TABLE></TD></TR></xsl:if></TABLE></xsl:if><xsl:if test="@Name='ProcessingHistory'"><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><B> Processing History: </B></TD></TR><xsl:for-each select="ProcessingHistory"><xsl:choose><xsl:when test="@ProcessingType = 'OnlineDyeSeparation_Target' and contains(@TargetUniqueIDList, /Data/Image/ImageDescription/UniqueID ) "><tr><td><TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><B><xsl:value-of select="@CreationTime" /></B></TD><TD align="left" style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><B> Applied OnlineDyeSeparation parameters </B></TD></TR></TABLE><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td><xsl:copy-of select="TR" /></td></TR></TABLE></TD></TR></TABLE></td></tr><tr><td colspan="2" align="center" border="0" cellspacing="5" cellpadding="5">&nbsp;</td></tr></xsl:when><xsl:when test="@ProcessingType = 'OnlineDyeSeparation_Source' and contains(@SourceUniqueIDList, /Data/Image/ImageDescription/UniqueID ) "><TR bgcolor="#DDDAD7"><TD align="left" style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><B><xsl:value-of select="@CreationTime" /></B></TD><TD align="left" style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><B> Active OnlineDyeSeparation parameters </B></TD></TR><TR align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TD><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td><xsl:copy-of select="TR" /></td></TR></TABLE></TD></TR><tr><td colspan="2" align="center" border="0" cellspacing="5" cellpadding="5">&nbsp;</td></tr></xsl:when><xsl:when test="@ProcessingType = 'Deconvolution_SVIHuygens' and contains(@ProcessingParameters, 'eDeconvolveImage' ) "><TR topmargin="0" leftmargin="0" border="0" bgcolor="#DDDAD7"><TD topmargin="0" leftmargin="0" align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><B><xsl:value-of select="@CreationTime" /></B></TD><TD align="left" style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><B>HyVolution Deconvolution</B></TD></TR><TR border="1" bgcolor="#DDDAD7"><TD colspan="2" border="0" cellspacing="0" cellpadding="0"><TABLE style="display:block;" topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><col width="38.2%" /><col width="61.8%" /><tr style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td>Programm</td><td><a style="font-weight: bold; color: 009b9b" title="Scientific Volume Imaging B.V." href="https://svi.nl/">
													SVI
												</a>&nbsp;<xsl:choose><xsl:when test="contains(@ProcessingParameters, 'Essential')"><a style="color: 009b9b" title="Huygens Essential" href="https://svi.nl/HuygensEssential">Huygens Essential</a></xsl:when><xsl:when test="contains(@ProcessingParameters, 'Pro')"><a style="color: 009b9b" title="Huygens Pro" href="https://svi.nl/HuygensProfessional">Huygens Professional</a></xsl:when><xsl:otherwise>Unknown Programm Parameter</xsl:otherwise></xsl:choose></td></tr><tr style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td>Strategy</td><td><xsl:choose><xsl:when test="contains(@ProcessingParameters, 'HUPP_DECON_FAST')">Fast Computation</xsl:when><xsl:when test="contains(@ProcessingParameters, 'HUPP_DECON_STANDARD')">Standard</xsl:when><xsl:when test="contains(@ProcessingParameters, 'HUPP_DECON_BEST_RESOLUTION')">Best Resolution</xsl:when><xsl:when test="contains(@ProcessingParameters, 'HUPP_DECON_HIGH_SPEED_IMAGING')">High Speed Imaging</xsl:when><xsl:when test="contains(@ProcessingParameters, 'HUPP_DECON_LOW_SIGNAL_CONFOCAL')">Low Signal</xsl:when><xsl:when test="contains(@ProcessingParameters, 'HUPP_DECON_NORMAL_SIGNAL_CONFOCAL')">Normal Signal</xsl:when><xsl:when test="contains(@ProcessingParameters, 'HUPP_DECON_HIGH_SIGNAL_CONFOCAL')">High Signal</xsl:when><xsl:otherwise>Unknown Strategy Parameter</xsl:otherwise></xsl:choose></td></tr><tr style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td>Crop</td><td><xsl:choose><xsl:when test="contains(@ProcessingParameters, 'HUPP_CROP_CONSERVATIVE')">
														Allow auto-crop of image
														<xsl:if test="contains(@ProcessingParameters, 'CROP_OPTION_WAS_IGNORED')"><font style="color=red">&nbsp;(The crop option was ignored!)&nbsp;</font></xsl:if></xsl:when><xsl:when test="contains(@ProcessingParameters, 'HUPP_CROP_NEVER')">No auto-crop</xsl:when><xsl:otherwise>Unknown Crop Parameter</xsl:otherwise></xsl:choose></td></tr><xsl:if test="contains(@ProcessingParameters, 'eStitchImage')"><tr style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td>Merge image after deconvolution</td><td>Active</td></tr></xsl:if></TABLE></TD></TR><tr><td colspan="2" align="center" border="0" cellspacing="5" cellpadding="5">&nbsp;</td></tr></xsl:when><xsl:when test="@ProcessingType = 'Deconvolution_SVIHuygens' and contains(@ProcessingParameters, 'ePushImage' ) "><TR topmargin="0" leftmargin="0" border="0" bgcolor="#DDDAD7"><TD topmargin="0" leftmargin="0" align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><B><xsl:value-of select="@CreationTime" /></B></TD><TD align="left" style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><B>Image received from <a style="color: 009b9b" title="Scientific Volume Imaging B.V." href="https://svi.nl/">SVI</a>&nbsp;Huygens</B></TD></TR><TR border="1" bgcolor="#DDDAD7"><TD colspan="2" border="0" cellspacing="0" cellpadding="0"><TABLE style="display:block;" topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><col width="38.2%" /><col width="61.8%" /><tr style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td>Programm</td><td><a style="font-weight: bold; color: 009b9b" title="Scientific Volume Imaging B.V." href="https://svi.nl/">
													SVI
												</a>&nbsp;<xsl:choose><xsl:when test="contains(@ProcessingParameters, 'Essential')"><a style="color: 009b9b" title="Huygens Essential" href="https://svi.nl/HuygensEssential">Huygens Essential</a></xsl:when><xsl:when test="contains(@ProcessingParameters, 'Pro')"><a style="color: 009b9b" title="Huygens Pro" href="https://svi.nl/HuygensProfessional">Huygens Professional</a></xsl:when><xsl:otherwise>Unknown Programm Parameter</xsl:otherwise></xsl:choose></td></tr></TABLE></TD></TR><tr><td colspan="2" align="center" border="0" cellspacing="5" cellpadding="5">&nbsp;</td></tr></xsl:when><xsl:when test="@ProcessingType = 'Deconvolution_Leica'"><TR topmargin="0" leftmargin="0" border="0" bgcolor="#DDDAD7"><TD topmargin="0" leftmargin="0" align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><B><xsl:value-of select="@CreationTime" /></B></TD><TD align="left" style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><B>Lightning / Thunder</B></TD></TR><TR border="1" bgcolor="#DDDAD7"><TD colspan="2" border="0" cellspacing="0" cellpadding="0"><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><col width="38.2%" /><col width="61.8%" /><xsl:for-each select="DeconvolutionParam"><xsl:sort select="@name" order="ascending" /><tr style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td><xsl:value-of select="@name" /></td><td><xsl:value-of select="@value" /></td></tr></xsl:for-each></TABLE></TD></TR><tr><td colspan="2" align="center" border="0" cellspacing="5" cellpadding="5">&nbsp;</td></tr></xsl:when><xsl:when test="@ProcessingType = 'GenericProcessing'"><TR topmargin="0" leftmargin="0" border="0" bgcolor="#DDDAD7"><TD topmargin="0" leftmargin="0" align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><B><xsl:value-of select="@CreationTime" /></B></TD><TD align="left" style="font-family: arial, helvetica; font-size: 7pt; font-weight: bold; color: 000000; padding: 3px;"><B><xsl:value-of select="@ProcessingParameters" /></B></TD></TR><TR border="1" bgcolor="#DDDAD7"><TD colspan="2" border="0" cellspacing="0" cellpadding="0"><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><col width="38.2%" /><col width="61.8%" /><xsl:for-each select="GenericProcessingParam"><xsl:sort select="@name" order="ascending" /><tr style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td><xsl:value-of select="@name" /></td><td><xsl:value-of select="@value" /></td></tr></xsl:for-each></TABLE></TD></TR><tr><td colspan="2" align="center" border="0" cellspacing="5" cellpadding="5">&nbsp;</td></tr></xsl:when></xsl:choose></xsl:for-each></TABLE></xsl:if><xsl:variable name="climateControlsAvailable"><xsl:value-of select="ATLConfocalSettingDefinition/ClimateControl/@ClimateControlCurrentlyInUse" /></xsl:variable><xsl:if test="$climateControlsAvailable = '1'"><TABLE width="98%" align="center" border="0" cellspacing="5" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 3px;"><b>Environmental Settings</b></TD></TR></TABLE><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5" bgcolor="#DDDAD7"><TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;"><TD colspan="2"><TABLE topmargin="0" leftmargin="0" width="100%" align="center" border="1" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF"><TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;"><TD width="20%"><b>Unit Name </b></TD><TD width="10%"><b>Enabled </b></TD><TD width="12%"><b>Setpoint </b></TD><TD width="12%"><b>Actual Value </b></TD><TD width="10%"><b>Range Control </b></TD><TD width="12%"><b>Minimum Range </b></TD><TD width="12%"><b>Maximum Range </b></TD><TD width="12%"><b>Stop On Alert </b></TD></TR><xsl:for-each select="ATLConfocalSettingDefinition/ClimateControl/ClimateUnit"><xsl:variable name="MyCounter" select="position()-1" /><xsl:variable name="SetpointVal" select="concat(@SetpointValue, '.0')" /><xsl:variable name="SetpointValPointNull" select="@SetpointValue" /><TR style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; padding: 3px;"><TD><xsl:value-of select="@Name" /></TD><TD><xsl:if test="@Enabled != '0'">
											ON
										</xsl:if><xsl:if test="@Enabled = '0'">
											OFF
										</xsl:if></TD><TD><xsl:if test="@SetpointValue*10 mod 10 != 0"><xsl:value-of select="@SetpointValue" /></xsl:if><xsl:if test="@SetpointValue*10 mod 10 = 0"><xsl:value-of select="concat(@SetpointValue, '.0')" /></xsl:if><xsl:value-of select="@DimensionUnit" /></TD><TD><xsl:if test="@ActualValue*10 mod 10 != 0"><xsl:value-of select="@ActualValue" /></xsl:if><xsl:if test="@ActualValue*10 mod 10 = 0"><xsl:value-of select="concat(@ActualValue, '.0')" /></xsl:if><xsl:value-of select="@DimensionUnit" /></TD><TD><xsl:if test="@RangeControlEnabled != '0'">
											ON
										</xsl:if><xsl:if test="@RangeControlEnabled = '0'">
											OFF
										</xsl:if></TD><xsl:if test="@RangeControlEnabled != '0'"><TD><xsl:if test="@RangeMinimumValue*10 mod 10 != 0"><xsl:value-of select="@RangeMinimumValue" /></xsl:if><xsl:if test="@RangeMinimumValue*10 mod 10 = 0"><xsl:value-of select="concat(@RangeMinimumValue, '.0')" /></xsl:if><xsl:value-of select="@DimensionUnit" /></TD><TD><xsl:if test="@RangeMaximumValue*10 mod 10 != 0"><xsl:value-of select="@RangeMaximumValue" /></xsl:if><xsl:if test="@RangeMaximumValue*10 mod 10 = 0"><xsl:value-of select="concat(@RangeMaximumValue, '.0')" /></xsl:if><xsl:value-of select="@DimensionUnit" /></TD><TD><xsl:if test="@RangeControlStopExperimentOnAlert != '0'">
												ON
											</xsl:if><xsl:if test="@RangeControlStopExperimentOnAlert = '0'">
												OFF
											</xsl:if></TD></xsl:if><xsl:if test="@RangeControlEnabled = '0'"><TD>
											-
										</TD><TD>
											-
										</TD><TD>
											-
										</TD></xsl:if></TR></xsl:for-each></TABLE></TD></TR></TABLE></xsl:if><xsl:if test="@Application='Huygens' and node()!='' "><TABLE width="98%" align="center" border="0" cellspacing="0" cellpadding="5"><TR><TD align="left" style="font-family: arial, helvetica; font-size: 8pt; font-weight: normal; color: 000000; padding: 5px; spacing: 5px"><B> SVI Huygens <xsl:value-of select="@Name" /></B></TD></TR><TR border="1" bgcolor="#DDDAD7"><TD colspan="2" border="0" cellspacing="0" cellpadding="0"><TABLE topmargin="0" leftmargin="0" width="100%" align="left" border="1" cellspacing="0" cellpadding="5" bgcolor="#FFFFFF"><tr style="font-family: arial, helvetica; font-size: 7pt; font-weight: normal; color: 000000; padding: 3px;"><td><xsl:copy-of select="node()" /></td></tr></TABLE></TD></TR></TABLE></xsl:if></xsl:template><xsl:template name="booleanToYesNo"><xsl:param name="theBoolValue" /><xsl:choose><xsl:when test="$theBoolValue = '1'">
        yes
      </xsl:when><xsl:otherwise>
        no
      </xsl:otherwise></xsl:choose></xsl:template></xsl:stylesheet>