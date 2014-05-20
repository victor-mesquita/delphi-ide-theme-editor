//**************************************************************************************************
//
// Unit Colorizer.Hooks
// unit Colorizer.Hooks for the Delphi IDE Colorizer
//
// The contents of this file are subject to the Mozilla Public License Version 1.1 (the "License");
// you may not use this file except in compliance with the License. You may obtain a copy of the
// License at http://www.mozilla.org/MPL/
//
// Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF
// ANY KIND, either express or implied. See the License for the specific language governing rights
// and limitations under the License.
//
// The Original Code is Colorizer.Hooks.pas.
//
// The Initial Developer of the Original Code is Rodrigo Ruz V.
// Portions created by Rodrigo Ruz V. are Copyright (C) 2011-2014 Rodrigo Ruz V.
// All Rights Reserved.
//
//**************************************************************************************************

unit Colorizer.Hooks;

interface
{$I ..\Common\Jedi.inc}

 procedure InstallColorizerHooks;
 procedure RemoveColorizerHooks;


implementation

uses
{$IFDEF DELPHIXE2_UP}
  Vcl.Styles,
  Vcl.Themes,
{$ELSE}
  Themes,
  UxTheme,
{$ENDIF}
  Messages,
  Controls,
  Forms,
  IOUtils,
  ExtCtrls,
  Dialogs,
  ComCtrls,
  Windows,
  Classes,
 {$IFDEF DELPHI2009_UP}
  Generics.Collections,
 {$ENDIF}
  uDelphiVersions,
  uDelphiIDEHighlight,
  SysUtils,
  Graphics,
  ImgList,
  CommCtrl,
  JclDebug,
  PngImage,
  Colorizer.Utils,
  CaptionedDockTree,
  GraphUtil,
  CategoryButtons,
  ActnPopup,
  ActnMan,
  StdCtrls,
  DDetours;

type
 TWinControlClass        = class(TWinControl);
 TCustomPanelClass       = class(TCustomPanel);
 TCustomStatusBarClass   = class(TCustomStatusBar);
 TDockCaptionDrawerClass = class(TDockCaptionDrawer);
{$IFDEF DELPHIXE2_UP}
 TUxThemeStyleClass      = class(TUxThemeStyle);
{$ENDIF}
 TCustomFormClass        = class(TCustomForm);
 TBrushClass             = class(TBrush);
 TCustomListViewClass    = class(TCustomListView);
 TSplitterClass          = class(TSplitter);
 TButtonControlClass     = class(TButtonControl);
 TCustomCheckBoxClass    = class(TCustomCheckBox);
 TRadioButtonClass       = class(TRadioButton);

var
  {$IF CompilerVersion<27} //XE6
  TrampolineCustomImageList_DoDraw     : procedure(Self: TObject; Index: Integer; Canvas: TCanvas; X, Y: Integer; Style: Cardinal; Enabled: Boolean) = nil;
  {$IFEND}
  Trampoline_TCanvas_FillRect          : procedure(Self: TCanvas;const Rect: TRect) = nil;
  Trampoline_TCustomStatusBar_WMPAINT  : procedure(Self: TCustomStatusBarClass; var Message: TWMPaint) = nil;
  Trampoline_TDockCaptionDrawer_DrawDockCaption      : function (Self : TDockCaptionDrawerClass;const Canvas: TCanvas; CaptionRect: TRect; State: TParentFormState): TDockCaptionHitTest =nil;
  {$IFDEF DELPHIXE6_UP}
  Trampoline_ModernDockCaptionDrawer_DrawDockCaption : function (Self : TDockCaptionDrawerClass;const Canvas: TCanvas; CaptionRect: TRect; State: TParentFormState): TDockCaptionHitTest =nil;
  {$ENDIF}
  {$IFDEF DELPHIXE2_UP}
  Trampoline_TStyleEngine_HandleMessage    : function(Self: TStyleEngine; Control: TWinControl; var Message: TMessage; DefWndProc: TWndMethod): Boolean = nil;
  Trampoline_TUxThemeStyle_DoDrawElement   : function (Self : TUxThemeStyle;DC: HDC; Details: TThemedElementDetails; const R: TRect; ClipRect: PRect = nil): Boolean = nil;
  {$ELSE}
  Trampoline_TUxTheme_DrawElement          : procedure (Self : TThemeServices;DC: HDC; Details: TThemedElementDetails; const R: TRect; ClipRect: TRect);
  Trampoline_DrawThemeBackground           : function(hTheme: UxTheme.HTHEME; hdc: HDC; iPartId, iStateId: Integer; const pRect: TRect; pClipRect: PRECT): HRESULT; stdcall = nil;
  {$ENDIF}
  Trampoline_TCustomListView_HeaderWndProc : procedure (Self:TCustomListView;var Message: TMessage) = nil;
  Trampoline_ProjectTree2PaintText         : procedure(Self : TObject; Sender: TObject{TBaseVirtualTree}; const TargetCanvas: TCanvas; Node: {PVirtualNode}Pointer; Column: Integer{TColumnIndex}; TextType: Byte {TVSTTextType})=nil;
  Trampoline_DrawText                      : function (hDC: HDC; lpString: LPCWSTR; nCount: Integer;  var lpRect: TRect; uFormat: UINT): Integer; stdcall = nil;
  Trampoline_GetSysColor                   : function (nIndex: Integer): DWORD; stdcall = nil;

  Trampoline_TCategoryButtons_DrawCategory : procedure(Self :TCategoryButtons; const Category: TButtonCategory; const Canvas: TCanvas; StartingPos: Integer) = nil;
  //Trampoline_TBitmap_SetSize : procedure(Self : TBitmap;AWidth, AHeight: Integer) = nil;
  Trampoline_TCustomPanel_Paint            : procedure (Self : TCustomPanelClass) = nil;
  //Trampoline_TPopupActionBar_GetStyle      : function(Self: TPopupActionBar) : TActionBarStyle = nil;
  Trampoline_TSplitter_Paint               : procedure (Self : TSplitterClass) = nil;

  Trampoline_CustomComboBox_WMPaint        : procedure(Self: TCustomComboBox;var Message: TWMPaint) = nil;
  Trampoline_TButtonControl_WndProc        : procedure (Self:TButtonControlClass;var Message: TMessage) = nil;

  Trampoline_DrawFrameControl              : function (DC: HDC; Rect: PRect; uType, uState: UINT): BOOL; stdcall = nil;

  FGutterBkColor : TColor = clNone;

type
  TPopupActionBarHelper = class helper for TPopupActionBar
  public
    function GetStyleAddress: Pointer;
  end;

  TCustomStatusBarHelper = class helper for TCustomStatusBar
  private
    function GetCanvasRW: TCanvas;
    procedure SetCanvasRW(const Value: TCanvas);
  public
    function  WMPaintAddress: Pointer;
    procedure DoUpdatePanels(UpdateRects, UpdateText: Boolean);
    property  CanvasRW : TCanvas read GetCanvasRW Write SetCanvasRW;
   end;

  TCustomFormHelper = class helper for TCustomForm
  public
    function  SetVisibleAddress: Pointer;
   end;

  TCustomListViewHelper = class helper for TCustomListView
  public
    function  HeaderWndProcAddress: Pointer;
    function  GetHeaderHandle: HWND;
   end;

  TCategoryButtonsHelper = class helper for TCategoryButtons
  public
    function  DrawCategoryAddress: Pointer;
    procedure GetCategoryBoundsHelper(const Category: TButtonCategory; const StartingPos: Integer; var CategoryBounds, ButtonBounds: TRect);
    procedure AdjustCategoryBoundsHelper(const Category: TButtonCategory; var CategoryBounds: TRect; IgnoreButtonFlow: Boolean = False);
    function  GetChevronBoundsHelper(const CategoryBounds: TRect): TRect;
    function  FSideBufferSizeHelper : Integer;
    function  FHotButtonHelper: TButtonItem;
    function  FDownButtonHelper: TButtonItem;
   end;

  TCustomComboBoxBarHelper = class helper for TCustomComboBox
  public
    function  WMPaintAddress: Pointer;
  end;

var
   ListBrush : TObjectDictionary<TObject, TBrush>;


function CustomDrawFrameControl(DC: HDC; Rect: PRect; uType, uState: UINT): BOOL; stdcall;
var
 LCanvas : TCanvas;
 OrgHWND : HWND;
 LWinControl : TWinControl;
begin
   if( uType=DFC_BUTTON) {and (uState=DFCS_BUTTONCHECK)} then
   begin
      if (DFCS_BUTTONCHECK and uState = DFCS_BUTTONCHECK) then
      begin
        LWinControl:=nil;
        OrgHWND :=WindowFromDC(DC);
        if OrgHWND<>0 then
           LWinControl :=FindControl(OrgHWND);

        if LWinControl<>nil then
          AddLog('LWinControl '+LWinControl.ClassName);


        LCanvas:=TCanvas.Create;
        try
          LCanvas.Handle:=DC;

         if (DFCS_CHECKED and uState = DFCS_CHECKED) then
         begin
           //AddLog('CustomDrawFrameControl checked')
          LCanvas.Brush.Color:= TColorizerLocalSettings.ColorMap.MenuColor;
          LCanvas.Pen.Color  :=TColorizerLocalSettings.ColorMap.FontColor;
          LCanvas.Rectangle(Rect^);

          DrawCheck(LCanvas, Point(Rect^.Left+3, Rect^.Top+6), 2, False);
         end
         else
         begin
           //AddLog('CustomDrawFrameControl unchecked');
          LCanvas.Brush.Color:=TColorizerLocalSettings.ColorMap.MenuColor;
          LCanvas.Pen.Color  :=TColorizerLocalSettings.ColorMap.FontColor;
          LCanvas.Rectangle(Rect^);
         end;


        finally
          LCanvas.Handle:=0;
          LCanvas.Free;
        end;
        Exit(True);
      end
      else
        Exit(Trampoline_DrawFrameControl(DC, Rect, uType, uState));
   end;
   Exit(Trampoline_DrawFrameControl(DC, Rect, uType, uState));
end;

//procedure CustomSetSize(Self : TBitmap;AWidth, AHeight: Integer);
//var
//  sCaller : string;
//  i : integer;
//begin
//   //if (nIndex=COLOR_WINDOWTEXT) then
//   begin
//      for i := 2 to 5 do
//      begin
//         sCaller := ProcByLevel(i);
//         AddLog('CustomSetSize', Format('%d AWidth %d AHeight %d %s',[i, AWidth, AHeight, sCaller]));
//      end;
//      AddLog('CustomSetSize', Format('%s',['---------------']));
//   end;
//
// Trampoline_TBitmap_SetSize(Self, AWidth, AHeight);
//end;

function RectVCenter(var R: TRect; Bounds: TRect): TRect;
begin
  OffsetRect(R, -R.Left, -R.Top);
  OffsetRect(R, 0, (Bounds.Height - R.Height) div 2);
  OffsetRect(R, Bounds.Left, Bounds.Top);

  Result := R;
end;

