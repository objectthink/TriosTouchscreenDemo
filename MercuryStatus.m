//
//  MercuryStatus.m
//  TRIOS-MOBILE
//
//  Created by stephen eshelman on 6/14/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import "MercuryStatus.h"

@implementation MercuryProcedureStatus

-(id)initWithMessage:(NSData*)message
{
   if(self = [super initWithMessage:message])
   {
      self.runStatus = (int)[self uintAtOffset:4 inData:message];
      self.endStatus = (int)[self uintAtOffset:8 inData:message];
      self.currentSegmentId = (int)[self uintAtOffset:12 inData:message];
   }
   return self;
}
@end

@implementation MercuryProcedureStatusResponse

-(id)initWithMessage:(NSData*)message
{
   if(self = [super initWithMessage:message])
   {
      self.runStatus = (int)[self uintAtOffset:0 inData:message];
      self.endStatus = (int)[self uintAtOffset:4 inData:message];
      self.currentSegmentId = (int)[self uintAtOffset:8 inData:message];
   }
   return self;
}
@end

@implementation MercuryDataFileStatus

-(id)initWithMessage:(NSMutableData *)message
{
   if(self = [super initWithMessage:message])
   {
      self.length = [self uintAtOffset:4 inData:message];
      self.state = (int)[self uintAtOffset:8 inData:message];
   }
   return self;
}
@end

@implementation MercuryRealTimeSignalsStatusResponse
-(id)initWithMessage:(NSData *)message
{
   if(self = [super initWithMessage:message])
   {
      self.signals = [[NSMutableArray alloc] init];
      
      [self.signals removeAllObjects];
      
      long signalCount = [message length]/4;
      for (int i = 1; i < signalCount -1; i++)
      {
         float signal = [self floatAtOffset:i*4 inData:message];
         [self.signals addObject:[NSNumber numberWithFloat:signal]];
      }
   }
   
   return self;
}
@end
