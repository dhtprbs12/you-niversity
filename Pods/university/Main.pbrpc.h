#if !defined(GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO) || !GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO
#import "Main.pbobjc.h"
#endif

#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
#import <ProtoRPC/ProtoService.h>
#import <ProtoRPC/ProtoRPC.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>
#endif

@class ActiveRequest;
@class AppAboutTerminatingRequest;
@class AuthRequest;
@class AuthResponse;
@class BoardTouchRequest;
@class BoardsRequest;
@class BoardsResponse;
@class CaptchaRequest;
@class CaptchaResponse;
@class CheckIfItsDeletedRequest;
@class CheckIfItsDeletedResponse;
@class CheckIfThereIsNewCommentsRequest;
@class CheckIfThereIsNewCommentsResponse;
@class CommentUploadRequest;
@class CreateBoardRequest;
@class CreateBoardResponse;
@class DeleteMentorRequest;
@class DeleteMyBoardRequest;
@class EmptyResponse;
@class GetAcceptibleUniversitiesRequest;
@class GetBoardObjectRequest;
@class GetBoardObjectResponse;
@class GetCommentObjectRequest;
@class GetCommentObjectResponse;
@class GetCommentsCountRequest;
@class GetCommentsCountResponse;
@class GetCommentsRequest;
@class GetCommentsResponse;
@class GetMentorCommentObjectRequest;
@class GetMentorCommentObjectResponse;
@class GetMentorCommentsCountRequest;
@class GetMentorCommentsCountResponse;
@class GetMentorCommentsRequest;
@class GetMentorCommentsResponse;
@class GetMentorObjectRequest;
@class GetMentorObjectResponse;
@class GetMentorsRequest;
@class GetMentorsResponse;
@class GetRepliedCommentsRequest;
@class GetRepliedCommentsResponse;
@class GetRepliedMentorCommentsRequest;
@class GetRepliedMentorCommentsResponse;
@class GetSharedCommentsRequest;
@class GetSharedCommentsResponse;
@class GetUniversitiesRequest;
@class GetUniversitiesResponse;
@class GetUniversityByNameRequest;
@class GetUniversityByNameResponse;
@class LogoutRequest;
@class MentorRegisterRequest;
@class MentorRegisterResponse;
@class MentorTouchRequest;
@class MyBoardsRequest;
@class PushUpdateRequest;
@class RepliedCommentUploadRequest;
@class ReportRequest;
@class ReviseMyBoardRequest;
@class ReviseMyReviewRequest;
@class UnregisterRequest;
@class UpdateAppleTokenRequest;
@class UpdateMentorInfoRequest;
@class UpdateProfileRequest;
@class UpdateProfileResponse;
@class UploadMentorCommentRequest;
@class UploadRepliedMentorCommentRequest;
@class UserLoginCheckRequest;
@class UserLoginCheckResponse;
@class UserRegisterRequest;
@class UserRegisterResponse;

#if !defined(GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO) || !GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO
  #import "User.pbobjc.h"
  #import "University.pbobjc.h"
  #import "Mentor.pbobjc.h"
  #import "Common.pbobjc.h"
  #import "Board.pbobjc.h"
#endif

@class GRPCProtoCall;


NS_ASSUME_NONNULL_BEGIN

@protocol Main <NSObject>

#pragma mark GetCaptcha(CaptchaRequest) returns (CaptchaResponse)

