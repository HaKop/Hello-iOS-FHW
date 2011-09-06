//
//	Dies ist die iOS Demonstrations-App zu der schriftlichen Arbeit:
//	"Mobile Applikationen: Grundlagen, Entwicklung und Vermarktung"
//
//	Zweck der Applikation ist eine begleitende Demonstration fundamentaler Entwicklungs-Konzepte der iOS-Entwicklung.
//	Die zugehörigen, ausführlichen Erläuterungen sind in der schriftlichen Arbeit zu finden.
//
//	Einige Konzepte, die hier demonstriert werden:
//	* Entwicklung nach dem Model View Controller Entwurfsmuster
//	* Target Action Entwurfsmuster, unterstützt durch den InterfaceBuilder
//	* Delegate Entwurfsmuster, Implementierung von Protokollen
//	außerdem:
//	Animationen, UserDefaults, Gesten-Erkennung, TCP-Client
//
//	Kern-Funktionalität dieser App ist die Bereitstellung eines TCP-Clients, welcher sich zu einem TCP-Server
//	verbindet, welcher wiederum in der Android-App realisiert wurde. Der Musik-Service, welcher ebenfalls von 
//	der Android-App bereitgestellt wird, kann über die erfolgreich aufgebaute Socket-Verbindung gesteuert werden.
//
//	Klassen dieses iOS-Projektes:
//	* Application Delegate, Einstieg und Kern-Komponente
//	* MainViewController, Controller der Screens leftView, mainView und rightView der Anwendung
//
//	Dieser Teil:
//	Implementations-Datei des View Controllers
//  Datei: MainViewController.m
//	Version: 1.1
//
//  Created by Harald Koppay on 01.09.11.
//  Copyright 2011 Harald Koppay. All rights reserved.
//

#import "MainViewController.h"
#import "HelloIosAppDelegate.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netdb.h>
#import <ifaddrs.h>
#import <arpa/inet.h>


@implementation MainViewController

// Getter und Setter Methoden werden automatisch erzeugt
@synthesize writeBack;
@synthesize leftView;
@synthesize mainView;
@synthesize rightView;
@synthesize userNameTextField, redSlider, greenSlider, blueSlider;
@synthesize btnConnectTCP, ipAddressTextField, portTextField, btnPlayMusic, btnStopMusic, statusLabel, localIpLabel;
@synthesize navSettings, navArrows, navMVC, navMVCArrows, navSettingsToMain, navSettingsToMainArrows, navMVCToMain, navMVCToMainArrows;
@synthesize swipeRecognizer, swipeToRightRecognizer;

#pragma mark -
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Benutzer-Einstellungen holen und auf die Views anwenden
	[self getLoadedUserSettings];
	
	// Parameter für die Animation der Navigations-Elemente definieren
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	// Zielkoordinaten der Animation festlegen
	[self.navSettings setCenter:CGPointMake(67, 409)];
	[self.navArrows setCenter:CGPointMake(10, 409)];
	[self.navMVC setCenter:CGPointMake(251, 388)];
	[self.navMVCArrows setCenter:CGPointMake(309, 389)];
	// Animation durchführen
	[UIView commitAnimations];
	
	// Gestenerkennungs-Objekte werden initialisiert
	self.swipeRecognizer= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
	self.swipeToRightRecognizer= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
	swipeToRightRecognizer.direction=UISwipeGestureRecognizerDirectionLeft;
	// Gestenerkennung wird aktiviert
	[self.mainView addGestureRecognizer:swipeRecognizer];
	[self.mainView addGestureRecognizer:swipeToRightRecognizer];
	
	// mainView wird angezeigt
	[self.view addSubview:mainView];
}

