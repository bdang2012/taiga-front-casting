class CastingController
    @.$inject = [
        "tgCurrentUserService",
        "$tgAuth",
        "tgCastingService",
        "$tgModel",
        "$tgLocation",
        "$tgNavUrls"
    ]

    constructor: (@currentUserService,@auth,@castingService,@model,@location,@navUrls) ->
        return

    onSuccess = (response) ->
        console.log('on success')

    onError =  (response) ->
        console.log('on error')

    
    FBLogin: ->
        binhAuth = @auth
        binhNavUrls = @navUrls
        binhLocation = @location
        binhCastingService = @castingService

        FB.login ((response) ->
                    
            if response.authResponse
                console.log 'Welcome!  Fetching your information.... '
                console.log(response)
                FB.api '/me', {
                    locale: 'en_US',
                    fields: 'name,email'
                }, (response) ->
                    console.log 'Good to see you, ' + response.name + '.'
                    console.log 'email is: ' + response.email
                    console.log(response)
                    console.log('end of response object')
                    data = {
                        "username": response.email,
                        "password": "vancouvertorontovancouver",
                        "type" : "normal"
                    }
                    # make sure you have facebook user before proceeding
                    binhCastingService.createUserIfNotExistForFacebook(response.email, response.name).then ->
                        promise = binhAuth.login(data, "normal")
                        promise.then ->
                            console.log('success binhAuth.login_facebook')
                            nextUrl = binhNavUrls.resolve("home")
                            binhLocation.url(nextUrl)
                    
                        return
          
                FB.api '/me/permissions' , (response) ->
                    console.log(response)
                    return
            else
                console.log 'User cancelled login or did not fully authorize.'
                return

            return
        ), scope: 'public_profile, email, user_friends'

    
angular.module("taigaCasting").controller("Casting", CastingController)