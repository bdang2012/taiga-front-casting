taiga = @.taiga

CastingTeamFiltersDirective = (projectService, lightboxFactory) ->
    link = (scope, el, attrs, ctrl) ->
        projectChange = () ->
            if projectService.project
                ctrl.show()
            else
                ctrl.hide()

        scope.$watch ( () ->
            return projectService.project
        ), projectChange

    return {
    scope: {},
    controller: "ProjectMenu",
    controllerAs: "vm",
    templateUrl: "components/casting-menu/casting-team-filter.html",
    link: link
    }

CastingTeamFiltersDirective.$inject = [
    "tgProjectService",
    "tgLightboxFactory"
]

angular.module("taigaComponents").directive("tgCastingTeamFilters", CastingTeamFiltersDirective)