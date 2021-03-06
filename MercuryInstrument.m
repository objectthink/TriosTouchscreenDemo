//
//  MercuryInstrument.m
//  TRIOS-MOBILE
//
//  Created by stephen eshelman on 6/4/14.
//  Copyright (c) 2014 objectthink.com. All rights reserved.
//

#import "MercuryInstrument.h"
#import "MercuryProcedure.h"

@interface WaitEvent : NSObject <NSCopying>
{
   NSCondition *_condition;
   bool _signaled;
}

- (id)initSignaled:(BOOL)signaled;
- (void)waitForSignal;
- (void)signal;

@end

@implementation WaitEvent

- (id)initSignaled:(BOOL)signaled
{
   if (self = ([super init]))
   {
      _condition = [[NSCondition alloc] init];
      _signaled = signaled;
   }
   
   return self;
}

-(id)initWith:(NSCondition*)condition andSignaled:(BOOL)signaled
{
   if (self = ([super init]))
   {
      _condition = condition;
      _signaled = signaled;
   }
   
   return self;
}

- (void)waitForSignal
{
   [_condition lock];
   
   while (!_signaled)
   {
      [_condition wait];
   }
   
   [_condition unlock];
}

- (void)signal
{
   [_condition lock];
   
   _signaled = YES;
   
   [_condition signal];
   [_condition unlock];
}

-(instancetype)copyWithZone:(NSZone *)zone
{
   //WaitEvent* event = [[WaitEvent alloc] initWith:_condition andSignaled:_signaled];
   
   return self;
}

@end


@implementation MercuryInstrumentItem : NSObject
{
}

-(id)init
{
   if(self = [super init])
   {
      self.bytes = [[NSMutableData alloc] init];
   }
   return self;
}

-(id)initWithMessage:(NSData*)message
{
   if(self = [super init])
   {
      self.bytes = [message copy];
   }
   return self;
}

-(NSMutableData*)getBytes
{
   return self.bytes;
}

-(float)floatAtOffset:(NSUInteger)offset inData:(NSData*)data
{
   assert([data length] >= offset + sizeof(float));

   float value;
   [data getBytes:&value range:NSMakeRange(offset, 4)];

   return value;
}

-(uint)uintAtOffset:(NSUInteger)offset inData:(NSData*)data
{
   assert([data length] >= offset + sizeof(float));

   uint value;
   [data getBytes:&value range:NSMakeRange(offset, 4)];
   
   return value;
}

-(instancetype)copyWithZone:(NSZone *)zone
{
   //this should never be called
   @throw
   [NSException
    exceptionWithName:@"Abstract"
    reason:@"copy called from MercuryInstrumentItem"
    userInfo:nil];
}
@end

@implementation MercuryStatus
@end

@implementation MercuryCommand
-(id)init
{
   if(self = [super init])
   {
   }
   return self;
}

-(NSMutableData*)getBytes
{
   [self.bytes setLength:0];

   [self.bytes appendBytes:&_subCommandId length:4];

   return self.bytes;
}

@end

@implementation MercuryAction
@end

@implementation MercuryGet
@end

@implementation MercuryResponse
-(instancetype)copyWithZone:(NSZone *)zone
{
   //this should never be called
//   @throw
//   [NSException
//    exceptionWithName:@"Abstract"
//    reason:@"copy called from MercuryInstrumentItem"
//    userInfo:nil];
   
   return self;
}
@end

@implementation MercuryStartProcedureCommand
-(id)init
{
   if(self = [super init])
   {
      self.subCommandId = MercuryStartProcedureCommandId;
   }
   return self;
}
@end

@implementation MercuryGetProcedureStatusCommand
-(id)init
{
   if(self = [super init])
   {
      self.subCommandId = MercuryGetProcedureStatusCommandId;
   }
   return self;
}
@end

@implementation MercuryGetDataFileStatusCommand
-(id)init
{
   if(self = [super init])
   {
      self.subCommandId = MercuryGetDataFileStatusCommandId;
   }
   return self;
}
@end

@implementation MercurySetRealTimeSignalsCommand
{
   NSMutableArray* signals;
}

-(id)init
{
   if(self = [super init])
   {
      self.subCommandId = 0x0001000A;
      
      signals = [[NSMutableArray alloc] init];
   }
   return self;
}

-(NSMutableData*)getBytes
{
   [super getBytes];
   
   [self.bytes setLength:0];
   
   uint temp = self.subCommandId;
   [self.bytes appendBytes:&temp length:4];
   
   for(NSNumber* signal in signals)
   {
      int i = [signal intValue];
      [self.bytes appendBytes:&i length:4];
   }
   
   return self.bytes;
}