//	Benutzer-Einstellungen holen und auf die Views anwenden
-(void)getLoadedUserSettings{
	// Zugriff auf das Application Delegate
	HelloIosAppDelegate *del = (HelloIosAppDelegate*) [UIApplication sharedApplication].delegate;
	
	// Farbeinstellungen und Benutzername werden aus den App Delegate Attributen geholt 
	[redSlider setValue:del.colorRed];
	[greenSlider setValue:del.colorGreen];
	[blueSlider setValue:del.colorBlue];
	[userNameTextField setText:del.userName];
	
	// Benutzername wird in das Begrüßungs TextLabel geschrieben
	[writeBack setText:[NSString stringWithFormat:@"Hallo %@",del.userName]];
	
	// UIColor-Objekt wird anhand der Benutzer-Farbeinstellungen erstellt
	UIColor *col= [[UIColor alloc] initWithRed:redSlider.value green:greenSlider.value blue:blueSlider.value alpha:1.0];
	
	// Hintergrundfarben der Views werden mit dem UIColor-Objekt gesetzt
	[leftView setBackgroundColor:col];
	[mainView setBackgroundColor:col];
	[rightView setBackgroundColor:col];
	[col release];
}

//	Hilfsmethode zur Animation der Navigationselemente im mainView
- (void)animateMainNav {
	// Zurücksetzen der Navigations-ELemente auf ursprüngliche Koordinaten
	[self.navSettings setCenter:CGPointMake(257, 421)];
	[self.navArrows setCenter:CGPointMake(200, 421)];
	[self.navMVC setCenter:CGPointMake(30, 388)];
	[self.navMVCArrows setCenter:CGPointMake(88, 389)];
	// Definition der Animations-Parameter
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelay:0.7];
	// Ziel-Koordinaten festlegen
	[self.navSettings setCenter:CGPointMake(67, 421)];
	[self.navArrows setCenter:CGPointMake(10, 421)];
	[self.navMVC setCenter:CGPointMake(251, 388)];
	[self.navMVCArrows setCenter:CGPointMake(309, 389)];
	// Animation starten
	[UIView commitAnimations];
}

//	Hilfsmethode zur Animation der Navigationselemente im leftView
- (void)animateSettingsNav{
	// Zurücksetzen der Navigations-ELemente auf ursprüngliche Koordinaten
	[self.navSettingsToMain setCenter:CGPointMake(30, 421)];
	[self.navSettingsToMainArrows setCenter:CGPointMake(88, 422)];
	// Definition der Animations-Parameter
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelay:0.7];
	// Ziel-Koordinaten festlegen
	[self.navSettingsToMain setCenter:CGPointMake(251, 421)];
	[self.navSettingsToMainArrows setCenter:CGPointMake(309, 422)];
	// Animation starten
	[UIView commitAnimations];
}

//	Hilfsmethode zur Animation der Navigationselemente im rightView
- (void)animateMVCNav {
	// Zurücksetzen der Navigations-ELemente auf ursprüngliche Koordinaten
	[self.navMVCToMain setCenter:CGPointMake(257, 429)];
	[self.navMVCToMainArrows setCenter:CGPointMake(200, 430)];
	// Definition der Animations-Parameter
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelay:0.7];
	// Ziel-Koordinaten festlegen
	[self.navMVCToMain setCenter:CGPointMake(67, 429)];
	[self.navMVCToMainArrows setCenter:CGPointMake(10, 430)];
	// Animation starten
	[UIView commitAnimations];
}

