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
# File: casting-resource.service.coffee
###

Resource = (urlsService, http,  config, paginateResponseService) ->
    service = {}

    service.getUserByEmail = (email) ->
        url = config.get("api") + 'casting/by_email'
        httpOptions = {}

        params = {
            email: email
        }

        return http.get(url, params, httpOptions).then (result) ->
            return Immutable.fromJS(result.data)

    service.getUserByUserId = (userid) ->
        url = config.get("api") + 'casting/by_userid'
        httpOptions = {}

        params = {
            userid: userid
        }

        return http.get(url, params, httpOptions).then (result) ->
            return Immutable.fromJS(result.data)

    service.createUserForFacebook = (email, username) ->
        url = config.get("api") + 'auth/register'
        httpOptions = {}

        username_nospace = username.replace " ","-"

        params = {
            type: "public",
            username: username_nospace,
            password: "vancouvertorontovancouver",
            email: email,
            full_name: username
        }

        return http.post(url, params, httpOptions).then (result) ->
            return Immutable.fromJS(result.data)

    service.getInventory = (paginate=false) ->
        url = config.get("api") + 'casting/members_list'
        httpOptions = {}

        params = {

        }

        return http.get(url, params, httpOptions)
        .then (result) ->
            return Immutable.fromJS(result.data)

    service.getMembersListForAgent = (userid, paginate=false) ->
        url = config.get("api") + 'casting/members_list_for_agent'
        httpOptions = {}

        params = {
            userid: userid
        }

        return http.get(url, params, httpOptions)
        .then (result) ->
            return Immutable.fromJS(result.data)

    service.getAgents = (paginate=false) ->
        url = urlsService.resolve("by_agents")

        httpOptions = {}

        if !paginate
            httpOptions.headers = {
                "x-disable-pagination": "1"
            }

        params = {}

        return http.get(url, params, httpOptions)
        .then (result) ->
            return Immutable.fromJS(result.data)

    service.change_is_agent = (user) ->
        url =  urlsService.resolve("users") + "/change_is_agent"
        return http.post(url, user)

    service.change_facebookinfo = (user) ->
        url = config.get("api") + 'casting/change_facebookinfo'
        return http.post(url, user)


    service.getCastingMembers = (paginate=false) ->
        url = config.get("api") + 'casting/members_list'
        httpOptions = {}

        params = {

        }

        return http.get(url, params, httpOptions)
        .then (result) ->
            return Immutable.fromJS(result.data)


    service.getCastingRoles = (paginate=false) ->
        url = config.get("api") + 'casting/roles_list'
        httpOptions = {}

        params = {

        }

        return http.get(url, params, httpOptions)
        .then (result) ->
            return Immutable.fromJS(result.data)

    return () ->
        return {"casting": service}

Resource.$inject = ["$tgUrls", "$tgHttp","$tgConfig"]

module = angular.module("taigaResources2")
module.factory("tgCastingResources", Resource)