- (void)getCaptchaWithRequest:(CaptchaRequest *)request handler:(void(^)(CaptchaResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetCaptchaWithRequest:(CaptchaRequest *)request handler:(void(^)(CaptchaResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark UserRegistration(UserRegisterRequest) returns (UserRegisterResponse)

- (void)userRegistrationWithRequest:(UserRegisterRequest *)request handler:(void(^)(UserRegisterResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUserRegistrationWithRequest:(UserRegisterRequest *)request handler:(void(^)(UserRegisterResponse *_Nullable response, NSError *_Nullable error))handler;


@end

@protocol AuthorizedMain <NSObject>

#pragma mark Auth(AuthRequest) returns (AuthResponse)

/**
 * user.proto
 */
- (void)authWithRequest:(AuthRequest *)request handler:(void(^)(AuthResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * user.proto
 */
- (GRPCProtoCall *)RPCToAuthWithRequest:(AuthRequest *)request handler:(void(^)(AuthResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark UserLoginCheck(UserLoginCheckRequest) returns (UserLoginCheckResponse)

- (void)userLoginCheckWithRequest:(UserLoginCheckRequest *)request handler:(void(^)(UserLoginCheckResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUserLoginCheckWithRequest:(UserLoginCheckRequest *)request handler:(void(^)(UserLoginCheckResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark UpdateProfile(UpdateProfileRequest) returns (UpdateProfileResponse)

- (void)updateProfileWithRequest:(UpdateProfileRequest *)request handler:(void(^)(UpdateProfileResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUpdateProfileWithRequest:(UpdateProfileRequest *)request handler:(void(^)(UpdateProfileResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Report(ReportRequest) returns (EmptyResponse)

- (void)reportWithRequest:(ReportRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToReportWithRequest:(ReportRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Logout(LogoutRequest) returns (EmptyResponse)

- (void)logoutWithRequest:(LogoutRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToLogoutWithRequest:(LogoutRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark UpdateActive(ActiveRequest) returns (EmptyResponse)

- (void)updateActiveWithRequest:(ActiveRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUpdateActiveWithRequest:(ActiveRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark PushUpdate(PushUpdateRequest) returns (EmptyResponse)

- (void)pushUpdateWithRequest:(PushUpdateRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToPushUpdateWithRequest:(PushUpdateRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Unregister(UnregisterRequest) returns (EmptyResponse)

- (void)unregisterWithRequest:(UnregisterRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUnregisterWithRequest:(UnregisterRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark UpdateAppleToken(UpdateAppleTokenRequest) returns (EmptyResponse)

- (void)updateAppleTokenWithRequest:(UpdateAppleTokenRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUpdateAppleTokenWithRequest:(UpdateAppleTokenRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark AppAboutTerminating(AppAboutTerminatingRequest) returns (EmptyResponse)

- (void)appAboutTerminatingWithRequest:(AppAboutTerminatingRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToAppAboutTerminatingWithRequest:(AppAboutTerminatingRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark MentorRegister(MentorRegisterRequest) returns (MentorRegisterResponse)

/**
 * mentor.proto
 */
- (void)mentorRegisterWithRequest:(MentorRegisterRequest *)request handler:(void(^)(MentorRegisterResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * mentor.proto
 */
- (GRPCProtoCall *)RPCToMentorRegisterWithRequest:(MentorRegisterRequest *)request handler:(void(^)(MentorRegisterResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark UpdateMentorInfo(UpdateMentorInfoRequest) returns (EmptyResponse)

- (void)updateMentorInfoWithRequest:(UpdateMentorInfoRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToUpdateMentorInfoWithRequest:(UpdateMentorInfoRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetMentors(GetMentorsRequest) returns (GetMentorsResponse)

- (void)getMentorsWithRequest:(GetMentorsRequest *)request handler:(void(^)(GetMentorsResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetMentorsWithRequest:(GetMentorsRequest *)request handler:(void(^)(GetMentorsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark MentorTouch(MentorTouchRequest) returns (EmptyResponse)

- (void)mentorTouchWithRequest:(MentorTouchRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToMentorTouchWithRequest:(MentorTouchRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark DeleteMentor(DeleteMentorRequest) returns (EmptyResponse)

- (void)deleteMentorWithRequest:(DeleteMentorRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToDeleteMentorWithRequest:(DeleteMentorRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark CreateBoard(CreateBoardRequest) returns (CreateBoardResponse)

/**
 * board.proto
 */
- (void)createBoardWithRequest:(CreateBoardRequest *)request handler:(void(^)(CreateBoardResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * board.proto
 */
- (GRPCProtoCall *)RPCToCreateBoardWithRequest:(CreateBoardRequest *)request handler:(void(^)(CreateBoardResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBoards(BoardsRequest) returns (BoardsResponse)

- (void)getBoardsWithRequest:(BoardsRequest *)request handler:(void(^)(BoardsResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetBoardsWithRequest:(BoardsRequest *)request handler:(void(^)(BoardsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetMyBoards(MyBoardsRequest) returns (BoardsResponse)

- (void)getMyBoardsWithRequest:(MyBoardsRequest *)request handler:(void(^)(BoardsResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetMyBoardsWithRequest:(MyBoardsRequest *)request handler:(void(^)(BoardsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark BoardTouch(BoardTouchRequest) returns (EmptyResponse)

- (void)boardTouchWithRequest:(BoardTouchRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToBoardTouchWithRequest:(BoardTouchRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark ReviseMyBoard(ReviseMyBoardRequest) returns (EmptyResponse)

- (void)reviseMyBoardWithRequest:(ReviseMyBoardRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToReviseMyBoardWithRequest:(ReviseMyBoardRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark ReviseMyReview(ReviseMyReviewRequest) returns (EmptyResponse)

- (void)reviseMyReviewWithRequest:(ReviseMyReviewRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToReviseMyReviewWithRequest:(ReviseMyReviewRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark DeleteMyBoard(DeleteMyBoardRequest) returns (EmptyResponse)

- (void)deleteMyBoardWithRequest:(DeleteMyBoardRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToDeleteMyBoardWithRequest:(DeleteMyBoardRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark CommentUpload(CommentUploadRequest) returns (EmptyResponse)

/**
 * common.proto
 */
- (void)commentUploadWithRequest:(CommentUploadRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * common.proto
 */
- (GRPCProtoCall *)RPCToCommentUploadWithRequest:(CommentUploadRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetComments(GetCommentsRequest) returns (GetCommentsResponse)

- (void)getCommentsWithRequest:(GetCommentsRequest *)request handler:(void(^)(GetCommentsResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetCommentsWithRequest:(GetCommentsRequest *)request handler:(void(^)(GetCommentsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetRepliedComments(GetRepliedCommentsRequest) returns (GetRepliedCommentsResponse)

- (void)getRepliedCommentsWithRequest:(GetRepliedCommentsRequest *)request handler:(void(^)(GetRepliedCommentsResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetRepliedCommentsWithRequest:(GetRepliedCommentsRequest *)request handler:(void(^)(GetRepliedCommentsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetCommentsCount(GetCommentsCountRequest) returns (GetCommentsCountResponse)

- (void)getCommentsCountWithRequest:(GetCommentsCountRequest *)request handler:(void(^)(GetCommentsCountResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetCommentsCountWithRequest:(GetCommentsCountRequest *)request handler:(void(^)(GetCommentsCountResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark RepliedCommentUpload(RepliedCommentUploadRequest) returns (EmptyResponse)

- (void)repliedCommentUploadWithRequest:(RepliedCommentUploadRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToRepliedCommentUploadWithRequest:(RepliedCommentUploadRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark MentorCommentUpload(UploadMentorCommentRequest) returns (EmptyResponse)

/**
 * mentor comment
 */
- (void)mentorCommentUploadWithRequest:(UploadMentorCommentRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * mentor comment
 */
- (GRPCProtoCall *)RPCToMentorCommentUploadWithRequest:(UploadMentorCommentRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark RepliedMentorCommentUpload(UploadRepliedMentorCommentRequest) returns (EmptyResponse)

- (void)repliedMentorCommentUploadWithRequest:(UploadRepliedMentorCommentRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToRepliedMentorCommentUploadWithRequest:(UploadRepliedMentorCommentRequest *)request handler:(void(^)(EmptyResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetMentorComments(GetMentorCommentsRequest) returns (GetMentorCommentsResponse)

- (void)getMentorCommentsWithRequest:(GetMentorCommentsRequest *)request handler:(void(^)(GetMentorCommentsResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetMentorCommentsWithRequest:(GetMentorCommentsRequest *)request handler:(void(^)(GetMentorCommentsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetRepliedMentorComments(GetRepliedMentorCommentsRequest) returns (GetRepliedMentorCommentsResponse)

- (void)getRepliedMentorCommentsWithRequest:(GetRepliedMentorCommentsRequest *)request handler:(void(^)(GetRepliedMentorCommentsResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetRepliedMentorCommentsWithRequest:(GetRepliedMentorCommentsRequest *)request handler:(void(^)(GetRepliedMentorCommentsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetMentorCommentsCount(GetMentorCommentsCountRequest) returns (GetMentorCommentsCountResponse)

- (void)getMentorCommentsCountWithRequest:(GetMentorCommentsCountRequest *)request handler:(void(^)(GetMentorCommentsCountResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetMentorCommentsCountWithRequest:(GetMentorCommentsCountRequest *)request handler:(void(^)(GetMentorCommentsCountResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetSharedComments(GetSharedCommentsRequest) returns (GetSharedCommentsResponse)

- (void)getSharedCommentsWithRequest:(GetSharedCommentsRequest *)request handler:(void(^)(GetSharedCommentsResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetSharedCommentsWithRequest:(GetSharedCommentsRequest *)request handler:(void(^)(GetSharedCommentsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark CheckIfThereIsNewComments(CheckIfThereIsNewCommentsRequest) returns (CheckIfThereIsNewCommentsResponse)

- (void)checkIfThereIsNewCommentsWithRequest:(CheckIfThereIsNewCommentsRequest *)request handler:(void(^)(CheckIfThereIsNewCommentsResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToCheckIfThereIsNewCommentsWithRequest:(CheckIfThereIsNewCommentsRequest *)request handler:(void(^)(CheckIfThereIsNewCommentsResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark CheckIfItsDeleted(CheckIfItsDeletedRequest) returns (CheckIfItsDeletedResponse)

- (void)checkIfItsDeletedWithRequest:(CheckIfItsDeletedRequest *)request handler:(void(^)(CheckIfItsDeletedResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToCheckIfItsDeletedWithRequest:(CheckIfItsDeletedRequest *)request handler:(void(^)(CheckIfItsDeletedResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetBoardObject(GetBoardObjectRequest) returns (GetBoardObjectResponse)

/**
 * shared comment
 */
- (void)getBoardObjectWithRequest:(GetBoardObjectRequest *)request handler:(void(^)(GetBoardObjectResponse *_Nullable response, NSError *_Nullable error))handler;

/**
 * shared comment
 */
- (GRPCProtoCall *)RPCToGetBoardObjectWithRequest:(GetBoardObjectRequest *)request handler:(void(^)(GetBoardObjectResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetCommentObject(GetCommentObjectRequest) returns (GetCommentObjectResponse)

- (void)getCommentObjectWithRequest:(GetCommentObjectRequest *)request handler:(void(^)(GetCommentObjectResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetCommentObjectWithRequest:(GetCommentObjectRequest *)request handler:(void(^)(GetCommentObjectResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetMentorObject(GetMentorObjectRequest) returns (GetMentorObjectResponse)

- (void)getMentorObjectWithRequest:(GetMentorObjectRequest *)request handler:(void(^)(GetMentorObjectResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetMentorObjectWithRequest:(GetMentorObjectRequest *)request handler:(void(^)(GetMentorObjectResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetMentorCommentObject(GetMentorCommentObjectRequest) returns (GetMentorCommentObjectResponse)

- (void)getMentorCommentObjectWithRequest:(GetMentorCommentObjectRequest *)request handler:(void(^)(GetMentorCommentObjectResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetMentorCommentObjectWithRequest:(GetMentorCommentObjectRequest *)request handler:(void(^)(GetMentorCommentObjectResponse *_Nullable response, NSError *_Nullable error))handler;


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
- (void)getUniversitiesWithRequest:(GetUniversitiesRequest *)request handler:(void(^)(GetUniversitiesResponse *_Nullable response, NSError *_Nullable error))handler;

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
- (GRPCProtoCall *)RPCToGetUniversitiesWithRequest:(GetUniversitiesRequest *)request handler:(void(^)(GetUniversitiesResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetAcceptibleUniversities(GetAcceptibleUniversitiesRequest) returns (GetUniversitiesResponse)

- (void)getAcceptibleUniversitiesWithRequest:(GetAcceptibleUniversitiesRequest *)request handler:(void(^)(GetUniversitiesResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetAcceptibleUniversitiesWithRequest:(GetAcceptibleUniversitiesRequest *)request handler:(void(^)(GetUniversitiesResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark GetUniversityByName(GetUniversityByNameRequest) returns (GetUniversityByNameResponse)

- (void)getUniversityByNameWithRequest:(GetUniversityByNameRequest *)request handler:(void(^)(GetUniversityByNameResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToGetUniversityByNameWithRequest:(GetUniversityByNameRequest *)request handler:(void(^)(GetUniversityByNameResponse *_Nullable response, NSError *_Nullable error))handler;


@end


#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface Main : GRPCProtoService<Main>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface AuthorizedMain : GRPCProtoService<AuthorizedMain>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
#endif

NS_ASSUME_NONNULL_END

