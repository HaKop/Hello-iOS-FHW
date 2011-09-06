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
//	Komponenten dieses iOS-Projektes:
//	* Application Delegate, Einstieg und Kern-Komponente
//	* MainViewController, Controller der Screens leftView, mainView und rightView der Anwendung
//
//	Dieser Teil:
//	Header-Datei des View Controllers
//  Datei: MainViewController.h
//	Version: 1.1
//
//  Created by Harald Koppay on 01.09.11.
//  Copyright 2011 Harald Koppay. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MainViewController : UIViewController <UITextFieldDelegate, NSStreamDelegate> {
	// Die drei Views bzw. Screens der Anwendung
	UIView *leftView;
	UIView *mainView;
	UIView *rightView;
	
	// GUI-Elemente des mainViews
	UILabel *writeBack;
	UILabel *navSettings;
	UIImageView *navArrows;
	UILabel *navMVC;
	UIImageView *navMVCArrows;
	
	// GUI-Elemente des leftViews
	UITextField *userNameTextField;
	UISlider *redSlider;
	UISlider *greenSlider;
	UISlider *blueSlider;
	UILabel *navSettingsToMain;
	UIImageView *navSettingsToMainArrows;
	
	// GUI-Elemente des rightViews
	UIButton *btnConnectTCP;
	UIButton *btnPlayMusic;
	UIButton *btnStopMusic;
	UITextField *ipAddressTextField;
	UITextField *portTextField;
	NSInputStream *inputStream;
	NSOutputStream *outputStream;
	UILabel *statusLabel;
	UILabel *localIpLabel;
	UILabel *navMVCToMain;
	UIImageView *navMVCToMainArrows;
	
	// Klassen für die Gestenerkennung
	// Gestenerkennung "Wisch"-Geste nach links
	UISwipeGestureRecognizer *swipeRecognizer;
	// Gestenerkennung "Wisch"-Geste nach rechts
	UISwipeGestureRecognizer *swipeToRightRecognizer;
}

//	Property-Deklarationen
//	Die Marke IBOutlet ermöglicht die Verbindnung mit Interface Builder Objekten

//	Property-Deklaration der drei Views/Screens
@property(nonatomic,retain) IBOutlet UIView *leftView;
@property(nonatomic,retain) IBOutlet UIView *mainView;
@property(nonatomic,retain) IBOutlet UIView *rightView;

//	Property-Deklaration der GUI-Elemente des mainViews
@property(nonatomic,retain) IBOutlet UILabel *writeBack;
@property(nonatomic,retain) IBOutlet UILabel *navSettings;
@property(nonatomic,retain) IBOutlet UIImageView *navArrows;
@property(nonatomic,retain) IBOutlet UILabel *navMVC;
@property(nonatomic,retain) IBOutlet UIImageView *navMVCArrows;

//	Property-Deklaration der GUI-Elemente des leftViews
@property(nonatomic,retain) IBOutlet UITextField *userNameTextField;
@property(nonatomic,retain) IBOutlet UISlider *redSlider;
@property(nonatomic,retain) IBOutlet UISlider *greenSlider;
@property(nonatomic,retain) IBOutlet UISlider *blueSlider;
@property(nonatomic,retain) IBOutlet UILabel *navSettingsToMain;
@property(nonatomic,retain) IBOutlet UIImageView *navSettingsToMainArrows;

//	Property-Deklaration der GUI-Elemente des rightViews
@property(nonatomic,retain) IBOutlet UIButton *btnConnectTCP;
@property(nonatomic,retain) IBOutlet UIButton *btnPlayMusic;
@property(nonatomic,retain) IBOutlet UIButton *btnStopMusic;
@property(nonatomic,retain) IBOutlet UITextField *ipAddressTextField;
@property(nonatomic,retain) IBOutlet UITextField *portTextField;
@property(nonatomic,retain) IBOutlet UILabel *statusLabel;
@property(nonatomic,retain) IBOutlet UILabel *localIpLabel;
@property(nonatomic,retain) IBOutlet UILabel *navMVCToMain;
@property(nonatomic,retain) IBOutlet UIImageView *navMVCToMainArrows;

//	Property-Deklaration für die Gestenerkennungs-Klassen
@property(nonatomic,retain) UISwipeGestureRecognizer *swipeRecognizer;
@property(nonatomic,retain) UISwipeGestureRecognizer *swipeToRightRecognizer;

//	Action/Methode zur Verarbeitung von Veränderungen der Slider-Werte im leftView
//	Marke IBAction dient der Verknüpfung mit Interface Builder Objekten
- (IBAction)sliderEvents:(UISlider *)slider;
//	Action/Methode zur Verarbeitung von Button-Clicks im rightView
//	Marke IBAction dient der Verknüpfung mit Interface Builder Objekten
- (IBAction)btnNetworkingTouched:(UIButton *)btn;

//	Methoden der Socket-Kommunikation
//	Verbindung zum Host/TCP-Server wird hergestellt,
//	Streams werden geöffnet
- (void)initNetworkCommunication;
//	Senden eines "MUSIC STOP" Kommandos auf dem geöffneten OutputStream
- (void)sendStopCmdToServer;
//	Senden eines "MUSIC PLAY" Kommandos auf dem geöffneten OutputStream
- (void)sendPlayCmdToServer;
//	Verbindung zum Host/TCP-Server wird beendet,
//	Streams werden geschlossen
- (void)disconnectFromServer;
//	Hilfsmethode zur Prüfung, ob eine Netzwerkverbindung besteht
- (BOOL)checkNetwork;
//	Verbindnung zum Host/TCP-Server wird wieder hergestellt
- (void)reconnect;
//	Hilfmethode zur Ermittlung der IP-Adresse des Netzwerk-Interfaces
- (NSString *)getIPAddress;

//	Hilfsmethoden für die (animierte) Navigation zwischen den einzelnen Views
//	Methode für die Animation der Navigationselemente im mainView
- (void)animateMainNav;
//	Methode für die Animation der Navigationselemente im leftView
- (void)animateSettingsNav;
//	Methode für die Animation der Navigationselemente im rightView
- (void)animateMVCNav;
//	Hilfsmethode, welche alle Einstellungen im leftView, in die Attribute des Application Delegates zurückschreibt
//	Dank modifizierter Setter-Methoden, werden diese Einstellungen sofort in die NSUserDefaults-Datenbank geschrieben
- (void)closingLeftView;
//	Hilfsmethode, welche das Anzeigen der IP-Adresse des Netzwerk-Interfaces veranlasst sobald rightView geöffnet wird
- (void)initRightView;

//	Methode zum Laden der gespeicherten Benutzer-Einstellungen
- (void)getLoadedUserSettings;

@end
