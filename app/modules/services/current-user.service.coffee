###
# Copyright (C) 2014-2015 Taiga Agile LLC <taiga@taiga.io>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# File: current-user.service.coffee
###

taiga = @.taiga

groupBy = @.taiga.groupBy

class CurrentUserService
    @.$inject = [
        "tgProjectsService",
        "$tgStorage",
        "tgResources",
        "tgCastingService"
    ]

    constructor: (@projectsService, @storageService, @rs,@castingService) ->
        @._user = null
        @._projects = Immutable.Map()
        @._projectsById = Immutable.Map()
        @._joyride = null
        @._inventory = Immutable.Map()
        @._agents = Immutable.Map()

        taiga.defineImmutableProperty @, "projects", () => return @._projects
        taiga.defineImmutableProperty @, "projectsById", () => return @._projectsById
        taiga.defineImmutableProperty @, "inventory", () => return @._inventory
        taiga.defineImmutableProperty @, "agents", () => return @._agents

    isAuthenticated: ->
        if @.getUser() != null
            return true
        return false

    getUser: () ->
        if !@._user
            userData = @storageService.get("userInfo")

            if userData
                userData = Immutable.fromJS(userData)
                @.setUser(userData)

        return @._user

    removeUser: () ->
        @._user = null
        @._projects = Immutable.Map()
        @._projectsById = Immutable.Map()
        @._joyride = null

    setUser: (user) ->
        @._user = user

        return @._loadUserInfo()

    bulkUpdateProjectsOrder: (sortData) ->
        @projectsService.bulkUpdateProjectsOrder(sortData).then () =>
            @.loadProjects()

    loadProjects: () ->
        return @projectsService.getProjectsByUserId(@._user.get("id"))
            .then (projects) => @.setProjects(projects)

    disableJoyRide: (section) ->
        if section
            @._joyride[section] = false
        else
            @._joyride = {
                backlog: false,
                kanban: false,
                dashboard: false
            }

        @rs.user.setUserStorage('joyride', @._joyride)

    loadJoyRideConfig: () ->
        return new Promise (resolve) =>
            if @._joyride != null
                resolve(@._joyride)
                return

            @rs.user.getUserStorage('joyride')
                .then (config) =>
                    @._joyride = config
                    resolve(@._joyride)
                .catch () =>
                    #joyride not defined
                    @._joyride = {
                        backlog: true,
                        kanban: true,
                        dashboard: true
                    }

                    @rs.user.createUserStorage('joyride', @._joyride)

                    resolve(@._joyride)


    setProjects: (projects) ->
        @._projects = @._projects.set("all", projects)
        @._projects = @._projects.set("recents", projects.slice(0, 10))

        @._projectsById = Immutable.fromJS(groupBy(projects.toJS(), (p) -> p.id))

        return @.projects

    isProducer: ->
        console.log("<<<<<bdlog: in current-user.service.coffee >>>>")
        if !@._user
            return false

        return @._user.get("is_producer")

    isAgent: ->
        if !@._user
            return false
        return @._user.get("is_agent")

    isProducerOrAgent: ->
        return (@.isProducer() or @.isAgent() )

    _loadInventory: () ->
        return @castingService.getInventory()
        .then (inventory) =>
            @._inventory = @._inventory.set("all", inventory)

            console.log 'bdlog: in loadInventory '
            console.log @._inventory.toJS()

            return @.inventory
            loadAgents: () ->

    loadAgents: () ->
        return @castingService.getAgents()
        .then (agents) =>
            @._agents = @._agents.set("all", agents)

            return @.agents


    _loadUserInfo: () ->
        return Promise.all([
            @.loadProjects()
            @._loadInventory()
            @.loadAgents()
        ])

angular.module("taigaCommon").service("tgCurrentUserService", CurrentUserService)
