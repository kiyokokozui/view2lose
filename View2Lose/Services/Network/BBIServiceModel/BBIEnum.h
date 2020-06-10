//
//  BBIEnum.h
//  BBI
//
//  Created by Alex Brufsky on 11/5/14.
//  Copyright (c) 2014 Better Body Image. All rights reserved.
//

#ifndef BBI_BBIEnum_h
#define BBI_BBIEnum_h

/*----------------------BBIEnum----------------------

This file contains all enumerations and static 
 variables neccessary for the functioning of the
 BBIModelEndpoint conduit.

----------------------------------------------------*/

enum BBIRequestId {
    BBIRequestNone = 0,
    BBIRequestLogin = 1,
    BBIRequestCreateNewUser = 2,
    BBIRequestCreateNewClient = 3,
    BBIRequestUpdateUser = 4,
    BBIRequestUpdateUserWorkout = 5,
    BBIRequestDeleteUser = 6,
    BBIRequestAddUserWorkout = 7,
    BBIRequestLoadAllClients = 8,
    BBIRequestDefaultWorkoutByBodyType = 9,
    BBIRequestLoadUserWorkout = 10,
    BBIRequestLoadLookupData = 11,
    BBIRequestWarpImage = 12,
    BBIRequestCalculateBMR = 13,
    BBIRequestLoadAllWorkouts = 14,
    BBIRequestLoadCorporateClients = 15,
    BBIRequestLoadUserRoles = 16,
    BBIRequestLoadBananaWorkout = 17,
    BBIRequestLoadAppleWorkout = 18,
    BBIRequestLoadPearWorkout = 19,
    BBIRequestLoadPotatoWorkout = 20,
    BBIRequestWarpMeLogin = 21,
    BBIRequestLoadWarpMeSystemSettings = 22,
    BBIRequestUpdateWeight = 23,
    BBIRequestUpdateWaistSize = 24,
    BBIRequestUSDAFreeText = 25,
    BBIRequestUSDACalorie = 26,
    BBIRequestCompleteUser = 27,
    BBIRequestUpdateProfile = 28,
    BBIRequestForgotPassword = 29,
    BBIAddCalorieIntakeEntry = 30,
    BBIAddBurnedCaloriesEntry = 31,
    BBIFetchCalorieIntakeForWeek = 32,
    BBIFetchCalorieBurnedForWeek = 33,
    BBIResetCalories = 34,
    BBIRequestWarpImageSMR = 35,
    BBIRequestGetUserImages = 36,
    BBIRequestActivateAccount = 37,
    BBIRequestValidateTeamName = 38
};
typedef enum  BBIRequestId BBIRequestId;

static char * const BBIRequestIdByEnum[] = {
    "None",
    "Login",
    "CreateNewUser",
    "CreateNewClient",
    "UpdateUser",
    "UpdateUserWorkout",
    "DeleteUser",
    "AddUserWorkout",
    "LoadAllClients",
    "DefaultWorkoutByBodyType",
    "LoadUserWorkout",
    "LoadLookupData",
    "WarpImage",
    "CalculateBMR",
    "LoadAllWorkouts",
    "LoadCorporateClients",
    "LoadUserRoles",
    "LoadBananaWorkout",
    "LoadAppleWorkout",
    "LoadPearWorkout",
    "LoadPotatoWorkout",
    "WarpMeLogin",
    "LoadWarpMeSystemSettings",
    "UpdateUserWeight",
    "UpdateUserWaist",
    "search",
    "nutrients",
    "CompleteProfile",
    "Interaction",
    "RetrievePassword",
    "AddUserCalorieEntry",
    "AddUserCalorieBurnEntry",
    "LoadWeeklyCalorieEntries",
    "LoadWeeklyCalorieBurnEntries",
    "ResetTodaysCalories",
    "WarpImage2",
    "GetAllUserImages",
    "ActivateAccount",
    "ValidateTeamName"
};


enum BBIRequestType {
    GET = 0,
    POST = 1,
    USDA = 2
};
typedef enum BBIRequestType BBIRequestType;

#endif
