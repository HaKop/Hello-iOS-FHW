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
//	Implementations-Datei des Application Delegates
//  Datei: HelloIosAppDelegate.m
//	Version: 1.1
//
//  Created by Harald Koppay on 01.09.11.
//  Copyright 2011 Harald Koppay. All rights reserved.
//


#import "HelloIosAppDelegate.h"


@implementation HelloIosAppDelegate

// Getter und Setter Methoden werden automatisch erzeugt
@synthesize window;
@synthesize mainViewCtrl;
@synthesize colorRed, colorGreen, colorBlue, userName;


#pragma mark -
#pragma mark Application lifecycle

//	Zustandsübergangsmethode; wird nach dem Start der App und vor dem Übergang in den Zustand ACTIVE aufgerufen.
//	Hier werden alle Initialisierungsmaßnahmen durchgeführt.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Benutzer-Einstellungen werden aus den UserDefaults geladen
	[self loadUserSettings];
	
	// View-Controller wird initialisiert und der Basis-View dem window-Objekt hinzugefügt
	[self setMainViewCtrl:[[MainViewController alloc] initWithNibName:@"MainView" bundle:nil]];
	[[self window] addSubview:[[self mainViewCtrl] view]];
    
	// window und alle Unterelemente werden angezeigt und nehmen fortan alle Benutzerinteraktionen entgegen.
    [self.window makeKeyAndVisible];
    
    return YES;
}



//	Zustandsübergangsmethode; wird kurz vor dem Eintreten der App in den Hintergrund aufgerufen.
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

//	Zustandsübergangsmethode; wird beim Eintreten der App in den Hintergrund aufgerufen.
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}

//	Zustandsübergangsmethode; wird kurz vor dem Eintreten der App in den Vordergrund aufgerufen.
- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}

//	Zustandsübergangsmethode; wird beim Eintreten der App in den Vordergrund aufgerufen.
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

//	Zustandsübergangsmethode; wird kurz vor Beendigung der App aufgerufen. Jedoch nicht wenn die Anwendung im Zustand SUSPENDED ist.
- (void)applicationWillTerminate:(UIApplication *)application {
}


#pragma mark UserDefaults
//	Methode zum Laden der Benutzer-Einstellungen aus der UserDefaults-Datenbank.
//	Es wird in die Attribute colorRed, colorGreen, colorBlue und userName geschrieben.
- (void)loadUserSettings{
	// Laden des Benuternamens
	userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
	// Wurde kein Benutzername gespeichert, so wird der Standard-Name "iOS" verwendet
	if ([userName compare:@""] == NSOrderedSame) {
		userName = @"iOS";
	}
	
	// Laden der Farbeinstellungen
	colorRed = [[NSUserDefaults standardUserDefaults] floatForKey:@"colorRed"];	
	colorGreen = [[NSUserDefaults standardUserDefaults] floatForKey:@"colorGreen"];
	colorBlue = [[NSUserDefaults standardUserDefaults] floatForKey:@"colorBlue"];
	
	// Wurden keine Farbeinstellungen gespeichert bzw. sind diese gleich 0, so wird eine Standard-Farbe verwendet
	if (colorRed == 0 && colorGreen == 0 && colorRed == 0) {
		colorRed = 0.8;
		colorGreen = 0.9;
		colorBlue = 1.0;
	}
}

#pragma mark Ueberschriebene Setter

//	Setter-Methoden für die Attribute colorRed, colorGreen, colorBlue und userName werden dahingehend überschrieben,
//	dass nach jeder Änderung, der entsprechende Wert direkt in die UserDefaults-Datenbank der App übernommen wird.
-(void)setUserName:(NSMutableString*)string{
	[string retain];
	[userName release];
	userName = string;
	[[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
}
-(void)setColorRed:(float)value{
	colorRed = value;
	[[NSUserDefaults standardUserDefaults] setFloat:colorRed forKey:@"colorRed"];
}
-(void)setColorGreen:(float)value{
	colorGreen = value;
	[[NSUserDefaults standardUserDefaults] setFloat:colorGreen forKey:@"colorGreen"];
}
-(void)setColorBlue:(float)value{
	colorBlue = value;
	[[NSUserDefaults standardUserDefaults] setFloat:colorBlue forKey:@"colorBlue"];
}




#pragma mark -
#pragma mark Memory management

//	Event-Handler-Methode, die aufgerufen wird sobald ein Speichernotstand auftritt. Hier sollte soviel Speicher wie möglich
//	wieder freigegeben werden.
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

//	Speicherbereiningung bei Beendigung der App
- (void)dealloc {  
	[userName release];
	[mainViewCtrl release];
    [window release];
    [super dealloc];
}


@end

