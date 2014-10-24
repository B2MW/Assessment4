//
//  Owner.h
//  Assessment4
//
//  Created by Bradley Walker on 10/24/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Owner : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *dog;
@end

@interface Owner (CoreDataGeneratedAccessors)

- (void)addDogObject:(NSManagedObject *)value;
- (void)removeDogObject:(NSManagedObject *)value;
- (void)addDog:(NSSet *)values;
- (void)removeDog:(NSSet *)values;

@end
