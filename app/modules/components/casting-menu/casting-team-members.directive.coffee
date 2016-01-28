taiga = @.taiga

CastingTeamMembersDirective = (projectService, lightboxFactory) ->
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
        templateUrl: "components/casting-menu/casting-team-members.html",
        # link: link
    }

CastingTeamMembersDirective.$inject = [
    "tgProjectService",
    "tgLightboxFactory"
]

angular.module("taigaComponents").directive("tgCastingTeamMembers", CastingTeamMembersDirective)




