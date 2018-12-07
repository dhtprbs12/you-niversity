// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: university.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class University;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - UniversityRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface UniversityRoot : GPBRootObject
@end

#pragma mark - University

typedef GPB_ENUM(University_FieldNumber) {
  University_FieldNumber_UniversityId = 1,
  University_FieldNumber_Name = 2,
  University_FieldNumber_Ranking = 3,
  University_FieldNumber_Website = 4,
  University_FieldNumber_Address = 5,
  University_FieldNumber_NumOfStudents = 6,
  University_FieldNumber_TuitionFee = 7,
  University_FieldNumber_Sat = 8,
  University_FieldNumber_Act = 9,
  University_FieldNumber_ApplicationFee = 10,
  University_FieldNumber_SatAct = 11,
  University_FieldNumber_HighSchoolGpa = 12,
  University_FieldNumber_AcceptanceRate = 13,
  University_FieldNumber_CrawlingURL = 14,
};

@interface University : GPBMessage

@property(nonatomic, readwrite) int64_t universityId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

@property(nonatomic, readwrite, copy, null_resettable) NSString *ranking;

@property(nonatomic, readwrite, copy, null_resettable) NSString *website;

@property(nonatomic, readwrite, copy, null_resettable) NSString *address;

@property(nonatomic, readwrite, copy, null_resettable) NSString *numOfStudents;

@property(nonatomic, readwrite, copy, null_resettable) NSString *tuitionFee;

@property(nonatomic, readwrite, copy, null_resettable) NSString *sat;

@property(nonatomic, readwrite, copy, null_resettable) NSString *act;

@property(nonatomic, readwrite, copy, null_resettable) NSString *applicationFee;

@property(nonatomic, readwrite, copy, null_resettable) NSString *satAct;

@property(nonatomic, readwrite, copy, null_resettable) NSString *highSchoolGpa;

@property(nonatomic, readwrite, copy, null_resettable) NSString *acceptanceRate;

@property(nonatomic, readwrite, copy, null_resettable) NSString *crawlingURL;

@end

#pragma mark - GetUniversitiesRequest

typedef GPB_ENUM(GetUniversitiesRequest_FieldNumber) {
  GetUniversitiesRequest_FieldNumber_UniversityId = 1,
};

@interface GetUniversitiesRequest : GPBMessage

@property(nonatomic, readwrite) int64_t universityId;

@end

#pragma mark - GetUniversitiesResponse

typedef GPB_ENUM(GetUniversitiesResponse_FieldNumber) {
  GetUniversitiesResponse_FieldNumber_UniversitiesArray = 1,
};

@interface GetUniversitiesResponse : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<University*> *universitiesArray;
/** The number of items in @c universitiesArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger universitiesArray_Count;

@end

#pragma mark - GetAcceptibleUniversitiesRequest

typedef GPB_ENUM(GetAcceptibleUniversitiesRequest_FieldNumber) {
  GetAcceptibleUniversitiesRequest_FieldNumber_UniversityId = 1,
  GetAcceptibleUniversitiesRequest_FieldNumber_TestType = 2,
  GetAcceptibleUniversitiesRequest_FieldNumber_Score = 3,
  GetAcceptibleUniversitiesRequest_FieldNumber_GpaScore = 4,
};

@interface GetAcceptibleUniversitiesRequest : GPBMessage

@property(nonatomic, readwrite) int64_t universityId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *testType;

@property(nonatomic, readwrite, copy, null_resettable) NSString *score;

@property(nonatomic, readwrite, copy, null_resettable) NSString *gpaScore;

@end

#pragma mark - GetUniversityByNameRequest

typedef GPB_ENUM(GetUniversityByNameRequest_FieldNumber) {
  GetUniversityByNameRequest_FieldNumber_Name = 1,
};

@interface GetUniversityByNameRequest : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

@end

#pragma mark - GetUniversityByNameResponse

typedef GPB_ENUM(GetUniversityByNameResponse_FieldNumber) {
  GetUniversityByNameResponse_FieldNumber_University = 1,
};

@interface GetUniversityByNameResponse : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) University *university;
/** Test to see if @c university has been set. */
@property(nonatomic, readwrite) BOOL hasUniversity;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)