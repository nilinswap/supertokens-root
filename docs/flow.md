# Flow

## common
C1: it starts from src/main/java/io/supertokens/Main.java which calls Webserver's start. it has




/recipe/session/refresh -> res is expected to have

- req body

```javascript
{
    refreshToken: string;
    antiCsrfToken ? : string;
    enableAntiCsrf ? : boolean;
}
```

- res body

```typescript
let accessToken = response.accessToken;
let refreshToken = response.refreshToken;
let idRefreshToken = response.idRefreshToken;
let anticsrftoken = response.antiCsrfToken;
```

RSR1 - every session refresh it returns a new RT and new AT but that is if previous RT was valid (i.e. either it is 
current RT in the db or the previous one) if RT is not any of them, we throw 401 and logs out (cookie deletion part 
is written in supertokens-node part). Also
subsequent 
calls of 
getSession uses the accesstoken and not refresh token.





=======================================================

/recipe/handshake - for jwt

/recipe/session/verify - this is called by getSession in js layer. whenever we need sessionInfo, we use this. e.g. an
api that returns the email of the user (probably logged out); another example is one api call that wants to fetch
something on userId but js layer is stateless so it fetches session from backend using access token.

- req body

```typescript
let requestBody: {
    accessToken: string;
    antiCsrfToken?: string;
    doAntiCsrfCheck: boolean;
    enableAntiCsrf?: boolean;
};
```

- res body

```typescript
if (response.accessToken !== undefined) {
    setFrontTokenInHeaders(
        res,
        response.session.userId,
        response.accessToken.expiry,
        response.session.userDataInJWT
    );
    // READCODE BUNI MW3: we attach accesstoken to response. 
    attachAccessTokenToCookie(config, res, response.accessToken.token, response.accessToken.expiry);
    accessToken = response.accessToken.token;
}
```

/recipe/signinup/code - get new code

RSC1 - match how it uses request body attributes. notice this api is only implemented in passwordless. 


- req body

```typescript
let response = await input.options.recipeImplementation.createCode(
    "email" in input
        ? {
            userContext: input.userContext,
            email: input.email,
            userInputCode:
                input.options.config.getCustomUserInputCode === undefined
                    ? undefined
                    : await input.options.config.getCustomUserInputCode(input.userContext),
        }
        : {
            userContext: input.userContext,
            phoneNumber: input.phoneNumber,
            userInputCode:
                input.options.config.getCustomUserInputCode === undefined
                    ? undefined
                    : await input.options.config.getCustomUserInputCode(input.userContext),
        }
)
```

- res body has things like codeLifetime, preAuthSessionId

/recipe/signinup/code/consume - verify code and give access /recipe/user - getUser
RSCC1 - see the flow

- req body

```typescript
{
    preAuthSessionId: input.preAuthSessionId,
        deviceId:input.deviceId,
        userInputCode:input.userInputCode,
        userContext:input.userContext,
}
```

- res body

```typescript
let user = response.user;

const session = await Session.createNewSession(input.options.res, user.id, {}, {}, input.userContext);
return {
    status: "OK",
    createdNewUser: response.createdNewUser,
    user: response.user,
    session,
};
```

where createNewSession has body

```typescript
let response = await SessionFunctions.createNewSession(helpers, userId, accessTokenPayload, sessionData);
attachCreateOrRefreshSessionResponseToExpressRes(config, res, response);
return new Session(
    helpers,
    response.accessToken.token,
    response.session.handle,
    response.session.userId,
    response.session.userDataInJWT,
    res
);
```

and createNewSession finally calls the recipe/session api

```typescript
let requestBody: {
  userId: string;
  userDataInJWT: any;
  userDataInDatabase: any;
  enableAntiCsrf?: boolean;
} = {
  userId,
  userDataInJWT: accessTokenPayload,
  userDataInDatabase: sessionData,
};
 let response = await helpers.querier.sendPostRequest(new NormalisedURLPath("/recipe/session"), requestBody);
```

so basically first only user is created when we call consume api, it returns user_id and we use email(userContext) 
that we have to call /recipe/session which returns new session that we use.

======================================================
POST /recipe/session creates new session and GET /recipe/session gets session - RS1




======================================================

POST /session/verify

SV1 - this is for jwt verification. so getsession get is all it is for non-jwt case.

- refresh_session api - if access_token is expired, use refresh_token to generate new refresh_token and access_token. if
  not then, provide do nothing. if refresh_token is expired, clear cookies.

- /session/code - register email and mark it as unverified, generate and send an otp.
- /session/verify - use code and email to make sure that code matches and mark it as verified if success. return 401 or
  200 based on match and set or clear cookies.

1. cookie set process


## Findings

### interesting finds
1. Use of resourceDistributor which ties all singleton classes together.
2. ProcessState to log states
3. there is use of cronjobs but for what?
4. there is use of some getDevice_Transaction, commitTransaction  etc. what is happening here?


## HOOK

- understand some nuances of the code. (coding pattern, third party libraries etc)
- imagine how I would write the same code. how I will end-up with same codebase. Find many ways of doing this. 
- Checkout more features and find them in code. Not to document or anything but just know how to navigate. Pick few 
  features randomly.
  
