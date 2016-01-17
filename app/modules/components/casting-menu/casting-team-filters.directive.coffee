taiga = @.taiga

CastingTeamFiltersDirective = (projectService, lightboxFactory) ->

    return {
    scope: {},
    controller: "Casting",
    controllerAs: "vm",
    templateUrl: "components/casting-menu/casting-team-filter.html",
    # link: link
    }

CastingTeamFiltersDirective.$inject = [
    "tgProjectService",
    "tgLightboxFactory"
]

angular.module("taigaComponents").directive("tgCastingTeamFilters", CastingTeamFiltersDirective)