//	Methode für die Verarbeitung von erkannten "Wisch"-Gesten.
//	Je nach Richtung und Ursprungs-View der Wisch-Geste, wird zum left, right oder main-View navigiert.
//	Entsprechende Animations-Hilfsmethoden werden aufgerufen.
//	input: sender: Gestenerkennungs-Objekt, welches der erkannten Geste zugewiesen war
- (void) onSwipe:(UISwipeGestureRecognizer *)sender {
	// Variable zum Festhalten des gewünschten Navigations-Animationstypen
	int trans;
	
	// Definition der Animations-Parameter für den Wechsel zwischen den Views
	[UIView beginAnimations:@"animateSwipe" context:nil];
	[UIView setAnimationDuration:0.7];
	
	// Eine Wischgeste im mainView nach rechts (entspricht Navigation zum leftView hin)
	// oder im leftView nach links (entspricht Navigation zum mainView hin) wurde erkannt 
	if (sender==swipeRecognizer) {
		// Eine Wischgeste im mainView nach rechts (entspricht Navigation zum leftView hin)
		if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
			// Gestenerkennung wird vom 'alten' View entfernt und dem 'neuen' View hinzugefügt.
			// Änderung der zu erkennenden Wischgeste
			// und Navigation zum 'neuen' View
			[mainView removeGestureRecognizer:swipeRecognizer];
			[mainView removeGestureRecognizer:swipeToRightRecognizer];
			// 'alter' View wird durch 'neuen' View in der View-Hierarchie ausgetauscht
			[self.mainView removeFromSuperview];
			[self.view addSubview:leftView];
			[leftView addGestureRecognizer:swipeRecognizer];
			swipeRecognizer.direction=UISwipeGestureRecognizerDirectionLeft;
			trans=UIViewAnimationTransitionFlipFromLeft;
		// Eine Wischgeste im leftView nach links (entspricht Navigation zum mainView hin)
		} else {
			// Gestenerkennung wird vom 'alten' View entfernt und dem 'neuen' View hinzugefügt.
			// Änderung der zu erkennenden Wischgeste
			// und Navigation zum 'neuen' View
			[leftView removeGestureRecognizer:swipeRecognizer];
			// 'alter' View wird durch 'neuen' View in der View-Hierarchie ausgetauscht
			[self.leftView removeFromSuperview];
			[self.view addSubview:self.mainView];
			[mainView addGestureRecognizer:swipeRecognizer];
			[mainView addGestureRecognizer:swipeToRightRecognizer];
			swipeRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
			trans = UIViewAnimationTransitionFlipFromRight;
			[self closingLeftView];
		}
	// Eine Wischgeste im mainView nach links (entspricht Navigation zum rightView hin)
	// oder im rightView nach rechts (entspricht Navigation zum mainView hin) wurde erkannt
	} else {
		// Eine Wischgeste im mainView nach links (entspricht Navigation zum rightView hin)
		if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
			// Gestenerkennung wird vom 'alten' View entfernt und dem 'neuen' View hinzugefügt.
			// Änderung der zu erkennenden Wischgeste
			// und Navigation zum 'neuen' View
			[mainView removeGestureRecognizer:swipeRecognizer];
			[mainView removeGestureRecognizer:swipeToRightRecognizer];
			// 'alter' View wird durch 'neuen' View in der View-Hierarchie ausgetauscht
			[self.mainView removeFromSuperview];
			[self.view addSubview:rightView];
			[rightView addGestureRecognizer:swipeToRightRecognizer];
			swipeToRightRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
			trans=UIViewAnimationTransitionFlipFromRight;
			[self initRightView];
		// Eine Wischgeste im rightView nach rechts (entspricht Navigation zum mainView hin)
		} else {
			// Gestenerkennung wird vom 'alten' View entfernt und dem 'neuen' View hinzugefügt.
			// Änderung der zu erkennenden Wischgeste
			// und Navigation zum 'neuen' View
			[rightView removeGestureRecognizer:swipeToRightRecognizer];
			// 'alter' View wird durch 'neuen' View in der View-Hierarchie ausgetauscht
			[self.rightView removeFromSuperview];
			[self.view addSubview:self.mainView];
			[mainView addGestureRecognizer:swipeRecognizer];
			[mainView addGestureRecognizer:swipeToRightRecognizer];
			swipeToRightRecognizer.direction=UISwipeGestureRecognizerDirectionLeft;
			trans = UIViewAnimationTransitionFlipFromLeft;
		}
	}
	
	// Ausführen der Navigations-Animation
	// cache:YES sorgt dafür, dass alle weiteren Animationen warten, bis diese hier beendet wurde
	[UIView setAnimationTransition:trans forView:self.view cache:YES];	
	[UIView commitAnimations];
	
	// Hilfsmethoden für die Animation der Navigations-Elemente werden gerufen
	[self animateMainNav];
	[self animateSettingsNav];
	[self animateMVCNav];
}

