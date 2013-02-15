$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'scorm2004/sequencing'

def cm01_xml
  xml = <<EOS
<?xml version = "1.0" standalone = "no"?>
<manifest identifier = "LMSTestPackage_CM-01" version = "1.1.1"
    xmlns = "http://www.imsglobal.org/xsd/imscp_v1p1"
    xmlns:adlcp = "http://www.adlnet.org/xsd/adlcp_v1p3"
    xmlns:adlseq = "http://www.adlnet.org/xsd/adlseq_v1p3"
    xmlns:adlnav = "http://www.adlnet.org/xsd/adlnav_v1p3"
    xmlns:imsss = "http://www.imsglobal.org/xsd/imsss"
    xmlns:xsi = "http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation = "http://www.imsglobal.org/xsd/imscp_v1p1 imscp_v1p1.xsd
                                           http://www.adlnet.org/xsd/adlcp_v1p3 adlcp_v1p3.xsd
                                           http://www.adlnet.org/xsd/adlseq_v1p3 adlseq_v1p3.xsd
                                           http://www.adlnet.org/xsd/adlnav_v1p3 adlnav_v1p3.xsd
                                           http://www.imsglobal.org/xsd/imsss imsss_v1p0.xsd">

   <metadata>
      <schema>ADL SCORM</schema>
      <schemaversion>2004 4th Edition</schemaversion>
   </metadata>

   <organizations default = "CM-01">
      <organization identifier = "CM-01">
         <title>LMS Test Content Package CM-01 </title>
         <item identifier = "activity_1" identifierref = "SEQ01" parameters = "?tc=CM-01&amp;act=1">
            <title>Activity 1</title>
            <imsss:sequencing>
               <imsss:limitConditions attemptAbsoluteDurationLimit="P5Y6M4DT12H30M58S" />
            </imsss:sequencing>
            <adlnav:presentation>
               <adlnav:navigationInterface>
                  <adlnav:hideLMSUI>continue</adlnav:hideLMSUI>
                  <adlnav:hideLMSUI>previous</adlnav:hideLMSUI>
                  <adlnav:hideLMSUI>suspendAll</adlnav:hideLMSUI>
               </adlnav:navigationInterface>
            </adlnav:presentation>
         </item>
         <item identifier = "activity_2" identifierref = "SEQ01" parameters = "?tc=CM-01&amp;act=2">
            <title>Activity 2</title>
            <imsss:sequencing>
               <imsss:objectives>
                  <imsss:primaryObjective satisfiedByMeasure="true">
                     <imsss:minNormalizedMeasure>0.8</imsss:minNormalizedMeasure>
                  </imsss:primaryObjective>
               </imsss:objectives>
            </imsss:sequencing>
            <adlnav:presentation>
               <adlnav:navigationInterface>
                  <adlnav:hideLMSUI>continue</adlnav:hideLMSUI>
                  <adlnav:hideLMSUI>previous</adlnav:hideLMSUI>
                  <adlnav:hideLMSUI>suspendAll</adlnav:hideLMSUI>
               </adlnav:navigationInterface>
            </adlnav:presentation>
         </item>
         <item identifier = "activity_3" identifierref = "SEQ01" parameters = "?tc=CM-01&amp;act=3">
            <title>Activity 3</title>
            <imsss:sequencing>
               <imsss:limitConditions attemptAbsoluteDurationLimit="P5Y6M4DT12H30M58.55S" />
               <imsss:objectives>
                  <imsss:primaryObjective satisfiedByMeasure="true">
                     <imsss:minNormalizedMeasure>0.7</imsss:minNormalizedMeasure>
                  </imsss:primaryObjective>
               </imsss:objectives>
            </imsss:sequencing>
            <adlnav:presentation>
               <adlnav:navigationInterface>
                  <adlnav:hideLMSUI>continue</adlnav:hideLMSUI>
                  <adlnav:hideLMSUI>previous</adlnav:hideLMSUI>
                  <adlnav:hideLMSUI>suspendAll</adlnav:hideLMSUI>
               </adlnav:navigationInterface>
            </adlnav:presentation>
         </item>
         <imsss:sequencing>
            <imsss:controlMode choice = "false" flow = "true"/>
         </imsss:sequencing>
      </organization>
   </organizations>
   <resources>
      <resource identifier="SEQ01" type="webcontent" adlcp:scormType="sco" href="SequencingTest.htm" xml:base="resources/">
         <file href="SequencingTest.htm"/>
         <dependency identifierref="LMSFNCTS01"/>
         <dependency identifierref="JAR01"/>
         <dependency identifierref="ABOUT01"/>
         <dependency identifierref="EMULATION01"/>
         <dependency identifierref="LMSINCLUDE"/>
      </resource>
      <resource identifier="LMSFNCTS01" type="webcontent" adlcp:scormType="asset">
         <file href="common/lmsrtefunctions.js" />
      </resource>
      <resource identifier="JAR01" type="webcontent" adlcp:scormType="asset" xml:base="common/">
         <file href="LMSTest.jar" />
      </resource>
      <resource identifier="ABOUT01" type="webcontent" adlcp:scormType="asset">
         <file href="common/About.js" />
      </resource>
      <resource identifier="EMULATION01" type="webcontent" adlcp:scormType="asset">
         <file href="common/EmulationCode.js" />
         <dependency identifierref="BROWSERDETECT01"/>
      </resource>
      <resource identifier="BROWSERDETECT01" type="webcontent" adlcp:scormType="asset">
         <file href="common/BrowserDetect.js" />
      </resource>
      <resource identifier="LMSINCLUDE" type="webcontent" adlcp:scormType="asset">
         <file href="includes/LMSTestContentPackages_style.css"/>
      </resource>
   </resources>
</manifest>
EOS
end
