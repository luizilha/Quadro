//
//  AssuntoViewController.m
//  Quadro
//
//  Created by Luiz Ilha on 2/12/15.
//  Copyright (c) 2015 LUIZ ILHA M MACIEL. All rights reserved.
//

#import "AssuntoViewController.h"
#import "Assunto.h"
#import "AssuntoTableViewCell.h"
#import "TodasMateriasSingleton.h"
#import "Materia.h"
#import "PosCameraViewController.h"
#import "FotosViewController.h"
#import "CustomCameraViewController.h"

@interface AssuntoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSInteger posicaoAssunto;
@end

@implementation AssuntoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [_table reloadData];
}

- (IBAction)camera:(id)sender {
    /*
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
     */
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomCameraViewController *camera = [sb instantiateViewControllerWithIdentifier:@"camera"];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PosCameraViewController *pos = [sb instantiateViewControllerWithIdentifier:@"pos"];
    pos.foto = image;
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    [pos setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:pos animated:NO completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identificador = @"assuntoCell";
    
    AssuntoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identificador forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[AssuntoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identificador];
    }
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
    Assunto *assunto = [materia.assuntos objectAtIndex:indexPath.row];
    cell.assunto.text = assunto.nomeAssunto;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"hh:mm dd/MM";
    cell.data.text =  [df stringFromDate:assunto.dataPublicacao];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Materia *materia = [[[TodasMateriasSingleton sharedInstance] listaDeMaterias] objectAtIndex:self.posicaoMateria];
    return materia.assuntos.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.posicaoAssunto = indexPath.row;
    [self performSegueWithIdentifier:@"segueListaFotos" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"segueListaFotos"]) {
        FotosViewController *view = [segue destinationViewController];
        view.posicaoMateria = self.posicaoMateria;
        view.posicaoAssunto = self.posicaoAssunto;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
