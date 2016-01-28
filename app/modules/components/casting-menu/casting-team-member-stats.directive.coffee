taiga = @.taiga


#############################################################################
## Team Member Stats Directive
#############################################################################

CastingTeamMemberStatsDirective = () ->
    return {
        scope: {
            stats: "=",
            userId: "=user"
            issuesEnabled: "=issuesenabled"
            tasksEnabled: "=tasksenabled"
            wikiEnabled: "=wikienabled"
        }

        controller: "Casting",
        controllerAs: "vm",
        templateUrl: "components/casting-menu/casting-team-member-stats.html",
    }

angular.module("taigaComponents").directive("tgCastingTeamMemberStats", CastingTeamMemberStatsDirective)




