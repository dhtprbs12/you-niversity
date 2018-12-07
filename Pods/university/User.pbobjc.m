// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: user.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "User.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - UserRoot

@implementation UserRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - UserRoot_FileDescriptor

static GPBFileDescriptor *UserRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@""
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - CaptchaRequest

@implementation CaptchaRequest


typedef struct CaptchaRequest__storage_ {
  uint32_t _has_storage_[1];
} CaptchaRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[CaptchaRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:NULL
                                    fieldCount:0
                                   storageSize:sizeof(CaptchaRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - CaptchaResponse

@implementation CaptchaResponse

@dynamic key;
@dynamic captcha;

typedef struct CaptchaResponse__storage_ {
  uint32_t _has_storage_[1];
  NSString *key;
  NSData *captcha;
} CaptchaResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "key",
        .dataTypeSpecific.className = NULL,
        .number = CaptchaResponse_FieldNumber_Key,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(CaptchaResponse__storage_, key),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "captcha",
        .dataTypeSpecific.className = NULL,
        .number = CaptchaResponse_FieldNumber_Captcha,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(CaptchaResponse__storage_, captcha),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeBytes,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[CaptchaResponse class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(CaptchaResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Device

@implementation Device

@dynamic deviceCode;
@dynamic deviceName;
@dynamic os;
@dynamic sdkVersion;
@dynamic appVersion;
@dynamic deviceToken;

typedef struct Device__storage_ {
  uint32_t _has_storage_[1];
  Device_OS os;
  NSString *deviceCode;
  NSString *deviceName;
  NSString *sdkVersion;
  NSString *appVersion;
  NSString *deviceToken;
} Device__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "deviceCode",
        .dataTypeSpecific.className = NULL,
        .number = Device_FieldNumber_DeviceCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(Device__storage_, deviceCode),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "deviceName",
        .dataTypeSpecific.className = NULL,
        .number = Device_FieldNumber_DeviceName,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(Device__storage_, deviceName),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "os",
        .dataTypeSpecific.enumDescFunc = Device_OS_EnumDescriptor,
        .number = Device_FieldNumber_Os,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(Device__storage_, os),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldHasEnumDescriptor),
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "sdkVersion",
        .dataTypeSpecific.className = NULL,
        .number = Device_FieldNumber_SdkVersion,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(Device__storage_, sdkVersion),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "appVersion",
        .dataTypeSpecific.className = NULL,
        .number = Device_FieldNumber_AppVersion,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(Device__storage_, appVersion),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "deviceToken",
        .dataTypeSpecific.className = NULL,
        .number = Device_FieldNumber_DeviceToken,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(Device__storage_, deviceToken),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[Device class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(Device__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t Device_Os_RawValue(Device *message) {
  GPBDescriptor *descriptor = [Device descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:Device_FieldNumber_Os];
  return GPBGetMessageInt32Field(message, field);
}

void SetDevice_Os_RawValue(Device *message, int32_t value) {
  GPBDescriptor *descriptor = [Device descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:Device_FieldNumber_Os];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - Enum Device_OS

GPBEnumDescriptor *Device_OS_EnumDescriptor(void) {
  static GPBEnumDescriptor *descriptor = NULL;
  if (!descriptor) {
    static const char *valueNames =
        "Android\000Ios\000";
    static const int32_t values[] = {
        Device_OS_Android,
        Device_OS_Ios,
    };
    GPBEnumDescriptor *worker =
        [GPBEnumDescriptor allocDescriptorForName:GPBNSStringifySymbol(Device_OS)
                                       valueNames:valueNames
                                           values:values
                                            count:(uint32_t)(sizeof(values) / sizeof(int32_t))
                                     enumVerifier:Device_OS_IsValidValue];
    if (!OSAtomicCompareAndSwapPtrBarrier(nil, worker, (void * volatile *)&descriptor)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL Device_OS_IsValidValue(int32_t value__) {
  switch (value__) {
    case Device_OS_Android:
    case Device_OS_Ios:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - UserRegisterRequest

@implementation UserRegisterRequest

@dynamic nickname;
@dynamic password;
@dynamic mentorNickname;
@dynamic mentorProfileurl;
@dynamic hasDevice, device;

typedef struct UserRegisterRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *nickname;
  NSString *password;
  NSString *mentorNickname;
  NSString *mentorProfileurl;
  Device *device;
} UserRegisterRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "nickname",
        .dataTypeSpecific.className = NULL,
        .number = UserRegisterRequest_FieldNumber_Nickname,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(UserRegisterRequest__storage_, nickname),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "password",
        .dataTypeSpecific.className = NULL,
        .number = UserRegisterRequest_FieldNumber_Password,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(UserRegisterRequest__storage_, password),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorNickname",
        .dataTypeSpecific.className = NULL,
        .number = UserRegisterRequest_FieldNumber_MentorNickname,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(UserRegisterRequest__storage_, mentorNickname),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorProfileurl",
        .dataTypeSpecific.className = NULL,
        .number = UserRegisterRequest_FieldNumber_MentorProfileurl,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(UserRegisterRequest__storage_, mentorProfileurl),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "device",
        .dataTypeSpecific.className = GPBStringifySymbol(Device),
        .number = UserRegisterRequest_FieldNumber_Device,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(UserRegisterRequest__storage_, device),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[UserRegisterRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(UserRegisterRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - UserRegisterResponse

@implementation UserRegisterResponse

@dynamic userId;
@dynamic token;
@dynamic isNicknameDuplicated;

typedef struct UserRegisterResponse__storage_ {
  uint32_t _has_storage_[1];
  NSString *token;
  NSString *isNicknameDuplicated;
  int64_t userId;
} UserRegisterResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = UserRegisterResponse_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(UserRegisterResponse__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "token",
        .dataTypeSpecific.className = NULL,
        .number = UserRegisterResponse_FieldNumber_Token,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(UserRegisterResponse__storage_, token),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "isNicknameDuplicated",
        .dataTypeSpecific.className = NULL,
        .number = UserRegisterResponse_FieldNumber_IsNicknameDuplicated,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(UserRegisterResponse__storage_, isNicknameDuplicated),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[UserRegisterResponse class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(UserRegisterResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - UserLoginCheckRequest

@implementation UserLoginCheckRequest

@dynamic userId;
@dynamic nickname;
@dynamic password;

typedef struct UserLoginCheckRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *nickname;
  NSString *password;
  int64_t userId;
} UserLoginCheckRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = UserLoginCheckRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(UserLoginCheckRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "nickname",
        .dataTypeSpecific.className = NULL,
        .number = UserLoginCheckRequest_FieldNumber_Nickname,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(UserLoginCheckRequest__storage_, nickname),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "password",
        .dataTypeSpecific.className = NULL,
        .number = UserLoginCheckRequest_FieldNumber_Password,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(UserLoginCheckRequest__storage_, password),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[UserLoginCheckRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(UserLoginCheckRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - UserLoginCheckResponse

@implementation UserLoginCheckResponse

@dynamic isInfoCorrect;

typedef struct UserLoginCheckResponse__storage_ {
  uint32_t _has_storage_[1];
  NSString *isInfoCorrect;
} UserLoginCheckResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "isInfoCorrect",
        .dataTypeSpecific.className = NULL,
        .number = UserLoginCheckResponse_FieldNumber_IsInfoCorrect,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(UserLoginCheckResponse__storage_, isInfoCorrect),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[UserLoginCheckResponse class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(UserLoginCheckResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - AuthRequest

@implementation AuthRequest

@dynamic token;

typedef struct AuthRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *token;
} AuthRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "token",
        .dataTypeSpecific.className = NULL,
        .number = AuthRequest_FieldNumber_Token,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AuthRequest__storage_, token),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AuthRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AuthRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - AuthResponse

@implementation AuthResponse

@dynamic userId;
@dynamic isExist;

typedef struct AuthResponse__storage_ {
  uint32_t _has_storage_[1];
  NSString *isExist;
  int64_t userId;
} AuthResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = AuthResponse_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AuthResponse__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "isExist",
        .dataTypeSpecific.className = NULL,
        .number = AuthResponse_FieldNumber_IsExist,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AuthResponse__storage_, isExist),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AuthResponse class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AuthResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - UpdateProfileRequest

@implementation UpdateProfileRequest

@dynamic userId;
@dynamic nickname;
@dynamic password;

typedef struct UpdateProfileRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *nickname;
  NSString *password;
  int64_t userId;
} UpdateProfileRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = UpdateProfileRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(UpdateProfileRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "nickname",
        .dataTypeSpecific.className = NULL,
        .number = UpdateProfileRequest_FieldNumber_Nickname,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(UpdateProfileRequest__storage_, nickname),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "password",
        .dataTypeSpecific.className = NULL,
        .number = UpdateProfileRequest_FieldNumber_Password,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(UpdateProfileRequest__storage_, password),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[UpdateProfileRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(UpdateProfileRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - UpdateProfileResponse

@implementation UpdateProfileResponse

@dynamic isUpdateSucceed;
@dynamic token;
@dynamic isNicknameDuplicated;

typedef struct UpdateProfileResponse__storage_ {
  uint32_t _has_storage_[1];
  NSString *isUpdateSucceed;
  NSString *token;
  NSString *isNicknameDuplicated;
} UpdateProfileResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "isUpdateSucceed",
        .dataTypeSpecific.className = NULL,
        .number = UpdateProfileResponse_FieldNumber_IsUpdateSucceed,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(UpdateProfileResponse__storage_, isUpdateSucceed),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "token",
        .dataTypeSpecific.className = NULL,
        .number = UpdateProfileResponse_FieldNumber_Token,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(UpdateProfileResponse__storage_, token),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "isNicknameDuplicated",
        .dataTypeSpecific.className = NULL,
        .number = UpdateProfileResponse_FieldNumber_IsNicknameDuplicated,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(UpdateProfileResponse__storage_, isNicknameDuplicated),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[UpdateProfileResponse class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(UpdateProfileResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - UnregisterRequest

@implementation UnregisterRequest

@dynamic userId;

typedef struct UnregisterRequest__storage_ {
  uint32_t _has_storage_[1];
  int64_t userId;
} UnregisterRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = UnregisterRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(UnregisterRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[UnregisterRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(UnregisterRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - ReportRequest

@implementation ReportRequest

@dynamic userId;
@dynamic content;

typedef struct ReportRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *content;
  int64_t userId;
} ReportRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = ReportRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ReportRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "content",
        .dataTypeSpecific.className = NULL,
        .number = ReportRequest_FieldNumber_Content,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ReportRequest__storage_, content),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ReportRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ReportRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - ActiveRequest

@implementation ActiveRequest

@dynamic userId;
@dynamic activeValue;

typedef struct ActiveRequest__storage_ {
  uint32_t _has_storage_[1];
  int64_t userId;
  int64_t activeValue;
} ActiveRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = ActiveRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ActiveRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "activeValue",
        .dataTypeSpecific.className = NULL,
        .number = ActiveRequest_FieldNumber_ActiveValue,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ActiveRequest__storage_, activeValue),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ActiveRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ActiveRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - LogoutRequest

@implementation LogoutRequest

@dynamic userId;

typedef struct LogoutRequest__storage_ {
  uint32_t _has_storage_[1];
  int64_t userId;
} LogoutRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = LogoutRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(LogoutRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[LogoutRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(LogoutRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - PushUpdateRequest

@implementation PushUpdateRequest

@dynamic value;
@dynamic userId;

typedef struct PushUpdateRequest__storage_ {
  uint32_t _has_storage_[1];
  int64_t value;
  int64_t userId;
} PushUpdateRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "value",
        .dataTypeSpecific.className = NULL,
        .number = PushUpdateRequest_FieldNumber_Value,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(PushUpdateRequest__storage_, value),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = PushUpdateRequest_FieldNumber_UserId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(PushUpdateRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[PushUpdateRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(PushUpdateRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - UpdateAppleTokenRequest

@implementation UpdateAppleTokenRequest

@dynamic userId;
@dynamic token;

typedef struct UpdateAppleTokenRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *token;
  int64_t userId;
} UpdateAppleTokenRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = UpdateAppleTokenRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(UpdateAppleTokenRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "token",
        .dataTypeSpecific.className = NULL,
        .number = UpdateAppleTokenRequest_FieldNumber_Token,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(UpdateAppleTokenRequest__storage_, token),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[UpdateAppleTokenRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(UpdateAppleTokenRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - AppAboutTerminatingRequest

@implementation AppAboutTerminatingRequest

@dynamic userId;

typedef struct AppAboutTerminatingRequest__storage_ {
  uint32_t _has_storage_[1];
  int64_t userId;
} AppAboutTerminatingRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = AppAboutTerminatingRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AppAboutTerminatingRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AppAboutTerminatingRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AppAboutTerminatingRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - GetOfflineMessagesRequest

@implementation GetOfflineMessagesRequest

@dynamic userId;

typedef struct GetOfflineMessagesRequest__storage_ {
  uint32_t _has_storage_[1];
  int64_t userId;
} GetOfflineMessagesRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = GetOfflineMessagesRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(GetOfflineMessagesRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GetOfflineMessagesRequest class]
                                     rootClass:[UserRoot class]
                                          file:UserRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GetOfflineMessagesRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