//	Hilfsmethode, welche alle Einstellungen im leftView, in die Attribute des Application Delegates zurückschreibt
//	Dank modifizierter Setter-Methoden im App Delegate, werden diese Einstellungen sofort in die NSUserDefaults-Datenbank geschrieben
-(void)closingLeftView {
	// Zugriff auf das Application Delegate
	HelloIosAppDelegate *del = (HelloIosAppDelegate*) [UIApplication sharedApplication].delegate;
	del.colorRed = redSlider.value;
	del.colorGreen = greenSlider.value;
	del.colorBlue = blueSlider.value;
	del.userName = userNameTextField.text;
}

//	Hilfsmethode, welche das Anzeigen der IP-Adresse des Netzwerk-Interfaces veranlasst sobald rightView geöffnet wird
-(void)initRightView{
	localIpLabel.text = [NSString stringWithFormat:@"Local IP: %@",[self getIPAddress]];
}

#pragma mark -
#pragma mark Methoden der Benutzer-Interaktion

//	Event-Handler-Methode zur Verarbeitung von Änderungen der Slider-Werte im leftView (bedingt durch Benutzer-Eingaben)
//	Hintergrundfarben der Views werden, analog zu den Farbeingaben in den Slidern, geändert
//	input: slider: Slider-Element, welches vom Benutzer verändert wurde
-(IBAction)sliderEvents:(UISlider *)slider{
	// Swipe-Erkennung wird deaktiviert solange der Slider bewegt wird
	[leftView removeGestureRecognizer:swipeRecognizer];
	
	UIColor *col= [[UIColor alloc] initWithRed:redSlider.value green:greenSlider.value blue:blueSlider.value alpha:1.0];
	[leftView setBackgroundColor:col];
	[mainView setBackgroundColor:col];
	[rightView setBackgroundColor:col];
	[col release];
	
	// Swipe-Erkennung wird aktiviert sobald die Verarbeitung abgeschlossen ist
	[leftView addGestureRecognizer:swipeRecognizer];
}

//	Optionale Methode aus dem UITextField-Protokoll zur Verarbeitung von RETURN-Eingaben in einem Textfeld
//	Dieser View Controller wird somit zum Delegate des UITextField-Objektes
//	Tastatur wird bei Betätigung von RETURN ausgeblendet
//	input: textField: Betreffendes Eingabefeld, innerhalb welchem RETURN betätigt wurde
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	// textField gibt seine Funktion als "First Responder" auf, verliert also den Fokus, womit auch die Tastatur ausgeblendet wird
	[textField resignFirstResponder];
	// Wurde der Text geändert, so wird er als neuer Benutzername übernommen
	if (textField == userNameTextField) {
		[writeBack setText:[NSString stringWithFormat:@"Hallo %@",textField.text]];
	}
	return NO;
}

