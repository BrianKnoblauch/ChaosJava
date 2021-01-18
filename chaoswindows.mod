MODULE chaoswindows;

(* DEFs - \xds\bin\XDS-x86\def\Win32 *)
(* Documentation - /xds/Sources/Distrib/workplace/pdf/xc.pdf *)

FROM WinDef     IMPORT HWND, LPARAM, LRESULT, MyInstance, UINT, WPARAM;
FROM WinUser    IMPORT CreateWindowEx, CS_SAVEBITS,  CW_USEDEFAULT, DefWindowProc, DestroyWindow, DispatchMessage, GetMessage, IDC_ARROW, IDI_APPLICATION,
                       LoadCursor, LoadIcon, MessageBox, MB_ICONEXCLAMATION, MB_OK, MSG, PostQuitMessage, RegisterClass, ShowWindow, SW_ENUM,
                       TranslateMessage, UpdateWindow, WM_CLOSE, WM_DESTROY, WNDCLASS, WS_EX_CLIENTEDGE, WS_OVERLAPPEDWINDOW;
FROM SYSTEM     IMPORT ADR, CAST;

CONST
    g_szClassName = "myWindowClass";

(* TODO - FSPaint procedure similar to Sketchie, but operate on x,y and use color based on the random direction? *)

PROCEDURE ["StdCall"] WndProc(hwnd : HWND; msg : UINT; wParam : WPARAM;  lParam : LPARAM): LRESULT;
BEGIN    
    CASE msg OF
    (* TODO invoke FSPaint on paint request *)
    (* TODO set window parameters and store resulting window size on create? *)
    | WM_CLOSE   : DestroyWindow(hwnd);
    | WM_DESTROY : PostQuitMessage(0);
    ELSE RETURN DefWindowProc(hwnd, msg, wParam, lParam);
    END;
    RETURN 0;    
END WndProc; 

VAR
    className : ARRAY [0..14] OF CHAR;
    hwnd      : HWND;
    Msg       : MSG;
    wc        : WNDCLASS;
(*    x,y       : CARDINAL;*)

BEGIN
    (* Register the Window Class *)
    wc.style         := CS_SAVEBITS;
    wc.lpfnWndProc   := WndProc;
    wc.cbClsExtra    := 0;
    wc.cbWndExtra    := 0;
    wc.hInstance     := MyInstance();
    wc.hIcon         := LoadIcon(NIL, IDI_APPLICATION);
    wc.hCursor       := LoadCursor(NIL, IDC_ARROW);
(* TODO can we set the background to black below? *)
(*    wc.hbrBackground := CAST(HBRUSH, COLOR_WINDOW+1);*)
    wc.lpszMenuName  := NIL;
    className        := g_szClassName;
    wc.lpszClassName := ADR(className);

    IF RegisterClass(wc)=0 THEN
       MessageBox(NIL, "Window Class registration failed!", "Error!", MB_ICONEXCLAMATION + MB_OK);
       RETURN ;
    END;

    (* Create the Window *)
    hwnd := CreateWindowEx(WS_EX_CLIENTEDGE, g_szClassName, "Chaos", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 240, 120, NIL,
			   NIL, MyInstance(), NIL);
    IF hwnd = NIL THEN
       MessageBox(NIL, "Window Creation failed!", "Error!", MB_ICONEXCLAMATION + MB_OK);
       RETURN ;
    END;

    ShowWindow(hwnd, SW_SHOWNORMAL);
    UpdateWindow(hwnd);

    (* The Message Loop *)
    WHILE GetMessage( Msg, NIL, 0, 0) DO
       TranslateMessage(Msg);
       DispatchMessage(Msg);
    END;
END chaoswindows.
