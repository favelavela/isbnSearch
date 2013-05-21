//
//  ControladoraViewController.h
//  isbn
//
//  Created by moviles on 3/9/13.
//  Copyright (c) 2013 moviles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControladoraViewController : UIViewController

- (IBAction)searchISBN:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtISBN;
@property (weak, nonatomic) IBOutlet UITextField *txtTitulo;
@property (weak, nonatomic) IBOutlet UITextField *txtSubtitulo;
@property (weak, nonatomic) IBOutlet UITextView *txtAutores;
@property (weak, nonatomic) NSManagedObjectContext *moc;

- (IBAction)btnBuscar:(id)sender;
- (void) buscaISBN;
@end
