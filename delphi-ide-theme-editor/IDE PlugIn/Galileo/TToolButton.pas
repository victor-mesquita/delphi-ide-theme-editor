type
  TToolButton=class(TGraphicControl)
  private
   FAllowAllUp         :Boolean;
   FAutoSize           :Boolean;
   FDown               :Boolean;
   FGrouped            :Boolean;
   FImageIndex         :TImageIndex;
   FIndeterminate      :Boolean;
   FMarked             :Boolean;
   FMenuItem           :TMenuItem;
   FDropdownMenu       :TPopupMenu;
   FEnableDropdown     :Boolean;
   FWrap               :Boolean;
   FStyle              :TToolButtonStyle;
   FUpdateCount        :Integer;
   FCanvas             :TCanvas;
   FParent             :TWinControl;
   FWindowProc         :TWndMethod;
   FLeft               :Integer;
   FTop                :Integer;
   FWidth              :Integer;
   FHeight             :Integer;
   FControlStyle       :TControlStyle;
   FControlState       :TControlState;
   FDesktopFont        :Boolean;
   FVisible            :Boolean;
   FEnabled            :Boolean;
   FParentFont         :Boolean;
   FParentColor        :Boolean;
   FAlign              :TAlign;
   FAutoSize           :Boolean;
   FDragMode           :TDragMode;
   FIsControl          :Boolean;
   FBiDiMode           :TBiDiMode;
   FParentBiDiMode     :Boolean;
   FAnchors            :TAnchors;
   FFont               :TFont;
   FActionLink         :TControlActionLink;
   FColor              :TColor;
   FConstraints        :TSizeConstraints;
   FMargins            :TMargins;
   FCursor             :TCursor;
   FDragCursor         :TCursor;
   FPopupMenu          :TPopupMenu;
   FHint               :string;
   FFontHeight         :Integer;
   FScalingFlags       :TScalingFlags;
   FShowHint           :Boolean;
   FParentShowHint     :Boolean;
   FDragKind           :TDragKind;
   FDockOrientation    :TDockOrientation;
   FHostDockSite       :TWinControl;
   FWheelAccumulator   :Integer;
   FUndockWidth        :Integer;
   FUndockHeight       :Integer;
   FLRDockWidth        :Integer;
   FTBDockHeight       :Integer;
   FFloatingDockSiteClass:TWinControlClass;
   FTouchManager       :TTouchManager;
   FOnCanResize        :TCanResizeEvent;
   FOnConstrainedResize:TConstrainedResizeEvent;
   FOnMouseDown        :TMouseEvent;
   FOnMouseMove        :TMouseMoveEvent;
   FOnMouseUp          :TMouseEvent;
   FOnDragDrop         :TDragDropEvent;
   FOnDragOver         :TDragOverEvent;
   FOnResize           :TNotifyEvent;
   FOnStartDock        :TStartDockEvent;
   FOnEndDock          :TEndDragEvent;
   FOnStartDrag        :TStartDragEvent;
   FOnEndDrag          :TEndDragEvent;
   FOnClick            :TNotifyEvent;
   FOnDblClick         :TNotifyEvent;
   FOnContextPopup     :TContextPopupEvent;
   FOnMouseActivate    :TMouseActivateEvent;
   FOnMouseLeave       :TNotifyEvent;
   FOnMouseEnter       :TNotifyEvent;
   FOnMouseWheel       :TMouseWheelEvent;
   FOnMouseWheelDown   :TMouseWheelUpDownEvent;
   FOnMouseWheelUp     :TMouseWheelUpDownEvent;
   FOnGesture          :TGestureEvent;
   FHelpType           :THelpType;
   FHelpKeyword        :string;
   FHelpContext        :THelpContext;
   FCustomHint         :TCustomHint;
   FParentCustomHint   :Boolean;
   FText               :PWideChar;
   FOwner              :TComponent;
   FName               :TComponentName;
   FTag                :NativeInt;
   FComponents         :TList;
   FFreeNotifies       :TList;
   FDesignInfo         :Integer;
   FComponentState     :TComponentState;
   FVCLComObject       :Pointer;
   FObservers          :TObservers;
   FSortedComponents   :TList;
   function GetComponent(AIndex: Integer): TComponent;
  protected
   FToolBar            :TToolBar;
   FAnchorMove         :Boolean;
   FAnchorRules        :TPoint;
   FAnchorOrigin       :TPoint;
   FOriginalParentSize :TPoint;
   FExplicitLeft       :Integer;
   FExplicitTop        :Integer;
   FExplicitWidth      :Integer;
   FExplicitHeight     :Integer;
   FReserved           :Pointer;
   FComponentStyle     :TComponentStyle;
  public
   constructor Create(AOwner: TComponent);
   function CheckMenuDropdown: Boolean;
   procedure Click;
   procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer);
   constructor Create(AOwner: TComponent);
   class destructor Destroy;
   constructor Create(AOwner: TComponent);
   class destructor Destroy;
   procedure BeginDrag(Immediate: Boolean; Threshold: Integer);
   procedure BringToFront;
   function ClientToScreen(const Point: TPoint): TPoint;
   function ClientToParent(const Point: TPoint; AParent: TWinControl): TPoint;
   procedure Dock(NewDockSite: TWinControl; ARect: TRect);
   function Dragging: Boolean;
   procedure DragDrop(Source: TObject; X: Integer; Y: Integer);
   function DrawTextBiDiModeFlags(Flags: Integer): Integer;
   function DrawTextBiDiModeFlagsReadingOnly: Integer;
   procedure EndDrag(Drop: Boolean);
   function GetControlsAlignment: TAlignment;
   function GetParentComponent: TComponent;
   function HasParent: Boolean;
   procedure Hide;
   procedure InitiateAction;
   procedure Invalidate;
   procedure MouseWheelHandler(var Message: TMessage);
   function IsRightToLeft: Boolean;
   function ManualDock(NewDockSite: TWinControl; DropControl: TControl; ControlSide: TAlign): Boolean;
   function ManualFloat(ScreenPos: TRect): Boolean;
   function Perform(Msg: Cardinal; WParam: NativeUInt; LParam: NativeInt): NativeInt;
   procedure Refresh;
   procedure Repaint;
   function ReplaceDockedControl(Control: TControl; NewDockSite: TWinControl; DropControl: TControl; ControlSide: TAlign): Boolean;
   function ScreenToClient(const Point: TPoint): TPoint;
   function ParentToClient(const Point: TPoint; AParent: TWinControl): TPoint;
   procedure SendToBack;
   procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer);
   procedure SetDesignVisible(Value: Boolean);
   procedure SetParentComponent(Value: TComponent);
   procedure Show;
   procedure Update;
   function UseRightToLeftAlignment: Boolean;
   function UseRightToLeftReading: Boolean;
   function UseRightToLeftScrollBar: Boolean;
   procedure DefaultHandler(var Message);
   function GetTextBuf(Buffer: PWideChar; BufSize: Integer): Integer;
   function GetTextLen: Integer;
   function Perform(Msg: Cardinal; WParam: NativeUInt; LParam: PWideChar): NativeInt;
   function Perform(Msg: Cardinal; WParam: NativeUInt; var LParam: TRect): NativeInt;
   procedure SetTextBuf(Buffer: PWideChar);
   constructor Create(AOwner: TComponent);
   class destructor Destroy;
   procedure BeforeDestruction;
   procedure DestroyComponents;
   procedure Destroying;
   function ExecuteAction(Action: TBasicAction): Boolean;
   function FindComponent(const AName: string): TComponent;
   procedure FreeNotification(AComponent: TComponent);
   procedure RemoveFreeNotification(AComponent: TComponent);
   procedure FreeOnRelease;
   function GetEnumerator: TComponentEnumerator;
   function GetParentComponent: TComponent;
   function GetNamePath: string;
   function HasParent: Boolean;
   procedure InsertComponent(AComponent: TComponent);
   procedure RemoveComponent(AComponent: TComponent);
   procedure SetSubComponent(IsSubComponent: Boolean);
   function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HRESULT;
   function UpdateAction(Action: TBasicAction): Boolean;
   function IsImplementorOf(const I: IInterface): Boolean;
   function ReferenceInterface(const I: IInterface; Operation: TOperation): Boolean;
   class destructor Destroy;
   procedure Assign(Source: TPersistent);
   function GetNamePath: string;
   constructor Create;
   procedure Free;
   class function InitInstance(Instance: Pointer): TObject;
   procedure CleanupInstance;
   function ClassType: TClass;
   class function ClassName: string;
   class function ClassNameIs(const Name: string): Boolean;
   class function ClassParent: TClass;
   class function ClassInfo: Pointer;
   class function InstanceSize: Integer;
   class function InheritsFrom(AClass: TClass): Boolean;
   class function MethodAddress(const Name: ShortString): Pointer;
   class function MethodAddress(const Name: string): Pointer;
   class function MethodName(Address: Pointer): string;
   class function QualifiedClassName: string;
   function FieldAddress(const Name: ShortString): Pointer;
   function FieldAddress(const Name: string): Pointer;
   function GetInterface(const IID: TGUID; out Obj): Boolean;
   class function GetInterfaceEntry(const IID: TGUID): PInterfaceEntry;
   class function GetInterfaceTable: PInterfaceTable;
   class function UnitName: string;
   class function UnitScope: string;
   function Equals(Obj: TObject): Boolean;
   function GetHashCode: Integer;
   function ToString: string;
   function SafeCallException(ExceptObject: TObject; ExceptAddr: Pointer): HRESULT;
   procedure AfterConstruction;
   procedure BeforeDestruction;
   procedure Dispatch(var Message);
   procedure DefaultHandler(var Message);
   class function NewInstance: TObject;
   procedure FreeInstance;
   class destructor Destroy;
   property Index: Integer;
   property Enabled: Boolean;
   property Action: TBasicAction;
   property Align: TAlign;
   property Anchors: TAnchors;
   property BiDiMode: TBiDiMode;
   property BoundsRect: TRect;
   property ClientHeight: Integer;
   property ClientOrigin: TPoint;
   property ClientRect: TRect;
   property ClientWidth: Integer;
   property Constraints: TSizeConstraints;
   property ControlState: TControlState;
   property ControlStyle: TControlStyle;
   property DockOrientation: TDockOrientation;
   property ExplicitLeft: Integer;
   property ExplicitTop: Integer;
   property ExplicitWidth: Integer;
   property ExplicitHeight: Integer;
   property Floating: Boolean;
   property FloatingDockSiteClass: TWinControlClass;
   property HostDockSite: TWinControl;
   property LRDockWidth: Integer;
   property ShowHint: Boolean;
   property TBDockHeight: Integer;
   property Touch: TTouchManager;
   property UndockHeight: Integer;
   property UndockWidth: Integer;
   property Visible: Boolean;
   property WindowProc: TWndMethod;
   property Parent: TWinControl;
   property OnGesture: TGestureEvent;
   property ComObject: IInterface;
   property ComponentCount: Integer;
   property ComponentIndex: Integer;
   property ComponentState: TComponentState;
   property ComponentStyle: TComponentStyle;
   property DesignInfo: Integer;
   property Owner: TComponent;
   property VCLComObject: Pointer;
   property Observers: TObservers;
  published
   property Action: TBasicAction;
   property AllowAllUp: Boolean;
   property AutoSize: Boolean;
   property Caption: TCaption;
   property Down: Boolean;
   property DragCursor: TCursor;
   property DragKind: TDragKind;
   property DragMode: TDragMode;
   property DropdownMenu: TPopupMenu;
   property Enabled: Boolean;
   property EnableDropdown: Boolean;
   property Grouped: Boolean;
   property Height: Integer;
   property ImageIndex: TImageIndex;
   property Indeterminate: Boolean;
   property Marked: Boolean;
   property MenuItem: TMenuItem;
   property ParentShowHint: Boolean;
   property PopupMenu: TPopupMenu;
   property Wrap: Boolean;
   property ShowHint: Boolean;
   property Style: TToolButtonStyle;
   property Visible: Boolean;
   property Width: Integer;
   property OnClick: TNotifyEvent;
   property OnContextPopup: TContextPopupEvent;
   property OnDragDrop: TDragDropEvent;
   property OnDragOver: TDragOverEvent;
   property OnEndDock: TEndDragEvent;
   property OnEndDrag: TEndDragEvent;
   property OnMouseActivate: TMouseActivateEvent;
   property OnMouseDown: TMouseEvent;
   property OnMouseEnter: TNotifyEvent;
   property OnMouseLeave: TNotifyEvent;
   property OnMouseMove: TMouseMoveEvent;
   property OnMouseUp: TMouseEvent;
   property OnStartDock: TStartDockEvent;
   property OnStartDrag: TStartDragEvent;
   property AlignWithMargins: Boolean;
   property Left: Integer;
   property Top: Integer;
   property Width: Integer;
   property Height: Integer;
   property Cursor: TCursor;
   property Hint: string;
   property HelpType: THelpType;
   property HelpKeyword: string;
   property HelpContext: THelpContext;
   property Margins: TMargins;
   property CustomHint: TCustomHint;
   property ParentCustomHint: Boolean;
   property Name: TComponentName;
   property Tag: NativeInt;
  end;