//	Event-Handler-Methode zur Verarbeitung von Button-Clicks im rightView
//	Buttons im rightView steuern die Kommunikation mit dem TCP-Server
//	input: btn: Button des rigtViews, welcher betätigt wurde
-(IBAction)btnNetworkingTouched:(UIButton *)btn{
	// "Verbindungs"-Button wurde betätigt
	if (btn == btnConnectTCP){
		// TCP-Client ist nicht verbunden und nicht initialisiert
		if ([btnConnectTCP.currentTitle compare:@"Connect"] == NSOrderedSame) {
			// Wenn Nezwerkverbindung vorhanden: Verbindung zum TCP-Server aufbauen
			if ([self checkNetwork]){
				[self initRightView];
				[self initNetworkCommunication];
			// Wenn Netzwerkverbindung nicht vorhanden: Dialogfenster mit entsprechender Meldung ausgeben
			} else {
				UIAlertView *alert = [[UIAlertView alloc] 
									  initWithTitle:@"Network Connection Error" 
									  message:@"Eine Netzwerkverbindung muss bestehen, um dieses Feature zu nutzen." 
									  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		// TCP-Client ist verbunden: Verbindung beenden
		} else if ([btnConnectTCP.currentTitle compare:@"Disconnect"] == NSOrderedSame){
			[self disconnectFromServer];
		// TCP-Client ist nicht verbunden, aber initialisiert: Wiederverbinden
		} else {
			[self reconnect];
		}
	// "Play Music"-Button wurde betätigt
	} else if (btn == btnPlayMusic) {
		[self sendPlayCmdToServer];
	// "Stop Music"-Button wurde betätigt
	} else if (btn == btnStopMusic) {
		[self sendStopCmdToServer];
	}
}

#pragma mark -
#pragma mark Methoden der Socket-Kommunikation

//	Hilfsmethode zur Prüfung des Netzwerkstatus des Gerätes
//	Da das iOS-SDK keine Convenience-Methoden zur Prüfung des Netzwerkstatus anbietet,
//	geschieht dies hier über Umwegen mittels Prüfung der Verbindungsfähigkeit zu einer 0er-Adresse
//	Code u.a. in Anlehnung an Sadun, Erica: iPhone 3.0 cookbook
//	output: BOOL: Netzwerkverbindung vorhanden oder nicht vorhanden
-(BOOL)checkNetwork {
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	// Prüfung ob Flags gesetzt wurden
	if (!didRetrieveFlags)
	{
		return NO;
	}
	
	// Prüfung ob Flag "isReachable" gesetzt und "needConnection" nicht gesetzt sind --> Netzwerkverbindung vorhanden
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
}

//	Hilfsmethode zur Ermittlung der IP-Adresse des Netzwerk-Interfaces
//	Da das iOS-SDK keine Convenience-Methoden zur Ermittlung der IP-Adresse des Netzwerk-Interfaces anbietet,
//	geschieht dies hier manuell
//	Code u.a. in Anlehnung an Sadun, Erica: iPhone 3.0 cookbook
//	und Brown, Matt: How To get IP Address of iPhone OS (Blog-Entry)
//	output: NSString: IP-Adresse des eigenen Netzwerk-Interfaces als String
- (NSString *)getIPAddress {
	
    NSString *address = @"n/a";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
} 

//	Socketverbindung zum Host wird initialisiert/hergestellt
//	Streams für Ein-/Ausgabe werden geöffnet 
//	Erläuterungen analog ab Seite 112 in der schriftl. Ausarbeitung
- (void)initNetworkCommunication {
	// Der Aufbau der Verbindung zum TCP-Server des Android-Apps erfolgt nach Betätigung des Connect-Buttons im	rightView
	// IP-Adresse und Portnummer werden aus den entsprechenden Eingabefeldern im rightView geholt
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)ipAddressTextField.text, [portTextField.text intValue], &readStream, &writeStream);
    // Da in der Folge nur noch die Objective-C-Klassen NSInputStream und NSOutputStream verwendet werden sollen, 
	// werden die Zeiger readStream und writeStream auf NSStream-Zeiger gecastet
	inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
	
	// Die NSStream-Klasse stellt ein Delegate-Protokoll zur Verfügung, welches eine Methode zur Behandlung von Stream-Events definiert. 
	// Da der MainViewController diese Methode implementieren soll, wird er als Delegat für NSStream-Objekte ausgewiesen
	[inputStream setDelegate:self];
	[outputStream setDelegate:self];
	
	// Um nicht den UI-Thread der Anwendung zu blockieren während auf Stream-Events gewartet wird, 
	// kommt eine NSRunLoop zum Einsatz, die sicherstellt, dass das Stream- Delegat nur die Prozessorzeit bekommt, 
	// die es für die Abarbeitung von eintreffenden Stream-Events benötigt
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	// Streams werden geöffnet
	[inputStream open];
	[outputStream open];
}

//	reconnect() wird gerufen wenn die Socket-Verbindung bereits initialisiert, aber geschlossen wurde
//	Streams zum TCP-Server werden erneut geöffnet
-(void)reconnect{
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[inputStream open];
	[outputStream open];
}

//	Methode zum Senden eines "MUSIC PLAY"-Kommandos an den TCP-Server
- (void)sendPlayCmdToServer{
	NSString *playCmd = [NSString stringWithFormat:@"MUSIC PLAY\n"];
	// Encodierung in NSData für outputStream
	NSData *playCmdData = [[NSData alloc] initWithData:[playCmd dataUsingEncoding:NSASCIIStringEncoding]];
	// NSData-Objekt wird auf outputStream geschrieben
	[outputStream write:[playCmdData bytes] maxLength:[playCmdData length]];
	[playCmdData release];
}

