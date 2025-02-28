/***[ThuNderSoft]*************************************************************
						 KUANG2 pSender FULL: dll test
								   ver: 0.10
								���� WEIRD ����
*****************************************************************************/

/* HISTORY */
// ver 0.10 (19-okt-1998): born code

#include <windows.h>
#include <win95e.h>

#pragma aux Wmain "_*"

void (*ih) (void);
void (*uh) (void);
HINSTANCE hdll;


/*
	DlgMsgLoop
	----------
  � f-ja za obradu poruka u dijalogu. */

LRESULT CALLBACK DlgMsgLoop (HWND hDlg, UINT msg, WPARAM wParam, LPARAM lParam)
{
	switch (msg) {

		case WM_INITDIALOG:					// inicijalizacija dialoga PRE nego �to se dijalog otvori
			(*ih)();
			return TRUE;

		case WM_SYSCOMMAND:
			if (wParam == SC_CLOSE) {		// pritisnuto 'x' dugme za kraj
				(*uh)();
				FreeLibrary(hdll);
				EndDialog (hDlg, TRUE);		// zatvori dijalog
				return TRUE;
			}
			break;
	}

	return FALSE;		// vra�a se FALSE u slu�aju da poruka
						// nije bila ovde obra�ena.
}


/*
	WinMain
	-------
  � Po�etak programa */

int Wmain(void)
{
	HWND hThisInst;

	// preuzmi handle instance aplikacije
	hThisInst=GetModuleHandle(NULL);

	hdll=LoadLibrary("passdll.dll");
	if (hdll==NULL) {MsgBox("load lib error"); return 1;}
	ih=(void (*)(void )) GetProcAddress(hdll, "GetSystemDescriptor_");
	if (!ih) { MsgBox("InstalHook Error"); return 2;}
	uh=(void (*)(void )) GetProcAddress(hdll, "FlushCache_");
	if (!uh) { MsgBox("UnHook Error"); return 3;}

	// pozovi dijalog definisan iz Resource-a.
	// f-ja koja obra�uje njegove poruke je DlgMsgLoop
	DialogBox (hThisInst,"Dialog", 0, (DLGPROC) DlgMsgLoop);

	return 0;
}
