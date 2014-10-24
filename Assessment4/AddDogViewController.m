//
//  AddDogViewController.m
//  Assessment4
//
//  Created by Vik Denic on 8/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "AddDogViewController.h"
#import "AppDelegate.h"

@interface AddDogViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *breedTextField;
@property (weak, nonatomic) IBOutlet UITextField *colorTextField;

@end

@implementation AddDogViewController

//TODO: UPDATE CODE ACCORIDNGLY

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Dog";
    [self loadDogDetails];
}

-(void)loadDogDetails
{
    if (self.dog != nil) {
        self.nameTextField.text = self.dog.name;
        self.breedTextField.text = self.dog.breed;
        self.colorTextField.text = self.dog.color;
    }
}

- (IBAction)onPressedUpdateDog:(UIButton *)sender
{
    if (self.nameTextField != nil && self.breedTextField != nil && self.colorTextField != nil)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObject *newDog = [NSEntityDescription insertNewObjectForEntityForName:@"Dog" inManagedObjectContext:appDelegate.managedObjectContext];
//        NSManagedObject *owner = self.owner;

        [newDog setValue:self.nameTextField.text forKey:@"name"];
        [newDog setValue:self.breedTextField.text forKey:@"breed"];
        [newDog setValue:self.colorTextField.text forKey:@"color"];
        [newDog setValue:self.owner forKey:@"owner"];

        [appDelegate.managedObjectContext save:nil];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
