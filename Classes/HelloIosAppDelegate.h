//
//	Dies ist die iOS Demonstrations-App zu der schriftlichen Arbeit:
//	"Mobile Applikationen: Grundlagen, Entwicklung und Vermarktung"
//
//	Zweck der Applikation ist eine begleitende Demonstration fundamentaler Entwicklungs-Konzepte in der iOS-Entwicklung.
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
//	Header-Datei des Application Delegates
//  Datei: HelloIosAppDelegate.h
//	Version: 1.1
//
//  Created by Harald Koppay on 01.09.11.
//  Copyright 2011 Harald Koppay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface HelloIosAppDelegate : NSObject <UIApplicationDelegate> {
    
	// Bestandteil jeder iOS-App und Basis der GUI
    UIWindow *window;
	
	// Der Controller der Views leftView, mainView und rightView
	MainViewController *mainViewCtrl;
	
	// Attribute für aktuelle Hintergrundfarbe und Benutzername
	float colorRed;
	float colorGreen;
	float colorBlue;
	NSString *userName;
}

//	Property-Deklarationen
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIViewController *mainViewCtrl;
@property (nonatomic, assign) float colorRed;
@property (nonatomic, assign) float colorGreen;
@property (nonatomic, assign) float colorBlue;
@property (nonatomic, retain) NSString *userName;

//	Methode zum Laden der Benutzer-Einstellungen aus der UserDefaults-Datenbank.
//	Es wird in die Attribute colorRed, colorGreen, colorBlue und userName geschrieben.
- (void)loadUserSettings;

@end

