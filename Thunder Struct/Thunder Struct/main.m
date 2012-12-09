//
//  main.m
//  Thunder Struct
//  Part of One Ring to Cocoa-Bind Them All https://github.com/apontious/One-Ring-to-Cocoa-Bind-Them-All
//  Created for Edge Cases 30: One Ring to Cocoa-Bind Them All: http://www.edgecasesshow.com/030-one-ring-to-cocoa-bind-them-all.html
//
//  Created by Andrew Pontious on 12/8/12.
//  Copyright (c) 2012 Andrew Pontious.
//  Some right reserved: http://opensource.org/licenses/mit-license.php
//

#import <Foundation/Foundation.h>

// ----------------------------------------------------------------------------------------------------
// Sample project to explore the extent of the support for arbitrary C structures in Key-Value Coding.
//



// Apple documentation has an example called "ThreeFloats". I switched to integers to make the printing out of the value easier, and decided to add...a few more to see what the runtime does.

typedef struct {
    short      a, b, c;
    int        d, e, f;
    long       g, h, i;
    long long  j, k, l;
    float      m, n, o;
    double     p, q, r;
    BOOL       s, t, u;
    char *     v, * w, * x;
    char **    y, ** z;
} IntegersAndMore;

static NSString *NSStringFromIntegersAndMore(const IntegersAndMore structure) {
    return [NSString stringWithFormat:@"shorts: %hd, %hd, %hd, integers: %d, %d, %d, longs: %ld, %ld, %ld, long longs: %lld, %lld, %lld, floats: %f, %f, %f, doubles: %f, %f, %f, booleans: %@, %@, %@, C strings: %s, %s, %s, C pointers-to-strings: %p, %p",
            structure.a, structure.b, structure.c,
            structure.d, structure.e, structure.f,
            structure.g, structure.h, structure.i,
            structure.j, structure.k, structure.l,
            structure.m, structure.n, structure.o,
            structure.p, structure.q, structure.r,
            (structure.s ? @"YES" : @"NO"), (structure.t ? @"YES" : @"NO"), (structure.u ? @"YES" : @"NO"),
            structure.v, structure.w, structure.x,
            (void*)structure.y, (void*)structure.z];
}

@interface MyClass : NSObject
@property (nonatomic) IntegersAndMore integersAndMore;
@end

@implementation MyClass
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // ------------------------------------------------------------------
        // KVC
        
        // Initial value
        IntegersAndMore integersAndMore = { 1, 2, 3 };
        
        MyClass *temp = [[MyClass alloc] init];
        
        // Assign value #1, via normal method invocation.
        temp.integersAndMore = integersAndMore;
        
        // Retrieve via KVC.
        {{
            NSValue *value = [temp valueForKey:@"integersAndMore"];
            
            NSLog(@"value object retrieved via KVC: %@, Obj-C type: %s", value, [value objCType]);
            
            IntegersAndMore structure;
            [value getValue:&structure];
            NSLog(@"value struct: %@", NSStringFromIntegersAndMore(structure));
        }}
        
        // Assign value #2, via KVC
        
        // Changed value
        integersAndMore.a = 10; integersAndMore.b = 9; integersAndMore.c = 8;

        {{
            NSValue *value = [NSValue value:&integersAndMore withObjCType:@encode(IntegersAndMore)];
            [temp setValue:value forKey:@"integersAndMore"];
            
            NSLog(@"value object set and then retrieved via KVC: %@", [temp valueForKey:@"integersAndMore"]);
            
            IntegersAndMore structure;
            [value getValue:&structure];
            NSLog(@"value struct: %@", NSStringFromIntegersAndMore(structure));
        }}
        
        // ------------------------------------------------------------------
        // Boxed Expressions
        
        {{
            // Sad trombone!
            // Uncomment the below to get the build error "illegal type 'IntegersAndMore' used in boxed expression
            //NSValue *value = @(integersAndMore);
        }}
        
        {{
            // Uncomment the below to get the same kind of build error as above.
            /*CGRect rect = CGRectMake(1, 2, 3, 4);
            NSValue *value = @(rect);*/
        }}
    }

    return 0;
}

