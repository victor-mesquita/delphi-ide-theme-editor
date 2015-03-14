# Introduction #

> If you are reading this is because you want test the Delphi IDE Colorizer (DIC). Currently the wizard was tested in Windows 7 and 8.1 on Delphi XE-XE6. with JVCL, JCL, GExperts and CNWizards installed on the IDE and not conflicts are found so far.

> What I expect of this beta testing is found bugs, possible conflicts with third-party experts and components, add new suggested features and improve the overall performance of the Wizard.

# FAQ #

> This wiki describe the steps necessaries to use and test the Wizard.

## What is DIC? ##

> Delphi IDE Colorizer (DIC) is a RAD Studio Wizard which allows to customize the look and feel of the menus, popup menus, docked and floating windows and all the components included in the **workspace** of the IDE.

## Which versions of Delphi (RAD Studio) supports DIC? ##

> Currently DIC supports RAD Studio XE2-X7 and Appmethod 1.14 and 1.15.

## DIC supports modify the syntax highlight colors? ##

> No, for this task you must use the Delphi IDE Theme Editor.


## DIC supports design-time components? ##

> No, the aim of DIC is only change the appearance of the windows and components used by the IDE. and not interfere with the VCL or FMX components in design time. If any component in design time is modified in any way by the DIC Wizard this situation must be reported as a bug.

## DIC supports modify the non client area of the floating IDE windows? ##
> Yes, this option works with RAD Studio XE2 and above and uses the VCL Styles to do this task.

## DIC supports VCL Styles? ##

> Yes, this option works with RAD Studio XE2 and above . The VCL Styles can be used for paint the forms and components of the workspace area.

## How I can change the options of the DIC? ##

> The options of the Wizard can be modified using the settings form located in the Tools -> Delphi IDE Colorizer menu or Tools -> Options Third Party -> Delphi IDE Colorizer.

## Where the DIC files are stored? ##

> The files used by the DIC Wizard are stored in the %LOCALAPPDATA%\The Road To Delphi\DIC folder

## How I can Uninstall the plugin? ##
> go to the  **%LOCALAPPDATA%\The Road To Delphi\DIC**  folder and run the uninst.exe App.

## How I must report a bug? ##

> All the bugs found must be reported using the issue page of the project located here https://code.google.com/p/delphi-ide-theme-editor/issues/list . exist a sample bug issue (https://code.google.com/p/delphi-ide-theme-editor/issues/detail?id=42) which you can use as a guide. please remember add the "DIC" prefix to the summary of the issue report.


## How I must suggest a new feature? ##

> All the suggestions must be done using the issue page of the project located here https://code.google.com/p/delphi-ide-theme-editor/issues/list . exist a sample feature request (https://code.google.com/p/delphi-ide-theme-editor/issues/detail?id=43) which you can use as a guide. please remember add the "DIC" prefix to the summary of the feature report and modify the Labels of the report from **Type-Defect** to **Type-Enhancement**