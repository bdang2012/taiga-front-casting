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
# File: user.service.coffee
###

taiga = @.taiga
bindMethods = taiga.bindMethods


class CastingService extends taiga.Service
    @.$inject = ["tgResources","$projectUrl", "tgLightboxFactory"]

    constructor: (@rs,@projectUrl, @lightboxFactory) ->
        bindMethods(@)


    change_is_agent: (user) ->
        return @rs.users.change_is_agent(user)

    change_facebookinfo: (user) ->
        return @rs.casting.change_facebookinfo(user)

    getUserByEmail: (email) ->
        return @rs.casting.getUserByEmail(email)

    getUserByUserId: (userid) ->
        return @rs.casting.getUserByUserId(userid)

    createUserIfNotExistForFacebook: (email,username, facebookid) ->
        binhRs = @.rs
        promise = @.getUserByEmail(email)
        promise.then (user) ->
            console.log("<<<<<bdlog: createUserIfNotExistForFacebook: User already exist. just need do update")
            console.log(">>>>>")

        #case promise failed
        promise = promise.then null, (err) ->
            console.log("bdlog: user not exist .... create now")
            return binhRs.casting.createUserForFacebook(email,username, facebookid)
        return promise

    getInventory: (paginate) ->
        return @rs.casting.getInventory(paginate)

    getAgents: (paginate) ->
        return @rs.casting.getAgents(paginate)

    change_is_agent: (user) ->
        return @rs.casting.change_is_agent(user)

    getCastingRoles: (paginate) ->
        return @rs.casting.getCastingRoles(paginate)

    getCastingMembers: (paginate) ->
        return @rs.casting.getCastingMembers(paginate)

    getMembersListForAgent: (userid, paginate) ->
        return @rs.casting.getMembersListForAgent(userid,paginate)

angular.module("taigaCommon").service("tgCastingService", CastingService)
