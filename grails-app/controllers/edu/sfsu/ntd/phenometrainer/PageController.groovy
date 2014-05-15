package edu.sfsu.ntd.phenometrainer
/**
 * Controller for static content. Each action (class methods) maps directly to
 * the URL of some static content - e.g. main page, about page, help pages.
 */
class PageController {

    def trainService

    def about() {
      trainService.saveCurrentImageState(session["parasites"])
      render(view: 'about')
    }

    def help() {
      trainService.saveCurrentImageState(session["parasites"])
      render(view:'help')
    }

    def home() {
      render(view: 'home')
    }

    def download() {
      render(view: 'download')
    }

    def tutorial() {
      render(view: 'tutorial')
    }

    def unsupported() {
      render(view:'unsupported')
    }

}
