// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: mentor.proto

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

 #import "Mentor.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - MentorRoot

@implementation MentorRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - MentorRoot_FileDescriptor

static GPBFileDescriptor *MentorRoot_FileDescriptor(void) {
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

#pragma mark - MentorRegisterRequest

@implementation MentorRegisterRequest

@dynamic userId;
@dynamic mentorNickname;
@dynamic mentorUniversity;
@dynamic mentorMajor;
@dynamic mentorBackgroundurl;
@dynamic mentorProfileurl;
@dynamic mentorMentoringArea;
@dynamic mentorMentoringField;
@dynamic mentorIntroduction;
@dynamic mentorInformation;
@dynamic backgroundImage;
@dynamic profileImage;

typedef struct MentorRegisterRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *mentorNickname;
  NSString *mentorUniversity;
  NSString *mentorMajor;
  NSString *mentorBackgroundurl;
  NSString *mentorProfileurl;
  NSString *mentorMentoringArea;
  NSString *mentorMentoringField;
  NSString *mentorIntroduction;
  NSString *mentorInformation;
  NSData *backgroundImage;
  NSData *profileImage;
  int64_t userId;
} MentorRegisterRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_UserId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "mentorNickname",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_MentorNickname,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, mentorNickname),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorUniversity",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_MentorUniversity,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, mentorUniversity),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorMajor",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_MentorMajor,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, mentorMajor),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorBackgroundurl",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_MentorBackgroundurl,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, mentorBackgroundurl),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorProfileurl",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_MentorProfileurl,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, mentorProfileurl),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorMentoringArea",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_MentorMentoringArea,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, mentorMentoringArea),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorMentoringField",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_MentorMentoringField,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, mentorMentoringField),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorIntroduction",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_MentorIntroduction,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, mentorIntroduction),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorInformation",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_MentorInformation,
        .hasIndex = 9,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, mentorInformation),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "backgroundImage",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_BackgroundImage,
        .hasIndex = 10,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, backgroundImage),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeBytes,
      },
      {
        .name = "profileImage",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterRequest_FieldNumber_ProfileImage,
        .hasIndex = 11,
        .offset = (uint32_t)offsetof(MentorRegisterRequest__storage_, profileImage),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeBytes,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MentorRegisterRequest class]
                                     rootClass:[MentorRoot class]
                                          file:MentorRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MentorRegisterRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MentorRegisterResponse

@implementation MentorRegisterResponse

@dynamic mentorId;

typedef struct MentorRegisterResponse__storage_ {
  uint32_t _has_storage_[1];
  int64_t mentorId;
} MentorRegisterResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "mentorId",
        .dataTypeSpecific.className = NULL,
        .number = MentorRegisterResponse_FieldNumber_MentorId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MentorRegisterResponse__storage_, mentorId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MentorRegisterResponse class]
                                     rootClass:[MentorRoot class]
                                          file:MentorRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MentorRegisterResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - UpdateMentorInfoRequest

@implementation UpdateMentorInfoRequest

@dynamic mentorId;
@dynamic mentorNickname;
@dynamic mentorUniversity;
@dynamic mentorMajor;
@dynamic mentorBackgroundurl;
@dynamic mentorProfileurl;
@dynamic mentorMentoringArea;
@dynamic mentorMentoringField;
@dynamic mentorIntroduction;
@dynamic mentorInformation;
@dynamic backgroundImage;
@dynamic profileImage;
@dynamic userId;

