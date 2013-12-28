package edu.sfsu.ntd.phenometrainer

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

    def unsupported() {
      render(view:'unsupported')
    }
}
