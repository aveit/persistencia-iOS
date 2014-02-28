//
//  PRLocalizacaoViewController.m
//  Persistencia
//
//  Created by Acácio Veit Schneider on 27/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "PRLocalizacaoViewController.h"
#import "PRAppDelegate.h"
#import <MapKit/MapKit.h>

@interface PRLocalizacaoViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSalvar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MKPointAnnotation *annotation;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;

@end

@implementation PRLocalizacaoViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
  [self.mapView addGestureRecognizer: self.longPress];
  
  //Se a tarefa possui latitude e longitude, adiciona uma annotation ao mapa
  if ([self.tarefa.latitude doubleValue] != 0 && [self.tarefa.longitude doubleValue] != 0) {
    
    self.annotation = [[MKPointAnnotation alloc] init];

    CLLocationCoordinate2D coordenada;
    coordenada.latitude  = [self.tarefa.latitude doubleValue];
    coordenada.longitude = [self.tarefa.longitude doubleValue];
    
    [self.mapView setRegion: MKCoordinateRegionMakeWithDistance(coordenada, 7000000, 7000000) animated:YES];
    
    self.annotation.coordinate = coordenada;
    [self.mapView addAnnotation:self.annotation];
  }
}

//Ao clicar no botao de salvar
- (IBAction)clickSalvar:(UIBarButtonItem *)sender {
  
  MKPointAnnotation *annotation = [self.mapView.annotations firstObject];
  
  self.tarefa.latitude  = [NSNumber numberWithDouble: annotation.coordinate.latitude];
  self.tarefa.longitude = [NSNumber numberWithDouble: annotation.coordinate.longitude];
  [self.navigationController popViewControllerAnimated:YES];
}

-(void) handleLongPressGesture:(UIGestureRecognizer *) sender {
  
  //Remove o longo clique enquanto processa o método
  [self.mapView removeGestureRecognizer: sender];
  
  //Pega o ponto do mapa através do ponto clicado na tela
  CGPoint point = [sender locationInView:self.mapView];
  
  //Cria as coordenadas através do ponto clicado na tela
  CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
  
  MKPointAnnotation *dropPin = [[MKPointAnnotation alloc] init];
  
  if (self.annotation != nil) {
    
    //Remove a annotation que já foi criada anteriormente, pois só podemos ter uma
    [self.mapView removeAnnotation:self.annotation];
  }
  
  dropPin.coordinate    = locCoord;
  self.annotation       = dropPin;
  
  [self.mapView addAnnotation:dropPin];
  
  //Adiciona novamente o longo clique ao mapa
  [self.mapView addGestureRecognizer: sender];
}

-(void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [self carregaCor];
}

//Carrega o global tint nos elementos da tela
-(void) carregaCor {
  [self.navigationController.navigationBar setTintColor: (UIColor *)[(PRAppDelegate *)[[UIApplication sharedApplication] delegate] globalTint]];
}

@end
