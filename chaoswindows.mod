MODULE chaoswindows;

FROM Random     IMPORT Rand, Srand;
FROM SYSTEM     IMPORT ADR, CAST;
FROM Windows    IMPORT BeginPaint, COLORREF, CreateSolidBrush, CreateWindowEx, CS_SAVEBITS,  CW_USEDEFAULT, DefWindowProc, DestroyWindow, DispatchMessage,
                       EndPaint, GetClientRect, GetMessage, HWND, IDC_ARROW, IDI_APPLICATION, InvalidateRect, LPARAM, LRESULT, LoadCursor, LoadIcon,
                       RECT, MessageBox, MB_ICONEXCLAMATION, MB_OK, MSG, MyInstance, PAINTSTRUCT, PostQuitMessage, RegisterClass, RGB, SetPixel, SetTimer,
		       ShowWindow, SW_MAXIMIZE, TIMERPROC, TranslateMessage, UINT, UpdateWindow, WM_CLOSE, WM_CREATE,
		       WM_DESTROY, WM_PAINT, WM_TIMER, WNDCLASS, WPARAM, WS_EX_CLIENTEDGE, WS_OVERLAPPEDWINDOW;

CONST
     g_szClassName = "myWindowClass";

VAR
     x,y, maxx, maxy : CARDINAL;

PROCEDURE ["StdCall"] WndProc(hwnd : HWND; msg : UINT; wParam : WPARAM;  lParam : LPARAM): LRESULT;
VAR
    color           : COLORREF;  
    direction       : CARDINAL;
    lprect          : RECT;
    ps              : PAINTSTRUCT;
     
BEGIN
    CASE msg OF
    | WM_CREATE  :
      ShowWindow(hwnd, SW_MAXIMIZE);
      UpdateWindow(hwnd);
      GetClientRect(hwnd, lprect);
      maxy := lprect.bottom;
      y := maxy DIV 2;
      maxx := lprect.right;
      x := maxx DIV 2;      
      SetTimer(hwnd, 0, 1, CAST(TIMERPROC, NIL));
      RETURN 0;	  
    | WM_PAINT   :
      direction := Rand(3);
      CASE direction OF
      | 0 :
        x := (x + (maxx DIV 2)) DIV 2;
	y := y DIV 2;
	color := RGB(255, 0, 0);
      | 1 :
	x := (x + maxx) DIV 2;
	y := (y + maxy) DIV 2;
	color := RGB(0, 255, 0);
      | 2 :
	x := x DIV 2;
	y := (y + maxy) DIV 2;
	color := RGB(0, 0, 255);
      END; (* CASE *)
      BeginPaint(hwnd, ps);      
      SetPixel(ps.hdc, x, y, color);
      EndPaint(hwnd, ps);
      RETURN 0;
    | WM_CLOSE   :
      DestroyWindow(hwnd);
    | WM_DESTROY :
      PostQuitMessage(0);
    | WM_TIMER :
      InvalidateRect(hwnd, NIL, FALSE);
      RETURN 0;
    ELSE RETURN DefWindowProc(hwnd, msg, wParam, lParam);
    END; (* CASE *)
    RETURN 0;    
END WndProc; 

VAR
    className       : ARRAY [0..14] OF CHAR;
    hwnd            : HWND;
    Msg             : MSG;
    wc              : WNDCLASS;    

BEGIN
    Srand;
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
            
    (* The Message Loop *)
    WHILE GetMessage( Msg, NIL, 0, 0) DO
       TranslateMessage(Msg);
       DispatchMessage(Msg);
    END;
END chaoswindows.