-(void)addSignal:(int)signal
{
   [signals addObject:[NSNumber numberWithInt:signal]];
}
@end

@implementation MercuryGetRealTimeSignalsCommand
-(id)init
{
   if(self = [super init])
   {
      self.subCommandId = 0x00000008;
   }
   return self;
}
@end

@implementation MercuryInstrument
{
   NSMutableArray* delegates;
   uint _sequenceNumber;
   
   //NSDictionary* _signalToString;
   NSMutableDictionary* _commandsInProgress;
}

-(instancetype)init
{
   if ([super init])
   {
      self._signalToString =
      @{
        [NSNumber numberWithInt:IdHeaterADC] : @"IdHeaterADC",
        [NSNumber numberWithInt:IdHeaterMV] : @"IdHeaterMV",
        [NSNumber numberWithInt:IdHeaterC] : @"Heater Temperature",
        [NSNumber numberWithInt:IdFlangeADC] : @"IdFlangeADC",
        [NSNumber numberWithInt:IdFlangeMV] : @"IdFlangeMV",
        //[NSNumber numberWithInt:IdFlangeC] : @"IdFlangeC",
        [NSNumber numberWithInt:IdT0UncorrectedADC] : @"IdT0UncorrectedADC",
        [NSNumber numberWithInt:IdT0UncorrectedMV] : @"IdT0UncorrectedMV",
        [NSNumber numberWithInt:IdT0C] : @"IdT0C",
        [NSNumber numberWithInt:IdT0UncorrectedC] : @"IdT0UncorrectedC",
        [NSNumber numberWithInt:IdRefJunctionADC] : @"IdRefJunctionADC",
        [NSNumber numberWithInt:IdDeltaT0ADC] : @"IdDeltaT0ADC",
        [NSNumber numberWithInt:IdDeltaT0MV] : @"IdDeltaT0MV",
        [NSNumber numberWithInt:IdDeltaT0UVUnc] : @"IdDeltaT0UVUnc",
        [NSNumber numberWithInt:IdRefJunctionMV] : @"IdRefJunctionMV",
        [NSNumber numberWithInt:IdRefJunctionC] : @"Reference Junction Temperature",
        [NSNumber numberWithInt:IdDeltaLidADC] : @"IdDeltaLidADC",
        [NSNumber numberWithInt:IdDeltaLidMV] : @"IdDeltaLidMV",
        [NSNumber numberWithInt:IdDeltaLidUV] : @"IdDeltaLidUV",
        [NSNumber numberWithInt:IdDTAmpTempADC] : @"IdDTAmpTempADC",
        [NSNumber numberWithInt:IdDTAmpTempMV] : @"IdDTAmpTempMV",
        [NSNumber numberWithInt:IdDTAmpTempC] : @"IdDTAmpTempC",
        [NSNumber numberWithInt:IdDeltaT0CUnc] : @"IdDeltaT0CUnc",
        [NSNumber numberWithInt:IdDeltaT0C] : @"IdDeltaT0C",
        [NSNumber numberWithInt:IdSampleTC] : @"IdSampleTC",
        
        [NSNumber numberWithInt:IdCommonTime] : @"IdCommonTime",
        [NSNumber numberWithInt:IdHeatFlow]:@"IdHeatFlow",
        
        [NSNumber numberWithInt:IdSetPointTemperature]:@"Set Point Temperature",
        [NSNumber numberWithInt:IdTemperature]:@"Temperature",
        [NSNumber numberWithInt:IdFlangeC]:@"Flange Temperature",
        [NSNumber numberWithInt:IdBasePurgeFlowRate]:@"Base Purge"
        };
      
      delegates = [[NSMutableArray alloc]init];
      
      _commandsInProgress = [[NSMutableDictionary alloc] init];
   }
   
   return self;
}

-(NSArray*)knownSignalNames
{
   return [self._signalToString allValues];
}

-(NSArray*)knownSignalKeys
{
   return [self._signalToString allKeys];
}

-(NSString*)signalToString:(uint)index
{
   return [self._signalToString objectForKey:[NSNumber numberWithInt:index]];
}

-(void)addDelegate:(id<MercuryInstrumentDelegate>)delegate
{
   [delegates addObject:delegate];
}

-(void)removeDelegate:(id<MercuryInstrumentDelegate>)delegate
{
   [delegates removeObject:delegate];
}

-(float)floatAtOffset:(NSUInteger)offset inData:(NSData*)data
{
   assert([data length] >= offset + sizeof(float));
   
   float value;
   [data getBytes:&value range:NSMakeRange(offset, 4)];
   
   return value;
}