procedure CustomButtonControlWndProc(Self : TButtonControlClass;var Message: TMessage);
//
//  function GetDrawState(State: TCheckBoxState): TThemedButton;
//  begin
//    Result := tbButtonDontCare;
//
//    if not Self.Enabled then
//      case State of
//        cbUnChecked: Result := tbCheckBoxUncheckedDisabled;
//        cbChecked: Result := tbCheckBoxCheckedDisabled;
//        cbGrayed: Result := tbCheckBoxMixedDisabled;
//      end
////    else if Pressed and MouseInControl then
////      case State of
////        cbUnChecked: Result := tbCheckBoxUncheckedPressed;
////        cbChecked: Result := tbCheckBoxCheckedPressed;
////        cbGrayed: Result := tbCheckBoxMixedPressed;
////      end
////    else if MouseInControl then
////      case State of
////        cbUnChecked: Result := tbCheckBoxUncheckedHot;
////        cbChecked: Result := tbCheckBoxCheckedHot;
////        cbGrayed: Result := tbCheckBoxMixedHot;
////      end
//    else
//      case State of
//        cbUnChecked: Result := tbCheckBoxUncheckedNormal;
//        cbChecked: Result := tbCheckBoxCheckedNormal;
//        cbGrayed: Result := tbCheckBoxMixedNormal;
//      end;
//  end;
//
//  function GetRightAlignment: Boolean;
//  begin
//    Result := (Self.BiDiMode = bdRightToLeft) or
//              (GetWindowLong(Self.Handle, GWL_STYLE) and BS_RIGHTBUTTON = BS_RIGHTBUTTON);
//  end;
//
//  procedure DrawControlText(Canvas: TCanvas; Details: TThemedElementDetails;
//    const S: string; var R: TRect; Flags: Cardinal);
//  var
//    TextFormat: {$IFDEF DELPHIXE2_UP} TTextFormatFlags {$ELSE} Cardinal{$ENDIF};
//  begin
//    Canvas.Font := TWinControlClass(Self).Font;
//    TextFormat := {$IFDEF DELPHIXE2_UP}TTextFormatFlags(Flags){$ELSE} Flags {$ENDIF};
//    Canvas.Font.Color := TColorizerLocalSettings.ColorMap.FontColor;
//    StyleServices.DrawText(Canvas.Handle, Details, S, R, TextFormat, Canvas.Font.Color);
//  end;
//
//  procedure Paint(Canvas: TCanvas);
//  var
//     State: TCheckBoxState;
//     Details: TThemedElementDetails;
//     R: TRect;
//     Spacing: Integer;
//     BoxSize: TSize;
//     LCaption: string;
//     FWordWrap: Boolean;
//     LRect: TRect;
//     ElementSize: TElementSize;
//  begin
//    if StyleServices.Available then
//    begin
//      State := TCheckBoxState(SendMessage(Self.Handle, BM_GETCHECK, 0, 0));
//      Details := StyleServices.GetElementDetails(GetDrawState(State));
//
//      if TButtonControl(Self) is TCustomCheckBox then
//        FWordWrap :=  TCustomCheckBoxClass(Self).WordWrap
//      else
//      if TButtonControl(Self) is TRadioButton then
//        FWordWrap :=  TRadioButtonClass(Self).WordWrap
//      else
//        FWordWrap := False;
//
//      Spacing := 3;
//      LRect := Classes.Rect(0, 0, 20, 20);
//      ElementSize := esActual;
//      R := Self.ClientRect;
//      with StyleServices do
//        if not GetElementSize(Canvas.Handle, GetElementDetails(tbCheckBoxCheckedNormal),
//           LRect, ElementSize, BoxSize) then
//        begin
//          BoxSize.cx := 13;
//          BoxSize.cy := 13;
//        end;
//
//      if not GetRightAlignment then
//      begin
//        R := Rect(0, 0, BoxSize.cx, BoxSize.cy);
//        RectVCenter(R, Rect(0, 0, Self.Width, Self.Height));
//      end
//      else
//      begin
//        R := Rect(Self.Width - BoxSize.cx - 1, 0, Self.Width, Self.Height);
//        RectVCenter(R, Rect(Self.Width - BoxSize.cy - 1, 0, Self.Width, Self.Height));
//      end;
//
//      StyleServices.DrawElement(Canvas.Handle, Details, R);
//      Canvas.Font := TWinControlClass(Self).Font;
//
//      R := Rect(0, 0, Self.Width - BoxSize.cx - 10, Self.Height);
//      LCaption := Self.Caption; //Text;
//      if FWordWrap then
//        DrawText(Canvas.Handle, PWideChar(LCaption), Length(LCaption), R, Self.DrawTextBiDiModeFlags(DT_CALCRECT or DT_EXPANDTABS or DT_WORDBREAK))
//      else
//        DrawText(Canvas.Handle, PWideChar(LCaption), Length(LCaption), R, Self.DrawTextBiDiModeFlags(DT_CALCRECT or DT_EXPANDTABS));
//
//      if not GetRightAlignment then
//        RectVCenter(R, Rect(BoxSize.cx + Spacing, 0, Self.Width, Self.Height))
//      else
//       begin
//         if Self.BiDiMode <> bdRightToLeft then
//           RectVCenter(R, Rect(3, 0, Self.Width - BoxSize.cx - Spacing, Self.Height))
//         else
//           RectVCenter(R, Rect(Self.Width - BoxSize.cx - Spacing - R.Right, 0, Self.Width - BoxSize.cx - Spacing, Self.Height));
//       end;
//
//      if FWordWrap then
//        DrawControlText(Canvas, Details, LCaption, R, Self.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER or DT_EXPANDTABS or DT_WORDBREAK))
//      else
//        DrawControlText(Canvas, Details, LCaption, R, Self.DrawTextBiDiModeFlags(DT_LEFT or DT_VCENTER or DT_EXPANDTABS));
//
//      if Self.Focused then
//      begin
//        InflateRect(R, 2, 1);
//        if R.Top < 0 then
//          R.Top := 0;
//        if R.Bottom > Self.Height then
//          R.Bottom := Self.Height;
//        Canvas.Brush.Color := StyleServices.GetSystemColor(clBtnFace);
//        Canvas.DrawFocusRect(R);
//      end;
//    end;
//  end;
//
//  procedure PaintBackground(Canvas: TCanvas);
//  var
//    Details:  TThemedElementDetails;
//  begin
//    if StyleServices.Available then
//    begin
//      Details.Element := teButton;
//      if StyleServices.HasTransparentParts(Details) then
//          StyleServices.DrawParentBackground(Self.Handle, Canvas.Handle, Details, False);
//    end;
//  end;

var
  DC: HDC;
  SaveIndex: Integer;
  Canvas: TCanvas;
  PS: TPaintStruct;
  TempResult: LRESULT;
  LBrush : TBrush;
  LParentForm : TCustomForm;
begin
//  if TButtonControl(Self) is TCustomCheckBox then
//  begin
//    case Message.Msg of
//      BM_SETCHECK,
//      WM_LBUTTONDBLCLK,
//      WM_LBUTTONUP,
//      WM_LBUTTONDOWN :
//      begin
//        SendMessage(Self.Handle, WM_SETREDRAW, LPARAM(False), 0);
//        Trampoline_TButtonControl_WndProc(Self, Message);
//        SendMessage(Self.Handle, WM_SETREDRAW, LPARAM(True), 0);
//        InvalidateRect(Self.Handle, nil, False);
//      end;
//
//      WM_ERASEBKGND:
//      begin
//        DC := HDC(Message.WParam);
//        SaveIndex := SaveDC(DC);
//        Canvas := TCanvas.Create;
//        try
//          Canvas.Handle := DC;
//          PaintBackground(Canvas);
////          if FPaintOnEraseBkgnd then
////            Paint(Canvas);
//        finally
//          Canvas.Handle := 0;
//          Canvas.Free;
//          RestoreDC(DC, SaveIndex);
//        end;
//        Message.Result := 1;
//      end;
//
//      WM_MOUSEMOVE :
//      begin
//        InvalidateRect(Self.Handle, nil, False);
//
//      end;
//
//      WM_PAINT :
//      begin
//
//        DC := HDC(Message.WParam);
//        Canvas := TCanvas.Create;
//        try
//          if DC <> 0 then
//            Canvas.Handle := DC
//          else
//            Canvas.Handle := BeginPaint(Self.Handle, PS);
//           Paint(Canvas);
//           // paint other controls
//           if Self is TWinControl then
//              TWinControlClass(Self).PaintControls(Canvas.Handle, nil);
//
//          if DC = 0 then
//            EndPaint(Self.Handle, PS);
//        finally
//          Canvas.Handle := 0;
//          Canvas.Free;
//        end;
//
//      end
//      else
//       Trampoline_TButtonControl_WndProc(Self, Message)
//    end
//  end
//  else

  if (TButtonControl(Self) is TCustomCheckBox) and Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled and not (csDesigning in Self.ComponentState) then
  begin
    LParentForm:= GetParentForm(Self);
    if not (Assigned(LParentForm) and Assigned(TColorizerLocalSettings.HookedWindows) and (TColorizerLocalSettings.HookedWindows.IndexOf(LParentForm.ClassName)>=0)) then
    begin
      Trampoline_TButtonControl_WndProc(Self, Message);
      exit;
    end;

    case Message.Msg of

//      WM_CTLCOLORMSGBOX .. WM_CTLCOLORSTATIC:
//      begin
//
//        TempResult := SendMessage(Self.Handle, CM_BASE + Message.Msg, Message.wParam, Message.lParam);
//        Message.Result := SendMessage(Message.lParam, CM_BASE + Message.Msg, Message.wParam, Message.lParam);
//        if Message.Result = 0 then
//          Message.Result := TempResult;
//        Exit;
//      end;

