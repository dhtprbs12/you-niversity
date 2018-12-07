#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
#import "Main.pbrpc.h"
#import "Main.pbobjc.h"
#import <ProtoRPC/ProtoRPC.h>
#import <RxLibrary/GRXWriter+Immediate.h>

#import "User.pbobjc.h"
#import "University.pbobjc.h"
#import "Mentor.pbobjc.h"
#import "Common.pbobjc.h"
#import "Board.pbobjc.h"

@implementation Main

// Designated initializer
- (instancetype)initWithHost:(NSString *)host {
  self = [super initWithHost:host
                 packageName:@"proto.main"
                 serviceName:@"Main"];
  return self;
}

// Override superclass initializer to disallow different package and service names.
- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName {
  return [self initWithHost:host];
}

#pragma mark - Class Methods

+ (instancetype)serviceWithHost:(NSString *)host {
  return [[self alloc] initWithHost:host];
}

#pragma mark - Method Implementations

#pragma mark GetCaptcha(CaptchaRequest) returns (CaptchaResponse)

- (void)getCaptchaWithRequest:(CaptchaRequest *)request handler:(void(^)(CaptchaResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetCaptchaWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetCaptchaWithRequest:(CaptchaRequest *)request handler:(void(^)(CaptchaResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetCaptcha"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[CaptchaResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark UserRegistration(UserRegisterRequest) returns (UserRegisterResponse)

- (void)userRegistrationWithRequest:(UserRegisterRequest *)request handler:(void(^)(UserRegisterResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToUserRegistrationWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToUserRegistrationWithRequest:(UserRegisterRequest *)request handler:(void(^)(UserRegisterResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"UserRegistration"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[UserRegisterResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
@end
@implementation AuthorizedMain

// Designated initializer
- (instancetype)initWithHost:(NSString *)host {
  self = [super initWithHost:host
                 packageName:@"proto.main"
                 serviceName:@"AuthorizedMain"];
  return self;
}

// Override superclass initializer to disallow different package and service names.
- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName {
  return [self initWithHost:host];
}

#pragma mark - Class Methods

+ (instancetype)serviceWithHost:(NSString *)host {
  return [[self alloc] initWithHost:host];
}

#pragma mark - Method Implementations

#pragma mark Auth(AuthRequest) returns (AuthResponse)

/**
 * user.proto
 */
- (void)authWithRequest:(AuthRequest *)request handler:(void(^)(AuthResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToAuthWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * user.proto
 */
- (GRPCProtoCall *)RPCToAuthWithRequest:(AuthRequest *)request handler:(void(^)(AuthResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"Auth"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[AuthResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark UserLoginCheck(UserLoginCheckRequest) returns (UserLoginCheckResponse)

- (void)userLoginCheckWithRequest:(UserLoginCheckRequest *)request handler:(void(^)(UserLoginCheckResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToUserLoginCheckWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToUserLoginCheckWithRequest:(UserLoginCheckRequest *)request handler:(void(^)(UserLoginCheckResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"UserLoginCheck"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[UserLoginCheckResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark UpdateProfile(UpdateProfileRequest) returns (UpdateProfileResponse)

- (void)updateProfileWithRequest:(UpdateProfileRequest *)request handler:(void(^)(UpdateProfileResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToUpdateProfileWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToUpdateProfileWithRequest:(UpdateProfileRequest *)request handler:(void(^)(UpdateProfileResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"UpdateProfile"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[UpdateProfileResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark Report(ReportRequest) returns (EmptyResponse)

- (void)reportWithRequest:(ReportRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToReportWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToReportWithRequest:(ReportRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"Report"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark Logout(LogoutRequest) returns (EmptyResponse)

- (void)logoutWithRequest:(LogoutRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToLogoutWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToLogoutWithRequest:(LogoutRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"Logout"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark UpdateActive(ActiveRequest) returns (EmptyResponse)

- (void)updateActiveWithRequest:(ActiveRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToUpdateActiveWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToUpdateActiveWithRequest:(ActiveRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"UpdateActive"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark PushUpdate(PushUpdateRequest) returns (EmptyResponse)

- (void)pushUpdateWithRequest:(PushUpdateRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToPushUpdateWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToPushUpdateWithRequest:(PushUpdateRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"PushUpdate"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark Unregister(UnregisterRequest) returns (EmptyResponse)

- (void)unregisterWithRequest:(UnregisterRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToUnregisterWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToUnregisterWithRequest:(UnregisterRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"Unregister"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark UpdateAppleToken(UpdateAppleTokenRequest) returns (EmptyResponse)

- (void)updateAppleTokenWithRequest:(UpdateAppleTokenRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToUpdateAppleTokenWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToUpdateAppleTokenWithRequest:(UpdateAppleTokenRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"UpdateAppleToken"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark AppAboutTerminating(AppAboutTerminatingRequest) returns (EmptyResponse)

- (void)appAboutTerminatingWithRequest:(AppAboutTerminatingRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToAppAboutTerminatingWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToAppAboutTerminatingWithRequest:(AppAboutTerminatingRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"AppAboutTerminating"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark MentorRegister(MentorRegisterRequest) returns (MentorRegisterResponse)

/**
 * mentor.proto
 */
- (void)mentorRegisterWithRequest:(MentorRegisterRequest *)request handler:(void(^)(MentorRegisterResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToMentorRegisterWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * mentor.proto
 */
- (GRPCProtoCall *)RPCToMentorRegisterWithRequest:(MentorRegisterRequest *)request handler:(void(^)(MentorRegisterResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"MentorRegister"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[MentorRegisterResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark UpdateMentorInfo(UpdateMentorInfoRequest) returns (EmptyResponse)

- (void)updateMentorInfoWithRequest:(UpdateMentorInfoRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToUpdateMentorInfoWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToUpdateMentorInfoWithRequest:(UpdateMentorInfoRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"UpdateMentorInfo"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetMentors(GetMentorsRequest) returns (GetMentorsResponse)

- (void)getMentorsWithRequest:(GetMentorsRequest *)request handler:(void(^)(GetMentorsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetMentorsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetMentorsWithRequest:(GetMentorsRequest *)request handler:(void(^)(GetMentorsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetMentors"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetMentorsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark MentorTouch(MentorTouchRequest) returns (EmptyResponse)

- (void)mentorTouchWithRequest:(MentorTouchRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToMentorTouchWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToMentorTouchWithRequest:(MentorTouchRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"MentorTouch"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark DeleteMentor(DeleteMentorRequest) returns (EmptyResponse)

- (void)deleteMentorWithRequest:(DeleteMentorRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToDeleteMentorWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToDeleteMentorWithRequest:(DeleteMentorRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"DeleteMentor"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark CreateBoard(CreateBoardRequest) returns (CreateBoardResponse)

/**
 * board.proto
 */
- (void)createBoardWithRequest:(CreateBoardRequest *)request handler:(void(^)(CreateBoardResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToCreateBoardWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * board.proto
 */
- (GRPCProtoCall *)RPCToCreateBoardWithRequest:(CreateBoardRequest *)request handler:(void(^)(CreateBoardResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"CreateBoard"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[CreateBoardResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetBoards(BoardsRequest) returns (BoardsResponse)

- (void)getBoardsWithRequest:(BoardsRequest *)request handler:(void(^)(BoardsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetBoardsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetBoardsWithRequest:(BoardsRequest *)request handler:(void(^)(BoardsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetBoards"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[BoardsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetMyBoards(MyBoardsRequest) returns (BoardsResponse)

- (void)getMyBoardsWithRequest:(MyBoardsRequest *)request handler:(void(^)(BoardsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetMyBoardsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetMyBoardsWithRequest:(MyBoardsRequest *)request handler:(void(^)(BoardsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetMyBoards"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[BoardsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark BoardTouch(BoardTouchRequest) returns (EmptyResponse)

- (void)boardTouchWithRequest:(BoardTouchRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToBoardTouchWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToBoardTouchWithRequest:(BoardTouchRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"BoardTouch"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark ReviseMyBoard(ReviseMyBoardRequest) returns (EmptyResponse)

- (void)reviseMyBoardWithRequest:(ReviseMyBoardRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToReviseMyBoardWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToReviseMyBoardWithRequest:(ReviseMyBoardRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"ReviseMyBoard"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark ReviseMyReview(ReviseMyReviewRequest) returns (EmptyResponse)

- (void)reviseMyReviewWithRequest:(ReviseMyReviewRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToReviseMyReviewWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToReviseMyReviewWithRequest:(ReviseMyReviewRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"ReviseMyReview"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark DeleteMyBoard(DeleteMyBoardRequest) returns (EmptyResponse)

- (void)deleteMyBoardWithRequest:(DeleteMyBoardRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToDeleteMyBoardWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToDeleteMyBoardWithRequest:(DeleteMyBoardRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"DeleteMyBoard"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark CommentUpload(CommentUploadRequest) returns (EmptyResponse)

/**
 * common.proto
 */
- (void)commentUploadWithRequest:(CommentUploadRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToCommentUploadWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * common.proto
 */
- (GRPCProtoCall *)RPCToCommentUploadWithRequest:(CommentUploadRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"CommentUpload"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetComments(GetCommentsRequest) returns (GetCommentsResponse)

- (void)getCommentsWithRequest:(GetCommentsRequest *)request handler:(void(^)(GetCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetCommentsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetCommentsWithRequest:(GetCommentsRequest *)request handler:(void(^)(GetCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetComments"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetCommentsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetRepliedComments(GetRepliedCommentsRequest) returns (GetRepliedCommentsResponse)

- (void)getRepliedCommentsWithRequest:(GetRepliedCommentsRequest *)request handler:(void(^)(GetRepliedCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetRepliedCommentsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetRepliedCommentsWithRequest:(GetRepliedCommentsRequest *)request handler:(void(^)(GetRepliedCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetRepliedComments"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetRepliedCommentsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetCommentsCount(GetCommentsCountRequest) returns (GetCommentsCountResponse)

- (void)getCommentsCountWithRequest:(GetCommentsCountRequest *)request handler:(void(^)(GetCommentsCountResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetCommentsCountWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetCommentsCountWithRequest:(GetCommentsCountRequest *)request handler:(void(^)(GetCommentsCountResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetCommentsCount"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetCommentsCountResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark RepliedCommentUpload(RepliedCommentUploadRequest) returns (EmptyResponse)

- (void)repliedCommentUploadWithRequest:(RepliedCommentUploadRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToRepliedCommentUploadWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToRepliedCommentUploadWithRequest:(RepliedCommentUploadRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"RepliedCommentUpload"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark MentorCommentUpload(UploadMentorCommentRequest) returns (EmptyResponse)

/**
 * mentor comment
 */
- (void)mentorCommentUploadWithRequest:(UploadMentorCommentRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToMentorCommentUploadWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * mentor comment
 */
- (GRPCProtoCall *)RPCToMentorCommentUploadWithRequest:(UploadMentorCommentRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"MentorCommentUpload"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark RepliedMentorCommentUpload(UploadRepliedMentorCommentRequest) returns (EmptyResponse)

- (void)repliedMentorCommentUploadWithRequest:(UploadRepliedMentorCommentRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToRepliedMentorCommentUploadWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToRepliedMentorCommentUploadWithRequest:(UploadRepliedMentorCommentRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"RepliedMentorCommentUpload"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[EmptyResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetMentorComments(GetMentorCommentsRequest) returns (GetMentorCommentsResponse)

- (void)getMentorCommentsWithRequest:(GetMentorCommentsRequest *)request handler:(void(^)(GetMentorCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetMentorCommentsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetMentorCommentsWithRequest:(GetMentorCommentsRequest *)request handler:(void(^)(GetMentorCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetMentorComments"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetMentorCommentsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetRepliedMentorComments(GetRepliedMentorCommentsRequest) returns (GetRepliedMentorCommentsResponse)

- (void)getRepliedMentorCommentsWithRequest:(GetRepliedMentorCommentsRequest *)request handler:(void(^)(GetRepliedMentorCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetRepliedMentorCommentsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetRepliedMentorCommentsWithRequest:(GetRepliedMentorCommentsRequest *)request handler:(void(^)(GetRepliedMentorCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetRepliedMentorComments"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetRepliedMentorCommentsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetMentorCommentsCount(GetMentorCommentsCountRequest) returns (GetMentorCommentsCountResponse)

- (void)getMentorCommentsCountWithRequest:(GetMentorCommentsCountRequest *)request handler:(void(^)(GetMentorCommentsCountResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetMentorCommentsCountWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetMentorCommentsCountWithRequest:(GetMentorCommentsCountRequest *)request handler:(void(^)(GetMentorCommentsCountResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetMentorCommentsCount"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetMentorCommentsCountResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetSharedComments(GetSharedCommentsRequest) returns (GetSharedCommentsResponse)

- (void)getSharedCommentsWithRequest:(GetSharedCommentsRequest *)request handler:(void(^)(GetSharedCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetSharedCommentsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetSharedCommentsWithRequest:(GetSharedCommentsRequest *)request handler:(void(^)(GetSharedCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetSharedComments"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetSharedCommentsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark CheckIfThereIsNewComments(CheckIfThereIsNewCommentsRequest) returns (CheckIfThereIsNewCommentsResponse)

- (void)checkIfThereIsNewCommentsWithRequest:(CheckIfThereIsNewCommentsRequest *)request handler:(void(^)(CheckIfThereIsNewCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToCheckIfThereIsNewCommentsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToCheckIfThereIsNewCommentsWithRequest:(CheckIfThereIsNewCommentsRequest *)request handler:(void(^)(CheckIfThereIsNewCommentsResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"CheckIfThereIsNewComments"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[CheckIfThereIsNewCommentsResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark CheckIfItsDeleted(CheckIfItsDeletedRequest) returns (CheckIfItsDeletedResponse)

- (void)checkIfItsDeletedWithRequest:(CheckIfItsDeletedRequest *)request handler:(void(^)(CheckIfItsDeletedResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToCheckIfItsDeletedWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToCheckIfItsDeletedWithRequest:(CheckIfItsDeletedRequest *)request handler:(void(^)(CheckIfItsDeletedResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"CheckIfItsDeleted"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[CheckIfItsDeletedResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetBoardObject(GetBoardObjectRequest) returns (GetBoardObjectResponse)

/**
 * shared comment
 */
- (void)getBoardObjectWithRequest:(GetBoardObjectRequest *)request handler:(void(^)(GetBoardObjectResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetBoardObjectWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * shared comment
 */
- (GRPCProtoCall *)RPCToGetBoardObjectWithRequest:(GetBoardObjectRequest *)request handler:(void(^)(GetBoardObjectResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetBoardObject"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetBoardObjectResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetCommentObject(GetCommentObjectRequest) returns (GetCommentObjectResponse)

- (void)getCommentObjectWithRequest:(GetCommentObjectRequest *)request handler:(void(^)(GetCommentObjectResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetCommentObjectWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetCommentObjectWithRequest:(GetCommentObjectRequest *)request handler:(void(^)(GetCommentObjectResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetCommentObject"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetCommentObjectResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetMentorObject(GetMentorObjectRequest) returns (GetMentorObjectResponse)

- (void)getMentorObjectWithRequest:(GetMentorObjectRequest *)request handler:(void(^)(GetMentorObjectResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetMentorObjectWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetMentorObjectWithRequest:(GetMentorObjectRequest *)request handler:(void(^)(GetMentorObjectResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetMentorObject"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetMentorObjectResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetMentorCommentObject(GetMentorCommentObjectRequest) returns (GetMentorCommentObjectResponse)

- (void)getMentorCommentObjectWithRequest:(GetMentorCommentObjectRequest *)request handler:(void(^)(GetMentorCommentObjectResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetMentorCommentObjectWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetMentorCommentObjectWithRequest:(GetMentorCommentObjectRequest *)request handler:(void(^)(GetMentorCommentObjectResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetMentorCommentObject"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetMentorCommentObjectResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetUniversities(GetUniversitiesRequest) returns (GetUniversitiesResponse)

/**
 * conversation.proto
 * rpc GetConversations(GetConversationsRequest) returns (GetConversationsResponse){}
 * rpc JoinConversation(JoinConversationRequest) returns (EmptyResponse){}
 * rpc LeaveConversation(LeaveConversationRequest) returns (EmptyResponse){}
 * rpc SendMessage(SendMessageRequest) returns (SendMessageResponse){}
 * rpc ChatStream (ChatStreamRequest) returns (stream ChatStreamResponse){}
 * rpc GetMessages(GetMessagesRequest) returns (GetMessagesResponse){}
 * rpc GetLastMessage(GetLastMessageRequest) returns (GetLastMessageResponse){}
 * rpc DeleteConversation(DeleteConversationRequest) returns (EmptyResponse){}
 * 
 * university.proto
 */
- (void)getUniversitiesWithRequest:(GetUniversitiesRequest *)request handler:(void(^)(GetUniversitiesResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetUniversitiesWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
/**
 * conversation.proto
 * rpc GetConversations(GetConversationsRequest) returns (GetConversationsResponse){}
 * rpc JoinConversation(JoinConversationRequest) returns (EmptyResponse){}
 * rpc LeaveConversation(LeaveConversationRequest) returns (EmptyResponse){}
 * rpc SendMessage(SendMessageRequest) returns (SendMessageResponse){}
 * rpc ChatStream (ChatStreamRequest) returns (stream ChatStreamResponse){}
 * rpc GetMessages(GetMessagesRequest) returns (GetMessagesResponse){}
 * rpc GetLastMessage(GetLastMessageRequest) returns (GetLastMessageResponse){}
 * rpc DeleteConversation(DeleteConversationRequest) returns (EmptyResponse){}
 * 
 * university.proto
 */
- (GRPCProtoCall *)RPCToGetUniversitiesWithRequest:(GetUniversitiesRequest *)request handler:(void(^)(GetUniversitiesResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetUniversities"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetUniversitiesResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetAcceptibleUniversities(GetAcceptibleUniversitiesRequest) returns (GetUniversitiesResponse)

- (void)getAcceptibleUniversitiesWithRequest:(GetAcceptibleUniversitiesRequest *)request handler:(void(^)(GetUniversitiesResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetAcceptibleUniversitiesWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetAcceptibleUniversitiesWithRequest:(GetAcceptibleUniversitiesRequest *)request handler:(void(^)(GetUniversitiesResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetAcceptibleUniversities"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetUniversitiesResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark GetUniversityByName(GetUniversityByNameRequest) returns (GetUniversityByNameResponse)

- (void)getUniversityByNameWithRequest:(GetUniversityByNameRequest *)request handler:(void(^)(GetUniversityByNameResponse *_Nullable response, NSError *_Nullable error))handler{
  [[self RPCToGetUniversityByNameWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (GRPCProtoCall *)RPCToGetUniversityByNameWithRequest:(GetUniversityByNameRequest *)request handler:(void(^)(GetUniversityByNameResponse *_Nullable response, NSError *_Nullable error))handler{
  return [self RPCToMethod:@"GetUniversityByName"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[GetUniversityByNameResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
@end
#endif