-(uint)uintAtOffset:(NSUInteger)offset inData:(NSData*)data
{
   assert([data length] >= offset + sizeof(float));
   
   uint value;
   [data getBytes:&value range:NSMakeRange(offset, 4)];
   
   return value;
}

-(void)disconnect
{
   [self.socket disconnect];
}

-(BOOL)connectToHost:(NSString*)host andPort:(uint16_t)port
{
   self.host = [NSString stringWithFormat:@"%@",host];

   _sequenceNumber = 0;
   
   //dispatch_queue_t mainQueue = dispatch_get_main_queue();
   dispatch_queue_t mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
	
	NSError *error = nil;
	if (![self.socket
         connectToHost:host
         onPort:port
         withTimeout:30
         error:&error])
   {
		NSLog(@"Error connecting: %@", error);
      
      for (id<MercuryInstrumentDelegate> d in delegates)
      {
         if([d respondsToSelector:@selector(error:)])
            [d error:error];
      }

      return NO;
   }
   else
   {
      NSLog(@"Connecting!");
      return YES;
   }
}

-(BOOL)loginWithUsername:(NSString*)username
             machineName:(NSString*)machineName
               ipAddress:(NSString*)ipAddress
                  access:(uint)access
{
   BOOL r = YES;
   
   struct LoginCommand
   {
      unsigned char Sync[4];
      unsigned int Length;
      unsigned char Type[4];
      unsigned int RequestedAccess;
      unsigned char ClientIP[4];
      char UserName[64];
      char MachineName[64];
      unsigned char Footer[4];
   } LoginMessage =
   {
      {'S', 'Y', 'N', 'C'},
      140,
      {'L', 'O', 'G', 'N'},
      access,
      {127, 0, 0, 1},
      "",
      "",
      {'E', 'N', 'D', ' '}
   };
   
   memcpy(LoginMessage.UserName   , [username UTF8String]   , [username length]);
   memcpy(LoginMessage.MachineName, [machineName UTF8String], [machineName length]);
   
   NSData*   e = [NSData dataWithBytes:&LoginMessage length:152];
   
   [self.socket writeData:e withTimeout:(NSTimeInterval)30 tag:7];
   [self.socket readDataToData:[NSData dataWithBytes:"END " length:4] withTimeout:-1 tag:0];
   
   return r;
}

-(int)sendCommand:(MercuryCommand*)command
{
   __block MercuryResponse* _response;
   
   _sequenceNumber++;
   
   NSMutableData* message = [[NSMutableData alloc]init];
   
   uint length = (uint)[[command getBytes] length];   //(uint)[command.bytes length];
   
   uint action = 0x4E544341;
   uint get = 0x20544547;
   uint type = get;
   
   if([command isKindOfClass:[MercuryAction class]])
      type = action;
   
   length += 8;
   
   [message appendBytes:"SYNC" length:4];
   [message appendBytes:&length length:4];
   [message appendBytes:&type length:4];
   [message appendBytes:&_sequenceNumber length:4];
   [message appendData:[command getBytes]];
   [message appendBytes:"END " length:4];
   
   if(type == get)
   {
      WaitEvent* event = [[WaitEvent alloc] initSignaled:NO];

      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
      dispatch_async(queue,
      ^{
         [_commandsInProgress
          setObject:@{
                      [[MercuryResponse alloc] init]:@"Response",
                      event:@"Event"
                      }
          
          forKey:[NSNumber numberWithInt:_sequenceNumber]];
         
         [self.socket writeData:message withTimeout:-1 tag:0];
         [self.socket readDataToData:[NSData dataWithBytes:"END " length:4] withTimeout:-1 tag:0];

         [event waitForSignal];
         
         
         NSDictionary* d = [_commandsInProgress objectForKey:[NSNumber numberWithInt:_sequenceNumber]];
         
         _response = [d objectForKey:@"Response"];
         
         [_commandsInProgress removeObjectForKey:[NSNumber numberWithInt:_sequenceNumber]];

         
//         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
//         ^{
//            [self.socket writeData:message withTimeout:-1 tag:0];
//            [self.socket readDataToData:[NSData dataWithBytes:"END " length:4] withTimeout:-1 tag:0];
//         });
         
      });
   }
   else
   {
      [self.socket writeData:message withTimeout:-1 tag:0];
      //[self.socket readDataToData:[NSData dataWithBytes:"END " length:4] withTimeout:-1 tag:0];
   }
   
   return _sequenceNumber;
}