//      CM_CTLCOLORMSGBOX .. CM_CTLCOLORSTATIC:
//      WM_CTLCOLORMSGBOX .. WM_CTLCOLORSTATIC:
        CN_CTLCOLORSTATIC:
        begin
          if not ListBrush.ContainsKey(Self) then
             ListBrush.Add(Self, TBrush.Create);

          LBrush:=ListBrush.Items[Self];
          LBrush.Color:=TColorizerLocalSettings.ColorMap.Color;

          //AddLog('CN_CTLCOLORSTATIC');
          SetTextColor(Message.wParam, ColorToRGB(TColorizerLocalSettings.ColorMap.FontColor));
          //SetBkColor(Message.wParam, ColorToRGB(FBrush.Color));
          SetBkColor(Message.wParam, ColorToRGB(LBrush.Color));
          //SetBkMode(Message.wParam, TRANSPARENT);
          Message.Result :=  {LRESULT(GetStockObject(NULL_BRUSH)); //}LRESULT(LBrush.Handle);
          Exit;
        end;
    else
       Trampoline_TButtonControl_WndProc(Self, Message);
    end;
  end
  else
   Trampoline_TButtonControl_WndProc(Self, Message);
end;


type
  TCustomComboBoxClass = class(TCustomComboBox);
//Hook for combobox
procedure CustomWMPaintComboBox(Self: TCustomComboBoxClass;var Message: TWMPaint);
var
   FListHandle : HWND;
   FEditHandle : HWND;
  function GetButtonRect: TRect;
  begin
    Result := Self.ClientRect;
    InflateRect(Result, -2, -2);
    if Self.BiDiMode <> bdRightToLeft then
      Result.Left := Result.Right - GetSystemMetrics(SM_CXVSCROLL) + 1
    else
      Result.Right := Result.Left + GetSystemMetrics(SM_CXVSCROLL) - 1;
  end;

  procedure DrawItem(Canvas: TCanvas; Index: Integer; const R: TRect; Selected: Boolean);
  var
    DIS: TDrawItemStruct;
  begin
    FillChar(DIS, SizeOf(DIS), #0);
    DIS.CtlType := ODT_COMBOBOX;
    DIS.CtlID := GetDlgCtrlID(Self.Handle);
    DIS.itemAction := ODA_DRAWENTIRE;
    DIS.hDC := Canvas.Handle;
    DIS.hwndItem := Self.Handle;
    DIS.rcItem := R;
    DIS.itemID := Index;
    DIS.itemData := SendMessage(FListHandle, LB_GETITEMDATA, 0, 0);
    if Selected then
      DIS.itemState := DIS.itemState or ODS_FOCUS or ODS_SELECTED;

    SendMessage(Self.Handle, WM_DRAWITEM, Self.Handle, LPARAM(@DIS));
  end;

  procedure PaintBorder(Canvas: TCanvas);
  var
    R, ControlRect, EditRect, ListRect: TRect;
    DrawState: TThemedComboBox;
    BtnDrawState: TThemedComboBox;
    Details: TThemedElementDetails;
    Buffer: TBitmap;
  begin
    if not StyleServices.Available then Exit;

    if not Self.Enabled then
      BtnDrawState := tcDropDownButtonDisabled
    else if Self.DroppedDown then
      BtnDrawState := tcDropDownButtonPressed
//    else if Self.FMouseOnButton then
//      BtnDrawState := tcDropDownButtonHot
    else
      BtnDrawState := tcDropDownButtonNormal;

    if not Self.Enabled then
      DrawState := tcBorderDisabled
    else
    if Self.Focused then
      DrawState := tcBorderFocused
//    else if MouseInControl then
//      DrawState := tcBorderHot
    else
      DrawState := tcBorderNormal;

    Buffer := TBitMap.Create;
    Buffer.SetSize(Self.Width, Self.Height);
    try
      R := Rect(0, 0, Buffer.Width, Buffer.Height);
      // draw border + client in buffer
      Details := StyleServices.GetElementDetails(DrawState);

      if (Self.Style = csSimple) and (FListHandle <> 0) then
      begin
        GetWindowRect(FListHandle, ListRect);
        GetWindowRect(Self.Handle, ControlRect);
        R.Bottom := ListRect.Top - ControlRect.Top;

        Buffer.Canvas.Pen.Color:=TColorizerLocalSettings.ColorMap.FrameTopLeftOuter;
        Buffer.Canvas.Brush.Style:=bsClear;
        Buffer.Canvas.Rectangle(R);

        R := Rect(0, Self.Height - (ControlRect.Bottom - ListRect.Bottom), Self.Width, Self.Height);
        with Buffer.Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := TColorizerLocalSettings.ColorMap.MenuColor;
          FillRect(R);
        end;
        R := Rect(0, 0, Buffer.Width, Buffer.Height);
        R.Bottom := ListRect.Top - ControlRect.Top;
      end
      else
      begin
        Buffer.Canvas.Brush.Style:=bsSolid;
        Buffer.Canvas.Pen.Color:=TColorizerLocalSettings.ColorMap.FrameTopLeftOuter;
        Buffer.Canvas.Brush.Color:=TColorizerLocalSettings.ColorMap.MenuColor;
        Buffer.Canvas.Rectangle(R);
      end;

      // draw button in buffer
      if Self.Style <> csSimple then
      begin
        R:=GetButtonRect;
        Buffer.Canvas.Brush.Style:=bsSolid;
        Buffer.Canvas.Pen.Color:=TColorizerLocalSettings.ColorMap.FrameTopLeftOuter;
        Buffer.Canvas.Brush.Color:=TColorizerLocalSettings.ColorMap.MenuColor;
        Buffer.Canvas.Rectangle(R);

        Buffer.Canvas.Pen.Color:=TColorizerLocalSettings.ColorMap.FontColor;
        DrawArrow(Buffer.Canvas,TScrollDirection.sdDown, Point( R.Left + (R.Width Div 2)-4 , R.Top + (R.Height Div 2) - 2) ,4);
      end;

      if (SendMessage(Self.Handle, CB_GETCURSEL, 0, 0) >= 0) and (FEditHandle = 0) then
      begin
        R := Self.ClientRect;
        InflateRect(R, -3, -3);
        R.Right := GetButtonRect.Left - 2;
        ExcludeClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
      end
      else
      if FEditHandle <> 0 then
      begin
        GetWindowRect(Self.Handle, R);
        GetWindowRect(FEditHandle, EditRect);
        OffsetRect(EditRect, -R.Left, -R.Top);
        with EditRect do
          ExcludeClipRect(Canvas.Handle, Left, Top, Right, Bottom);
      end;

      Canvas.Draw(0, 0, Buffer);
    finally
      Buffer.Free;
    end;
  end;

var
  R: TRect;
  Canvas: TCanvas;
  PS: TPaintStruct;
  SaveIndex: Integer;
  DC: HDC;
  LComboBoxInfo: TComboBoxInfo;
  LParentForm  : TCustomForm;
begin
  if Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled and not (csDesigning in Self.ComponentState) then
  begin
    LParentForm:= GetParentForm(Self);
    if not (Assigned(LParentForm) and Assigned(TColorizerLocalSettings.HookedWindows) and (TColorizerLocalSettings.HookedWindows.IndexOf(LParentForm.ClassName)>=0)) then
    begin
      Trampoline_CustomComboBox_WMPaint(Self, Message);
      exit;
    end;

    FillChar(LComboBoxInfo, Sizeof(LComboBoxInfo), #0);
    GetComboBoxInfo(Self.Handle, LComboBoxInfo);
    FListHandle:= LComboBoxInfo.hwndList;
    FEditHandle:= LComboBoxInfo.hwndItem;

    DC := TMessage(Message).WParam;
    Canvas := TCanvas.Create;
    try
      if DC = 0 then
        Canvas.Handle := BeginPaint(Self.Handle, PS)
      else
        Canvas.Handle := DC;

      SaveIndex := SaveDC(Canvas.Handle);
      try
        PaintBorder(Canvas);
      finally
        RestoreDC(Canvas.Handle, SaveIndex);
      end;

      if (Self.Style <> csSimple) and (FEditHandle = 0) then
      begin
        R := Self.ClientRect;
        InflateRect(R, -3, -3);
        if Self.BiDiMode <> bdRightToLeft then
          R.Right := GetButtonRect.Left - 1
        else
          R.Left := GetButtonRect.Right + 1;
        SaveIndex := SaveDC(Canvas.Handle);
        try
          IntersectClipRect(Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom);
          DrawItem(Canvas, Self.ItemIndex, R, Self.Focused);
        finally
          RestoreDC(Canvas.Handle, SaveIndex);
        end;
      end;

    finally
      Canvas.Handle := 0;
      Canvas.Free;
      if DC = 0 then
        EndPaint(Self.Handle, PS);
    end;
  end
  else
     Trampoline_CustomComboBox_WMPaint(Self, Message);
end;
//begin
//
//  Trampoline_CustomComboBox_WMPaint(Self, Message);
//end;

//don't use this, check for another workaround
//function CustomGetStyle(Self: TPopupActionBar) : TActionBarStyle;
//begin
//  if Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled and  Assigned(TColorizerLocalSettings.ActionBarStyle) then
//    Exit(TColorizerLocalSettings.ActionBarStyle)
//  else
//   Exit(Trampoline_TPopupActionBar_GetStyle(Self));
//end;


//hook for TSplitter
procedure CustomSplitterPaint(Self : TSplitterClass);
var
  R: TRect;
  LParentForm : TCustomForm;
begin
  if Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled and not (csDesigning in Self.ComponentState) then
  begin

    LParentForm:= GetParentForm(Self);
    if not (Assigned(LParentForm) and Assigned(TColorizerLocalSettings.HookedWindows) and (TColorizerLocalSettings.HookedWindows.IndexOf(LParentForm.ClassName)>=0)) then
    begin
      Trampoline_TSplitter_Paint(Self);
      exit;
    end;

    R := Self.ClientRect;
    Self.Canvas.Brush.Color := TColorizerLocalSettings.ColorMap.Color;
    Self.Canvas.FillRect(Self.ClientRect);

    if Assigned(Self.OnPaint) then Self.OnPaint(Self);
  end
  else
    Trampoline_TSplitter_Paint(Self);
end;

//Hook for TPanel, draw flat border.
procedure CustomPanelPaint(Self : TCustomPanelClass);
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
  VerticalAlignments: array[TVerticalAlignment] of Longint = (DT_TOP, DT_BOTTOM, DT_VCENTER);
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
  BaseColor, BaseTopColor, BaseBottomColor: TColor;
  Flags: Longint;
  LParentForm : TCustomForm;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := BaseTopColor;
    if Bevel = bvLowered then
      TopColor := BaseBottomColor;
    BottomColor := BaseBottomColor;
    if Bevel = bvLowered then
      BottomColor := BaseTopColor;
  end;

begin
  if Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled and not (csDesigning in Self.ComponentState) then
  begin

    LParentForm:= GetParentForm(Self);
    if not (Assigned(LParentForm) and Assigned(TColorizerLocalSettings.HookedWindows) and (TColorizerLocalSettings.HookedWindows.IndexOf(LParentForm.ClassName)>=0)) then
    begin
      Trampoline_TCustomPanel_Paint(Self);
      exit;
    end;

    Rect := Self.GetClientRect;

    BaseColor       := TColorizerLocalSettings.ColorMap.Color;
    BaseTopColor    := TColorizerLocalSettings.ColorMap.FrameTopLeftOuter;
    BaseBottomColor := TColorizerLocalSettings.ColorMap.FrameTopLeftOuter;

    if Self.BevelOuter <> bvNone then
    begin
      AdjustColors(Self.BevelOuter);
      Frame3D(Self.Canvas, Rect, TopColor, BottomColor, Self.BevelWidth);
    end;

    if (csParentBackground in Self.ControlStyle) then
      Frame3D(Self.Canvas, Rect, BaseColor, BaseColor, Self.BorderWidth)
    else
      InflateRect(Rect, -Integer(Self.BorderWidth), -Integer(Self.BorderWidth));

    if Self.BevelInner <> bvNone then
    begin
      AdjustColors(Self.BevelInner);
      Frame3D(Self.Canvas, Rect, TopColor, BottomColor, Self.BevelWidth);
    end;

    with Self.Canvas do
    begin
      if not Self.ParentBackground then
      begin
        Brush.Color := BaseColor;
        FillRect(Rect);
      end;

      if Self.ShowCaption and (Self.Caption <> '') then
      begin
        Brush.Style := bsClear;
        Font := Self.Font;
        Flags := DT_EXPANDTABS or DT_SINGLELINE or
          VerticalAlignments[Self.VerticalAlignment] or Alignments[Self.Alignment];
        Flags := Self.DrawTextBiDiModeFlags(Flags);
        DrawText(Handle, Self.Caption, -1, Rect, Flags);
      end;
    end;

  end
  else
   Trampoline_TCustomPanel_Paint(Self);
end;



{ TPopupActionBarHelper }

function TPopupActionBarHelper.GetStyleAddress: Pointer;
var
  MethodAddr: function : TActionBarStyle  of object;
begin
  MethodAddr := Self.GetStyle;
  Result     := TMethod(MethodAddr).Code;
end;

{ TCustomStatusBarHelper }

procedure TCustomStatusBarHelper.DoUpdatePanels(UpdateRects,
  UpdateText: Boolean);
begin
  Self.UpdatePanels(UpdateRects, UpdateText);
end;

function TCustomStatusBarHelper.GetCanvasRW: TCanvas;
begin
 Result:= Self.FCanvas;
end;

procedure TCustomStatusBarHelper.SetCanvasRW(const Value: TCanvas);
begin
 Self.FCanvas:= Value;
end;

function TCustomStatusBarHelper.WMPaintAddress: Pointer;
var
  MethodAddr: procedure(var Message: TWMPaint) of object;
begin
  MethodAddr := Self.WMPaint;
  Result     := TMethod(MethodAddr).Code;
end;


{ TCustomComboBoxBarHelper }

function TCustomComboBoxBarHelper.WMPaintAddress: Pointer;
var
  MethodAddr: procedure(var Message: TWMPaint) of object;
begin
  MethodAddr := Self.WMPaint;
  Result     := TMethod(MethodAddr).Code;
end;


{ TCustomFormHelper }

function TCustomFormHelper.SetVisibleAddress: Pointer;
var
  MethodAddr: procedure(Value: Boolean) of object;
begin
  MethodAddr := Self.SetVisible;
  Result     := TMethod(MethodAddr).Code;
end;

{ TCustomListViewHelper }

function TCustomListViewHelper.GetHeaderHandle: HWND;
begin
  Result:=Self.FHeaderHandle;
end;

function TCustomListViewHelper.HeaderWndProcAddress: Pointer;
var
  MethodAddr: procedure(var Message: TMessage) of object;
begin
  MethodAddr := Self.HeaderWndProc;
  Result     := TMethod(MethodAddr).Code;
end;

{ TCategoryButtonsHelper }

function TCategoryButtonsHelper.DrawCategoryAddress: Pointer;
var
  MethodAddr: procedure(const Category: TButtonCategory; const Canvas: TCanvas; StartingPos: Integer) of object;
begin
  MethodAddr := Self.DrawCategory;
  Result     := TMethod(MethodAddr).Code;
end;

procedure TCategoryButtonsHelper.GetCategoryBoundsHelper(
  const Category: TButtonCategory; const StartingPos: Integer;
  var CategoryBounds, ButtonBounds: TRect);
begin
 Self.GetCategoryBounds(Category, StartingPos, CategoryBounds, ButtonBounds);
end;

procedure TCategoryButtonsHelper.AdjustCategoryBoundsHelper(const Category: TButtonCategory; var CategoryBounds: TRect; IgnoreButtonFlow: Boolean = False);
begin
 Self.AdjustCategoryBounds(Category, CategoryBounds, IgnoreButtonFlow);
end;

function  TCategoryButtonsHelper.GetChevronBoundsHelper(const CategoryBounds: TRect): TRect;
begin
 Result := Self.GetChevronBounds(CategoryBounds);
end;

function  TCategoryButtonsHelper.FSideBufferSizeHelper : Integer;
begin
 Result:= Self.FSideBufferSize;
end;

function  TCategoryButtonsHelper.FHotButtonHelper: TButtonItem;
begin
 Result:= Self.FHotButton;
end;

function  TCategoryButtonsHelper.FDownButtonHelper: TButtonItem;
begin
 Result:= Self.FDownButton;
end;

type
 TCategoryButtonsClass = class(TCategoryButtons);
procedure CustomDrawCategory(Self :TCategoryButtonsClass; const Category: TButtonCategory; const Canvas: TCanvas; StartingPos: Integer);
const
  cDropDownSize = 13;

  procedure DrawDropDownButton(X, Y: Integer; Collapsed: Boolean);
  const
    ChevronDirection: array[Boolean] of TScrollDirection = (sdDown, sdRight);
    ChevronXPosAdjust: array[Boolean] of Integer = (2, 0);
    ChevronYPosAdjust: array[Boolean] of Integer = (1, 3);

    procedure DrawPlusMinus;
    var
      Width, Height: Integer;
    begin
      Width := 9;
      Height := Width;
      Inc(X, 2);
      Inc(Y, 2);

      Canvas.Pen.Color   := TColorizerLocalSettings.ColorMap.FontColor;
      Canvas.Brush.Color := TColorizerLocalSettings.ColorMap.Color;
      Canvas.Rectangle(X, Y, X + Width, Y + Height);
      Canvas.Pen.Color   := TColorizerLocalSettings.ColorMap.FontColor;

      Canvas.MoveTo(X + 2, Y + Width div 2);
      Canvas.LineTo(X + Width - 2, Y + Width div 2);

      if Collapsed then
      begin
        Canvas.MoveTo(X + Width div 2, Y + 2);
        Canvas.LineTo(X + Width div 2, Y + Width - 2);
      end;
    end;

  begin
      DrawPlusMinus;
  end;
var
  I: Integer;
  ButtonTop, ButtonLeft, ButtonRight: Integer;
  ButtonRect: TRect;
  ActualWidth: Integer;
  ButtonStart: Integer;
  ButtonBottom: Integer;
  CapWidth: Integer;
  VerticalCaption: Boolean;
  CapLeft: Integer;
  DrawState: TButtonDrawState;
  Button: TButtonItem;
  CatHeight: Integer;
  CategoryBounds, CategoryFrameBounds,
  ButtonBounds, ChevronBounds: TRect;
  GradientColor, SourceColor, TempColor: TColor;
  Caption: string;
  CaptionRect: TRect;
  CategoryRealBounds: TRect;

begin
  if SameText(Self.ClassName, 'TIDECategoryButtons') and Assigned(TColorizerLocalSettings.ColorMap) then
  begin
    Self.GetCategoryBoundsHelper(Category, StartingPos, CategoryBounds, ButtonBounds);

    if (Self.SelectedItem = Category) and (Self.SelectedButtonColor <> clNone) then
      SourceColor := TColorizerLocalSettings.ColorMap.SelectedColor//Self.SelectedButtonColor
    else if Category.Color <> clNone then
      SourceColor := TColorizerLocalSettings.ColorMap.Color//Category.Color
    else
      SourceColor := TColorizerLocalSettings.ColorMap.MenuColor;//Self.Color;

    CategoryFrameBounds := CategoryBounds;
    Self.AdjustCategoryBoundsHelper(Category, CategoryFrameBounds);
    if boCaptionOnlyBorder in Self.ButtonOptions then
      CategoryRealBounds := CategoryFrameBounds
    else
      CategoryRealBounds := CategoryBounds;

    if (Self.SelectedItem <> Category) and (boGradientFill in Self.ButtonOptions) then
    begin
      if Category.GradientColor <> clNone then
        GradientColor := TColorizerLocalSettings.ColorMap.MenuColor//Category.GradientColor
      else
        GradientColor := TColorizerLocalSettings.ColorMap.MenuColor;//Self.Color;

      GradientFillCanvas(Canvas, SourceColor, GradientColor, CategoryRealBounds, Self.GradientDirection);
    end
    else
    begin
      Canvas.Brush.Color := SourceColor;
      Canvas.FillRect(CategoryRealBounds)
    end;

    with CategoryRealBounds do
    begin
      Right := Right - 1;
      TempColor := TColorizerLocalSettings.ColorMap.MenuColor;//Self.Color;

      Canvas.Pixels[Left, Top] := TempColor;
      Canvas.Pixels[Left+1, Top] := TempColor;
      Canvas.Pixels[Left, Top+1] := TempColor;

      Canvas.Pixels[Left, Bottom] := TempColor;
      Canvas.Pixels[Left+1, Bottom] := TempColor;
      Canvas.Pixels[Left, Bottom-1] := TempColor;

      if Self.BackgroundGradientColor <> clNone then
        TempColor := Self.BackgroundGradientColor;

      Canvas.Pixels[Right, Top] := TempColor;
      Canvas.Pixels[Right-1, Top] := TempColor;
      Canvas.Pixels[Right, Top+1] := TempColor;

      Canvas.Pixels[Right, Bottom] := TempColor;
      Canvas.Pixels[Right-1, Bottom] := TempColor;
      Canvas.Pixels[Right, Bottom-1] := TempColor;

      Canvas.Pen.Color := TColorizerLocalSettings.ColorMap.FrameTopLeftOuter;//GetShadowColor(SourceColor, -10);

      Canvas.Polyline([Point(Left + 2, Top),
        Point(Right - 2, Top), { Top line }
        Point(Right, Top + 2), { Top right curve }
        Point(Right, Bottom - 2), { Right side line }
        Point(Right - 2, Bottom), { Bottom right curve }
        Point(Left + 2, Bottom), { Bottom line }
        Point(Left, Bottom - 2), { Bottom left curve }
        Point(Left, Top + 2), { Left side line }
        Point(Left + 2, Top)]); { Top left curve }
    end;

    if ((Category.Collapsed) and (Self.SelectedItem <> nil) and
       (Self.CurrentCategory = Category)) or (Self.SelectedItem = Category) then
    begin
      Canvas.Brush.Color := TColorizerLocalSettings.ColorMap.FrameTopLeftOuter;//GetShadowColor(SourceColor, -75);
      with CategoryFrameBounds do
        Canvas.FrameRect(Rect(Left + 1, Top + 1, Right, Bottom));
    end;

    ChevronBounds := Self.GetChevronBoundsHelper(CategoryRealBounds);

    if (Category.Items <> nil) and (Category.Items.Count > 0) then
      DrawDropDownButton(ChevronBounds.Left, ChevronBounds.Top,
        Category.Collapsed);

    VerticalCaption := Self.HasVerticalCaption(Category);

    { Draw the category caption. Truncating and vertical as needed. }
    Caption := Category.Caption;

    if (boBoldCaptions in Self.ButtonOptions) then
      Canvas.Font.Style := Canvas.Font.Style + [fsBold];

    CapWidth := Canvas.TextWidth(Caption);
    if VerticalCaption then
      CatHeight := CategoryBounds.Bottom - CategoryBounds.Top - 3 - cDropDownSize
    else
      CatHeight := CategoryBounds.Right - CategoryBounds.Left - 2 - cDropDownSize;

    CapLeft := (CatHeight - CapWidth) div 2;
    if CapLeft < 2 then
      CapLeft := 2;


    Canvas.Brush.Style := bsClear;
    Canvas.Font.Color := TColorizerLocalSettings.ColorMap.FontColor;//Category.TextColor;

    if not VerticalCaption then
    begin
      CaptionRect.Left := CategoryBounds.Left + 4 + cDropDownSize;
      CaptionRect.Top := CategoryBounds.Top + 1;
    end
    else
    begin
      CaptionRect.Left := CategoryBounds.Left + 1;
      CaptionRect.Top := CategoryBounds.Bottom - CapLeft;
      Canvas.Font.Orientation := 900;
    end;

    CaptionRect.Right := CaptionRect.Left + CatHeight;
    CaptionRect.Bottom := CaptionRect.Top + Canvas.TextHeight(Caption);
    Canvas.TextRect(CaptionRect, Caption, [tfNoClip, tfEndEllipsis]);

    if (boBoldCaptions in Self.ButtonOptions) then
      Canvas.Font.Style := Canvas.Font.Style - [fsBold];

    Canvas.Brush.Style := bsSolid;
    Canvas.Font.Orientation := 0;

    if not Category.Collapsed and (Category.Items <> nil) then
    begin
      { Draw the buttons }
      if (Self.ButtonFlow = cbfVertical) and (boFullSize in Self.ButtonOptions) then
        ActualWidth := Self.ClientWidth - Self.FSideBufferSizeHelper
      else
        ActualWidth := Self.ButtonWidth;

      ButtonStart := ButtonBounds.Left;
      ButtonTop := ButtonBounds.Top;
      ButtonLeft := ButtonStart;
      for I := 0 to Category.Items.Count - 1 do
      begin
        { Don't waste time painting clipped things }
        if (Self.ButtonFlow = cbfVertical) and (ButtonTop > Self.ClientHeight) then
          Break;

        ButtonBottom := ButtonTop + Self.ButtonHeight;
        ButtonRight := ButtonLeft + ActualWidth;
        if VerticalCaption and not (boCaptionOnlyBorder in Self.ButtonOptions) then
          Dec(ButtonRight, 3);
        if (ButtonBottom >= 0) and (ButtonRight >= 0) then
        begin
          ButtonRect := Rect(ButtonLeft, ButtonTop, ButtonRight, ButtonBottom);

          Button := Category.Items[I];
          DrawState := [];
          if Button = Self.FHotButtonHelper then
          begin
            Include(DrawState, bdsHot);
            if Button = Self.FDownButtonHelper then
              Include(DrawState, bdsDown);
          end;
          if Button = Self.SelectedItem then
            Include(DrawState, bdsSelected)
          else if (Button = Self.FocusedItem) and Self.Focused and (Self.FDownButtonHelper = nil) then
            Include(DrawState, bdsFocused);

//          if Button = FInsertTop then
//            Include(DrawState, bdsInsertTop)
//          else if Button = FInsertBottom then
//            Include(DrawState, bdsInsertBottom)
//          else if Button = FInsertRight then
//            Include(DrawState, bdsInsertRight)
//          else if Button = FInsertLeft then
//            Include(DrawState, bdsInsertLeft);

          Self.DrawButton(Button, Canvas, ButtonRect, DrawState);
        end;
        Inc(ButtonLeft, ActualWidth);

        if (ButtonLeft + ActualWidth) > ButtonBounds.Right then
        begin
          ButtonLeft := ButtonStart;
          Inc(ButtonTop, Self.ButtonHeight);
        end;
      end;
    end;

  end
  else
  Trampoline_TCategoryButtons_DrawCategory(Self, Category, Canvas, StartingPos);
end;

{$IF CompilerVersion<27} //XE6

procedure Bitmap2GrayScale(const BitMap: TBitmap);
type
  TRGBArray = array[0..32767] of TRGBTriple;
  PRGBArray = ^TRGBArray;
var
  x, y, Gray: Integer;
  Row       : PRGBArray;
begin
  BitMap.PixelFormat := pf24Bit;
  for y := 0 to BitMap.Height - 1 do
  begin
    Row := BitMap.ScanLine[y];
    for x := 0 to BitMap.Width - 1 do
    begin
      Gray             := (Row[x].rgbtRed + Row[x].rgbtGreen + Row[x].rgbtBlue) div 3;
      Row[x].rgbtRed   := Gray;
      Row[x].rgbtGreen := Gray;
      Row[x].rgbtBlue  := Gray;
    end;
  end;
end;

function GetRGBColor(Value: TColor): DWORD;
begin
  Result := ColorToRGB(Value);
  case Result of
    clNone    :  Result := CLR_NONE;
    clDefault :  Result := CLR_DEFAULT;
  end;
end;


type
  TCustomImageListClass = class(TCustomImageList);

procedure CustomImageListHack_DoDraw(Self: TObject; Index: Integer; Canvas: TCanvas; X, Y: Integer; Style: Cardinal; Enabled: Boolean);
var
  MaskBitMap : TBitmap;
  GrayBitMap : TBitmap;
  LImageList : TCustomImageListClass;
begin
  if Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled then
    begin
      LImageList:=TCustomImageListClass(Self);
      if not LImageList.HandleAllocated then Exit;
      if Enabled then
        ImageList_DrawEx(LImageList.Handle, Index, Canvas.Handle, X, Y, 0, 0, GetRGBColor(LImageList.BkColor), GetRGBColor(LImageList.BlendColor), Style)
      else
      begin
        GrayBitMap := TBitmap.Create;
        MaskBitMap := TBitmap.Create;
        try
          GrayBitMap.SetSize(LImageList.Width, LImageList.Height);
          MaskBitMap.SetSize(LImageList.Width, LImageList.Height);
          LImageList.GetImages(Index, GrayBitMap, MaskBitMap);
          Bitmap2GrayScale(GrayBitMap);
          BitBlt(Canvas.Handle, X, Y, LImageList.Width, LImageList.Height, MaskBitMap.Canvas.Handle, 0, 0, SRCERASE);
          BitBlt(Canvas.Handle, X, Y, LImageList.Width, LImageList.Height, GrayBitMap.Canvas.Handle, 0, 0, SRCINVERT);
        finally
          GrayBitMap.Free;
          MaskBitMap.Free;
        end;
      end;
    end
  else
    TrampolineCustomImageList_DoDraw(Self, Index, Canvas, X, Y, Style, Enabled);
end;
{$IFEND}

//Retuns the current Gutter color , using the background of the current syntax highlighter
function GetGutterBkColor : TColor;
var
  ATheme : TIDETheme;
  sColor : string;
begin
  if FGutterBkColor<>clNone then
   Result:=FGutterBkColor
  else
  begin
    if Assigned(TColorizerLocalSettings.IDEData) then
    begin
      ImportDelphiIDEThemeFromReg(ATheme, TColorizerLocalSettings.IDEData.Version, False);
      sColor:=ATheme[LineNumber].BackgroundColorNew;
      try
        Result:=StringToColor(sColor);
      except
        if Assigned(TColorizerLocalSettings.ColorMap) then
         Result:=TColorizerLocalSettings.ColorMap.Color
        else
         Result:=clBtnFace;
      end;
      FGutterBkColor:=Result;
    end
    else
    if Assigned(TColorizerLocalSettings.ColorMap) then
      Result:=TColorizerLocalSettings.ColorMap.Color
    else
      Result:=clBtnFace
  end;
end;

//Hook for paint the gutter of the TEditControl and the bacgrounf of the TGradientTabSet component
procedure  CustomFillRect(Self: TCanvas;const Rect: TRect);
var
  sCaller : string;
begin
   if Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled and Assigned(TColorizerLocalSettings.ColorMap) and  (Self.Brush.Color=clBtnFace) then
   begin
     sCaller := ProcByLevel(1);
     if SameText(sCaller, 'EditorControl.TCustomEditControl.EVFillGutter') then
        Self.Brush.Color:=GetGutterBkColor
     else
      if SameText(sCaller, 'GDIPlus.GradientTabs.TGradientTabSet.DrawTabsToMemoryBitmap') then
        Self.Brush.Color:=TColorizerLocalSettings.ColorMap.Color;
   end;
   Trampoline_TCanvas_FillRect(Self, Rect);
end;

//Hook for paint the header of the TVirtualStringTree component
{$IFDEF DELPHIXE2_UP}
function CustomDrawElement(Self : TUxThemeStyle;DC: HDC; Details: TThemedElementDetails; const R: TRect; ClipRect:PRect = nil): Boolean;
const
  HP_HEADERITEMRIGHT = 3;
var
  sCaller : string;
  LCanvas : TCanvas;
  SaveIndex: Integer;
begin

   if Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled and Assigned(TColorizerLocalSettings.ColorMap) and (Details.Element = teHeader) {and (Details.Part=HP_HEADERITEMRIGHT) } then
   begin
    sCaller := ProcByLevel(2);
    if SameText(sCaller, 'IDEVirtualTrees.TVirtualTreeColumns.PaintHeader') then
    begin
       SaveIndex := SaveDC(DC);
       LCanvas:=TCanvas.Create;
       try
         LCanvas.Handle:=DC;
          GradientFillCanvas(LCanvas, TColorizerLocalSettings.ColorMap.Color, TColorizerLocalSettings.ColorMap.HighlightColor, R, gdVertical);
          LCanvas.Brush.Style:=TBrushStyle.bsClear;
          LCanvas.Pen.Color:=TColorizerLocalSettings.ColorMap.FrameTopLeftInner;
          LCanvas.Rectangle(R);
       finally
          LCanvas.Handle:=0;
          LCanvas.Free;
          RestoreDC(DC, SaveIndex);
       end;

       exit(True);
    end;
   end;
   Result:=Trampoline_TUxThemeStyle_DoDrawElement(Self, DC, Details, R, ClipRect);
end;
{$ELSE}
procedure CustomDrawElement(Self : TThemeServices;DC: HDC; Details: TThemedElementDetails; const R: TRect; ClipRect: TRect);
const
  HP_HEADERITEMRIGHT = 3;
var
  sCaller : string;
  LCanvas : TCanvas;
  SaveIndex: Integer;
begin
   //TFile.AppendAllText('C:\Delphi\google-code\DITE\delphi-ide-theme-editor\IDE PlugIn\CustomDrawElementXE.txt', Format('%s',['CustomDrawElement']));
   if Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled and Assigned(TColorizerLocalSettings.ColorMap) and (Details.Element = teHeader) {and (Details.Part=HP_HEADERITEMRIGHT) } then
   begin
    sCaller := ProcByLevel(2);
    if SameText(sCaller, 'IDEVirtualTrees.TVirtualTreeColumns.PaintHeader') then
    begin
       SaveIndex := SaveDC(DC);
       LCanvas:=TCanvas.Create;
       try
         LCanvas.Handle:=DC;
          GradientFillCanvas(LCanvas, TColorizerLocalSettings.ColorMap.Color, TColorizerLocalSettings.ColorMap.HighlightColor, R, gdVertical);
          LCanvas.Brush.Style:=TBrushStyle.bsClear;
          LCanvas.Pen.Color:=TColorizerLocalSettings.ColorMap.FrameTopLeftInner;
          LCanvas.Rectangle(R);
       finally
          LCanvas.Handle:=0;
          LCanvas.Free;
          RestoreDC(DC, SaveIndex);
       end;
       Exit();
    end;
   end;
   Trampoline_TUxTheme_DrawElement(Self, DC, Details, R, ClipRect);
end;

function CustomDrawBackground(hTheme: UxTheme.HTHEME; hdc: HDC; iPartId, iStateId: Integer; const pRect: TRect; pClipRect: PRECT): HRESULT; stdcall;
var
  sCaller : string;
  LCanvas : TCanvas;
  SaveIndex: Integer;
begin
  if iPartId=HP_HEADERITEM then
  begin
    sCaller := ProcByLevel(2);
    if SameText(sCaller, 'IDEVirtualTrees.TVirtualTreeColumns.PaintHeader') then
    begin
      //TFile.AppendAllText('C:\Delphi\google-code\DITE\delphi-ide-theme-editor\IDE PlugIn\CustomDrawBackgroundXE.txt',
      //Format('%s  iPartId %d iStateId %d %s',[sCaller, iPartId, iStateId, sLineBreak]));
       SaveIndex := SaveDC(hdc);
       LCanvas:=TCanvas.Create;
       try
         LCanvas.Handle:=hdc;
          GradientFillCanvas(LCanvas, TColorizerLocalSettings.ColorMap.Color, TColorizerLocalSettings.ColorMap.HighlightColor, pRect, gdVertical);
          LCanvas.Brush.Style:=TBrushStyle.bsClear;
          LCanvas.Pen.Color:=TColorizerLocalSettings.ColorMap.FrameTopLeftInner;
          LCanvas.Rectangle(pRect);
       finally
          LCanvas.Handle:=0;
          LCanvas.Free;
          RestoreDC(hdc, SaveIndex);
       end;
       Exit(0);
    end;
  end;
  Result:=Trampoline_DrawThemeBackground(hTheme, hdc, iPartId, iStateId, pRect, pClipRect);
end;

{$ENDIF}

{$IFDEF DELPHIXE2_UP}
//Hook, for avoid apply a VCL Style to a TWinControl in desing time
function CustomHandleMessage(Self: TStyleEngine; Control: TWinControl; var Message: TMessage; DefWndProc: TWndMethod): Boolean;
begin
  if Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled and Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.UseVCLStyles then
  begin
    Result:=False;
    if not Assigned(Control) then exit;
    if csDesigning in Control.ComponentState then  exit;
  end;
  Result:=Trampoline_TStyleEngine_HandleMessage(Self, Control, Message, DefWndProc);
end;
{$ENDIF}

//Hook for paint IDE TStatusBar
procedure CustomStatusBarWMPaint(Self: TCustomStatusBarClass; var Message: TWMPaint);
var
  DC: HDC;
  Buffer: TBitmap;
  LCanvas: TCanvas;
  PS: TPaintStruct;
  LStyleServices : {$IFDEF DELPHIXE2_UP}  TCustomStyleServices {$ELSE}TThemeServices{$ENDIF};
  LParentForm : TCustomForm;

      procedure DrawControlText(Canvas: TCanvas; Details: TThemedElementDetails;
        const S: string; var R: TRect; Flags: Cardinal);
      var
        TextFormat: {$IFDEF DELPHIXE2_UP} TTextFormatFlags {$ELSE} Cardinal{$ENDIF};
      begin
        Canvas.Font := TWinControlClass(Self).Font;
        TextFormat := {$IFDEF DELPHIXE2_UP}TTextFormatFlags(Flags){$ELSE} Flags {$ENDIF};
        Canvas.Font.Color := TColorizerLocalSettings.ColorMap.FontColor;
        LStyleServices.DrawText(Canvas.Handle, Details, S, R, TextFormat, Canvas.Font.Color);
      end;

      procedure Paint(Canvas : TCanvas);
      const
        AlignStyles: array [TAlignment] of Integer = (DT_LEFT, DT_RIGHT, DT_CENTER);
      var
        R : TRect;
        Res, Count, I: Integer;
        Idx, Flags: Cardinal;
        Details: TThemedElementDetails;
        LText: string;
        Borders: array [0..2] of Integer;
        SaveCanvas: TCanvas;
      begin

        {$IFDEF DELPHIXE2_UP}
        LStyleServices:=StyleServices;
        {$ELSE}
        LStyleServices :=ThemeServices
        {$ENDIF};

        if not {$IFDEF DELPHIXE2_UP}LStyleServices.Available{$ELSE}LStyleServices.ThemesAvailable{$ENDIF}then
          Exit;

        Details := LStyleServices.GetElementDetails(tsStatusRoot);
        //StyleServices.DrawElement(Canvas.Handle, Details, Rect(0, 0, Self.Width, Self.Height));
        Canvas.Brush.Color := TColorizerLocalSettings.ColorMap.Color;
        Canvas.FillRect(Rect(0, 0, Self.Width, Self.Height));


        if SendMessage(Self.Handle, SB_ISSIMPLE, 0, 0) > 0 then
        begin
          R := Self.ClientRect;
          FillChar(Borders, SizeOf(Borders), 0);
          SendMessage(Self.Handle, SB_GETBORDERS, 0, LParam(@Borders));
          R.Left := Borders[0] + Borders[2];
          R.Top := Borders[1];
          R.Bottom := R.Bottom - Borders[1];
          R.Right := R.Right - Borders[2];

          Canvas.Brush.Color := TColorizerLocalSettings.ColorMap.Color;
          Canvas.FillRect(R);

          //R1 := Self.ClientRect;
          //R1.Left := R1.Right - R.Height;
          //Details := StyleServices.GetElementDetails(tsGripper);
          //StyleServices.DrawElement(Canvas.Handle, Details, R1);

          Details := LStyleServices.GetElementDetails(tsPane);
          SetLength(LText, Word(SendMessage(Self.Handle, SB_GETTEXTLENGTH, 0, 0)));
          if Length(LText) > 0 then
          begin
           SendMessage(Self.Handle, SB_GETTEXT, 0, LParam(@LText[1]));
           Flags := Self.DrawTextBiDiModeFlags(DT_LEFT);
           DrawControlText(Canvas, Details, LText, R, Flags);
          end;
        end
        else
        begin
          Count := Self.Panels.Count;
          for I := 0 to Count - 1 do
          begin
            R := Rect(0, 0, 0, 0);
            SendMessage(Self.Handle, SB_GETRECT, I, LParam(@R));
            if IsRectEmpty(R) then
              Exit;

            Canvas.Brush.Color := TColorizerLocalSettings.ColorMap.HighlightColor;
            Canvas.FillRect(R);

//            if I = Count - 1 then
//            begin
//              R1 := Self.ClientRect;
//              R1.Left := R1.Right - R.Height;
//              Details := StyleServices.GetElementDetails(tsGripper);
//              StyleServices.DrawElement(Canvas.Handle, Details, R1);
//            end;
            Details := LStyleServices.GetElementDetails(tsPane);
            InflateRect(R, -1, -1);
            if Self is TCustomStatusBar then
              Flags := Self.DrawTextBiDiModeFlags(AlignStyles[TCustomStatusBar(Self).Panels[I].Alignment])
            else
              Flags := Self.DrawTextBiDiModeFlags(DT_LEFT);
            Idx := I;
            SetLength(LText, Word(SendMessage(Self.Handle, SB_GETTEXTLENGTH, Idx, 0)));
            if Length(LText) > 0 then
            begin
              Res := SendMessage(Self.Handle, SB_GETTEXT, Idx, LParam(@LText[1]));
              if (Res and SBT_OWNERDRAW = 0) then
                DrawControlText(Canvas, Details, LText, R, Flags)
              else
              if (Self is TCustomStatusBar) and Assigned(TCustomStatusBar(Self).OnDrawPanel) then
              begin
                SaveCanvas  := Self.Canvas;
                Self.CanvasRW := Canvas;
                try
                  Self.OnDrawPanel(TCustomStatusBar(Self), Self.Panels[I], R);
                finally
                  Self.CanvasRW := SaveCanvas;
                end;
              end;
            end
            else if (Self is TCustomStatusBar) then
             if (TCustomStatusBar(Self).Panels[I].Style <> psOwnerDraw) then
               DrawControlText(Canvas, Details, TCustomStatusBar(Self).Panels[I].Text, R, Flags)
             else
               if Assigned(TCustomStatusBar(Self).OnDrawPanel) then
               begin
                 SaveCanvas := TCustomStatusBar(Self).Canvas;
                 TCustomStatusBar(Self).CanvasRW := Canvas;
                 try
                   TCustomStatusBar(Self).OnDrawPanel(TCustomStatusBar(Self), TCustomStatusBar(Self).Panels[I], R);
                 finally
                   TCustomStatusBar(Self).CanvasRW := SaveCanvas;
                 end;
               end;
          end;
        end;

      end;

begin
    if (Assigned(TColorizerLocalSettings.Settings) and not TColorizerLocalSettings.Settings.Enabled) or (csDesigning in Self.ComponentState) or (not Assigned(TColorizerLocalSettings.ColorMap)) or (Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.UseVCLStyles) then
    begin
     Trampoline_TCustomStatusBar_WMPAINT(Self, Message);
     exit;
    end;


    LParentForm:= GetParentForm(Self);
    if not (Assigned(LParentForm) and Assigned(TColorizerLocalSettings.HookedWindows) and (TColorizerLocalSettings.HookedWindows.IndexOf(LParentForm.ClassName)>=0)) then
    begin
      Trampoline_TCustomStatusBar_WMPAINT(Self, Message);
      exit;
    end;


    Self.DoUpdatePanels(False, True);

    DC := HDC(Message.DC);
    LCanvas := TCanvas.Create;
    try
        if DC <> 0 then
          LCanvas.Handle := DC
        else
        LCanvas.Handle := BeginPaint(Self.Handle, PS);
        if (DC = 0) then
        begin
          Buffer := TBitmap.Create;
          try
            Buffer.SetSize(Self.Width, Self.Height);
            LCanvas.Brush.Color := TColorizerLocalSettings.ColorMap.Color;
            LCanvas.FillRect(Self.ClientRect);
            Paint(Buffer.Canvas);
            // paint other controls
            if Self is TWinControl then
              TWinControlClass(Self).PaintControls(Buffer.Canvas.Handle, nil);
            LCanvas.Draw(0, 0, Buffer);
          finally
            Buffer.Free;
          end;
        end;

      if DC = 0 then
        EndPaint(Self.Handle, PS);
    finally
      LCanvas.Handle := 0;
      LCanvas.Free;
    end;

end;

procedure CropPNG(Source: TPngImage; Left, Top, Width, Height: Integer; out Target: TPngImage);

  function ColorToTriple(Color: TColor): TRGBTriple;
  begin
    Color := ColorToRGB(Color);
    Result.rgbtBlue := Color shr 16 and $FF;
    Result.rgbtGreen := Color shr 8 and $FF;
    Result.rgbtRed := Color and $FF;
  end;

var
   X, Y: Integer;
   LBitmap: TBitmap;
   LRGBLine: PRGBLine;
   AlphaLineA, AlphaLineB: PngImage.PByteArray;
begin
  if (Source.Width < (Left + Width)) or (Source.Height < (Top + Height)) then
    raise Exception.Create('Invalid position/size');

  LBitmap := TBitmap.Create;
  try
    LBitmap.Width := Width;
    LBitmap.Height := Height;
    LBitmap.PixelFormat := pf24bit;

    for Y := 0 to LBitmap.Height - 1 do
    begin
      LRGBLine := LBitmap.Scanline[Y];
      for X := 0 to LBitmap.Width - 1 do
        LRGBLine^[X] := ColorToTriple(Source.Pixels[Left + X, Top + Y]);
    end;

    Target := TPngImage.Create;
    Target.Assign(LBitmap);
  finally
    LBitmap.Free;
  end;

  if Source.Header.ColorType in [COLOR_GRAYSCALEALPHA, COLOR_RGBALPHA] then begin
    Target.CreateAlpha;
    for Y := 0 to Target.Height - 1 do begin
      AlphaLineA := Source.AlphaScanline[Top + Y];
      AlphaLineB := Target.AlphaScanline[Y];
      for X := 0 to Target.Width - 1 do
        AlphaLineB^[X] := AlphaLineA^[X + Left];
    end;
  end;
end;

//Hook for the docked IDE windows.
function CustomDrawDockCaption(Self : TDockCaptionDrawerClass;const Canvas: TCanvas; CaptionRect: TRect; State: TParentFormState): TDockCaptionHitTest;
var
  LColorStart, LColorEnd : TColor;

  procedure DrawIcon;
  var
    FormBitmap: TBitmap;
    DestBitmap: TBitmap;
    ImageSize: Integer;
    X, Y: Integer;
  begin
    if (State.Icon <> nil) and (State.Icon.HandleAllocated) then
    begin
      if Self.DockCaptionOrientation = dcoHorizontal then
      begin
        ImageSize := CaptionRect.Bottom - CaptionRect.Top - 3;
        X := CaptionRect.Left;
        Y := CaptionRect.Top + 2;
      end
      else
      begin
        ImageSize := CaptionRect.Right - CaptionRect.Left - 3;
        X := CaptionRect.Left + 1;
        Y := CaptionRect.Top;
      end;

      FormBitmap := nil;
      DestBitmap := TBitmap.Create;
      try
        FormBitmap := TBitmap.Create;
        DestBitmap.Width :=  ImageSize;
        DestBitmap.Height := ImageSize;
        DestBitmap.Canvas.Brush.Color := clFuchsia;
        DestBitmap.Canvas.FillRect(Rect(0, 0, DestBitmap.Width, DestBitmap.Height));
        FormBitmap.Width := State.Icon.Width;
        FormBitmap.Height := State.Icon.Height;
        FormBitmap.Canvas.Draw(0, 0, State.Icon);
        ScaleImage(FormBitmap, DestBitmap, DestBitmap.Width / FormBitmap.Width);

        DestBitmap.TransparentColor := DestBitmap.Canvas.Pixels[0, DestBitmap.Height - 1];
        DestBitmap.Transparent := True;

        Canvas.Draw(X, Y, DestBitmap);
      finally
        FormBitmap.Free;
        DestBitmap.Free;
      end;

      if Self.DockCaptionOrientation = dcoHorizontal then
        CaptionRect.Left := CaptionRect.Left + 6 + ImageSize
      else
        CaptionRect.Top := CaptionRect.Top + 6 + ImageSize;
    end;
  end;

  function CalcButtonSize(
    const CaptionRect: TRect): Integer;
  const
    cButtonBuffer = 8;
  begin
    if Self.DockCaptionOrientation = dcoHorizontal then
      Result := CaptionRect.Bottom - CaptionRect.Top - cButtonBuffer
    else
      Result := CaptionRect.Right - CaptionRect.Left - cButtonBuffer;
  end;

  function GetCloseRect(const CaptionRect: TRect): TRect;
  const
    cSideBuffer = 4;
  var
    CloseSize: Integer;
  begin
    CloseSize := CalcButtonSize(CaptionRect);
    if Self.DockCaptionOrientation = dcoHorizontal then
    begin
      Result.Left := CaptionRect.Right - CloseSize - cSideBuffer;
      Result.Top := CaptionRect.Top + ((CaptionRect.Bottom - CaptionRect.Top) - CloseSize) div 2;
    end
    else
    begin
      Result.Left := CaptionRect.Left + ((CaptionRect.Right - CaptionRect.Left) - CloseSize) div 2;
      Result.Top := CaptionRect.Top + 2 * cSideBuffer;
    end;
    Result.Right := Result.Left + CloseSize;
    Result.Bottom := Result.Top + CloseSize;
  end;

  function GetPinRect(const CaptionRect: TRect): TRect;
  const
    cSideBuffer = 4;
  var
    PinSize: Integer;
  begin
    PinSize := CalcButtonSize(CaptionRect);
    if Self.DockCaptionOrientation = dcoHorizontal then
    begin
      Result.Left := CaptionRect.Right - 2*PinSize - 2*cSideBuffer;
      Result.Top := CaptionRect.Top + ((CaptionRect.Bottom - CaptionRect.Top) - PinSize) div 2;
    end
    else
    begin
      Result.Left := CaptionRect.Left + ((CaptionRect.Right - CaptionRect.Left) - PinSize) div 2;
      Result.Top := CaptionRect.Top + 2*cSideBuffer + 2*PinSize;
    end;
    Result.Right := Result.Left + PinSize + 2;
    Result.Bottom := Result.Top + PinSize;
  end;

var
  ShouldDrawClose: Boolean;
  CloseRect, PinRect: TRect;
  LPngImage : TPngImage;
begin

  if (Assigned(TColorizerLocalSettings.Settings) and not TColorizerLocalSettings.Settings.Enabled) or (not TColorizerLocalSettings.Settings.DockCustom) or (not Assigned(TColorizerLocalSettings.ColorMap)) or (Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.UseVCLStyles) then
  begin
    Result:=Trampoline_TDockCaptionDrawer_DrawDockCaption(Self, Canvas, CaptionRect, State);
    exit;
  end;

  Canvas.Font.Color :=  TColorizerLocalSettings.ColorMap.FontColor;
  if Self.DockCaptionOrientation = dcoHorizontal then
  begin
    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := TColorizerLocalSettings.ColorMap.FrameTopLeftInner;

    CaptionRect.Top := CaptionRect.Top + 1;

    if State.Focused then
    begin
      if not TColorizerLocalSettings.Settings.DockCustomColors then
      begin
        LColorStart := TColorizerLocalSettings.ColorMap.Color;
        LColorEnd   := TColorizerLocalSettings.ColorMap.HighlightColor;
      end
      else
      begin
        try LColorStart := StringToColor(TColorizerLocalSettings.Settings.DockStartGradActive); except LColorStart := TColorizerLocalSettings.ColorMap.Color; end;
        try LColorEnd   := StringToColor(TColorizerLocalSettings.Settings.DockEndGradActive);   except LColorEnd   := TColorizerLocalSettings.ColorMap.HighlightColor; end;
      end;

    end
    else
    begin
      if not TColorizerLocalSettings.Settings.DockCustomColors then
      begin
        LColorStart := TColorizerLocalSettings.ColorMap.DisabledColor;
        LColorEnd   := TColorizerLocalSettings.ColorMap.DisabledColor;//GetHighLightColor(TColorizerLocalSettings.ColorMap.DisabledColor);
      end
      else
      begin
        try LColorStart := StringToColor(TColorizerLocalSettings.Settings.DockStartGradInActive); except LColorStart := TColorizerLocalSettings.ColorMap.DisabledColor; end;
        try LColorEnd   := StringToColor(TColorizerLocalSettings.Settings.DockEndGradInActive); except LColorEnd   := TColorizerLocalSettings.ColorMap.DisabledColor; end;
      end;
    end;

    //Canvas.Brush.Color := LColor;

    if TColorizerLocalSettings.Settings.DockGradientHor then
      GradientFillCanvas(Canvas, LColorStart, LColorEnd, Rect(CaptionRect.Left + 1, CaptionRect.Top + 1, CaptionRect.Right, CaptionRect.Bottom), gdHorizontal)
    else
      GradientFillCanvas(Canvas, LColorStart, LColorEnd, Rect(CaptionRect.Left + 1, CaptionRect.Top + 1, CaptionRect.Right, CaptionRect.Bottom), gdVertical);


    Canvas.Pen.Color :=  TColorizerLocalSettings.ColorMap.FrameTopLeftInner; //GetShadowColor(Canvas.Pen.Color, -20);
    with CaptionRect do
      Canvas.Polyline([Point(Left + 2, Top),
        Point(Right - 2, Top),
        Point(Right, Top + 2),
        Point(Right, Bottom - 2),
        Point(Right - 2, Bottom),
        Point(Left + 2, Bottom),
        Point(Left, Bottom - 2),
        Point(Left, Top + 2),
        Point(Left + 3, Top)]);

    CloseRect := GetCloseRect(CaptionRect);

    if Self.DockCaptionPinButton <> dcpbNone then
    begin
      PinRect := GetPinRect(CaptionRect);

        if Self.DockCaptionPinButton = dcpbUp then
        begin
          CropPNG(TColorizerLocalSettings.DockImages, 32, 0, 16, 16, LPngImage);
          try
            Canvas.Draw(PinRect.Left, PinRect.Top, LPngImage);
          finally
            LPngImage.free;
          end;
        end
        else
        begin
            CropPNG(TColorizerLocalSettings.DockImages, 16, 0, 16, 16, LPngImage);
            try
              Canvas.Draw(PinRect.Left, PinRect.Top, LPngImage);
            finally
              LPngImage.free;
            end;
        end;


      CaptionRect.Right := PinRect.Right - 2;
    end
    else
      CaptionRect.Right := CloseRect.Right - 2;

    CaptionRect.Left := CaptionRect.Left + 6;
    DrawIcon;
    ShouldDrawClose := CloseRect.Left >= CaptionRect.Left;

  end
  else
  begin
    Canvas.MoveTo(CaptionRect.Left + 1, CaptionRect.Top + 1);
    Canvas.LineTo(CaptionRect.Right - 1, CaptionRect.Top + 1);


    if State.Focused then
    begin
      LColorStart := TColorizerLocalSettings.ColorMap.Color;
      LColorEnd   := TColorizerLocalSettings.ColorMap.HighlightColor;
    end
    else
    begin
      LColorStart := TColorizerLocalSettings.ColorMap.DisabledColor;
      LColorEnd   := GetHighLightColor(TColorizerLocalSettings.ColorMap.DisabledColor);
    end;

    //Canvas.Brush.Color := LColor;

    //Canvas.FillRect(Rect(CaptionRect.Left, CaptionRect.Top + 2, CaptionRect.Right, CaptionRect.Bottom));
    if TColorizerLocalSettings.Settings.DockGradientHor then
      GradientFillCanvas(Canvas, LColorStart, LColorEnd, Rect(CaptionRect.Left, CaptionRect.Top + 2, CaptionRect.Right, CaptionRect.Bottom), gdHorizontal)
    else
      GradientFillCanvas(Canvas, LColorStart, LColorEnd, Rect(CaptionRect.Left, CaptionRect.Top + 2, CaptionRect.Right, CaptionRect.Bottom), gdVertical);


    Canvas.Pen.Color := State.EndColor;
    Canvas.MoveTo(CaptionRect.Left + 1, CaptionRect.Bottom);
    Canvas.LineTo(CaptionRect.Right - 1, CaptionRect.Bottom);

    Canvas.Font.Orientation := 900;
    CloseRect := GetCloseRect(CaptionRect);

    if Self.DockCaptionPinButton <> dcpbNone then
    begin
      PinRect := GetPinRect(CaptionRect);
      LPngImage:=TPNGImage.Create;
      try
        if Self.DockCaptionPinButton = dcpbUp then
         LPngImage.LoadFromResourceName(HInstance, 'pin_dock_left')
        else
         LPngImage.LoadFromResourceName(HInstance, 'pin_dock');

        Canvas.Draw(PinRect.Left, PinRect.Top, LPngImage);
      finally
        LPngImage.free;
      end;
      CaptionRect.Top := PinRect.Bottom + 2;
    end
    else
      CaptionRect.Top := CloseRect.Bottom + 2;

    ShouldDrawClose   := CaptionRect.Top < CaptionRect.Bottom;
    CaptionRect.Right := CaptionRect.Left + (CaptionRect.Bottom - CaptionRect.Top - 2);
    CaptionRect.Top   := CaptionRect.Top + Canvas.TextWidth(State.Caption) + 2;

    if CaptionRect.Top > CaptionRect.Bottom then
      CaptionRect.Top := CaptionRect.Bottom;
  end;

  Canvas.Brush.Style := bsClear;
  if State.Caption <> '' then
  begin
    if State.Focused then
      Canvas.Font.Style := Canvas.Font.Style + [fsBold]
    else
      Canvas.Font.Style := Canvas.Font.Style - [fsBold];

   if ShouldDrawClose then
     CaptionRect.Right := CaptionRect.Right - (CloseRect.Right - CloseRect.Left) - 4;

    Canvas.TextRect(CaptionRect, State.Caption,
      [tfEndEllipsis, tfVerticalCenter, tfSingleLine]);
  end;

  if ShouldDrawClose then
  begin
      CropPNG(TColorizerLocalSettings.DockImages, 0, 0, 16, 16, LPngImage);
      try
        Canvas.Draw(CloseRect.Left, CloseRect.Top, LPngImage);
      finally
        LPngImage.free;
      end;
  end;

  Exit(0);
end;

//Hook for the TCustomListView component
procedure CustomHeaderWndProc(Self:TCustomListView;var Message: TMessage);
var
  LStyleServices : {$IFDEF DELPHIXE2_UP} TCustomStyleServices {$ELSE}TThemeServices{$ENDIF};

      procedure DrawControlText(Canvas: TCanvas; Details: TThemedElementDetails;
        const S: string; var R: TRect; Flags: Cardinal);
      var
        TextFormat: {$IFDEF DELPHIXE2_UP} TTextFormatFlags {$ELSE} Cardinal{$ENDIF};
      begin
        Canvas.Font := TWinControlClass(Self).Font;
        TextFormat := {$IFDEF DELPHIXE2_UP}TTextFormatFlags(Flags){$ELSE} Flags {$ENDIF};
        Canvas.Font.Color := TColorizerLocalSettings.ColorMap.FontColor;
        LStyleServices.DrawText(Canvas.Handle, Details, S, R, TextFormat, Canvas.Font.Color);
      end;

    procedure DrawHeaderSection(Canvas: TCanvas; R: TRect; Index: Integer;
      const Text: string; IsPressed, IsBackground: Boolean);
    var
      Item: THDItem;
      ImageList: HIMAGELIST;
      DrawState: TThemedHeader;
      IconWidth, IconHeight: Integer;
      LDetails: TThemedElementDetails;
      LBuffer : TBitmap;
    begin
      FillChar(Item, SizeOf(Item), 0);
      Item.Mask := HDI_FORMAT;
      Header_GetItem(Self.Handle, Index, Item);

      LBuffer:=TBitmap.Create;
      try
       {$IFDEF DELPHIXE2_UP}
       LBuffer.SetSize(R.Width, R.Height);
       {$ELSE}
       LBuffer.SetSize(R.Right-R.Left, R.Bottom-R.Top);
       {$ENDIF}
       LBuffer.Canvas.Pen.Color:=TColorizerLocalSettings.ColorMap.FrameTopLeftInner;
       LBuffer.Canvas.Rectangle(Rect(0, 0, R.Right, R.Bottom));
       GradientFillCanvas(LBuffer.Canvas, TColorizerLocalSettings.ColorMap.Color, TColorizerLocalSettings.ColorMap.HighlightColor, Rect(1, 1, R.Right-1, R.Bottom-1), gdVertical);
       Canvas.Draw(R.Left, R.Top, LBuffer);
      finally
       LBuffer.Free;
      end;

      ImageList := SendMessage(Self.Handle, HDM_GETIMAGELIST, 0, 0);
      Item.Mask := HDI_FORMAT or HDI_IMAGE;
      InflateRect(R, -2, -2);
      if (ImageList <> 0) and Header_GetItem(Self.Handle, Index, Item) then
      begin
        if Item.fmt and HDF_IMAGE = HDF_IMAGE then
          ImageList_Draw(ImageList, Item.iImage, Canvas.Handle, R.Left, R.Top, ILD_TRANSPARENT);
        ImageList_GetIconSize(ImageList, IconWidth, IconHeight);
        Inc(R.Left, IconWidth + 5);
      end;

      if IsBackground then
        DrawState := thHeaderItemNormal
      else
      if IsPressed then
        DrawState := thHeaderItemPressed
      else
        DrawState := thHeaderItemNormal;

      LDetails := LStyleServices.GetElementDetails(DrawState);
      DrawControlText(Canvas, LDetails, Text, R, DT_VCENTER or DT_LEFT or  DT_SINGLELINE or DT_END_ELLIPSIS);
    end;


var
  Canvas: TCanvas;
  R, HeaderR: TRect;
  PS: TPaintStruct;
  HeaderDC: HDC;
  I, ColumnIndex, RightOffset: Integer;
  SectionOrder: array of Integer;
  Item: THDItem;
  Buffer: array [0..255] of Char;
  LParentForm : TCustomForm;
begin
  {$IFDEF DELPHIXE2_UP}
  LStyleServices:=StyleServices;
  {$ELSE}
  LStyleServices:=ThemeServices
  {$ENDIF};

  if Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled and  (Message.Msg=WM_PAINT) then
  if not (csDesigning in Self.ComponentState) then
  begin
    LParentForm:= GetParentForm(Self);
    if Assigned(LParentForm) and Assigned(TColorizerLocalSettings.HookedWindows) and (TColorizerLocalSettings.HookedWindows.IndexOf(LParentForm.ClassName)>=0) then
    begin
        HeaderDC := BeginPaint(Self.GetHeaderHandle, PS);
      try
        Canvas := TCanvas.Create;
        try
          Canvas.Handle := HeaderDC;
          RightOffset := 0;

          for I := 0 to Header_GetItemCount(Self.GetHeaderHandle) - 1 do
          begin
            SetLength(SectionOrder, Header_GetItemCount(Self.GetHeaderHandle));
            Header_GetOrderArray(Self.GetHeaderHandle, Header_GetItemCount(Self.GetHeaderHandle),
              Pointer(SectionOrder));
            ColumnIndex := SectionOrder[I];
            Header_GETITEMRECT(Self.GetHeaderHandle, ColumnIndex, @R);
            FillChar(Item, SizeOf(Item), 0);
            Item.Mask := HDI_TEXT;
            Item.pszText := @Buffer;
            Item.cchTextMax := Length(Buffer);
            Header_GetItem(Self.GetHeaderHandle, ColumnIndex, Item);
            DrawHeaderSection(Canvas, R, ColumnIndex, Item.pszText,
              {FPressedSection = ColumnIndex} False, False);

            if RightOffset < R.Right then
              RightOffset := R.Right;
          end;

          GetWindowRect(Self.GetHeaderHandle, HeaderR);

          {$IFDEF DELPHIXE2_UP}
          R := Rect(RightOffset, 0, HeaderR.Width + 2, HeaderR.Height);
          {$ELSE}
          R := Rect(RightOffset, 0, (HeaderR.Right-HeaderR.Left) + 2, (HeaderR.Bottom - HeaderR.Top));
          {$ENDIF};
          if not IsRectEmpty(R) then
            DrawHeaderSection(Canvas, R, -1, '', False, True);

        finally
          Canvas.Handle := 0;
          Canvas.Free;
        end;
      finally
          EndPaint(Self.GetHeaderHandle, PS)
      end;
      exit;
    end;
  end;
  Trampoline_TCustomListView_HeaderWndProc(Self, Message);
end;

procedure CustomProjectTree2PaintText(Self : TObject; Sender: TObject{TBaseVirtualTree}; const TargetCanvas: TCanvas; Node: {PVirtualNode}Pointer; Column: Integer{TColumnIndex}; TextType: Byte {TVSTTextType});
begin
  //TargetCanvas.Font.Color:=clRed;
  Trampoline_ProjectTree2PaintText(Self, Sender, TargetCanvas, Node, Column, TextType);
end;

//Hook for allow change font color in TProjectManagerForm.TVirtualStringTree ,
//because this component is not using the colors set via RTTI
//Note  : This is a temporal workaround.
function CustomDrawText(hDC: HDC; lpString: LPCWSTR; nCount: Integer;  var lpRect: TRect; uFormat: UINT): Integer; stdcall;
var
  sCaller : string;
begin
 if Assigned(TColorizerLocalSettings.Settings) and TColorizerLocalSettings.Settings.Enabled and Assigned(TColorizerLocalSettings.ColorMap) then
 begin
  if GetTextColor(hDC) = GetSysColor(COLOR_WINDOWTEXT) then
  begin
    sCaller := ProcByLevel(2);
    if SameText(sCaller, 'IDEVirtualTrees.TCustomVirtualStringTree.PaintNormalText') then
      SetTextColor(hDC, TColorizerLocalSettings.ColorMap.FontColor);
  end;
 end;

  Result:=Trampoline_DrawText(hDC, lpString, nCount, lpRect, uFormat);
end;

//Hook to fix artifacts and undocumented painting methods ex: TClosableTabScroller background
function CustomGetSysColor(nIndex: Integer): DWORD; stdcall;
var
  sCaller : string;
  //i  : Integer;
begin

//   if (nIndex=COLOR_WINDOWTEXT) then
//   begin
//      for i := 2 to 5 do
//      begin
//         sCaller := ProcByLevel(i);
//         AddLog('CustomGetSysColor', Format('%d nIndex %d %s',[i, nIndex, sCaller]));
//      end;
//      AddLog('CustomGetSysColor', Format('%s',['---------------']));
//   end;

   if  Assigned(TColorizerLocalSettings.Settings) and (TColorizerLocalSettings.Settings.Enabled) and Assigned(TColorizerLocalSettings.ColorMap) and  (nIndex=COLOR_BTNFACE) then
   begin
    //Vcl.Controls.TWinControl.PaintHandler
    //Vcl.Controls.TWinControl.WMPaint
    //Vcl.Controls.TWinControl.WMPrintClient

     sCaller := ProcByLevel(2);
     if SameText(sCaller, '') then
       Exit(ColorToRGB(TColorizerLocalSettings.ColorMap.Color));
   end;

   Exit(Trampoline_GetSysColor(nIndex));
end;


const
  sProjectTree2PaintText      = '@Projectfrm@TProjectManagerForm@ProjectTree2PaintText$qqrp32Idevirtualtrees@TBaseVirtualTreexp20Vcl@Graphics@TCanvasp28Idevirtualtrees@TVirtualNodei28Idevirtualtrees@TVSTTextType';
{$IFDEF DELPHIXE6_UP}
  sModernThemeDrawDockCaption = '@Moderntheme@TModernDockCaptionDrawer@DrawDockCaption$qqrxp20Vcl@Graphics@TCanvasrx18System@Types@TRectrx38Vcl@Captioneddocktree@TParentFormState';
{$ENDIF}

{$IFNDEF DELPHIXE2_UP}
type
 //TThemeServicesDrawElement1 =  procedure (DC: HDC; Details: TThemedElementDetails;  const R: TRect) of object;
 TThemeServicesDrawElement2 =  procedure (DC: HDC; Details: TThemedElementDetails;  const R: TRect; ClipRect: TRect) of object;
{$ENDIF}




procedure InstallColorizerHooks;
var
  pOrgAddress, GetSysColorOrgPointer : Pointer;
{$IFDEF DELPHIXE6_UP}
  ModernThemeModule           : HMODULE;
  pModernThemeDrawDockCaption : Pointer;
{$ENDIF}
{$IFNDEF DELPHIXE2_UP}
 LThemeServicesDrawElement2   : TThemeServicesDrawElement2;
{$ENDIF}
begin
 ListBrush := TObjectDictionary<TObject, TBrush>.Create([doOwnsValues]);
{$IF CompilerVersion<27} //XE6
  TrampolineCustomImageList_DoDraw:=InterceptCreate(@TCustomImageListClass.DoDraw, @CustomImageListHack_DoDraw);
{$IFEND}
  Trampoline_TCanvas_FillRect     :=InterceptCreate(@TCanvas.FillRect, @CustomFillRect);
  Trampoline_TCustomStatusBar_WMPAINT   := InterceptCreate(TCustomStatusBarClass(nil).WMPaintAddress,   @CustomStatusBarWMPaint);
  Trampoline_CustomComboBox_WMPaint     := InterceptCreate(TCustomComboBox(nil).WMPaintAddress,   @CustomWMPaintComboBox);

  Trampoline_TDockCaptionDrawer_DrawDockCaption  := InterceptCreate(@TDockCaptionDrawer.DrawDockCaption,   @CustomDrawDockCaption);

  //Trampoline_TBitmap_SetSize := InterceptCreate(@TBitmap.SetSize,   @CustomSetSize);

{$IFDEF DELPHIXE2_UP}
  Trampoline_TStyleEngine_HandleMessage     := InterceptCreate(@TStyleEngine.HandleMessage,   @CustomHandleMessage);
  Trampoline_TUxThemeStyle_DoDrawElement    := InterceptCreate(@TUxThemeStyleClass.DoDrawElement,   @CustomDrawElement);
{$ELSE}
  LThemeServicesDrawElement2                := ThemeServices.DrawElement;
  Trampoline_TUxTheme_DrawElement           := InterceptCreate(@LThemeServicesDrawElement2,   @CustomDrawElement);
  if Assigned(DrawThemeBackground) then
    Trampoline_DrawThemeBackground            := InterceptCreate(@DrawThemeBackground,   @CustomDrawBackground);
{$ENDIF}
  Trampoline_TCustomListView_HeaderWndProc  := InterceptCreate(TCustomListViewClass(nil).HeaderWndProcAddress, @CustomHeaderWndProc);
  Trampoline_DrawText                       := InterceptCreate(@Windows.DrawTextW, @CustomDrawText);

   GetSysColorOrgPointer     := GetProcAddress(GetModuleHandle(user32), 'GetSysColor');
   if Assigned(GetSysColorOrgPointer) then
     Trampoline_GetSysColor    :=  InterceptCreate(GetSysColorOrgPointer, @CustomGetSysColor);

   pOrgAddress     := GetProcAddress(GetModuleHandle(user32), 'DrawFrameControl');
   if Assigned(pOrgAddress) then
     Trampoline_DrawFrameControl :=  InterceptCreate(pOrgAddress, @CustomDrawFrameControl);

  Trampoline_TCategoryButtons_DrawCategory := InterceptCreate(TCategoryButtons(nil).DrawCategoryAddress,   @CustomDrawCategory);
  Trampoline_TCustomPanel_Paint            := InterceptCreate(@TCustomPanelClass.Paint, @CustomPanelPaint);

  //Trampoline_TPopupActionBar_GetStyle      := InterceptCreate(TPopupActionBar(nil).GetStyleAddress, @CustomGetStyle);

  Trampoline_TSplitter_Paint               := InterceptCreate(@TSplitterClass.Paint, @CustomSplitterPaint);
  Trampoline_TButtonControl_WndProc        := InterceptCreate(@TButtonControlClass.WndProc, @CustomButtonControlWndProc);
{$IFDEF DELPHIXE6_UP}
  ModernThemeModule := LoadLibrary('ModernTheme200.bpl');
  if ModernThemeModule<>0 then
  begin
   pModernThemeDrawDockCaption := GetProcAddress(ModernThemeModule, sModernThemeDrawDockCaption);
   if Assigned(pModernThemeDrawDockCaption) then
     Trampoline_ModernDockCaptionDrawer_DrawDockCaption:= InterceptCreate(pModernThemeDrawDockCaption, @CustomDrawDockCaption);
  end;
{$ENDIF}

end;

procedure RemoveColorizerHooks;
begin
{$IF CompilerVersion<27} //XE6
  if Assigned(TrampolineCustomImageList_DoDraw) then
    InterceptRemove(@TrampolineCustomImageList_DoDraw);
{$IFEND}
  if Assigned(Trampoline_TCanvas_FillRect) then
    InterceptRemove(@Trampoline_TCanvas_FillRect);
{$IFDEF DELPHIXE2_UP}
  if Assigned(Trampoline_TStyleEngine_HandleMessage) then
    InterceptRemove(@Trampoline_TStyleEngine_HandleMessage);
  if Assigned(Trampoline_TUxThemeStyle_DoDrawElement) then
    InterceptRemove(@Trampoline_TUxThemeStyle_DoDrawElement);
{$ELSE}
  if Assigned(Trampoline_TUxTheme_DrawElement) then
    InterceptRemove(@Trampoline_TUxTheme_DrawElement);
  if Assigned(Trampoline_DrawThemeBackground) then
    InterceptRemove(@Trampoline_DrawThemeBackground);
{$ENDIF}
  if Assigned(Trampoline_TCustomStatusBar_WMPAINT) then
    InterceptRemove(@Trampoline_TCustomStatusBar_WMPAINT);
  if Assigned(Trampoline_TDockCaptionDrawer_DrawDockCaption) then
    InterceptRemove(@Trampoline_TDockCaptionDrawer_DrawDockCaption);
  if Assigned(Trampoline_TCustomListView_HeaderWndProc) then
    InterceptRemove(@Trampoline_TCustomListView_HeaderWndProc);
  if Assigned(Trampoline_ProjectTree2PaintText) then
    InterceptRemove(@Trampoline_ProjectTree2PaintText);
  if Assigned(Trampoline_DrawText) then
    InterceptRemove(@Trampoline_DrawText);
  if Assigned(Trampoline_GetSysColor) then
    InterceptRemove(@Trampoline_GetSysColor);
  if Assigned(Trampoline_TCategoryButtons_DrawCategory) then
    InterceptRemove(@Trampoline_TCategoryButtons_DrawCategory);

  if Assigned(Trampoline_TCustomPanel_Paint) then
    InterceptRemove(@Trampoline_TCustomPanel_Paint);

  if Assigned(Trampoline_TButtonControl_WndProc) then
    InterceptRemove(@Trampoline_TButtonControl_WndProc);

  if Assigned(Trampoline_TSplitter_Paint) then
    InterceptRemove(@Trampoline_TSplitter_Paint);

  if Assigned(Trampoline_CustomComboBox_WMPaint) then
    InterceptRemove(@Trampoline_CustomComboBox_WMPaint);

  if Assigned(Trampoline_DrawFrameControl) then
    InterceptRemove(@Trampoline_DrawFrameControl);

{$IFDEF DELPHIXE6_UP}
  if Assigned(Trampoline_ModernDockCaptionDrawer_DrawDockCaption) then
    InterceptRemove(@Trampoline_ModernDockCaptionDrawer_DrawDockCaption);
{$ENDIF}

   ListBrush.Free;
end;





end.
