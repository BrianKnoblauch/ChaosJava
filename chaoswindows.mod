MODULE chaoswindows;

FROM SYSTEM     IMPORT ADR;
FROM Windows    IMPORT BeginPaint, CreateSolidBrush, CreateWindowEx, CS_SAVEBITS,  CW_USEDEFAULT, DefWindowProc, DestroyWindow, DispatchMessage,
                       EndPaint, GetMessage, GetSystemMetrics, HWND, HWND_TOPMOST, IDC_ARROW, IDI_APPLICATION, LPARAM, LRESULT, LoadCursor, LoadIcon,
                       MessageBox,
                       MB_ICONEXCLAMATION, MB_OK, MSG, MyInstance, PAINTSTRUCT, PostQuitMessage, RegisterClass, RGB, SetWindowPos, ShowWindow,
		       SM_CXSCREEN, SM_CYSCREEN, SW_ENUM, SWP_NOZORDER, TranslateMessage, UINT, UpdateWindow, WM_CLOSE, WM_CREATE, WM_DESTROY, WM_PAINT,
		       WNDCLASS,
		       WPARAM, WS_EX_CLIENTEDGE, WS_OVERLAPPEDWINDOW;

CONST
    g_szClassName = "myWindowClass";

PROCEDURE ["StdCall"] WndProc(hwnd : HWND; msg : UINT; wParam : WPARAM;  lParam : LPARAM): LRESULT;
VAR
    ps              : PAINTSTRUCT;
    x,y, maxx, maxy : CARDINAL;
     
BEGIN    
    CASE msg OF
    | WM_PAINT   :
      (* TODO get random direction and select color for each *)
      (* hBrush := Windows.CreateSolidBrush (Windows.RGB (0, 0, 255)); *)
      BeginPaint (hwnd, ps);      
      (* setpixel *)
      EndPaint (hwnd, ps);
    | WM_CREATE  :
      (* TODO maximize window with frame, following is close but not quite right *)
      maxy := GetSystemMetrics(SM_CYSCREEN);
      y := maxy DIV 2;
      maxx := GetSystemMetrics(SM_CXSCREEN);
      x := maxx DIV 2;
      SetWindowPos(hwnd, HWND_TOPMOST, 0, 0, maxx, maxy, SWP_NOZORDER);
      RETURN 0;
    | WM_CLOSE   :
      DestroyWindow(hwnd);
    | WM_DESTROY :
      PostQuitMessage(0);
    ELSE RETURN DefWindowProc(hwnd, msg, wParam, lParam);
    END;
    RETURN 0;    
END WndProc; 

VAR
    className       : ARRAY [0..14] OF CHAR;
    hwnd            : HWND;
    Msg             : MSG;
    wc              : WNDCLASS;

BEGIN
    (* Register the Window Class *)
    wc.style         := CS_SAVEBITS;
    wc.lpfnWndProc   := WndProc;
    wc.cbClsExtra    := 0;
    wc.cbWndExtra    := 0;
    wc.hInstance     := MyInstance();
    wc.hIcon         := LoadIcon(NIL, IDI_APPLICATION);
    wc.hCursor       := LoadCursor(NIL, IDC_ARROW);
    wc.hbrBackground := CreateSolidBrush(RGB (0, 0, 0));
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