-(MercuryResponse*)sendCommandNew:(MercuryCommand*)command
{
   _sequenceNumber++;
   
   NSMutableData* message = [[NSMutableData alloc]init];
   
   uint length = (uint)[[command getBytes] length];   //(uint)[command.bytes length];
   
   uint action = 0x4E544341;
   uint get = 0x20544547;
   uint type = get;
   
   if([command isKindOfClass:[MercuryAction class]])
      type = action;
   
   length += 8;
   
   [message appendBytes:"SYNC" length:4];
   [message appendBytes:&length length:4];
   [message appendBytes:&type length:4];
   [message appendBytes:&_sequenceNumber length:4];
   [message appendData:[command getBytes]];
   [message appendBytes:"END " length:4];
   
   [self.socket writeData:message withTimeout:-1 tag:0];
   [self.socket readDataToData:[NSData dataWithBytes:"END " length:4] withTimeout:-1 tag:0];
   
   return [[MercuryResponse alloc] init];
}

-(void)sendCommand:(MercuryCommand*)command onCompletion:(void (^)(MercuryResponse*))completionBlock
{
   @synchronized(self)
   {
      _sequenceNumber = _sequenceNumber + 1;
      [self sendCommandImpl:command onCompletion:completionBlock];
   }
}

-(void)sendCommandImpl:(MercuryCommand*)command onCompletion:(void (^)(MercuryResponse*))completionBlock
{
   __block MercuryResponse* _response;
   __block uint sNumber = _sequenceNumber;
   
   NSMutableData* message = [[NSMutableData alloc]init];
   
   uint length = (uint)[[command getBytes] length];
   
   uint action = 0x4E544341;
   uint get = 0x20544547;
   uint type = get;
   
   if([command isKindOfClass:[MercuryAction class]])
      type = action;
   
   length += 8;
   
   [message appendBytes:"SYNC" length:4];
   [message appendBytes:&length length:4];
   [message appendBytes:&type length:4];
   [message appendBytes:&_sequenceNumber length:4];
   [message appendData:[command getBytes]];
   [message appendBytes:"END " length:4];
   
   if(type == get)
   {
      WaitEvent* event = [[WaitEvent alloc] initSignaled:NO];

      NSMutableDictionary* d = [[NSMutableDictionary alloc] init];

      [d setObject:event forKey:@"Event"];

      [_commandsInProgress setObject:d forKey:[NSNumber numberWithInt:_sequenceNumber]];

      NSLog(@"SENDCOMMAND: ABOUT TO WAIT FOR RESPONSE: %d", _sequenceNumber);
      
      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
      dispatch_async(queue,
      ^{
         //NSMutableDictionary* d = [[NSMutableDictionary alloc] init];
         
         //[d setObject:[[MercuryResponse alloc] init] forKey:@"Response"];
         //[d setObject:event forKey:@"Event"];
                        
         //[_commandsInProgress setObject:d forKey:[NSNumber numberWithInt:_sequenceNumber]];
                        
         [self.socket writeData:message withTimeout:-1 tag:0];
         [self.socket readDataToData:[NSData dataWithBytes:"END " length:4] withTimeout:-1 tag:0];
         
         [event waitForSignal];
                        
          _response = [d objectForKey:@"Response"];
                                 
         if(completionBlock != nil)
            completionBlock(_response);
         
         [_commandsInProgress removeObjectForKey:[NSNumber numberWithInt:sNumber]];
      });
   }
   else
   {
      [self.socket writeData:message withTimeout:-1 tag:0];
      //[self.socket readDataToData:[NSData dataWithBytes:"END " length:4] withTimeout:-1 tag:0];
   }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
#if !TARGET_IPHONE_SIMULATOR
   {
      [sock performBlock:^{
         if ([sock enableBackgroundingOnSocket])
            NSLog(@"Enabled backgrounding on socket");
         else
            NSLog(@"Enabling backgrounding failed!");
      }];
   }
#endif
   
   for (id<MercuryInstrumentDelegate> delegate in delegates)
   {
      [delegate connected];
   }
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
   @synchronized(self)
   {
      [self socketImpl:sock didReadData:data withTag:tag];
   }
}

