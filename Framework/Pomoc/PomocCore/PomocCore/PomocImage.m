//
//  PomocImage.m
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 6/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PomocImage.h"
#import "AWSS3.h"

#define S3_KEY @"18v5JVbT7VNCv95DggCl0I1EYq5mjqxeCS1fxCXB"
#define S3_BUCKET_NAME @"pomoc"

@interface PomocImage () <AmazonServiceRequestDelegate> {
    S3TransferManager *tm;
    AmazonS3Client *s3;
    NSMutableDictionary *reqBlocks;
}

@end

@implementation PomocImage

+ (PomocImage *)sharedInstance
{
    static PomocImage *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[PomocImage alloc] init];
    });
    
    return _sharedInstance;
}

- (id) init {
    if (self = [super init]) {
        s3 = [[AmazonS3Client alloc]
               initWithAccessKey:@"AKIAJNKKEW52GZHOKS7Q"
                   withSecretKey:@"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"];
        tm = [S3TransferManager new];
        tm.s3 = s3;
        tm.delegate = self;
        reqBlocks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)uploadImage:(UIImage *)image withFilename:(NSString*)name withCompletion:(void(^)(NSString *))block {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:name inBucket:S3_BUCKET_NAME];
    por.contentType = [self contentTypeForImageData:image];
    por.data = imageData;
    por.requestTag = name;
    [s3 putObject:por];
    [tm upload:por];
    [reqBlocks setObject:block forKey:name];
}

- (void)uploadImage:(UIImage *)image withCompletion:(void(^)(NSString *))block {
    NSString *name = [[NSUUID UUID] UUIDString];
    [self uploadImage:image withFilename:name withCompletion:block];
}

- (void)downloadImage:(NSString *)filename withCompletion:(void(^)(UIImage *))block {
    UIImage *cachedImage = [self retrieveFileFromCache:filename];
    
    if (cachedImage) {
        block(cachedImage);
        return;
    }
    
    NSString *filepath = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
    
    S3GetObjectRequest *gor = [[S3GetObjectRequest alloc] initWithKey:filename withBucket:S3_BUCKET_NAME];
    
    gor.requestTag = filename;
    gor.targetFilePath = filepath;
    __weak PomocImage *weakSelf = self;

    reqBlocks[filename] = ^void (NSString *filename) {
        // Saving to temp is automagically done by the transfermanager
        // [weakSelf saveFileToCache:image withFilename:filename];
        UIImage *downloadedImage = [weakSelf retrieveFileFromCache:filename];
        block(downloadedImage);
    };
    
    [tm download:gor];
}

- (void)saveFileToCache:(UIImage *)image withFilename:(NSString *)filename{
    // TODO: Might want to choose with file conflicts
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [imageData writeToFile:filePath atomically:YES];
}

- (UIImage *)retrieveFileFromCache:(NSString *)filename {
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:filePath]){
        return [UIImage imageWithContentsOfFile:filePath];
    }
    return nil;
}

- (NSString *)contentTypeForImageData:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation (image,0);
    
    uint8_t c;
    [imageData getBytes:&c length:1];
    
    switch (c)
    {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x42:
            return @"@image/bmp";
    }
    return nil;
}

# pragma mark - AmazonServiceRequestDelegate

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response {
    // NSLog(@"didReceiveResponse called: %@", response);
}

-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data {
    // NSLog(@"didReceiveData called");
}

-(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite {
    // NSLog(@"didSendData called: %ll - %ll / %ll", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response {
    // NSLog(@"didCompleteWithResponse response called\n: %@", response);
    // NSLog(@"didCompleteWithResponse request called\n: %@", request);
    
    void(^block)(NSString *) = reqBlocks[request.requestTag];
    if (block) {
        block(request.requestTag);
    } else {
        // GG there is no response block
    }
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error {
    // NSLog(@"didFailWithError called: %@", error);
}

@end
