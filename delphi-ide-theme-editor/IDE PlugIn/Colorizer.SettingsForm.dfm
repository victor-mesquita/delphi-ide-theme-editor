object FormIDEColorizerSettings: TFormIDEColorizerSettings
  Left = 509
  Top = 252
  Caption = 'Delphi IDE Colorizer Settings'
  ClientHeight = 499
  ClientWidth = 468
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Top = 10
  GlassFrame.Bottom = 40
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 468
    Height = 499
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PageControlSettings: TPageControl
      Left = 0
      Top = 0
      Width = 468
      Height = 458
      ActivePage = TabSheetMain
      Align = alClient
      TabOrder = 0
      object TabSheetMain: TTabSheet
        Caption = 'Main Settings'
        object Label1: TLabel
          Left = 3
          Top = 70
          Width = 37
          Height = 13
          Caption = 'Themes'
        end
        object Label7: TLabel
          Left = 154
          Top = 173
          Width = 25
          Height = 13
          Caption = 'Color'
        end
        object Label6: TLabel
          Left = 3
          Top = 173
          Width = 38
          Height = 13
          Caption = 'Element'
        end
        object LabelSetting: TLabel
          Left = 3
          Top = 0
          Width = 59
          Height = 13
          Caption = 'LabelSetting'
        end
        object Image1: TImage
          Left = 3
          Top = 119
          Width = 262
          Height = 25
        end
        object Bevel1: TBevel
          Left = 3
          Top = 248
          Width = 310
          Height = 5
          Shape = bsTopLine
        end
        object Label2: TLabel
          Left = 3
          Top = 229
          Width = 37
          Height = 13
          Caption = 'Options'
        end
        object Label18: TLabel
          Left = 3
          Top = 376
          Width = 45
          Height = 13
          Caption = 'ColorMap'
          Visible = False
        end
        object Label23: TLabel
          Left = 170
          Top = 376
          Width = 24
          Height = 13
          Caption = 'Style'
          FocusControl = StyleCombo
          Visible = False
        end
        object CheckBoxEnabled: TCheckBox
          Left = 379
          Top = 3
          Width = 65
          Height = 17
          Caption = 'Enabled'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 6
          OnClick = CheckBoxEnabledClick
        end
        object cbThemeName: TComboBox
          Left = 3
          Top = 88
          Width = 264
          Height = 21
          TabOrder = 1
          OnChange = cbThemeNameChange
        end
        object Button3: TButton
          Left = 273
          Top = 86
          Width = 75
          Height = 25
          Caption = 'Save'
          TabOrder = 0
          OnClick = Button3Click
        end
        object CbClrElement: TColorBox
          Left = 154
          Top = 192
          Width = 166
          Height = 22
          NoneColorColor = 16729138
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames, cbCustomColors]
          TabOrder = 4
          OnChange = CbClrElementChange
        end
        object BtnSelForColor: TButton
          Left = 326
          Top = 192
          Width = 22
          Height = 22
          ImageIndex = 2
          Images = ImageList1
          TabOrder = 5
          OnClick = BtnSelForColorClick
        end
        object cbColorElements: TComboBox
          Left = 3
          Top = 192
          Width = 145
          Height = 21
          Style = csDropDownList
          TabOrder = 3
          OnChange = cbColorElementsChange
        end
        object CheckBoxAutoColor: TCheckBox
          Left = 3
          Top = 150
          Width = 156
          Height = 17
          Caption = 'Auto Generate Color Values'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object CheckBoxFixIDEDrawIcon: TCheckBox
          Left = 3
          Top = 331
          Width = 254
          Height = 17
          Caption = 'Fix disabled icons draw in IDE Menus and toolbars'
          TabOrder = 7
        end
        object CheckBoxActivateDWM: TCheckBox
          Left = 326
          Top = 393
          Width = 145
          Height = 17
          Caption = 'Activate Glass colorization'
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 8
          Visible = False
        end
        object CheckBoxGutterIcons: TCheckBox
          Left = 3
          Top = 354
          Width = 110
          Height = 17
          Caption = 'Modify Gutter Icons'
          TabOrder = 9
          OnClick = CheckBoxGutterIconsClick
        end
        object ColorMapCombo: TComboBox
          Left = 3
          Top = 391
          Width = 157
          Height = 21
          Style = csDropDownList
          TabOrder = 10
          Visible = False
        end
        object StyleCombo: TComboBox
          Left = 168
          Top = 391
          Width = 145
          Height = 21
          Style = csDropDownList
          TabOrder = 11
          Visible = False
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Addtional controls'
        ImageIndex = 1
        TabVisible = False
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        DesignSize = (
          460
          430)
        object Label4: TLabel
          Left = 3
          Top = 3
          Width = 29
          Height = 13
          Caption = 'Types'
        end
        object Label5: TLabel
          Left = 267
          Top = 3
          Width = 49
          Height = 13
          Caption = 'Properties'
        end
        object ListViewTypes: TListView
          Left = 3
          Top = 23
          Width = 250
          Height = 404
          Anchors = [akLeft, akTop, akBottom]
          Columns = <
            item
              Caption = 'Component'
              Width = 220
            end>
          ReadOnly = True
          RowSelect = True
          TabOrder = 1
          ViewStyle = vsReport
          OnChange = ListViewTypesChange
        end
        object ListViewProps: TListView
          Left = 267
          Top = 22
          Width = 250
          Height = 404
          Anchors = [akLeft, akTop, akBottom]
          Columns = <
            item
              Caption = 'Name'
              Width = 200
            end>
          ReadOnly = True
          RowSelect = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
      object TabSheetVCLStyles: TTabSheet
        Caption = 'VCL Styles'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label9: TLabel
          Left = 3
          Top = 26
          Width = 24
          Height = 13
          Caption = 'Style'
        end
        object CheckBoxUseVClStyles: TCheckBox
          Left = 3
          Top = 3
          Width = 97
          Height = 17
          Caption = 'Use VCL Styles'
          TabOrder = 0
          OnClick = CheckBoxUseVClStylesClick
        end
        object CbStyles: TComboBox
          Left = 3
          Top = 45
          Width = 414
          Height = 21
          Style = csDropDownList
          TabOrder = 1
          OnChange = CbStylesChange
        end
        object PanelPreview: TPanel
          Left = 3
          Top = 88
          Width = 414
          Height = 212
          BevelOuter = bvNone
          TabOrder = 2
        end
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 458
      Width = 468
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object BtnApply: TButton
        Left = 4
        Top = 6
        Width = 75
        Height = 25
        Caption = 'Apply'
        TabOrder = 0
        OnClick = BtnApplyClick
      end
    end
  end
  object ImageList1: TImageList
    ColorDepth = cd32Bit
    Left = 368
    Top = 200
    Bitmap = {
      494C010107000800FC0110001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000003A20108F5D341AB59F5A2DEEB666
      33FFB46633FFB36532FFB16432FFAF6331FFAD6231FFAB6130FFA96030FFA85F
      30FFA75E2FFFA45E2FFE93542AF162381CC40000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000107
      0A37000000000000000000000000000000000000000000000000061E0F88155F
      30F2176935FF155F30F2061E0F88000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C4E27DEEBC5ACFFEAC4ACFFFEFB
      F8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFB
      F8FFFEFBF8FFC8997AFFC79777FF8F5129ED0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001B77
      9AD51F8DB7E90000000C000000000000000000000000061C0E84268B51FF62B9
      8CFF94D2B1FF62B98CFF268B51FF071F108C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B76935FEEDCAB2FFE0A178FFFEFA
      F7FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF
      87FFFDF9F6FFCA8C63FFC99A7AFFA45E2FFE0000000000000000000000000000
      000044964CFF3F9047FF3A8941FF36823CFF317B37FF2D7532FF286F2DFF2469
      29FF216425FF1E6021FF1B5C1EFF18591CFF0000000000000000000000000000
      000C2BADDFFF29AADEFF0A2F408A0000000000000000186434F760B98AFF5EB9
      86FFFFFFFFFF5EB886FF65BB8EFF166332F70000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BA6A36FFEECCB5FFE1A178FFFEFA
      F7FFBEDCC1FFBEDCC1FFBEDCC1FFBEDCC1FFBEDCC1FFBEDCC1FFBEDCC1FFBEDC
      C1FFFDF9F6FFCD8F66FFCC9D80FFA75F30FF0000000000000000000000000000
      00004A9E52FF224A26B31F4623B21D4220B1193E1DAF173A1AAE153517AB1230
      14A8102D12A50D290FA20C260DA11B5D1FFF0000000000000000000000000000
      00001B7293CF4DBBE7FF4AB9E6FF1F8FBDED000101172F794AFF9BD4B5FFFFFF
      FFFFFFFFFFFFFFFFFFFF94D2B1FF176935FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BA6936FFEFCEB7FFE1A177FFFEFA
      F7FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF87FF60BF
      87FFFDF9F6FFCF9268FFCEA283FFA95F30FF00000000000000001A391D9E1836
      1B9E4FA659FF387A3EE335753AE4306E35E22D6932E229632DE1245C29E02259
      25E01E5321DF1A4E1EDE0E2C10A61F6223FF0000000000000000000000000000
      00000000000029AEDFFF83D3F2FF53BCE7FF2CA9DEFF3F835BFC8FD3B0FF91D6
      B0FFFFFFFFFF63BB8BFF65BB8EFF166332F70000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B96834FFEFD0BAFFE2A178FFFEFB
      F8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFBF8FFFEFB
      F8FFFEFBF8FFD3956BFFD2A689FFAA6030FF00000000000000001C3C1F9E070F
      085255AE5FFF326C39CF326B38D3306835D52D6532D62B612FD8275D2BD82356
      27D61F5223D51E5523E0123114AB236828FF0000000000000000000000000000
      00000000000018647FC06ECCEEFF82D2F2FF7CCEF1FF4CA1A5FF5FAA80FF94D4
      B3FFB9E6D0FF68BA8EFF2B8E55FF071F108C0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BA6834FFF0D2BDFFE2A278FFE2A2
      78FFE1A278FFE2A279FFE1A279FFE0A076FFDE9E75FFDD9E74FFDC9C72FFD99A
      70FFD8986FFFD6986EFFD5AA8DFFAC6131FF050B0545040A054528542DB81023
      127D5AB564FF38753FD638763FDA36753CDD34743AE0316E36E02D6A32E12A65
      2FE1245929D7245C28E1153717AF286F2DFF30ABCCF032B5D9F831B2D9F82FB0
      D8F82DADD7F82BABD6F885D7F3FF2DB5EBFF48BBECFF7ECEF1FF53A6ABFF5494
      72FF4D8D64FF38754FF20A1C107C000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BA6834FFF2D5C1FFE3A278FFE3A2
      78FFE2A279FFE2A279FFE2A379FFE1A177FFE0A076FFDE9F75FFDE9D73FFDC9C
      72FFDA9A71FFD99A71FFDAAF94FFAE6231FF050B054500000010234727A40810
      08525EBB69FF2D5A32B82F6235C2316837CA316A38D0306835D32D6633D62E69
      34E0275D2CD528622DE2183C1BB12E7633FF2FA2C1E973DAF2FF92E6F8FF90E3
      F7FF8CE0F6FF89DCF5FF89DBF5FF87D7F4FF83D3F2FF7DCFF1FF7ACCF0FF78C9
      EFFF46B3E3FF1F96C8F500030423000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BA6834FFF2D8C4FFE3A379FFE3A2
      78FFE3A378FFE2A379FFE2A279FFE1A279FFE1A177FFDF9F75FFDE9E74FFDD9D
      72FFDB9B70FFDC9C72FFDDB499FFB06332FF050C06450000000E244928A3070E
      074A62C06DFF2043259C254B2AA929562EB62D5D32C02D6133C72E6233CC306A
      35DB295F2ED02D6932E21B411FB3337E39FF02090A374DCDECFF97E9F9FF48D5
      F3FF43CFF1FF3ECAF0FF36C1EEFF88D9F4FF2CB1DFFE28A6D4F827A3D3F825A1
      D2F8239ED0F8219BCFF81C87B6E9000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BA6934FFF4D9C7FFE6A57BFFC88B
      62FFC98C63FFC98D65FFCB916AFFCB916BFFCA8F67FFC88B63FFC88B62FFC88B
      62FFC88B62FFDA9B72FFE1B99EFFB26432FF060C07450000000D264B2AA3060C
      064465C571FF1428167A19331D8A1D3B2096234726A626502BB229572EBC2E66
      35D129592EC62F6B35DF1E4421B1398740FF0000000034B6D5F47EE1F5FF8DE6
      F8FF41D2F3FF3DCDF1FF37C7EFFF8BDCF5FF56C5EAFF09242E74000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B86934FEF4DCC9FFE7A67BFFF9EC
      E1FFF9ECE1FFF9EDE3FFFCF4EEFFFDFAF7FFFDF7F3FFFAEDE5FFF7E7DBFFF7E5
      D9FFF6E5D8FFDE9F75FFE4BDA3FFB36532FF060D07450000000B284D2CA3050A
      053D488D51D8498E51D9488C50DA468A4EDB43894CDC42864ADD3F8246DD3F85
      46E538783EDC3B8243EB2B5E30CB285B2DCB000000000615195459D4EFFF98EA
      F9FF45D6F4FF40D0F2FF3BCBF0FF6CD5F3FF7DD7F3FF48BFE7FF030F124A0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B36532FAF5DDCCFFE7A77CFFFAF0
      E8FFFAF0E8FFC98C64FFFAF0E9FFFDF8F3FFFEFAF8FFFCF4EFFFF9E9DFFFF7E7
      DBFFF7E5D9FFE0A176FFE7C1A8FFB56633FF070D07450000000A294F2DA20408
      04350409053A050A063F050B0642060C0746060D074A060D074C060F07500D1E
      0E7A050B054A1633189E0000000000000000000000000000000039C0DEF992E9
      F9FF70E1F7FF43D4F3FF3FCEF2FF3AC9F0FF89DCF5FF6ED0EFFF3BBAE4FF0003
      0423000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A55D2EF0F6DFD0FFE8A77CFFFCF6
      F1FFFCF6F1FFC88B62FFFAF1E9FFFBF4EEFFFDFAF7FFFDF9F6FFFAF0E8FFF8E8
      DDFFF7E6DBFFE1A278FFEFD5C2FFB46733FE070E0845000000091A331D821A32
      1D8219311C8218301C82182F1B82172E1982162D1882152B1782142A16821A3A
      1EA01024127E0F22117E0000000000000000000000000000000010353D8362D9
      F1FF99EBFAFF46D8F4FF42D3F3FF3DCEF1FF38C8F0FF8BDCF5FF60CBEDFF2EB3
      DDFC000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000864B25D8F6DFD1FFE9A97EFFFEFA
      F6FFFDFAF6FFC88B62FFFBF3EEFFFBF1EAFFFCF6F2FFFEFBF8FFFCF6F1FFF9EC
      E2FFF8E7DBFFEED0B9FFECD0BCFFB06839F8070E084500000008000000080000
      0008000000080000000800000008000000080000000800000008000000080409
      0445000000000000000000000000000000000000000000000000000000003DC8
      E7FD99EDFAFF98EBF9FF96E8F9FF93E5F8FF90E2F7FF8DDFF6FF8ADBF5FF54C7
      EBFF2BA6CDF30000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004526139BF6E0D1FFF7E0D1FFFEFB
      F8FFFEFBF7FFFDF9F6FFFCF5F0FFFAF0EAFFFBF2EDFFFDF9F6FFFDFAF7FFFBF1
      EBFFF6E7DDFEE4C9B6FBAC744FEC1B0F07630409053704090537040905370408
      0537040804370408043704080437030704370307043703070337030603370306
      0337000000000000000000000000000000000000000000000000000000001953
      5FA23DCCEBFF3CCBEAFF3AC9E9FF39C7E9FF38C3E8FF36C1E7FF34BFE6FF33BC
      E5FF31BAE4FF248EB0E100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000024140A713B211090784321CCA35C
      2DEEB36532FAB86934FEBA6934FFBA6834FFBA6834FFBB6A37FFBC6C39FFBA6B
      38FFA35C30EF764526CB130B0554000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000117130F64926C4EF4B17E54FFAE7C
      50FF946B4BF61E17137300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000019531CFA184C19F10000
      0000000000000000000000000000000000000000000000000000000000000000
      00000600002E2F00067E610018B684002ED57E003BD2550034AE24001B720300
      0221000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000806053D826449E7B18056FFCBAA88FFD1B394FFBA8D
      61FFB48658FFAA754BFF836247EB0A0807460000000000000000000000000000
      000000000000000000000000000000000000113A14C71C5C1FFF000100230000
      00000000000000000000000000000000000000000000000000000000000C3901
      0085BD030AF1E13E57FFEE6183FFF371A0FFF06FB1FFE458B5FFD234B3FF9901
      91E61F00226E0000000200000000000000000000000000000000000000000403
      0F41000000080000000000000000000000000000000000000000000000000000
      000801010E410000000000000000000000000000000000000000000000000000
      00000000001400000008AA7D54FED5BA9EFFD6BA9DFFD3B79BFFD1B293FFB688
      5BFFB98D60FFB78C5FFFB18054FFA5734BFE0000000000000000000000000000
      0000000000000E2D10A1206925FC1F6722FF1E6421FF113A13C5000000000000
      000000000000000000000000000000000000000000000000000E691300AEE950
      3EFFF88483FFFF959EFFFF7290FFFF5E99FFFF5EB6FFFF76D8FFFC91EFFFE86F
      EAFFB530CCFF2B003C910000000500000000000000000000000004040F414D4A
      F2FF3E3CE9FD0000000800000000000000000000000000000000000000082220
      DEFC2F2DEAFF02010E4100000000000000000000000000000001101510635788
      5BF461A168FF5FA067FFB07C50FFE1CDB7FFD8BFA4FFD8BFA6FFD4B99CFFB78B
      5EFFB6895EFFB78C5FFFB98D60FFB07C50FF0000000000000000000000000000
      0000174519C128772CFF66A06DFF69A171FF286F2CFF1F6622FF050F05640206
      024119521CF01B5A1EFF0001002300000000000000004E1B0092F07542FFFCA5
      91FFFF796DFFFF4F56FFFF5877FFFF5C9AFFFF5ABBFFFF55DAFFFF4AF7FFF179
      FFFFD684F1FF9632CFFF1200246F000000000000000005050F415654F5FF615F
      FAFF5653F6FF3E3CE7FC000000080000000000000000000000082928E0FC3F3D
      F1FF4A48F6FF2F2DEAFF02010E41000000000608063D537A57E764A26AFF92BF
      98FF9DC7A3FF6FAB76FFAE7C4FFFE3D0BBFFDAC2AAFFD3B79DFFC7A27BFFC097
      6DFFB5885AFFB6895EFFB98D60FFB07E52FF0000000000000000000000001A4C
      1CC11E7221FF93BF9CFF6AAE81FF4B9D65FF6EAF83FF73A578FF206923FF1F66
      22FF1D5D1FF80613067400000000000000000E07003EF0760AFBFBB88DFFFF96
      68FFFF7759FFFF6F69FFFF7488FFFF7AACFFFF79CDFFFF6FEDFFF761FFFFD950
      FFFFCF7AFFFFB271ECFF4A05ADEB01000322000000000202062B5956F6FF6360
      FAFF6F6EFFFF5754F6FF3F3DE8FC0000000800000008322FE3FC4543F2FF6160
      FFFF4846F4FF2D2BE9FF0100062B00000000619C69FEA8CDAEFFA5CCABFFA1C9
      A8FF98C49EFF69A872FFAD7A4DFFDCC8AFFFBE9E80FFB78C63FFD1B28EFFD1B2
      8EFFBA8F64FFBB9066FFB6895EFFB07C50FF00000000000000000E280F872B8B
      30FF75B481FF4B9D52FF77B28BFF4BA068FF44995EFF6FAF83FF347B37FF216C
      24FF05100564000000000000000000000000603E009EFDBD5EFFFFD09BFFFFA4
      59FFFFA16FFFFF9983FFFF969AFFFF9EBEFFFF9EE0FFFE91FBFFE77AFFFFC964
      FFFFA74DFFFFBD94FDFF703EDDFF0B002D7900000000000000000202062B5957
      F6FF6461FAFF726FFFFF5856F6FF3F3EE8FC3C3AE8FD4E4BF4FF6665FFFF4E4C
      F5FF3432EBFF0101062B000000000000000060A067FFBFDAC4FFACD0B2FFAACE
      B0FF9DC8A5FF6BA974FF94797CFF585FC8FF4E56E3FF4D54E0FF565DC8FF8F76
      83FFBA8F64FFD1B28EFFC5A179FFA6764DFE00000000000000002C8831F560AC
      66FF75BD90FF429F5BFF499E51FF76B38BFF4CA168FF459B60FF6FB084FF689F
      6DFF226F25FF00000012000000000717087CAB8506D5FEDD7EFFFFD16AFFFFC7
      69FFFFC784FFFFC39DFFFFBCB2FFFFBED0FFFFBEF1FFF4AFFFFFD695FFFFB577
      FFFF945CFFFF9875FFFF8163ECFF14026BB70000000000000000000000000202
      062B5A58F6FF6562FAFF7270FFFF716EFFFF6E6CFFFF6C6AFFFF5553F7FF3D3B
      EEFF0101062B0000000000000000000000005E9F66FFC4DEC9FFB3D4B8FFA3C9
      A9FF80AA99FF5F6BC2FF4E56E0FF6466EBFF9292F4FF5F61EAFF5659E4FF4750
      DCFF5E61BDFFA5887DFFC0996FFF655140C800000000000000002F9333F850A8
      57FF6BBB8BFF4BA96EFF409E5AFF4AA152FF82BE95FF4FA26BFF459C61FF88BD
      98FF247528FF227126FE216E25FF206A24FFD7C20CF1FFF28FFFFFE960FFFFE8
      74FFFFE792FFFFE7AFFFFFE6CAFFFFE5E5FFFCDEFDFFE1C5FFFFC1A5FFFFA083
      FFFF7C64FFFF7462FFFF8779F6FF110598D80000000000000000000000000000
      00000202062B5B59F7FF7774FFFF5754FFFF5552FFFF706EFFFF4644F0FF0101
      062B000000000000000000000000000000005B9E63FFB8D6BDFF86B98EFF6FAB
      76FF5157DCFF6468EBFF9795F4FF9090F3FF8889F0FF595DE7FF5D60E9FF5B5F
      E8FF4F56E4FF4752D6FE0A0808430000000A000000001F6222C731A036FF319D
      36FF93CFABFF5AB37CFF4CAB70FF3FA05BFF4CA555FF84C097FF55A771FF85BD
      98FF287C2BFF216D25F40615076D00000000D6D80CF4F9FA91FFFAFD62FFFAFD
      79FFF9FD97FFFAFDB4FFFAFED3FFFAFEEFFFEFF3FFFFD0D5FFFFAEB2FFFF8C90
      FFFF6A6DFFFF6567FFFF8182FBFF06099FDB0000000000000000000000000000
      0000000000085956F2FD7B77FFFF5C59FFFF5956FFFF7472FFFF4340EBFD0000
      000800000000000000000000000000000000629D69FE85B98EFF98C5A1FF72AC
      7AFF4D55E2FFB3B0F9FF9695F4FF9292F4FF8B8CF0FF5A5EE8FF5A5FE7FF5B5F
      E8FF5D60E9FF4D55E2FF030406300000000033A638FA34A939FF144216A22D8A
      33EA4EAC54FF8CCCA4FF5CB47EFF4DAC71FF40A25BFF4FA957FF99CBA8FF8DBE
      94FF27822CFF11291BAF000000000000000097AC0ADBE4F581FFE5FF6DFFE0FF
      77FFE0FF94FFDFFFAEFFDCFFC7FFDCFFE0FFD9FEFAFFC4E9FFFFA6CAFFFF86A9
      FFFF678AFFFF768DFFFF7185FBFF04127BBE0000000000000000000000000000
      0008625FF3FC6E6BFBFF7E7CFFFF7C79FFFF7A77FFFF7775FFFF5C5AF7FF4340
      E9FC0000000800000000000000000000000047604AC87AB384FF74AE7CFF6DAA
      76FF4C52E1FFB3B0F9FF9495F5FF6468EBFF6D6FECFF6C70ECFF585AE5FF5A5F
      E7FF5D60E9FF4F56E2FF0304063000000000309D36F100030123000000000000
      000032A338FE37A43DFF8FCEA7FF60B883FF56B179FF5EB174FF36963CFF2788
      2BFF55A360FF1B3A31DB0000000000000000516A03ADC5EB65FFDDFF9AFFC4FF
      6DFFC2FF8BFFBDFFA0FFB8FFB2FFBCFFCFFFBCFFEEFFAFF8FFFF98DEFFFF7CC1
      FFFF61A2FFFF9DBCFFFF5782F8FF010F418A0000000000000000000000086A67
      F6FC7572FDFF8581FFFF7471FCFF6260F8FF5E5BF7FF6B68FAFF7977FFFF5E5B
      F7FF4441E9FC0000000800000000000000000000000A0507063B0D120D5B6CA7
      75FF4A50E0FFA1A1F4FF686AECFF5F61EAFF9692F7FF9692F7FF6266E9FF6364
      EAFF5A5FE7FF4D55E2FF0304063000000000000000000000000000000000030B
      034134AA3AFF309535F043AB49FF9DD4ACFFA3D7B7FF84C28DFF268E2BFF4DB6
      5DFF96C8A9FF2A8C2FFF29882EFF28842CFF0F1700529FE136FFCBF696FFADFF
      6AFFA3FF78FF9CFF8CFF9AFFA2FFA3FFC3FFA1FFDFFF96FFF8FF84EFFFFF6CD3
      FFFF76C4FFFF91C4FCFF1164E2F6000309320000000000000008706DFAFD7B78
      FEFF8986FFFF7A77FDFF6A67FBFF0202072B0202072B5F5CF8FF6C6AFAFF7B78
      FFFF5F5DF7FF4542EAFC00000005000000000000000000000000000000000000
      00005258D9FE7A7AF2FF9692F7FF6266E9FF5056E3FF5056E3FF6266E9FF9692
      F7FF7A7AF2FF4B54D7FE0202042600000000000000000000000000000000309E
      35F033A638F800000000309935F133A738FF32A437FF32A037FF70C17CFFAEE3
      C1FF5D8B76FF0A150F75000000000000000000000006376704B093E255FFBAF9
      9CFF89FF6CFF77FF74FF81FF96FF88FFB5FF86FFD1FF7CFFECFF6BFBFEFF74E8
      FFFF9ADFFCFF52B9FBFF02274C8E00000000000000000101031F7875FFFF807C
      FFFF807CFEFF726FFDFF0303072B00000000000000000202072B605DF8FF6D6B
      FBFF7C7AFFFF605DF8FF0D0D2D6F000000020000000000000000000000000000
      000045487FC86C6DECFF6466EBFF5D60E9FF7676F0FF7272F0FF5D60E9FF6769
      EBFF6D6FECFF45487DC8000000000000000000000000000000000000000038B6
      3EFF0B250C74000000000000000033A237F82D9231ED1D3429A5357D4AF7319A
      38FE102019890000000000000000000000000000000001030020318C08CF72E1
      56FFA0F698FF9DFFA5FF79FF9DFF6EFFADFF6EFFC7FF7AFFE3FFA4FFFAFF97F4
      FBFF53D8F5FF065D7FB6000001110000000000000000000000000101031F7875
      FFFF7774FEFF0303072B000000000000000000000000000000000202072B625F
      F8FF6866F9FF242269A802010629000000000000000000000000000000000000
      00000000000A06060A3B0D0E175B5F61E3FF4F55E2FF4F55E2FF5D60E3FF0E0F
      195E06060A3B0000000A00000000000000000000000000000000000000000103
      012300000000000000000000000036B13CFF1A541DB201020122081A09652D95
      33F2000000000000000000000000000000000000000000000000010300220E62
      04AF38D73BFF68E67AFF87F3A9FF95F9C3FF96FBD3FF86F7DBFF66EFE0FF18DD
      DCFA034B53980000011200000000000000000000000000000000000000000101
      031F0303072B0000000000000000000000000000000000000000000000000202
      072B11102E6F05050E3E00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000038B63DFF030B0441000000000511065231A1
      36F7000000000000000000000000000000000000000000000000000000000000
      000300160154056218AF0E9A3DDA14C268F414BF7CF10D956FD405584AA20010
      0F45000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000A000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object XPColorMap: TXPColorMap
    HighlightColor = clWhite
    BtnSelectedColor = clBtnFace
    UnusedColor = clWhite
    Left = 289
    Top = 149
  end
  object ColorDialog1: TColorDialog
    Left = 364
    Top = 248
  end
  object TwilightColorMap: TTwilightColorMap
    HighlightColor = clBlack
    FrameBottomRightOuter = clBlack
    BtnFrameColor = clBlack
    DisabledColor = cl3DDkShadow
    Left = 336
    Top = 147
  end
  object StandardColorMap: TStandardColorMap
    HighlightColor = clBtnHighlight
    UnusedColor = 15988985
    MenuColor = clMenu
    SelectedColor = clHighlight
    Left = 384
    Top = 156
  end
end