typedef struct UpdateMentorInfoRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *mentorNickname;
  NSString *mentorUniversity;
  NSString *mentorMajor;
  NSString *mentorBackgroundurl;
  NSString *mentorProfileurl;
  NSString *mentorMentoringArea;
  NSString *mentorMentoringField;
  NSString *mentorIntroduction;
  NSString *mentorInformation;
  NSData *backgroundImage;
  NSData *profileImage;
  int64_t mentorId;
  int64_t userId;
} UpdateMentorInfoRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "mentorId",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_MentorId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, mentorId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "mentorNickname",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_MentorNickname,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, mentorNickname),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorUniversity",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_MentorUniversity,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, mentorUniversity),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorMajor",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_MentorMajor,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, mentorMajor),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorBackgroundurl",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_MentorBackgroundurl,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, mentorBackgroundurl),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorProfileurl",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_MentorProfileurl,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, mentorProfileurl),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorMentoringArea",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_MentorMentoringArea,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, mentorMentoringArea),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorMentoringField",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_MentorMentoringField,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, mentorMentoringField),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorIntroduction",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_MentorIntroduction,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, mentorIntroduction),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorInformation",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_MentorInformation,
        .hasIndex = 9,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, mentorInformation),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "backgroundImage",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_BackgroundImage,
        .hasIndex = 10,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, backgroundImage),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeBytes,
      },
      {
        .name = "profileImage",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_ProfileImage,
        .hasIndex = 11,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, profileImage),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeBytes,
      },
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = UpdateMentorInfoRequest_FieldNumber_UserId,
        .hasIndex = 12,
        .offset = (uint32_t)offsetof(UpdateMentorInfoRequest__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[UpdateMentorInfoRequest class]
                                     rootClass:[MentorRoot class]
                                          file:MentorRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(UpdateMentorInfoRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - Mentor

@implementation Mentor

@dynamic numberId;
@dynamic mentorId;
@dynamic userId;
@dynamic mentorNickname;
@dynamic mentorUniversity;
@dynamic mentorMajor;
@dynamic mentorBackgroundurl;
@dynamic mentorProfileurl;
@dynamic mentorMentoringArea;
@dynamic mentorMentoringField;
@dynamic mentorIntroduction;
@dynamic mentorInformation;
@dynamic mentorTouchCount;
@dynamic mentorFavoriteCount;
@dynamic mentorIsActive;
@dynamic mentorCreatedAt;

typedef struct Mentor__storage_ {
  uint32_t _has_storage_[1];
  NSString *mentorNickname;
  NSString *mentorUniversity;
  NSString *mentorMajor;
  NSString *mentorBackgroundurl;
  NSString *mentorProfileurl;
  NSString *mentorMentoringArea;
  NSString *mentorMentoringField;
  NSString *mentorIntroduction;
  NSString *mentorInformation;
  NSString *mentorCreatedAt;
  int64_t numberId;
  int64_t mentorId;
  int64_t userId;
  int64_t mentorTouchCount;
  int64_t mentorFavoriteCount;
  int64_t mentorIsActive;
} Mentor__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "numberId",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_NumberId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(Mentor__storage_, numberId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "mentorId",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorId,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "userId",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_UserId,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(Mentor__storage_, userId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "mentorNickname",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorNickname,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorNickname),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorUniversity",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorUniversity,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorUniversity),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorMajor",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorMajor,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorMajor),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorBackgroundurl",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorBackgroundurl,
        .hasIndex = 6,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorBackgroundurl),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorProfileurl",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorProfileurl,
        .hasIndex = 7,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorProfileurl),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorMentoringArea",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorMentoringArea,
        .hasIndex = 8,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorMentoringArea),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorMentoringField",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorMentoringField,
        .hasIndex = 9,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorMentoringField),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorIntroduction",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorIntroduction,
        .hasIndex = 10,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorIntroduction),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorInformation",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorInformation,
        .hasIndex = 11,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorInformation),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "mentorTouchCount",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorTouchCount,
        .hasIndex = 12,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorTouchCount),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "mentorFavoriteCount",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorFavoriteCount,
        .hasIndex = 13,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorFavoriteCount),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "mentorIsActive",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorIsActive,
        .hasIndex = 14,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorIsActive),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "mentorCreatedAt",
        .dataTypeSpecific.className = NULL,
        .number = Mentor_FieldNumber_MentorCreatedAt,
        .hasIndex = 15,
        .offset = (uint32_t)offsetof(Mentor__storage_, mentorCreatedAt),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[Mentor class]
                                     rootClass:[MentorRoot class]
                                          file:MentorRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(Mentor__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - GetMentorsRequest

@implementation GetMentorsRequest

@dynamic numberId;
@dynamic indicator;
@dynamic scrollIs;

typedef struct GetMentorsRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *indicator;
  NSString *scrollIs;
  int64_t numberId;
} GetMentorsRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "numberId",
        .dataTypeSpecific.className = NULL,
        .number = GetMentorsRequest_FieldNumber_NumberId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(GetMentorsRequest__storage_, numberId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "indicator",
        .dataTypeSpecific.className = NULL,
        .number = GetMentorsRequest_FieldNumber_Indicator,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(GetMentorsRequest__storage_, indicator),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "scrollIs",
        .dataTypeSpecific.className = NULL,
        .number = GetMentorsRequest_FieldNumber_ScrollIs,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(GetMentorsRequest__storage_, scrollIs),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GetMentorsRequest class]
                                     rootClass:[MentorRoot class]
                                          file:MentorRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GetMentorsRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - GetMentorsResponse

@implementation GetMentorsResponse

@dynamic mentorsArray, mentorsArray_Count;

typedef struct GetMentorsResponse__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *mentorsArray;
} GetMentorsResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "mentorsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(Mentor),
        .number = GetMentorsResponse_FieldNumber_MentorsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(GetMentorsResponse__storage_, mentorsArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[GetMentorsResponse class]
                                     rootClass:[MentorRoot class]
                                          file:MentorRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(GetMentorsResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MentorTouchRequest

@implementation MentorTouchRequest

@dynamic mentorId;
@dynamic indicator;

typedef struct MentorTouchRequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *indicator;
  int64_t mentorId;
} MentorTouchRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "mentorId",
        .dataTypeSpecific.className = NULL,
        .number = MentorTouchRequest_FieldNumber_MentorId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MentorTouchRequest__storage_, mentorId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "indicator",
        .dataTypeSpecific.className = NULL,
        .number = MentorTouchRequest_FieldNumber_Indicator,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(MentorTouchRequest__storage_, indicator),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MentorTouchRequest class]
                                     rootClass:[MentorRoot class]
                                          file:MentorRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MentorTouchRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - MentorTouchResponse

@implementation MentorTouchResponse

@dynamic isDeleted;

typedef struct MentorTouchResponse__storage_ {
  uint32_t _has_storage_[1];
  NSString *isDeleted;
} MentorTouchResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "isDeleted",
        .dataTypeSpecific.className = NULL,
        .number = MentorTouchResponse_FieldNumber_IsDeleted,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(MentorTouchResponse__storage_, isDeleted),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[MentorTouchResponse class]
                                     rootClass:[MentorRoot class]
                                          file:MentorRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(MentorTouchResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - DeleteMentorRequest

@implementation DeleteMentorRequest

@dynamic mentorId;

typedef struct DeleteMentorRequest__storage_ {
  uint32_t _has_storage_[1];
  int64_t mentorId;
} DeleteMentorRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "mentorId",
        .dataTypeSpecific.className = NULL,
        .number = DeleteMentorRequest_FieldNumber_MentorId,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(DeleteMentorRequest__storage_, mentorId),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[DeleteMentorRequest class]
                                     rootClass:[MentorRoot class]
                                          file:MentorRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(DeleteMentorRequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)