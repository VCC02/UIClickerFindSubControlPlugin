{
    Copyright (C) 2025 VCC
    creation date: 18 Feb 2025
    initial release date: 23 Mar 2025

    author: VCC
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
    OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}


unit FindSubControlPluginProperties;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ClickerUtils;


const
  CPropertiesCount = 4;

  COperationModePropertyIndex = 0;
  CPlatformIndexPropertyIndex = 1;
  CDeviceIndexPropertyIndex = 2;
  CFindSubControlActionPropertiesVarPropertyIndex = 3;

  COperationModePropertyName = 'OperationMode';   //omGetCapabilities, omExecute
  CPlatformIndexPropertyName = 'PlatformIndex';
  CDeviceIndexPropertyName = 'DeviceIndex';
  CFindSubControlActionPropertiesVarPropertyName = 'FindSubControlActionPropertiesVar';

  COperationMode_GetCapabilities_Name = 'omGetCapabilities';
  COperationMode_Execute_Name = 'omExecute';

  CRequiredPropertyNames: array[0..CPropertiesCount - 1] of string = (  //these are the expected property names, configured in plugin properties
    COperationModePropertyName,
    CPlatformIndexPropertyName,
    CDeviceIndexPropertyName,
    CFindSubControlActionPropertiesVarPropertyName
  );

  //property details: (e.g. enum options, hints, icons, menus, min..max spin intervals etc)

  //See TOIEditorType datatype from ObjectInspectorFrame.pas, for valid values
  CRequiredPropertyTypes: array[0..CPropertiesCount - 1] of string = (
    'EnumCombo', //OperationMode
    'SpinText', //PlatformIndex
    'SpinText', //DeviceIndex
    'TextWithArrow' //CFindSubControlActionPropertiesVar
  );

  CRequiredPropertyDataTypes: array[0..CPropertiesCount - 1] of string = (
    CDTEnum, //OperationMode
    CDTInteger, //PlatformIndex
    CDTInteger, //DeviceIndex
    CDTString  //FindSubControlActionPropertiesVar
  );

  CPluginEnumCounts: array[0..CPropertiesCount - 1] of Integer = (
    2, //OperationMode
    0, //PlatformIndex
    0, //DeviceIndex
    0  //FindSubControlActionPropertiesVar
  );

  CPluginEnumStrings: array[0..CPropertiesCount - 1] of string = (
    COperationMode_GetCapabilities_Name + #4#5 + COperationMode_Execute_Name + #4#5, //OperationMode
    '', //PlatformIndex
    '', //DeviceIndex
    ''  //FindSubControlActionPropertiesVar
  );

  CPluginHints: array[0..CPropertiesCount - 1] of string = (
    'OperationMode should be used for getting platform and device capabilities (when set to omGetCapabilities).' + #4#5 + 'Then in a subsequent action, it should be used for executing the FindSubControl operation (set to omExecute).', //OperationMode
    'Index of the OpenCL platform, where the target device is.', //CurrentTextVarName
    'Index of the OpenCL device, where the FindSubControl action is executed.', //DeviceIndex
    'Name of a variable, set to the list of properties and their values, from the FindSubControl action, which this plugin replaces.' + #4#5 + 'The action does not have to exist in the current template, but it is easier to get its properties, by calling $GetActionProperties()$ from a SetVar action.' + #4#5 + 'In that case, the list of properties and their values, is found in the $ActionPropertiesResult$ variable.' + #4#5 + 'The FindSubControl action should be disabled, to avoid being called automatically at template execution.' //FindSubControlActionPropertiesVar
  );

  CPropertyEnabled: array[0..CPropertiesCount - 1] of string = (  // The 'PropertyValue[<index>]' replacement uses indexes from the following array only. It doesn't count fixed properties.
    '', //OperationMode                        // If empty string, the property is unconditionally enabled. For available operators, see CComp constans in ClickerUtils.pas.
    'PropertyValue[0]==omExecute', //PlatformIndex
    'PropertyValue[0]==omExecute', //TextToBeTypedVarName
    ''  //FindSubControlActionPropertiesVar
  );

  CPluginDefaultValues: array[0..CPropertiesCount - 1] of string = (
    'omExecute', //OperationMode
    '0', //PlatformIndex
    '0', //TextToBeTypedVarName
    '$ActionPropertiesResult$'      //FindSubControlActionPropertiesVar
  );


function FillInPropertyDetails: string;


implementation


uses
  ClickerActionPlugins;


function FillInPropertyDetails: string;
var
  i: Integer;
begin
  Result := '';

  for i := 0 to CPropertiesCount - 1 do
    Result := Result + CRequiredPropertyNames[i] + '=' + CRequiredPropertyTypes[i] + #8#7 +
                       CPluginPropertyAttr_DataType + '=' + CRequiredPropertyDataTypes[i] + #8#7 +
                       CPluginPropertyAttr_EnumCounts + '=' + IntToStr(CPluginEnumCounts[i]) + #8#7 +
                       CPluginPropertyAttr_EnumStrings + '=' + CPluginEnumStrings[i] + #8#7 +
                       CPluginPropertyAttr_Hint + '=' + CPluginHints[i] + #8#7 +
                       CPluginPropertyAttr_Enabled + '=' + CPropertyEnabled[i] + #8#7 +
                       CPluginPropertyAttr_DefaultValue + '=' + CPluginDefaultValues[i] + #8#7 +
                       #13#10;
end;

end.

