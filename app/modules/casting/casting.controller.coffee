taiga = @.taiga

mixOf = @.taiga.mixOf

class CastingController extends mixOf(taiga.Controller, taiga.PageMixin)
    @.$inject = [
        "$scope",
        "$rootScope",
        "tgCurrentUserService",
        "$tgAuth",
        "tgCastingService",
        "$tgModel",
        "$tgLocation",
        "$tgNavUrls",

    ]

    constructor: (@scope, @rootscope,@currentUserService,@auth,@castingService,@model,@location,@navUrls) ->
        taiga.defineImmutableProperty(@, "projects", () => @currentUserService.projects.get("all"))
        taiga.defineImmutableProperty(@, "inventory", () => @currentUserService.inventory.get("all"))
        taiga.defineImmutableProperty(@, "agents", () => @currentUserService.agents.get("all"))
        # taiga.defineImmutableProperty(@, "casting_roles", () => @currentUserService.cating_roles.get("all"))

        promise = @castingService.getCastingRoles(false)

        promise.then (data) =>
            console.log('promise......done1')
            @scope.castingRoles = data.toJS()
            console.log('promise......done2')

    openActivateAgentLightbox: (user) ->
        if confirm 'Promote this user to be Agent: ' + user.get("full_name") + "?"
            userChanged = user.set("is_agent",true)
            this.castingService.change_is_agent(userChanged)
            location.reload()

    openDeactivateAgentLightbox: (user) ->
        if confirm 'Are you sure you want to deactivate Agent ' + user.get("full_name") + "?"
            userChanged = user.set("is_agent",false)
            this.castingService.change_is_agent(userChanged)
            location.reload()


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

    loadRoles: ->
        @scope.castingRoles = @castingService.getCastingRoles()
        return @scope.castingRoles

    loadInitialData: ->
        promise = @.loadRoles()
        return promise

angular.module("taigaCasting").controller("Casting", CastingController)

