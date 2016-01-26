taiga = @.taiga

CastingTeamMembersAgentDirective = (projectService, lightboxFactory) ->
    return {
        scope: {
            memberships: "=",
            filtersQ: "=filtersq",
            filtersRole: "=filtersrole",
            stats: "="
            issuesEnabled: "=issuesenabled"
            tasksEnabled: "=tasksenabled"
            wikiEnabled: "=wikienabled"
        }
        controller: "Casting",
        controllerAs: "vm",
        templateUrl: "components/casting-menu/casting-team-members-agent.html",
        # link: link
    }

CastingTeamMembersAgentDirective.$inject = [
    "tgProjectService",
    "tgLightboxFactory"
]

angular.module("taigaComponents").directive("tgCastingTeamMembersAgent", CastingTeamMembersAgentDirective)


