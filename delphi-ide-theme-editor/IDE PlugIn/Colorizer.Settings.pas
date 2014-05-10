//**************************************************************************************************
//
// Unit Colorizer.Settings
// unit Colorizer.Settings  for the Delphi IDE Colorizer
//
// The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
// you may not use this file except in compliance with the License. You may obtain a copy of the
// License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
// ANY KIND, either express or implied. See the License for the specific language governing rights
// and limitations under the License.
//
// The Original Code is Colorizer.Settings.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2014 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************aa

unit Colorizer.Settings;

interface

type
  TSettings=class
  private
    FEnableDWMColorization: boolean;
    FEnabled: boolean;
    FThemeName: string;
    FFixIDEDisabledIconsDraw: boolean;
    FAutogenerateColors: boolean;
    FVCLStyleName: string;
    FUseVCLStyles: boolean;
    FChangeIconsGutter: boolean;
//    FStyleBarName: string;
//    FColorMapName: string;
  public
    property EnableDWMColorization : boolean read FEnableDWMColorization write FEnableDWMColorization;
    property Enabled : boolean read FEnabled write FEnabled;
    property ThemeName : string read FThemeName write FThemeName;
    property FixIDEDisabledIconsDraw : boolean read FFixIDEDisabledIconsDraw write FFixIDEDisabledIconsDraw;
    property AutogenerateColors : boolean read FAutogenerateColors write FAutogenerateColors;

    property UseVCLStyles  : boolean read FUseVCLStyles write FUseVCLStyles;
    property VCLStyleName  : string read FVCLStyleName write FVCLStyleName;
    property ChangeIconsGutter  : boolean read FChangeIconsGutter write FChangeIconsGutter;
//    property ColorMapName  : string read FColorMapName write FColorMapName;
//    property StyleBarName  : string read FStyleBarName write FStyleBarName;
  end;

  procedure ReadSettings(Settings: TSettings;Const Path:String);
  procedure WriteSettings(Settings: TSettings;Const Path:String);

implementation


uses
  SysUtils,
  IniFiles;


procedure ReadSettings(Settings: TSettings;Const Path:String);
var
  LIniFile: TIniFile;
begin
  //C:\Users\Public\Documents\RAD Studio\Projects\XE2\delphi-ide-theme-editor\IDE PlugIn\
  LIniFile := TIniFile.Create(IncludeTrailingPathDelimiter(Path) + 'Settings.ini');
  try
    Settings.EnableDWMColorization   := LIniFile.ReadBool('Global', 'EnableDWMColorization', True);
    Settings.Enabled                 := LIniFile.ReadBool('Global', 'Enabled', True);
    Settings.FixIDEDisabledIconsDraw := LIniFile.ReadBool('Global', 'FixIDEDisabledIconsDraw', True);
    Settings.AutogenerateColors      := LIniFile.ReadBool('Global', 'AutogenerateColors', True);
    Settings.ThemeName               := LIniFile.ReadString('Global', 'ThemeName', '');
    Settings.VCLStyleName            := LIniFile.ReadString('Global', 'VCLStyleName', 'Carbon.vsf');
    Settings.UseVCLStyles            := LIniFile.ReadBool('Global', 'UseVCLStyles', False);
    Settings.ChangeIconsGutter       := LIniFile.ReadBool('Global', 'ChangeIconsGutter', True);
//    Settings.ColorMapName            := iniFile.ReadString('Global', 'ColorMapName', 'TXPColorMap');
//    Settings.StyleBarName            := iniFile.ReadString('Global', 'StyleBarName', 'XP Style');
  finally
    LIniFile.Free;
  end;
end;

procedure WriteSettings(Settings: TSettings;Const Path:String);
var
  LIniFile: TIniFile;
begin
  LIniFile := TIniFile.Create(IncludeTrailingPathDelimiter(Path) + 'Settings.ini');
  try
    LIniFile.WriteBool('Global', 'EnableDWMColorization', Settings.EnableDWMColorization);
    LIniFile.WriteBool('Global', 'Enabled', Settings.Enabled);
    LIniFile.WriteBool('Global', 'FixIDEDisabledIconsDraw', Settings.FixIDEDisabledIconsDraw);
    LIniFile.WriteBool('Global', 'AutogenerateColors', Settings.AutogenerateColors);
    LIniFile.WriteString('Global', 'ThemeName', Settings.ThemeName);
    LIniFile.WriteString('Global', 'VCLStyleName', Settings.VCLStyleName);
    LIniFile.WriteBool('Global', 'UseVCLStyles', Settings.UseVCLStyles);
    LIniFile.WriteBool('Global', 'ChangeIconsGutter', Settings.ChangeIconsGutter);
//    iniFile.WriteString('Global', 'ColorMapName', Settings.ColorMapName);
//    iniFile.WriteString('Global', 'StyleBarName', Settings.StyleBarName);
  finally
    LIniFile.Free;
  end;
end;

end.