-(void)socketImpl:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
   //////////////////////////////
   NSInputStream* inputStream = [NSInputStream inputStreamWithData:data];
   
   [inputStream open];
   
   Byte sync[4];
   Byte type[4];
   Byte length[4];
   Byte length2[4];
   Byte temp[4];
   
   [inputStream read:sync maxLength:4];     //SYNC
   [inputStream read:length maxLength:4];   //LENGTH
   [inputStream read:type maxLength:4];     //STAT or
   
   [inputStream read:length2 maxLength:4];  //SUBCOMMAND ID
   [inputStream read:temp maxLength:4];
   [inputStream read:temp maxLength:4];

   
   NSString* typeAsString =
   [[NSString alloc] initWithBytes:type length:4 encoding:NSUTF8StringEncoding];
   
   uint datalength = [self uintAtOffset:4 inData:data];

   //////////////////////////////
   NSData* message = [NSData dataWithBytes:[data bytes]+12 length:datalength]; //[self uintAtOffset:4 inData:data]];
   if([delegates count] > 0)
   {
      if ([typeAsString isEqualToString:@"ACPT"])
      {
         self.access = (MercuryAccess)[self uintAtOffset:12 inData:data];
         
         for (id<MercuryInstrumentDelegate> delegate in delegates)
         {
            [delegate accept:self.access];
         }
      }
      
      if ([typeAsString isEqualToString:@"STAT"])
      {
         uint subcommand = [self uintAtOffset:12 inData:data];
         
         if(subcommand == 0x00020002)
         {
            //FIXUP MESSAGE SO THAT WE CAN USE ENUM TO INDEX INTO
            //SIGNALS RETURNED IN STATUS
            message = [NSData dataWithBytes:[data bytes]+8 length:[self uintAtOffset:4 inData:data]];
         }
         
         id delegatesCopy = delegates.copy;
         for (id<MercuryInstrumentDelegate> d in delegatesCopy)
         {
            [d stat:message withSubcommand:subcommand];
         }
      }
      
      if([typeAsString isEqualToString:@"ACK "])
      {
         uint sequenceNumber = [self uintAtOffset:12 inData:data];
//         
//         NSDictionary* response = [_commandsInProgress objectForKey:[NSNumber numberWithInt:sequenceNumber]];
//         if(response != nil)
//         {
//            WaitEvent* event = [response objectForKey:@"Event"];
//            [event signal];
//         }

         id delegatesCopy = delegates.copy;
         for (id<MercuryInstrumentDelegate> delegate in delegatesCopy)
         {
            [delegate ackWithSequenceNumber:sequenceNumber];
         }
      }
      
      if ([typeAsString isEqualToString:@"NAK "])
      {
         uint sequenceNumer = [self uintAtOffset:12 inData:data];
         uint errorCode = [self uintAtOffset:16 inData:data];
         
         NSMutableDictionary* responseDictionary =
         [_commandsInProgress objectForKey:[NSNumber numberWithInt:sequenceNumer]];
         
         if(responseDictionary != nil)
         {
            WaitEvent* event = [responseDictionary objectForKey:@"Event"];
            
            [event signal];
         }
         
         id delegatesCopy = delegates.copy;
         for (id<MercuryInstrumentDelegate> delegate in delegatesCopy)
         {
            [delegate nakWithSequenceNumber:sequenceNumer andError:errorCode];
         }
      }
      
      if([typeAsString isEqualToString:@"RSP "])
      {
         //             |          4            8            12            16
         //     4     8            12           16           20            24
         //SYNC/LENGTH  //RESPONSE | Sequence # | Subcommand | Status Code |<Data>`

         uint sequenceNumber  = [self uintAtOffset:12 inData:data];
         uint subcommand      = [self uintAtOffset:16 inData:data];
         uint status          = [self uintAtOffset:20 inData:data];
         
         if( (datalength - 16) > 0)
            message = [NSData dataWithBytes:[data bytes]+24 length:datalength - 16];
         
         id delegatesCopy = delegates.copy;
         for (id<MercuryInstrumentDelegate> delegate in delegatesCopy)
            
         {
            [delegate           response:message
                      withSequenceNumber:sequenceNumber
                              subcommand:subcommand
                                  status:status];
         }
         
         NSMutableDictionary* responseDictionary =
         [_commandsInProgress objectForKey:[NSNumber numberWithInt:sequenceNumber]];
         
         if(responseDictionary != nil)
         {
            WaitEvent* event = [responseDictionary objectForKey:@"Event"];
            
            MercuryResponse* response = [[MercuryResponse alloc] initWithMessage:message];
            
            [responseDictionary setValue:response forKey:@"Response"];
           
            NSLog(@"RSP: ABOUT TO SIGNAL: %d", sequenceNumber);
            
            [event signal];
         }
      }
   }
   //////////////////////////////
   
   [sock readDataToData:[NSData dataWithBytes:"END " length:4] withTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error
{
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, error);
   
   for (id<MercuryInstrumentDelegate> d in delegates)
   {
      if([d respondsToSelector:@selector(error:)])
         [d error:error];
   }
}
@end
