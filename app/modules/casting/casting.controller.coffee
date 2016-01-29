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
        @scope.tasksEnabled = true
        @scope.issuesEnabled = true
        @scope.wikiEnabled= true
        @scope.binhfnGetObjectFromJSById = @.binhfnGetObjectFromJSById

        taiga.defineImmutableProperty(@, "agents", () => @currentUserService.agents.get("all"))

        if @auth.getUser()
            currentUser = @auth.getUser()
            console.log("current user is")
            console.log(currentUser)

        b_scope = @scope
        b_castingService = @castingService
        @castingService.getCastingRoles(false)
        .then (response) ->
            b_scope.castingRoles = response.toJS()
        .then (response) ->
            return b_castingService.getAgents()
        .then (response) ->
            b_scope.memberships_agent = response.toJS()
        .then (response) ->
            if currentUser and currentUser.is_agent
                return b_castingService.getMembersListForAgent(currentUser.id)
            else
                return b_castingService.getCastingMembers()

        .then (response) ->
            b_scope.castingMembers = response.toJS()


    binhfnGetObjectFromJSById:  (arr, value) ->
        result = arr.filter((o) ->
            o.id == value
        )
        if result then result[0] else null


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
        binhModel = @model

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
                    console.log 'facebookid is: ' + response.id
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
                        promise.then (user)->
                            console.log('success binhAuth.login_facebook.  now update facebookinfo')
                            user.photo = response.id
                            user.full_name = response.name
                            binhCastingService.change_facebookinfo(user).then ->
                                binhCastingService.getUserByEmail(response.email).then (data) ->
                                    user_refreshed = binhModel.make_model("users",data.toJS())
                                    binhAuth.setUser(user_refreshed)
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
        promise = @castingService.getCastingRoles(false)
        promise.then (data) =>
            @scope.castingRoles = data.toJS()
            return @scope.castingRoles

    loadMembers: ->
        console.log('xxxxxloading members')
        user = @auth.getUser()

        # Calculate totals
        # @scope.totals = {}
        # for member in @scope.activeUsers
        #    @scope.totals[member.id] = 0

        # Get current user
        # @scope.currentUser = _.find(@scope.activeUsers, {id: user?.id})

        # Get member list without current user
        # @scope.memberships = _.reject(@scope.activeUsers, {id: user?.id})


        # @scope.memberships_agent = @.agents.toJS()

        console.log('done xxxxxloading members')


    loadInitialData: ->
        promise = @.loadRoles()
        return promise.then =>
            @.fillUsersAndRoles(@scope.castingMembers, @scope.castingRoles, true)
            return @.loadMembers()

angular.module("taigaCasting").controller("Casting", CastingController)