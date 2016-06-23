//
//  JSONResponseSerializerWithData.m
//  CarRentalStaff
//
//  Created by Nathan on 11/29/14.
//  Copyright (c) 2014 Tom Hu. All rights reserved.
//

#import "YTKJSONSerializerWithData.h"



@implementation YTKJSONSerializerWithData

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error{
    id JSONObject = [super responseObjectForResponse:response
                                                data:data
                                               error:error];
    if (*error != nil) {
        NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
        if(data){
            userInfo[JSONResponseError] = [NSData data];
        }
        else{
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&error];
            if (!error) {
                userInfo[JSONResponseError] = json;
            }
        }
        NSError *newError = [NSError errorWithDomain:(*error).domain
                                                code:(*error).code
                                            userInfo:userInfo];
        (*error) = newError;
    }
    return (JSONObject);
    
}

@end
