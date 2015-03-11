//
//  CustomCameraViewController.m
//  Quadro
//
//  Created by Luiz Ilha on 2/24/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "CustomCameraViewController.h"
#import "TodasMateriasSingleton.h"
#import "Materia.h"
#import "Assunto.h"
#import "FotoComAnotacao.h"
#import "PosCameraViewController.h"

@interface CustomCameraViewController ()
@property (nonatomic) NSMutableArray *listaDeFotosComAnotacao;
@property (weak, nonatomic) IBOutlet UIButton *botaoConfirma;
@property (weak, nonatomic) IBOutlet UIImageView *imagemTirada;
@property (weak, nonatomic) IBOutlet UIButton *botaoFoto;
@property (weak, nonatomic) IBOutlet UIView *cameraFrame;
- (IBAction)takePhoto:(id)sender;

@end

@implementation CustomCameraViewController
AVCaptureSession *session;
AVCaptureStillImageOutput *stillImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listaDeFotosComAnotacao = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.terminaEdicao) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        
        session = [[AVCaptureSession alloc] init];
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error;
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if ([session canAddInput:deviceInput]) {
            [session addInput:deviceInput];
        }
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        CALayer *rootLayer = [[self cameraFrame] layer];
        
        //    CALayer *rootLayer = [[self frameFromCapture] layer];
        [rootLayer setMasksToBounds:YES];
        CGRect frame = self.cameraFrame.frame;
        [previewLayer setFrame:frame];
        [rootLayer insertSublayer:previewLayer atIndex:0];
        
        stillImage = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey ,nil];
        [stillImage setOutputSettings:outputSettings];
        [session addOutput:stillImage];
        
        [session startRunning];
    }
    
    
}

- (IBAction)takePhoto:(id)sender {
    [self.botaoConfirma setTitle:@"OK" forState:UIControlStateNormal];
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImage.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    [stillImage captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            FotoComAnotacao *fotoComAnotacao = [[FotoComAnotacao alloc] init];
            fotoComAnotacao.foto = image;
            fotoComAnotacao.anotacao = nil;
            [self.listaDeFotosComAnotacao addObject:fotoComAnotacao];
            self.imagemTirada.image = image;
            [self.botaoFoto setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.listaDeFotosComAnotacao.count] forState:UIControlStateNormal];
        }
    }];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"seguePosCamera"]) {
        if ([self.botaoConfirma.titleLabel.text  isEqual: @"Cancelar"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            PosCameraViewController *poscamera = [segue destinationViewController];
            poscamera.posicaoMateria = self.posicaoMateria;
            poscamera.listaDeFotosComAnotacao = self.listaDeFotosComAnotacao;
            self.terminaEdicao = YES;
        }
    }
}

@end