//	Methode zum Senden eines "MUSIC STOP "-Kommandos an den TCP-Server
- (void)sendStopCmdToServer{
	NSString *stopCmd = [NSString stringWithFormat:@"MUSIC STOP\n"];
	// Encodierung in NSData für outputStream
	NSData *stopCmdData = [[NSData alloc] initWithData:[stopCmd dataUsingEncoding:NSASCIIStringEncoding]];
	// NSData-Objekt wird auf outputStream geschrieben
	[outputStream write:[stopCmdData bytes] maxLength:[stopCmdData length]];
	[stopCmdData release];
}

//	Event-Handler-Methode zur Verarbeitung von Events auf den Ein-/Ausgabe-Streams
//	Konform zum Protokoll NSStreamDelegate
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {	
	switch (streamEvent) {	
		// Verbindung zum Host wurde erfolgreich hergestellt
		case NSStreamEventOpenCompleted:
			// Anpassen der GUI-Elemente
			statusLabel.text = @"Server: Connection established...";
			btnPlayMusic.enabled = YES;
			btnPlayMusic.alpha =1.0;
			btnStopMusic.enabled = YES;
			btnStopMusic.alpha =1.0;
			[btnConnectTCP setTitle:@"Disconnect" forState:UIControlStateNormal];
			break;
		// Es sind Daten auf dem inputStream eingetroffen
		case NSStreamEventHasBytesAvailable:
			if (theStream == inputStream) {
				uint8_t buffer[1024];
				int len;
				// Solange Daten verfügbar sind, werden diese verarbeitet
				while ([inputStream hasBytesAvailable]) {
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0) {
						// Daten werden in NSString-Objekte encodiert
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						if (nil != output) {
							// Angekommene Daten werden als NSStrings im Status-Textlabel angeezeigt
							statusLabel.text = [NSString stringWithFormat:@"Server %@", output];
						}
						[output release];
					}
				}
			}
			break;		
		// Es ist ein Fehler aufgetreten. Hilfsmethode zum Schliessen der Streams wird aufgerufen
		case NSStreamEventErrorOccurred:
			statusLabel.text = [NSString stringWithFormat:@"Cannot connect."];			
			[self disconnectFromServer];
			break;
		// Verbindung wurde beendet. Hilfsmethode zum Schliessen der Streams wird aufgerufen
		case NSStreamEventEndEncountered:
			statusLabel.text = [NSString stringWithFormat:@"Connection Lost."];			
			[self disconnectFromServer];
			break;			
		default:
			break;
	}
}

//	Methode zum Schließen der Socket-Verbindung
//	Streams werden geschlossen, GUI-Elemente angepasst
- (void)disconnectFromServer{
	// Schließen der Streams
	[outputStream close];
	[inputStream close];
	[outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	// Anpassen der GUI-Elemente
	[btnConnectTCP setTitle:@"Connect" forState:UIControlStateNormal];
	statusLabel.text = [NSString stringWithFormat:@""];	
	btnPlayMusic.enabled = NO;
	btnPlayMusic.alpha =0.2;
	btnStopMusic.enabled = NO;
	btnStopMusic.alpha =0.2;
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//	Speicherbereiningung bei Freigabe des Controllers
- (void)dealloc {
	[writeBack release];
	[leftView release];
	[mainView release];
	[rightView release];
	[userNameTextField release];
	[redSlider release];
	[greenSlider release];
	[blueSlider release];
	[btnConnectTCP release];
	[btnPlayMusic release];
	[btnStopMusic release];
	[ipAddressTextField release];
	[portTextField release];
	[statusLabel release];
	[localIpLabel release];
	[navSettings release];
	[navArrows release];
	[navMVC release];
	[navMVCArrows release];
	[navSettingsToMain release];
	[navSettingsToMainArrows release];
	[navMVCToMain release];
	[navMVCToMainArrows release];
	[swipeRecognizer release];
	[swipeToRightRecognizer release];

    [super dealloc];
}


@end
